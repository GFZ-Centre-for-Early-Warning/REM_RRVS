##############################################################################################
# R script that creates RRVS tasks based 
# on strata in a shapefile
# Author: M.Haas mhaas@gfz-potsdam.de
# 
# input: 1) database information 
#           (host,databasename,user,password,survey id in database (for footprints to use) 
#        2) UTM Zone of buildings/images
#        3) maximum distance buildings should have from gps path of images
#        4) user id for which the tasks are
#        5) nr of tasks, task size (nr of buildings)
#        6) directory and filename of shapefile with strata
#
# IN ORDER TO USE THIS SCRIPT ADJUST THE 
# AGGREGATE TYPES FUNCTION accordingly
#############################################################################################
library(RPostgreSQL)
library(rgeos)
library(rgdal)
library(sp)
library(maptools)

#database settings
host <- 'host'
dbuser <- 'user'
password <- 'password'
dbname <- 'rem'
survey_gid <- 2
utm <- 32636
dbuffer <- 30
#user_id to assign task to
user_id <- 1
#aimed task size
task_nr <- 10
task_size <- 100
#strata
strata_dir <- '/home/mhaas/PhD/Routines/LandsatAnalysis/Jordan/'
strata_shp <- 'madaba_regions'


#classes 1x,2x,3x: before 72,72-92,92-2015
#        x1,x2,x3: res,com,mix

#function to aggregate types (1x -> 1972; 2x -> 1972-1992; 3x -> 1992-2015)
aggregateTypes <- function(types){
  new_types <- types
  new_types[which(types<40)] <- '1992-2015'
  new_types[which(types<30)] <- '1972-1992'
  new_types[which(types<20)] <- '1972'
  return(new_types)
}

#sql function
sql_query <- function(sql){
  drv <- dbDriver("PostgreSQL")
  con <- dbConnect(drv, host=host, user=dbuser, password=password, dbname=dbname)
  on.exit(dbDisconnect(con))
  on.exit(dbUnloadDriver(drv), add = TRUE)
  post <- dbGetQuery(con, statement = sql)
  return(post)
}

#function for integer histograms
int.hist = function(x,ylab="Frequency",...) {
  histo <- table(factor(x,levels=min(x):max(x)))
  barplot(table(factor(x,levels=min(x):max(x))),space=0,xaxt="n",ylab=ylab,...);axis(1)
  return(histo)
}

#create paths for all streams in the database
query <- "DROP TABLE IF EXISTS PATH; CREATE TABLE path AS WITH streams AS (SELECT i.gps,g.gid,g.the_geom,rtrim(i.filename,'0123456789.jpg') 	FROM image.img AS i, image.gps AS g WHERE i.gps=g.gid) SELECT rtrim as stream,ST_MakeLine(the_geom) as path FROM streams GROUP BY rtrim;"
create_it <- sql_query(query)
#get footprints within the path considering a buffer
query <- paste("SELECT DISTINCT o.gid, ST_AsText(o.the_geom) AS wktgeom FROM asset.object AS o,survey.survey AS s, path AS p WHERE o.survey_gid=",survey_gid," AND ST_DWithIn(ST_Transform(p.path,",utm,"),ST_Centroid(ST_Transform(o.the_geom,",utm,")),",dbuffer,");",sep="")
buildings <- sql_query(query)
#create sp for buidlings
id0<-1
p4s="+proj=longlat +datum=WGS84 +no_defs"
gids <- data.frame(buildings$gid)
polys <- readWKT(buildings$wktgeom[1],id=id0,p4s=p4s)
for (i in 2:length(buildings$wktgeom)){
  poly <- readWKT(buildings$wktgeom[i],id=i,p4s=p4s)
  polys <- rbind(polys,poly)
}
buildings.sp <- SpatialPolygonsDataFrame(polys,data=gids)

#take strata layer
strata <- readOGR(dsn=strata_dir,layer=strata_shp)
strata <- spTransform(strata,p4s)

