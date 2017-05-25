##############################################################################################
# R script that creates RRVS tasks randomly from a given img and bdg dataset
# 
# Author: M.Haas mhaas@gfz-potsdam.de
# 
# input: 1) database information 
#           (host,databasename,user,password,survey id in database (for footprints to use) 
#        2) UTM Zone of buildings/images
#        3) maximum distance buildings should have from gps path of images
#        4) user id for which the tasks are
#        5) nr of tasks, task size (nr of buildings)
#
# install.packages("RPostgreSQL")
# install.packages("rgeos")
# install.packages("rgdal")
# install.packages("sp")
# install.packages("maptools")
#############################################################################################
library(RPostgreSQL)
library(rgeos)
library(rgdal)
library(sp)
library(maptools)

#database settings
host <- 'localhost'
dbuser <- 'postgres'
password <- 'postgres'
dbname <- 'rem'
survey_gid <- 6
utm <- 32719
dbuffer <- 30
#user_id to assign task to
user_id <- 41
#aimed task size
task_nr <- 7
task_size <- 100
seed <- 42

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

#create buffer around images belonging to survey for 
query <- paste("DROP TABLE IF EXISTS PATH; CREATE TABLE path AS SELECT g.path[1] as gid, g.geom::geometry(Polygon, 4326) as path FROM (SELECT(ST_Dump(ST_UNION(ST_Transform(ST_Buffer(ST_Transform(the_geom,",utm,"), ",dbuffer,"),4326)))).* FROM image.gps WHERE gid in (SELECT gid FROM image.img WHERE survey=",survey_gid,")) as g;",sep="")
create_it <- sql_query(query)
#get footprints within the path considering a buffer
query <- paste("SELECT DISTINCT o.gid, ST_AsText(o.the_geom) AS wktgeom FROM asset.object AS o,survey.survey AS s, path AS p WHERE o.survey_gid=",survey_gid," AND ST_contains(ST_Transform(p.path,",utm,"),ST_Centroid(ST_Transform(o.the_geom,",utm,")));",sep="")
buildings <- sql_query(query)

#adjust nr of tasks if larger than possible
test <- as.integer(length(buildings$gid)/task_size)
if (test < task_nr){task_nr<-test}

#generate random sample of buildings
set.seed = seed
gids<-sample(buildings$gid,task_nr*task_size,replace=FALSE)

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

  query <- paste("WITH buildings AS (SELECT unnest(bdg_gids) AS id FROM users.tasks WHERE id=",task_id,") UPDATE users.tasks SET img_ids=(SELECT DISTINCT array_agg(i.gid ) FROM buildings, image.img AS i, image.gps AS g, asset.object AS o WHERE o.gid=id AND i.gps=g.gid AND ST_DWITHIN(ST_Transform(o.the_geom,",utm,"),ST_Transform(g.the_geom,",utm,"),",dbuffer,") AND i.survey=",survey_gid,") WHERE users.tasks.id=",task_id,";",sep='')
  exec <- sql_query(query)
  #assign task to user_id
  query <- paste("INSERT INTO users.tasks_users(user_id,task_id) VALUES (",user_id,",",task_id,");",sep='')
  exec <- sql_query(query)
}
