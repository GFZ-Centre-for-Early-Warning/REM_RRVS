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


#database settings
host <- 'localhost'
dbuser <- 'postgres'
password <- 'postgres'
dbname <- 'rem'
survey_gid <- 1
utm <- 32617
dbuffer <- 50


#sql function
sql_query <- function(sql){
  drv <- dbDriver("PostgreSQL")
  con <- dbConnect(drv, host=host, user=dbuser, password=password, dbname=dbname)
  on.exit(dbDisconnect(con))
  on.exit(dbUnloadDriver(drv), add = TRUE)
  post <- dbGetQuery(con, statement = sql)
  return(post)
}


#create paths for all streams in the database
query<-"SELECT t2.id AS tasks, o.gid ,ST_AsText(o.the_geom) AS wktgeom
FROM 
((asset.object_attribute AS oa
  INNER JOIN asset.object AS o ON oa.object_id = o.gid)
  INNER JOIN (SELECT t.id, UNNEST (bdg_gids) AS prueba FROM users.tasks AS t) AS t2 ON oa.object_id = prueba)
WHERE oa.attribute_type_code='COMMENT' AND oa.attribute_value LIKE '%iec%'AND o.source = 'Huella_LIS'"

buildings <- sql_query(query)

#for each task get images
for (i in length(buildings$tasks)){
  task_id <- buildings$tasks[i]
  bdg_id <- buildings$gid[i]
  #query images
  img_ids<-sql_query(paste("SELECT UNNEST(img_ids) AS id FROM users.tasks WHERE id=",task_id,";",sep=''))
  #additional images in buffer
  add_img<-sql_query(paste("SELECT i.gid AS id FROM image.img AS i, image.gps AS g, asset.object AS o WHERE o.gid=",bdg_id," AND i.gps=g.gid AND ST_DWITHIN(ST_Transform(ST_Centroid(o.the_geom),",utm,"),ST_Transform(g.the_geom,",utm,"),",dbuffer,")",sep=''))
  #union
  new_img_ids <- union(img_ids$id,add_img$id)
  #insert back into users.tasks
  array <- paste(img_ids,sep=',',collapse='')
  array <- substr(array,3,nchar(array)-1)
  query <- paste("UPDATE users.tasks SET img_ids='{",array,"}' WHERE id=",task_id,";",sep='')
  sql_query(query)
}