#assign all buildings in path to strata
buildings.strata.in <- over(buildings.sp,strata)
#remove buildings that could not be assigned a strata
buildings.strata <- buildings.strata.in[complete.cases(buildings.strata.in),]
buildings.sp <- buildings.sp[complete.cases(buildings.strata.in),]
#histogramm
buildings.hist <- int.hist(buildings.strata$type)
#aggregate types
buildings.sp$sample_type <- aggregateTypes(buildings.strata$type)
#for each strata determine weights: buildings in strata/total number of buildings along path
nr_tot <- length(buildings.sp$sample_type)
weights <- c()
types <- unique(buildings.sp$sample_type)
for (type in types){
  type_pop <- length(which(buildings.sp$sample_type==type))
  weight <- type_pop/nr_tot
  if (length(weights)==0){
    weights <- cbind(type,weight,type_pop)
  }else{
    weights <- rbind(weights,cbind(type,weight,type_pop))
  }
}

#adjust nr of tasks if larger than possible
test <- as.integer(sum(as.numeric(weights[,3]))/task_size)
if (test < task_nr){task_nr<-test}

#create building sample
#sampling without replacement nr_s(type)=weigth(type)*task_size*task_nr
# weight <- rep(0,length(buildings.sp))
# for (type in types){
#   weight[which(buildings.sp@data$sample_type==type)]<-as.double(weights[which(weights[,1]==type),2])
# }

sample_weights <- round(as.double(weights[,2])*task_size*task_nr)
#check if unequal to intended size due to rounding
tot_diff <- task_size*task_nr-sum(sample_weights)
#if yes adjust the sample sizes
if(tot_diff!=0){
  increments <- rep(sign(tot_diff),abs(tot_diff))
  for (i in increments){
    diff <- abs(as.double(weights[,2])*task_size*task_nr-sample_weights)  
    sample_weights[which(diff==max(diff))]<-sample_weights[which(diff==max(diff))]+i
  }
}


# type_pop <- as.double(weights[which(weights[,1]==types[1]),3])
# sample_size <- as.integer(task_size*weight*task_nr)
buildings.sampled.all <- buildings.sp[sample(which(buildings.sp@data$sample_type==types[1]),size=sample_weights[1],replace=FALSE),]
for(i in seq(2,length(types))){
#   weight <- as.double(weights[which(weights[,1]==type),2])
#   sample_size <- as.integer(task_size*weight*task_nr)
   buildings.sampled.all <- spRbind(buildings.sampled.all,buildings.sp[sample(which(buildings.sp@data$sample_type==types[i]),size=sample_weights[i],replace=FALSE),])
}

#get all building ids of sampled buildings
gids<-buildings.sampled.all$buildings.gid

#create tasks (in form of buildings)
for (i in seq(task_nr)){
  #get task id
  task_id <- sql_query("SELECT max(id) FROM users.tasks")
  if (is.na(task_id)){task_id<-1}else{task_id <- task_id+1}
  
  #get buildings for task
  selected <- sample(gids,task_size,replace=FALSE)
  #reduce gids by selected for next iteration
  gids <- setdiff(gids,selected)
  
  #write task to database
  bdg_gids <- paste0("'{",paste0(selected,collapse=","),"}'")
  query <- paste("INSERT INTO users.tasks(id,bdg_gids) VALUES(",task_id,",",bdg_gids,");",sep='')
  exec <- sql_query(query)
  #write images related to task to task

  query <- paste("WITH buildings AS (SELECT unnest(bdg_gids) AS id FROM users.tasks WHERE id=",task_id,") UPDATE users.tasks SET img_ids=(SELECT DISTINCT array_agg(i.gid ) FROM buildings, image.img AS i, image.gps AS g, asset.object AS o WHERE o.gid=id AND i.gps=g.gid AND ST_DWITHIN(ST_Transform(ST_Centroid(o.the_geom),32636),ST_Transform(g.the_geom,32636),30)) WHERE users.tasks.id=",task_id,";",sep='')
  exec <- sql_query(query)
  #assign task to user_id
  query <- paste("INSERT INTO users.tasks_users(user_id,task_id) VALUES (",user_id,",",task_id,");",sep='')
  exec <- sql_query(query)
}
