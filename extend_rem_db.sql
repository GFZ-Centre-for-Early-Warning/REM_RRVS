--
-- This script extends an existing REM database for the RRVS Webtool user schema
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;


CREATE SCHEMA users;

ALTER SCHEMA users OWNER TO postgres;

SET search_path = users, pg_catalog;

--
-- Name: roles; Type: TABLE; Schema: users; Owner: postgres; Tablespace: 
--

CREATE TABLE roles (
    id integer NOT NULL,
    name character varying(254)
);

ALTER TABLE users.roles OWNER TO postgres;

ALTER TABLE ONLY roles
    ADD CONSTRAINT role_pkey PRIMARY KEY (id);

--
-- Name: users; Type: TABLE; Schema: users; Owner: postgres; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    authenticated boolean,
    name character varying(25)
);

ALTER TABLE users.users OWNER TO postgres;
ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);

--
-- Name: roles_users; Type: TABLE; Schema: users; Owner: postgres; Tablespace: 
--

CREATE TABLE roles_users (
    user_id integer,
    role_id integer
);


ALTER TABLE users.roles_users OWNER TO postgres;
ALTER TABLE ONLY roles_users
    ADD CONSTRAINT roles_users_role_id_fkey FOREIGN KEY (role_id) REFERENCES roles(id);
ALTER TABLE ONLY roles_users
    ADD CONSTRAINT roles_users_users_id_fkey FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: tasks; Type: TABLE; Schema: users; Owner: postgres; Tablespace: 
--

CREATE TABLE tasks (
    id integer NOT NULL,
    bdg_gids integer[],
    img_ids integer[]
);


ALTER TABLE users.tasks OWNER TO postgres;
ALTER TABLE ONLY tasks
    ADD CONSTRAINT task_pkey PRIMARY KEY (id);

--
-- Name: tasks_users; Type: TABLE; Schema: users; Owner: postgres; Tablespace: 
--

CREATE TABLE tasks_users (
    user_id integer,
    task_id integer
);


ALTER TABLE users.tasks_users OWNER TO postgres;
ALTER TABLE ONLY tasks_users
    ADD CONSTRAINT tasks_users_task_id_fkey FOREIGN KEY (task_id) REFERENCES tasks(id);
ALTER TABLE ONLY tasks_users
    ADD CONSTRAINT tasks_users_users_id_fkey FOREIGN KEY (user_id) REFERENCES users(id);

