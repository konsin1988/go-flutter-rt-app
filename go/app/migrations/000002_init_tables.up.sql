-------------------------------------------------------------------  AI_CONVERSATION
CREATE TABLE if not exists ai.conversation (
	id int4 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL,
	user_id int4 NOT NULL,
	title varchar NOT NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	pinned_at timestamptz DEFAULT '1970-01-01 03:00:00+03'::timestamp with time zone NOT NULL,
	CONSTRAINT conversation_pk PRIMARY KEY (id)
);

----------------------------------------------------------- AI MESSAGE
CREATE EXTENSION IF NOT EXISTS vector;

CREATE TABLE if not exists ai.message (
	id int4 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL,
	conversation_id int4 NOT NULL,
	message_role_id int4 NOT NULL,
	"content" varchar NOT NULL,
	model varchar NULL,
	prompt_tokens int4 NULL,
	completion_tokens int4 NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	embedding vector(1536) NULL,
	CONSTRAINT message_pk PRIMARY KEY (id)
);
CREATE INDEX message_embedding_idx ON ai.message USING hnsw (embedding vector_cosine_ops);

------------------------------------------------------------- AI MESSAGE ROLE
CREATE TABLE if not exists ai.message_role (
	id int4 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL,
	"role" varchar NOT NULL,
	CONSTRAINT message_role_pk PRIMARY KEY (id)
);

-------------------------------------------------------------- B_USER
CREATE TABLE if not exists user_data.b_user (
	id int4 NOT NULL,
	first_name varchar(50) NULL,
	last_name varchar(50) NULL,
	second_name varchar(50) NULL,
	email varchar(50) NULL,
	birthday timestamptz NULL,
	photo varchar(128) NULL,
	mobile varchar(50) NULL,
	"position" varchar(128) NULL,
	dept varchar(50) NULL,
	phone_inner int4 NULL,
	CONSTRAINT b_user_pk PRIMARY KEY (id)
);


--------------------------------------------------------------- B_DEPARTMENT
CREATE TABLE if not exists user_data.b_department (
	id int4 NOT NULL,
	"name" varchar(128) NULL,
	parent int4 NULL,
	head int4 NULL,
	CONSTRAINT b_department_pk PRIMARY KEY (id)
);
