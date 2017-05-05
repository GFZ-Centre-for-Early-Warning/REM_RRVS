######################################################################
# Script to convert idct2rem
# Requires footprint data already stored on REM Database and points of idct
# have to be on the corresponding footprint.
# Associates parameters with available footprints
# For now only works for UNMODIFIED buildings no conflict handeling
######################################################################

#clear all variables
rm(list=ls(all.names=TRUE))

setwd("pass/to/idct_csvfile")

library(RPostgreSQL)

#idct database snapshot
data <- read.csv("IDCTDO_survey_points.csv")

#longitudinal or transverse preferred
L_T <- 'L'
# preference for variables which are mapped from two idct variables to one rem variable
order1 <- c("MAT_TECH","MAS_REIN")
order2 <- c("MAS_MORT","STEELCON")


#mapping
#mapping <- read.csv("mapping.csv")
#database settings
host <- 'host'
dbuser <- 'user'
password <- 'password'
dbname <- 'rem'


#Which survey
survey_gid=1
status = "UNMODIFIED"

############################
# Functions
############################

#sql function
sql_query <- function(sql){
  drv <- dbDriver("PostgreSQL")
  con <- dbConnect(drv, host=host, user=dbuser, password=password, dbname=dbname)
  on.exit(dbDisconnect(con))
  on.exit(dbUnloadDriver(drv), add = TRUE)
  post <- dbGetQuery(con, statement = sql)
  return(post)
}

#function to check weather L/T variables are empty and if both are filled which is preferred
choose_L_T <- function(df,v,pref){
  types <- c("L","T")
  other <- types[which(types!=pref)]
  #Get preferred
  val1 <- df[,paste(v,'_',pref,sep='')]
  #check if prefered is not empty
  idxs1 <- which(is.na(val1))
  idxs2 <- which(val1=='')
  idxs <- union(idxs1,idxs2)
  if (length(idxs)>0){
     val2 <- df[,paste(v,'_',other,sep='')]
     val1[idxs] <- val2[idxs]
  }
  return(val1)
}

#from two vectors which have two fields in IDCT go to only 1 in REM
double <- function(vec1,vec2){
  #vec 1 is prefered
  vec1 <- as.character(vec1)
  #check if prefered is empty
  idxs1 <- which(is.na(vec1))
  idxs2 <- which(vec1=='')
  idxs <- union(idxs1,idxs2)
  #set these to the one of vec2
  vec2 <- as.character(vec2)
  vec1[idxs] <- vec2[idxs]
  return(as.factor(vec1))
}

