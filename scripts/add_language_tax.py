#small script to add another language to the rem_db     taxonomy description
import pandas
import sqlalchemy

#file with translation and attribute code
language='es'
fn = 'translation.csv'

# database connection
user = 'postgres'
password = 'postgres'
host = 'localhost'

#read in file
translation = pandas.read_csv(fn,encoding='utf-8')

#db conn
engine = sqlalchemy.create_engine('postgresql://{}:{}@{}:5432/test'.format(user,password,host),encoding='utf-8')

#get table as is
taxonomy = pandas.read_sql("select * from taxonomy.dic_attribute_value;", engine)

#check if column is already there
new_column='description_'+language

if new_column in taxonomy.columns:
    inp = raw_input('WARNING: {} exists already! Shall it be updated (yes/no)'.format(new_column))
    if inp!='yes':
        raise Exception
    else:
        taxonomy.drop(new_column,axis=1)

#get only translation column and key
new_language = translation[['attribute_value','translation']]
new_language.columns=['attribute_value',new_column]
#updated taxonomy
updated=pandas.merge(taxonomy,new_language,on='attribute_value')
updated=updated.sort_values(by='gid')

#store data in pandas dataframe
updated.to_sql("dic_attribute_value", engine, schema="taxonomy",if_exists="replace",index=False)

#FIX: GETS DROPPED by pandas
#set names and comments constraints etc
res=engine.execute("SELECT MAX(gid)+1 FROM taxonomy.dic_attribute_value;")
max_gid = list(res)
max_gid = int(max_gid[0][0])

#print ('please run manually hangs might hang in db'
sql="""ALTER TABLE taxonomy.dic_attribute_value OWNER TO postgres;
    COMMENT ON TABLE taxonomy.dic_attribute_value IS 'The attribute type dictionary table. Contains information about the attribute types.';
    COMMENT ON TABLE taxonomy.dic_attribute_value IS 'The attribute type dictionary table. Contains information about the attribute types.';
     COMMENT ON COLUMN taxonomy.dic_attribute_value.gid IS 'Unique attribute value identifier';
     COMMENT ON COLUMN taxonomy.dic_attribute_value.attribute_type_code IS 'Code of the attribute type to which the   value refers to';
     COMMENT ON COLUMN taxonomy.dic_attribute_value.attribute_value IS 'Value of the attribute';
     COMMENT ON COLUMN taxonomy.dic_attribute_value.description IS 'Short textual description of the attribute value';
     COMMENT ON COLUMN taxonomy.dic_attribute_value.extended_description IS 'Extended textual description of the attribute value';
     ALTER TABLE taxonomy.dic_attribute_value ADD PRIMARY KEY (gid);
     ALTER TABLE taxonomy.dic_attribute_value ADD CONSTRAINT fk_attribute_type_code FOREIGN KEY (attribute_type_code) REFERENCES taxonomy.dic_attribute_type (code) MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION;"""
res=engine.execute(sql)

sql="""CREATE INDEX idx_dic_attribute_value ON taxonomy.dic_attribute_value USING btree (attribute_type_code COLLATE pg_catalog."default");
     CREATE SEQUENCE taxonomy.dic_attribute_value_gid_seq START WITH {} OWNED BY taxonomy.dic_attribute_value.gid;
     ALTER TABLE taxonomy.dic_attribute_value ALTER COLUMN gid SET DEFAULT NEXTVAL('taxonomy.dic_attribute_value_gid_seq'); """.format(max_gid)
res=engine.execute(sql)
