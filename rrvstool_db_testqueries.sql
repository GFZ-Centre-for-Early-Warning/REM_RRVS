------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
-- Name: RRVS database multi-temporal support examples
-- Date: 13.01.16
-- Author: M. Wieland
-- DBMS: PostgreSQL9.2 / PostGIS2.0
-- Description: Some examples to 
--			- activate/deactivate logging of transactions
--			- properly insert, update and delete entries with temporal component
--			- transaction and valid time history
--			- spatio-temporal queries
------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------
-- Example for activation/deactivation of logging transactions on a table or view --
------------------------------------------------------------------------------------
-- selective transaction logs: history.history_table(target_table regclass, history_view boolean, history_query_text boolean, excluded_cols text[]) 
SELECT history.history_table('asset.object', 'false', 'false', '{source, accuracy}'::text[]);	--activate table log with no query text activated and excluded cols specified
SELECT history.history_table('asset.ve_object', 'true', 'false');	--activate logs for a view

--deactivate transaction logs on table
DROP TRIGGER IF EXISTS history_trigger_row ON asset.object;

--deactivate transaction logs on view
DROP TRIGGER IF EXISTS zhistory_trigger_row ON asset.ve_object;
DROP TRIGGER IF EXISTS zhistory_trigger_row_modified ON history.logged_actions;

----------------------------------------------------------------------------------------
-- Example statements to properly INSERT, UPDATE or DELETE objects for different cases--
----------------------------------------------------------------------------------------
--INSERT an object cause of a real world construction: 1. mark the object change type as 'BUILT'; 2. set the date of construction; 3. insert it
insert into asset.ve_object (description, yr_built_vt, yr_built_vt1) values ('insert', 'BUILT', '01-01-2000');

--UPDATE an object cause of a real world modification: 1. mark the object change type as 'MODIF'; 2. set the date of modification; 3. update it
update asset.ve_object set description='modified', yr_built_vt='MODIF', yr_built_vt1='01-01-2002' where gid=2898;

--UPDATE an object cause of a correction or cause more information gets available (no real world change): update it without marking the object change type
update asset.ve_object set description='modified_corrected' where gid=2898;

--DELETE an object cause of a real world destruction: 1. mark the object change type as 'DESTR'; 2. set the date of destruction; 3. delete it
update asset.ve_object set description='deleted', yr_built_vt='DESTR', yr_built_vt1='01-01-2014' where gid=2898;
delete from asset.ve_object where gid=2898;

-----------------------------------------------------------------
------------ Example of a "spatio-temporal query" ---------------
-----------------------------------------------------------------
-- This performs a spatio-temporal query that selects all the buildings that
-- Valid time: were modified between 2013-12-01 and 2014-12-01,
-- Spatial: are located inside a buffer of 50m to a street,
-- Attribute: that are of material type MR and
-- Transaction time: that got an information update within the last two weeḱs from the issue of the query.
SELECT DISTINCT ON (a.gid) a.* FROM history.vtime_history as a, public.streets_osm as b WHERE 
	a.yr_built_vt1 >= '2013-12-01' AND a.yr_built_vt1 <= '2014-12-01' AND a.yr_built_vt = 'MODIF' AND
	ST_INTERSECTS(ST_BUFFER(ST_TRANSFORM(b.the_geom,32632),50), ST_TRANSFORM(a.the_geom,32632)) IS TRUE AND
	a.mat_type = 'MR' AND
	a.transaction_timestamp > (timestamp 'now' - interval '1 week')
	ORDER BY a.gid, a.transaction_timestamp DESC;