#function to assign height according to REM schema
height_vals <- function(data){
  #assign default height type
  height   <- rep("H99",length(data$STORY_AG_1))
  height2 <- rep("HB99",length(data$STORY_AG_1))
  #assign default height value
  height_1    <- rep(99,length(data$STORY_AG_1))
  height_2    <- rep(99,length(data$STORY_AG_1))
  height2_1   <- rep(99,length(data$STORY_AG_1))
  height2_2   <- rep(99,length(data$STORY_AG_1))
  
  ###
  #ABOVE GROUND
  #find which are not empty
  idxs1 <- which(data$STORY_AG_1!='')
  idxs2 <- which(!is.na(data$STORY_AG_1))
  idxs <- union(idxs1,idxs2)
  if (length(idxs)>0){
    #assign height type for above ground
    height[idxs] <- "H"
    #assign height values for above ground
    height_1[idxs] <- as.integer(data$STORY_AG_1)[idxs]
  }
  #second height value
  #find which are not empty
  idxs1 <- which(data$STORY_AG_2!='')
  idxs2 <- which(!is.na(data$STORY_AG_2))
  idxs <- union(idxs1,idxs2)
  if (length(idxs)>0){
    #assign second height values for above ground
    height_2[idxs] <- as.integer(data$STORY_AG_2)[idxs]
  }
  
  ###
  #BELOW GROUND
  #find which are not empty
  idxs1 <- which(data$STORY_BG_1!='')
  idxs2 <- which(!is.na(data$STORY_BG_1))
  idxs <- union(idxs1,idxs2)
  if (length(idxs)>0){
    #assign height type for below ground
    height2[idxs] <- "HB"
    #assign height values for below ground
    height2_1[idxs] <- as.integer(data$STORY_BG_1)[idxs]
  }
  #second height value
  #find which are not empty
  idxs1 <- which(data$STORY_BG_2!='')
  idxs2 <- which(!is.na(data$STORY_BG_2))
  idxs <- union(idxs1,idxs2)
  if (length(idxs)>0){
    #assign height values for below ground
    height2_2[idxs] <- as.integer(data$STORY_BG_2)[idxs]
  }
  
  ###
  #Ground floor height
  #ONLY STORED IN CASE height2 not used for below ground
  #Quality not used: HT_GR_GF_Q
  #find which are not empty
  idxs1 <- which(data$HT_GR_GF_1!='')
  idxs2 <- which(!is.na(data$HT_GR_GF_1))
  idxs3 <- union(idxs1,idxs2)
  #only if height2 not used yet
  idxs4 <- which(height2=="HB99")
    
  if (length(idxs)>0){
    #assign height type for below ground
    height2[idxs] <- "HF"
    #assign height values for below ground
    height2_1[idxs] <- as.integer(data$HT_GR_GF_1)[idxs]
  }
  #second height value
  #find which are not empty
  idxs1 <- which(data$HT_GR_GF_2!='')
  idxs2 <- which(!is.na(data$HT_GR_GF_2))
  idxs <- union(idxs1,idxs2)
  if (length(idxs)>0){
    #assign height values for below ground
    height2_2[idxs] <- as.integer(data$HT_GR_GF_2)[idxs]
  }
  return(list(height,height2,height_1,height_2,height2_1,height2_2))
}

#function that generates the update statement from one row of the rem data.frame
rem_update <- function(df,idx,gid){
  query <- "UPDATE asset.ve_object SET "
  #fields with integer values
  ints <- c("height_1","height_2","height2_1","height2_2","year_1","year_2")
  #add all values
  for (name in names(df)){
    if (name %in% ints){
      query <- paste(query,name,"=",as.character(df[name][[1]]),",",sep="")
    }else{
      query <- paste(query,name,"='",as.character(df[name][[1]]),"',",sep="")
    }
  }
  #remove last comma and add where condition
  query <- paste(substr(query,1,nchar(query)-1)," WHERE gid=",gid,sep="")
  return(query)
}

###########################################
# Data preparation
##########################################

#New status after update
rrvs_status	<- rep("COMPLETED",length(data$SOURCE))
#generate new data.frame

#REMAP all names from idct to rem
source      <- data$SOURCE
comment	    <- data$COMMENTS
plan_shape	<- data$PLAN_SHAPE
position	  <- data$POSITION
nonstrcexw	<- data$NONSTRCEXW
roof_conn	  <- data$ROOF_CONN
roofsysmat	<- data$ROOFSYSMAT
roofcovmat	<- data$ROOFCOVMAT
roof_shape	<- data$ROOF_SHAPE
roofsystyp	<- data$ROOFSYSTYP
str_irreg	  <- data$STR_IRREG
floor_conn	<- data$FLOOR_CONN
floor_mat	  <- data$FLOOR_MAT
floor_type	<- data$FLOOR_TYPE
foundn_sys	<- data$FOUNDN_SYS
occupy      <-	data$OCCUPCY
occupy_dt	  <- data$OCCUPCY_DT

#row wise
mat_prop	  <- choose_L_T(data,"MAS_MORT",L_T)
mat_tech	  <- choose_L_T(data,"MAS_REIN",L_T)
#double
mat_tech	  <- double(choose_L_T(data,"MAT_TECH",L_T),mat_tech)
mat_type	  <- choose_L_T(data,"MAT_TYPE",L_T)
#double
mat_prop	  <- double(mat_prop,choose_L_T(data,"STEELCON",L_T))

#NOT used: llrs_q <- LLRS_QUAL
llrs	      <- choose_L_T(data,"LLRS",L_T)
llrs_duct  	<- choose_L_T(data,"LLRS_DCT",L_T)

#Different implementation REM has 2 and IDCT 4 (Horiz/Vert + primary and secondary)
#Check if more than 2 defined if yes select primary ones
str_irreg_type	 <- data$STR_HZIR_P
str_irreg_type_2 <-	data$STR_VEIR_P
str_irreg_type   <- double(str_irreg_type,data$STR_HZIR_S)
str_irreg_type_2 <- double(str_irreg_type_2,data$STR_VEIR_S)


#In REM we have defined height and height_2 which define the type of hight (above ground or below or ground floor height) 
#with two numeric fields each two values we don't have a field with quality (approximate, exact..)
h <- height_vals(data)
height     <- h[[1]]
height2    <- h[[2]]
height_1   <- h[[3]]
height_2   <- h[[4]]
height2_1  <- h[[5]]
height2_2  <- h[[6]]



yr_built	<- data$YR_BUILT_Q
#set to default value
year_1    <- rep(99,length(data$STORY_AG_1))
year_2    <- rep(99,length(data$STORY_AG_1))
#overwrite in case available
year_1 <- double(data$YR_BUILT_1,year_1)
year_2 <- double(data$YR_BUILT_2,year_2)

#in case building was retrofitted set age to retrofitting year
year_1 <- double(data$YR_RETRO,year_1)


#NOT USED IN REM:
# STORY_AG_Q
# SLOPE
# SAMPLE_GRP
# DIRECT_1
# DIRECT_2
# DATE_MADE
# USER_MADE
# DATE_CHNG
# USER_CHNG
# OBJ_UID
# PROJ_UID
# X
# Y

#IN REM but not in IDCT
#--> not updated 
# survey_gid 
# description	
# accuracy	
# the_geom	
# object_id	
# build_type	
# build_subtype	
# vuln	
# vuln_1	
# vuln_2	
# object_id1	

#store in a dataframe
#New status after update
rrvs_status	<- rep("COMPLETED",length(data$SOURCE))
#generate new data.frame

#REMAP all names from idct to rem
rem <- data.frame(source,comment,plan_shape,position,nonstrcexw,roof_conn,
                  roofsysmat,roofcovmat,roof_shape,roofsystyp,str_irreg,
                  floor_conn,floor_mat,floor_type,foundn_sys,occupy,occupy_dt,
                  mat_prop,mat_tech,mat_type,llrs,llrs_duct,str_irreg_type,str_irreg_type_2,
                  height,height2,height_1,height_2,height2_1,height2_2,yr_built,
                  year_1,year_2,rrvs_status)
                  
####################################################
# Determine which buildings belong to the IDCT data
####################################################
query <- "DROP TABLE IF EXISTS idct"
drop_it <- sql_query(query)

idct.loc <- data.frame(data$X,data$Y)
idct.id  <- data.frame(seq_along(data$X))

#make sp object out of idct X and Y
#id0<-1
p4s="+proj=longlat +datum=WGS84 +no_defs"
idct.sp <- SpatialPointsDataFrame(SpatialPoints(idct.loc,proj4string=CRS(p4s)),proj4string=CRS(p4s),idct.id)

#create table with idct points on database
conn <- paste("PG:dbname=",dbname," user=",dbuser," password=",password," host=",host,sep="")
writeOGR(idct.sp, conn, layer_options = "geometry_name=geom", 
                           "idct", "PostgreSQL")

#find buildings which correspond to locations of idct
query = paste("WITH b AS (SELECT * FROM idct) SELECT gid,b.ogc_fid as iid,rrvs_status FROM asset.ve_object,b WHERE survey_gid=",survey_gid," AND rrvs_status='",status,"' AND ST_CONTAINS(the_geom,b.geom)",sep="") 
matches <- sql_query(query)

if (length(matches$gid)>0){
  #update the relevant buildings
  for (i in seq_along(matches$gid)){
    iid <- matches$iid[i]
    row <- rem[iid,]
    #remove empty columns (keeps unknown in database)
    row[which(row=='')]=NULL
    query <- rem_update(row,iid,matches$gid[i])
    sql_query(query)
  }
  print(paste("Found",length(matches$gid),"records and updated them"))
}else{
  print(paste("Found no matching records"))
}




