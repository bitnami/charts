-- ----------------------------
-- drop table if exists
-- ----------------------------

drop table if exists "public"."t_user";
drop table if exists "public"."t_member";
drop table if exists "public"."t_setting";
drop table if exists "public"."t_role";
drop table if exists "public"."t_role_menu";
drop table if exists "public"."t_menu";
drop table if exists "public"."t_message";
drop table if exists "public"."t_flink_sql";
drop table if exists "public"."t_flink_savepoint";
drop table if exists "public"."t_flink_project";
drop table if exists "public"."t_flink_env";
drop table if exists "public"."t_flink_effective";
drop table if exists "public"."t_flink_config";
drop table if exists "public"."t_flink_cluster";
drop table if exists "public"."t_flink_app";
drop table if exists "public"."t_app_build_pipe";
drop table if exists "public"."t_app_backup";
drop table if exists "public"."t_alert_config";
drop table if exists "public"."t_access_token";
drop table if exists "public"."t_flink_log";
drop table if exists "public"."t_team";
drop table if exists "public"."t_variable";
drop table if exists "public"."t_external_link";
drop table if exists "public"."t_yarn_queue";

-- ----------------------------
-- drop sequence if exists
-- ----------------------------
drop sequence if exists "public"."streampark_t_user_id_seq";
drop sequence if exists "public"."streampark_t_member_id_seq";
drop sequence if exists "public"."streampark_t_role_id_seq";
drop sequence if exists "public"."streampark_t_role_menu_id_seq";
drop sequence if exists "public"."streampark_t_menu_id_seq";
drop sequence if exists "public"."streampark_t_message_id_seq";
drop sequence if exists "public"."streampark_t_flink_sql_id_seq";
drop sequence if exists "public"."streampark_t_flink_savepoint_id_seq";
drop sequence if exists "public"."streampark_t_flink_project_id_seq";
drop sequence if exists "public"."streampark_t_flink_env_id_seq";
drop sequence if exists "public"."streampark_t_flink_effective_id_seq";
drop sequence if exists "public"."streampark_t_flink_config_id_seq";
drop sequence if exists "public"."streampark_t_flink_cluster_id_seq";
drop sequence if exists "public"."streampark_t_flink_app_id_seq";
drop sequence if exists "public"."streampark_t_app_backup_id_seq";
drop sequence if exists "public"."streampark_t_alert_config_id_seq";
drop sequence if exists "public"."streampark_t_access_token_id_seq";
drop sequence if exists "public"."streampark_t_flink_log_id_seq";
drop sequence if exists "public"."streampark_t_team_id_seq";
drop sequence if exists "public"."streampark_t_variable_id_seq";
drop sequence if exists "public"."streampark_t_external_link_id_seq";
drop sequence if exists "public"."streampark_t_yarn_queue_id_seq";

-- ----------------------------
-- drop trigger if exists
-- ----------------------------
drop trigger if exists "streampark_t_access_token_modify_time_tri" on "public"."t_access_token";
drop trigger if exists "streampark_t_app_build_pipe_modify_time_tri" on "public"."t_app_build_pipe";
drop trigger if exists "streampark_t_flink_app_modify_time_tri" on "public"."t_flink_app";
drop trigger if exists "streampark_t_flink_project_modify_time_tri" on "public"."t_flink_project";
drop trigger if exists "streampark_t_menu_modify_time_tri" on "public"."t_menu";
drop trigger if exists "streampark_t_role_modify_time_tri" on "public"."t_role";
drop trigger if exists "streampark_t_user_modify_time_tri" on "public"."t_user";
drop trigger if exists "streampark_t_alert_config_modify_time_tri" on "public"."t_alert_config";

-- ----------------------------
-- table structure for t_access_token
-- ----------------------------
create sequence if not exists "public"."streampark_t_access_token_id_seq"
    increment 1 start 10000 cache 1 minvalue 10000 maxvalue 9223372036854775807;

create table "public"."t_access_token" (
  "id" int4 not null default nextval('streampark_t_access_token_id_seq'::regclass),
  "user_id" int8,
  "token" varchar(1024) collate "pg_catalog"."default",
  "expire_time" timestamp(6),
  "description" varchar(255) collate "pg_catalog"."default",
  "status" int2,
  "create_time" timestamp(6),
  "modify_time" timestamp(6)
);
comment on column "public"."t_access_token"."id" is 'key';
comment on column "public"."t_access_token"."token" is 'token';
comment on column "public"."t_access_token"."expire_time" is 'expiration time';
comment on column "public"."t_access_token"."description" is 'description';
comment on column "public"."t_access_token"."status" is '1:enable,0:disable';
comment on column "public"."t_access_token"."create_time" is 'create time';
comment on column "public"."t_access_token"."modify_time" is 'modify time';
alter table "public"."t_access_token" add constraint "t_access_token_pkey" primary key ("id");


-- ----------------------------
-- table structure for t_alert_config
-- ----------------------------
create sequence "public"."streampark_t_alert_config_id_seq"
    increment 1 start 10000 cache 1 minvalue 10000 maxvalue 9223372036854775807;

create table "public"."t_alert_config" (
  "id" int8 not null default nextval('streampark_t_alert_config_id_seq'::regclass),
  "user_id" int8,
  "alert_name" varchar(128) collate "pg_catalog"."default",
  "alert_type" int4 default 0,
  "email_params" varchar(255) collate "pg_catalog"."default",
  "sms_params" text collate "pg_catalog"."default",
  "ding_talk_params" text collate "pg_catalog"."default",
  "we_com_params" varchar(255) collate "pg_catalog"."default",
  "http_callback_params" text collate "pg_catalog"."default",
  "lark_params" text collate "pg_catalog"."default",
  "create_time" timestamp(6),
  "modify_time" timestamp(6)
)
;
comment on column "public"."t_alert_config"."alert_name" is 'alert name';
comment on column "public"."t_alert_config"."alert_type" is 'alert type';
comment on column "public"."t_alert_config"."email_params" is 'email params';
comment on column "public"."t_alert_config"."sms_params" is 'sms params';
comment on column "public"."t_alert_config"."ding_talk_params" is 'ding talk params';
comment on column "public"."t_alert_config"."we_com_params" is 'we com params';
comment on column "public"."t_alert_config"."http_callback_params" is 'http callback params';
comment on column "public"."t_alert_config"."lark_params" is 'lark params';
comment on column "public"."t_alert_config"."create_time" is 'create time';
comment on column "public"."t_alert_config"."modify_time" is 'modify time';
alter table "public"."t_alert_config" add constraint "t_alert_config_pkey" primary key ("id");
create index "inx_alert_user" on "public"."t_alert_config" using btree (
  "user_id" "pg_catalog"."int8_ops" asc nulls last
);


-- ----------------------------
-- table structure for t_app_backup
-- ----------------------------
create sequence "public"."streampark_t_app_backup_id_seq"
    increment 1 start 10000 cache 1 minvalue 10000 maxvalue 9223372036854775807;

create table "public"."t_app_backup" (
  "id" int8 not null default nextval('streampark_t_app_backup_id_seq'::regclass),
  "app_id" int8,
  "sql_id" int8,
  "config_id" int8,
  "version" int4,
  "path" varchar(128) collate "pg_catalog"."default",
  "description" varchar(255) collate "pg_catalog"."default",
  "create_time" timestamp(6)
)
;
alter table "public"."t_app_backup" add constraint "t_app_backup_pkey" primary key ("id");


-- ----------------------------
-- table structure for t_app_build_pipe
-- ----------------------------
create table "public"."t_app_build_pipe" (
  "app_id" int8 not null,
  "pipe_type" int2,
  "pipe_status" int2,
  "cur_step" int2,
  "total_step" int2,
  "steps_status" text collate "pg_catalog"."default",
  "steps_status_ts" text collate "pg_catalog"."default",
  "error" text collate "pg_catalog"."default",
  "build_result" text collate "pg_catalog"."default",
  "modify_time" timestamp(6)
)
;
alter table "public"."t_app_build_pipe" add constraint "t_app_build_pipe_pkey" primary key ("app_id");

-- ----------------------------
-- table structure for t_flink_app
-- ----------------------------
create sequence "public"."streampark_t_flink_app_id_seq"
    increment 1 start 10000 cache 1 minvalue 10000 maxvalue 9223372036854775807;

create table "public"."t_flink_app" (
  "id" int8 not null default nextval('streampark_t_flink_app_id_seq'::regclass),
  "team_id" int8,
  "job_type" int2,
  "execution_mode" int2,
  "resource_from" int2,
  "project_id" bigint,
  "job_name" varchar(255) collate "pg_catalog"."default",
  "module" varchar(255) collate "pg_catalog"."default",
  "jar" varchar(255) collate "pg_catalog"."default",
  "jar_check_sum" int8,
  "main_class" varchar(255) collate "pg_catalog"."default",
  "dependency" text collate "pg_catalog"."default",
  "args" text collate "pg_catalog"."default",
  "options" text collate "pg_catalog"."default",
  "hot_params" text collate "pg_catalog"."default",
  "user_id" int8,
  "app_type" int2,
  "duration" int8,
  "job_id" varchar(64) collate "pg_catalog"."default",
  "job_manager_url" varchar(255) collate "pg_catalog"."default",
  "version_id" int8,
  "cluster_id" varchar(45) collate "pg_catalog"."default",
  "k8s_namespace" varchar(63) collate "pg_catalog"."default",
  "flink_image" varchar(128) collate "pg_catalog"."default",
  "state" int2,
  "restart_size" int4,
  "restart_count" int4,
  "cp_threshold" int4,
  "cp_max_failure_interval" int4,
  "cp_failure_rate_interval" int4,
  "cp_failure_action" int2,
  "dynamic_properties" text collate "pg_catalog"."default",
  "description" varchar(255) collate "pg_catalog"."default",
  "resolve_order" int2,
  "k8s_rest_exposed_type" int2,
  "jm_memory" int4,
  "tm_memory" int4,
  "total_task" int4,
  "total_tm" int4,
  "total_slot" int4,
  "available_slot" int4,
  "option_state" int2,
  "tracking" int2,
  "create_time" timestamp(6),
  "modify_time" timestamp(6),
  "option_time" timestamp(6),
  "release" int2 default 1,
  "build" boolean default true,
  "start_time" timestamp(6),
  "end_time" timestamp(6),
  "alert_id" int8,
  "k8s_pod_template" text collate "pg_catalog"."default",
  "k8s_jm_pod_template" text collate "pg_catalog"."default",
  "k8s_tm_pod_template" text collate "pg_catalog"."default",
  "k8s_hadoop_integration" boolean default false,
  "flink_cluster_id" int8,
  "ingress_template" text collate "pg_catalog"."default",
  "default_mode_ingress" text collate "pg_catalog"."default",
  "tags" varchar(500) collate "pg_catalog"."default"
)
;
alter table "public"."t_flink_app" add constraint "t_flink_app_pkey" primary key ("id");
create index "inx_job_type" on "public"."t_flink_app" using btree (
  "job_type" "pg_catalog"."int2_ops" asc nulls last
);
create index "inx_track" on "public"."t_flink_app" using btree (
  "tracking" "pg_catalog"."int2_ops" asc nulls last
);
create index "inx_team_app" on "public"."t_flink_app" using btree (
  "team_id" "pg_catalog"."int8_ops" asc nulls last
);

-- ----------------------------
-- table structure for t_flink_cluster
-- ----------------------------
create sequence "public"."streampark_t_flink_cluster_id_seq"
    increment 1 start 10000 cache 1 minvalue 10000 maxvalue 9223372036854775807;

create table "public"."t_flink_cluster" (
  "id" int8 not null default nextval('streampark_t_flink_cluster_id_seq'::regclass),
  "address" varchar(150) collate "pg_catalog"."default",
  "cluster_id" varchar(45) collate "pg_catalog"."default",
  "cluster_name" varchar(128) collate "pg_catalog"."default" not null,
  "options" text collate "pg_catalog"."default",
  "yarn_queue" varchar(128) collate "pg_catalog"."default",
  "execution_mode" int2 not null default 1,
  "version_id" int8 not null,
  "k8s_namespace" varchar(63) collate "pg_catalog"."default",
  "service_account" varchar(64) collate "pg_catalog"."default",
  "description" varchar(255) collate "pg_catalog"."default",
  "user_id" int8,
  "flink_image" varchar(128) collate "pg_catalog"."default",
  "dynamic_properties" text collate "pg_catalog"."default",
  "k8s_rest_exposed_type" int2 default 2,
  "k8s_hadoop_integration" boolean default false,
  "k8s_conf" varchar(255) collate "pg_catalog"."default",
  "resolve_order" int4,
  "exception" text collate "pg_catalog"."default",
  "cluster_state" int2 default 0,
  "create_time" timestamp(6)
)
;
comment on column "public"."t_flink_cluster"."address" is 'url address of jobmanager';
comment on column "public"."t_flink_cluster"."cluster_id" is 'clusterid of session mode(yarn-session:application-id,k8s-session:cluster-id)';
comment on column "public"."t_flink_cluster"."cluster_name" is 'cluster name';
comment on column "public"."t_flink_cluster"."options" is 'parameter collection json form';
comment on column "public"."t_flink_cluster"."yarn_queue" is 'the yarn queue where the task is located';
comment on column "public"."t_flink_cluster"."execution_mode" is 'k8s execution session mode(1:remote,3:yarn-session,5:kubernetes-session)';
comment on column "public"."t_flink_cluster"."version_id" is 'flink version id';
comment on column "public"."t_flink_cluster"."k8s_namespace" is 'k8s namespace';
comment on column "public"."t_flink_cluster"."service_account" is 'k8s service account';
comment on column "public"."t_flink_cluster"."flink_image" is 'flink image';
comment on column "public"."t_flink_cluster"."dynamic_properties" is 'allows specifying multiple generic configuration options';
comment on column "public"."t_flink_cluster"."k8s_rest_exposed_type" is 'k8s export(0:loadbalancer,1:clusterip,2:nodeport)';
comment on column "public"."t_flink_cluster"."k8s_conf" is 'the path where the k 8 s configuration file is located';
comment on column "public"."t_flink_cluster"."exception" is 'exception information';
comment on column "public"."t_flink_cluster"."cluster_state" is 'cluster status (0: create not started, 1: started, 2: stopped)';
alter table "public"."t_flink_cluster" add constraint "t_flink_cluster_pkey" primary key ("id", "cluster_name");
create index "id" on "public"."t_flink_cluster" using btree (
  "cluster_id" collate "pg_catalog"."default" "pg_catalog"."text_ops" asc nulls last,
  "address" collate "pg_catalog"."default" "pg_catalog"."text_ops" asc nulls last,
  "execution_mode" "pg_catalog"."int2_ops" asc nulls last
);


-- ----------------------------
-- table structure for t_flink_config
-- ----------------------------
create sequence "public"."streampark_t_flink_config_id_seq"
    increment 1 start 10000 cache 1 minvalue 10000 maxvalue 9223372036854775807;

create table "public"."t_flink_config" (
  "id" int8 not null default nextval('streampark_t_flink_config_id_seq'::regclass),
  "app_id" int8 not null,
  "format" int2 not null default 0,
  "version" int4 not null,
  "latest" boolean not null default false,
  "content" text collate "pg_catalog"."default" not null,
  "create_time" timestamp(6)
)
;
alter table "public"."t_flink_config" add constraint "t_flink_config_pkey" primary key ("id");


-- ----------------------------
-- table structure for t_flink_effective
-- ----------------------------
create sequence "public"."streampark_t_flink_effective_id_seq"
    increment 1 start 10000 cache 1 minvalue 10000 maxvalue 9223372036854775807;

create table "public"."t_flink_effective" (
  "id" int8 not null default nextval('streampark_t_flink_effective_id_seq'::regclass),
  "app_id" int8 not null,
  "target_type" int2 not null,
  "target_id" int8 not null,
  "create_time" timestamp(6)
)
;
comment on column "public"."t_flink_effective"."target_type" is '1) config 2) flink sql';
comment on column "public"."t_flink_effective"."target_id" is 'configid or sqlid';
alter table "public"."t_flink_effective" add constraint "t_flink_effective_pkey" primary key ("id");
create index "un_effective_inx" on "public"."t_flink_effective" using btree (
  "app_id" "pg_catalog"."int8_ops" asc nulls last,
  "target_type" "pg_catalog"."int2_ops" asc nulls last
);


-- ----------------------------
-- table structure for t_flink_env
-- ----------------------------
create sequence "public"."streampark_t_flink_env_id_seq"
    increment 1 start 10000 cache 1 minvalue 10000 maxvalue 9223372036854775807;

create table "public"."t_flink_env" (
  "id" int8 not null default nextval('streampark_t_flink_env_id_seq'::regclass),
  "flink_name" varchar(128) collate "pg_catalog"."default" not null,
  "flink_home" varchar(255) collate "pg_catalog"."default" not null,
  "version" varchar(64) collate "pg_catalog"."default" not null,
  "scala_version" varchar(64) collate "pg_catalog"."default" not null,
  "flink_conf" text collate "pg_catalog"."default" not null,
  "is_default" boolean not null default false,
  "description" varchar(255) collate "pg_catalog"."default",
  "create_time" timestamp(6)
)
;
comment on column "public"."t_flink_env"."id" is 'id';
comment on column "public"."t_flink_env"."flink_name" is 'flink instance name';
comment on column "public"."t_flink_env"."flink_home" is 'flink home path';
comment on column "public"."t_flink_env"."version" is 'the version number corresponding to flink';
comment on column "public"."t_flink_env"."scala_version" is 'the scala version number corresponding to flink';
comment on column "public"."t_flink_env"."flink_conf" is 'flink conf configuration content';
comment on column "public"."t_flink_env"."is_default" is 'is it the default version';
comment on column "public"."t_flink_env"."description" is 'description';
comment on column "public"."t_flink_env"."create_time" is 'create time';
alter table "public"."t_flink_env" add constraint "t_flink_env_pkey" primary key ("id");
create index "un_env_name" on "public"."t_flink_env" using btree (
  "flink_name" collate "pg_catalog"."default" "pg_catalog"."text_ops" asc nulls last
);


-- ----------------------------
-- table structure for t_flink_log
-- ----------------------------
create sequence "public"."streampark_t_flink_log_id_seq"
    increment 1 start 10000 cache 1 minvalue 10000 maxvalue 9223372036854775807;

create table "public"."t_flink_log" (
  "id" int8 not null default nextval('streampark_t_flink_log_id_seq'::regclass),
  "app_id" int8,
  "yarn_app_id" varchar(64) collate "pg_catalog"."default",
  "job_manager_url" varchar(255) collate "pg_catalog"."default",
  "success" boolean,
  "exception" text collate "pg_catalog"."default",
  "option_time" timestamp(6),
  "option_name" int2
)
;
alter table "public"."t_flink_log" add constraint "t_flink_log_pkey" primary key ("id");


-- ----------------------------
-- table structure for t_flink_project
-- ----------------------------
create sequence "public"."streampark_t_flink_project_id_seq"
    increment 1 start 10000 cache 1 minvalue 10000 maxvalue 9223372036854775807;

create table "public"."t_flink_project" (
  "id" int8 not null default nextval('streampark_t_flink_project_id_seq'::regclass),
  "team_id" int8,
  "name" varchar(255) collate "pg_catalog"."default",
  "url" varchar(255) collate "pg_catalog"."default",
  "refs" varchar(64) collate "pg_catalog"."default",
  "user_name" varchar(64) collate "pg_catalog"."default",
  "password" varchar(64) collate "pg_catalog"."default",
  "prvkey_path" varchar(128) collate "pg_catalog"."default",
  "pom" varchar(255) collate "pg_catalog"."default",
  "build_args" varchar(255) collate "pg_catalog"."default",
  "type" int2,
  "repository" int2,
  "last_build" timestamp(6),
  "description" varchar(255) collate "pg_catalog"."default",
  "build_state" int2 default -1,
  "create_time" timestamp(6),
  "modify_time" timestamp(6)
)
;
alter table "public"."t_flink_project" add constraint "t_flink_project_pkey" primary key ("id");
create index "inx_team_project" on "public"."t_flink_project" using btree (
  "team_id" "pg_catalog"."int8_ops" asc nulls last
);


-- ----------------------------
-- table structure for t_flink_savepoint
-- ----------------------------
create sequence "public"."streampark_t_flink_savepoint_id_seq"
    increment 1 start 10000 cache 1 minvalue 10000 maxvalue 9223372036854775807;

create table "public"."t_flink_savepoint" (
  "id" int8 not null default nextval('streampark_t_flink_savepoint_id_seq'::regclass),
  "app_id" int8 not null,
  "chk_id" int8,
  "type" int2,
  "path" varchar(255) collate "pg_catalog"."default",
  "latest" boolean not null default true,
  "trigger_time" timestamp(6),
  "create_time" timestamp(6)
)
;
alter table "public"."t_flink_savepoint" add constraint "t_flink_savepoint_pkey" primary key ("id");


-- ----------------------------
-- table structure for t_flink_sql
-- ----------------------------
create sequence "public"."streampark_t_flink_sql_id_seq"
    increment 1 start 10000 cache 1 minvalue 10000 maxvalue 9223372036854775807;

create table "public"."t_flink_sql" (
  "id" int8 not null default nextval('streampark_t_flink_sql_id_seq'::regclass),
  "app_id" int8,
  "sql" text collate "pg_catalog"."default",
  "dependency" text collate "pg_catalog"."default",
  "version" int4,
  "candidate" int2 default 1 not null,
  "create_time" timestamp(6)
)
;
alter table "public"."t_flink_sql" add constraint "t_flink_sql_pkey" primary key ("id");


-- ----------------------------
-- table structure for t_menu
-- ----------------------------
create sequence "public"."streampark_t_menu_id_seq"
    increment 1 start 10000 cache 1 minvalue 10000 maxvalue 9223372036854775807;

create table "public"."t_menu" (
  "menu_id" int8 not null default nextval('streampark_t_menu_id_seq'::regclass),
  "parent_id" int8 not null,
  "menu_name" varchar(64) collate "pg_catalog"."default" not null,
  "path" varchar(64) collate "pg_catalog"."default",
  "component" varchar(64) collate "pg_catalog"."default",
  "perms" varchar(64) collate "pg_catalog"."default",
  "icon" varchar(64) collate "pg_catalog"."default",
  "type" int2,
  "display" boolean not null default true,
  "order_num" float8,
  "create_time" timestamp(6),
  "modify_time" timestamp(6)
)
;
comment on column "public"."t_menu"."menu_id" is 'menu button id';
comment on column "public"."t_menu"."parent_id" is 'parent menu id';
comment on column "public"."t_menu"."menu_name" is 'menu button name';
comment on column "public"."t_menu"."path" is 'routing path';
comment on column "public"."t_menu"."component" is 'corresponding routing component component';
comment on column "public"."t_menu"."perms" is 'authority id';
comment on column "public"."t_menu"."icon" is 'icon';
comment on column "public"."t_menu"."type" is 'type 0:menu 1:button';
comment on column "public"."t_menu"."display" is 'menu is displayed';
comment on column "public"."t_menu"."order_num" is 'sort';
comment on column "public"."t_menu"."create_time" is 'creation time';
comment on column "public"."t_menu"."modify_time" is 'modify time';
alter table "public"."t_menu" add constraint "t_menu_pkey" primary key ("menu_id");


-- ----------------------------
-- table structure for t_message
-- ----------------------------
create sequence "public"."streampark_t_message_id_seq"
    increment 1 start 10000 cache 1 minvalue 10000 maxvalue 9223372036854775807;

create table "public"."t_message" (
  "id" int8 not null default nextval('streampark_t_message_id_seq'::regclass),
  "app_id" int8,
  "user_id" int8,
  "type" int2,
  "title" varchar(255) collate "pg_catalog"."default",
  "context" text collate "pg_catalog"."default",
  "is_read" boolean default false,
  "create_time" timestamp(6)
)
;
alter table "public"."t_message" add constraint "t_message_pkey" primary key ("id");
create index "inx_mes_user" on "public"."t_message" using btree (
  "user_id" "pg_catalog"."int8_ops" asc nulls last
);


-- ----------------------------
-- Table of t_team
-- ----------------------------

create sequence "public"."streampark_t_team_id_seq"
    increment 1 start 10000 cache 1 minvalue 10000 maxvalue 9223372036854775807;

create table "public"."t_team" (
  "id" int8 not null default nextval('streampark_t_team_id_seq'::regclass),
  "team_name" varchar(64) collate "pg_catalog"."default" not null,
  "description" varchar(255) collate "pg_catalog"."default" default null,
  "create_time" timestamp(6),
  "modify_time" timestamp(6)
)
;
comment on column "public"."t_team"."id" is 'team id';
comment on column "public"."t_team"."team_name" is 'team name';
comment on column "public"."t_team"."create_time" is 'creation time';
comment on column "public"."t_team"."modify_time" is 'modify time';
create index "un_team_name" on "public"."t_team" using btree (
  "team_name" collate "pg_catalog"."default" "pg_catalog"."text_ops" asc nulls last
);

-- ----------------------------
-- Table of t_variable
-- ----------------------------
create sequence "public"."streampark_t_variable_id_seq"
    increment 1 start 10000 cache 1 minvalue 10000 maxvalue 9223372036854775807;

create table "public"."t_variable" (
  "id" int8 not null default nextval('streampark_t_variable_id_seq'::regclass),
  "variable_code" varchar(128) collate "pg_catalog"."default" not null,
  "variable_value" text collate "pg_catalog"."default" not null,
  "description" text collate "pg_catalog"."default" default null,
  "creator_id" int8  not null,
  "team_id" int8  not null,
  "desensitization" boolean not null default false,
  "create_time" timestamp(6),
  "modify_time" timestamp(6)
)
;
comment on column "public"."t_variable"."id" is 'variable id';
comment on column "public"."t_variable"."variable_code" is 'Variable code is used for parameter names passed to the program or as placeholders';
comment on column "public"."t_variable"."variable_value" is 'The specific value corresponding to the variable';
comment on column "public"."t_variable"."description" is 'More detailed description of variables';
comment on column "public"."t_variable"."creator_id" is 'user id of creator';
comment on column "public"."t_variable"."team_id" is 'team id';
comment on column "public"."t_variable"."desensitization" is '0 is no desensitization, 1 is desensitization, if set to desensitization, it will be replaced by * when displayed';
comment on column "public"."t_variable"."create_time" is 'creation time';
comment on column "public"."t_variable"."modify_time" is 'modify time';

alter table "public"."t_variable" add constraint "t_variable_pkey" primary key ("id");
create index "un_team_vcode_inx" on "public"."t_variable" using btree (
  "team_id" "pg_catalog"."int8_ops" asc nulls last,
  "variable_code" collate "pg_catalog"."default" "pg_catalog"."text_ops" asc nulls last
);


-- ----------------------------
-- table structure for t_role
-- ----------------------------
create sequence "public"."streampark_t_role_id_seq"
    increment 1 start 10000 cache 1 minvalue 10000 maxvalue 9223372036854775807;

create table "public"."t_role" (
  "role_id" int8 not null default nextval('streampark_t_role_id_seq'::regclass),
  "role_name" varchar(64) collate "pg_catalog"."default" not null,
  "create_time" timestamp(6),
  "modify_time" timestamp(6),
  "description" varchar(255) collate "pg_catalog"."default"
)
;
comment on column "public"."t_role"."role_id" is 'role id';
comment on column "public"."t_role"."role_name" is 'role name';
comment on column "public"."t_role"."description" is 'role description';
comment on column "public"."t_role"."create_time" is 'creation time';
comment on column "public"."t_role"."modify_time" is 'modify time';
alter table "public"."t_role" add constraint "t_role_pkey" primary key ("role_id");


-- ----------------------------
-- table structure for t_role_menu
-- ----------------------------
create sequence "public"."streampark_t_role_menu_id_seq"
    increment 1 start 10000 cache 1 minvalue 10000 maxvalue 9223372036854775807;

create table "public"."t_role_menu" (
  "id" int8 not null default nextval('streampark_t_role_menu_id_seq'::regclass),
  "role_id" int8 not null,
  "menu_id" int8 not null
)
;
alter table "public"."t_role_menu" add constraint "t_role_menu_pkey" primary key ("id");
create index "un_role_menu_inx" on "public"."t_role_menu" using btree (
  "role_id" "pg_catalog"."int8_ops" asc nulls last,
  "menu_id" "pg_catalog"."int8_ops" asc nulls last
);


-- ----------------------------
-- table structure for t_setting
-- ----------------------------
create table "public"."t_setting" (
  "order_num" int4,
  "setting_key" varchar(64) collate "pg_catalog"."default" not null,
  "setting_value" text collate "pg_catalog"."default",
  "setting_name" varchar(255) collate "pg_catalog"."default",
  "description" varchar(255) collate "pg_catalog"."default",
  "type" int2 not null
)
;
comment on column "public"."t_setting"."type" is '1: input 2: boolean 3: number';
alter table "public"."t_setting" add constraint "t_setting_pkey" primary key ("setting_key");

-- ----------------------------
-- table structure for t_user
-- ----------------------------
create sequence "public"."streampark_t_user_id_seq"
    increment 1 start 10000 cache 1 minvalue 10000 maxvalue 9223372036854775807;

create table "public"."t_user" (
  "user_id" int8 not null default nextval('streampark_t_user_id_seq'::regclass),
  "username" varchar(64) collate "pg_catalog"."default" not null,
  "nick_name" varchar(64) collate "pg_catalog"."default" not null,
  "salt" varchar(26) collate "pg_catalog"."default",
  "password" varchar(64) collate "pg_catalog"."default" not null,
  "email" varchar(64) collate "pg_catalog"."default",
  "user_type" int4,
  "login_type" int2 default 0,
  "last_team_id" int8,
  "status" int2,
  "create_time" timestamp(6),
  "modify_time" timestamp(6),
  "last_login_time" timestamp(6),
  "sex" char(1) collate "pg_catalog"."default",
  "avatar" varchar(128) collate "pg_catalog"."default",
  "description" varchar(255) collate "pg_catalog"."default"
)
;
comment on column "public"."t_user"."user_id" is 'user id';
comment on column "public"."t_user"."username" is 'user name';
comment on column "public"."t_user"."nick_name" is 'nick name';
comment on column "public"."t_user"."salt" is 'salt';
comment on column "public"."t_user"."password" is 'password';
comment on column "public"."t_user"."email" is 'email';
comment on column "public"."t_user"."user_type" is 'user type 1:admin 2:user';
comment on column "public"."t_user"."login_type" is 'login type 0:password 1:ldap';
comment on column "public"."t_user"."last_team_id" is 'last team id';
comment on column "public"."t_user"."status" is 'status 0:locked 1:active';
comment on column "public"."t_user"."create_time" is 'creation time';
comment on column "public"."t_user"."modify_time" is 'change time';
comment on column "public"."t_user"."last_login_time" is 'last login time';
comment on column "public"."t_user"."sex" is 'gender 0:male 1:female 2:confidential';
comment on column "public"."t_user"."avatar" is 'avatar';
comment on column "public"."t_user"."description" is 'description';
alter table "public"."t_user" add constraint "t_user_pkey" primary key ("user_id");
create index "un_username" on "public"."t_user" using btree (
  "username" collate "pg_catalog"."default" "pg_catalog"."text_ops" asc nulls last
);


-- ----------------------------
-- table structure for t_member
-- ----------------------------
create sequence "public"."streampark_t_member_id_seq"
    increment 1 start 10000 cache 1 minvalue 10000 maxvalue 9223372036854775807;

create table "public"."t_member" (
  "id" int8 not null default nextval('streampark_t_member_id_seq'::regclass),
  "team_id" int8,
  "user_id" int8,
  "role_id" int8,
  "create_time" timestamp(6),
  "modify_time" timestamp(6)
)
;
comment on column "public"."t_member"."team_id" is 'team id';
comment on column "public"."t_member"."user_id" is 'user id';
comment on column "public"."t_member"."role_id" is 'role id';
alter table "public"."t_member" add constraint "t_member_pkey" primary key ("id");
create index "un_user_role_inx" on "public"."t_member" using btree (
  "team_id" "pg_catalog"."int8_ops" asc nulls last,
  "user_id" "pg_catalog"."int8_ops" asc nulls last,
  "role_id" "pg_catalog"."int8_ops" asc nulls last
);


-- ----------------------------
-- table structure for t_external_link
-- ----------------------------
create sequence "public"."streampark_t_external_link_id_seq"
    increment 1 start 10000 cache 1 minvalue 10000 maxvalue 9223372036854775807;

create table "public"."t_external_link" (
  "id" int8 not null default nextval('streampark_t_external_link_id_seq'::regclass),
  "badge_label" varchar(64) collate "pg_catalog"."default",
  "badge_name" varchar(64) collate "pg_catalog"."default",
  "badge_color" varchar(64) collate "pg_catalog"."default",
  "link_url" text collate "pg_catalog"."default",
  "create_time" timestamp(6),
  "modify_time" timestamp(6))
;
alter table "public"."t_external_link" add constraint "t_external_link_pkey" primary key ("id");


-- ----------------------------
-- table structure for t_yarn_queue
-- ----------------------------
create sequence "public"."streampark_t_yarn_queue_id_seq"
    increment 1 start 10000 cache 1 minvalue 10000 maxvalue 9223372036854775807;

create table "public"."t_yarn_queue" (
  "id" int8 not null default nextval('streampark_t_yarn_queue_id_seq'::regclass),
  "team_id" int8 not null,
  "queue_label" varchar(128) not null collate "pg_catalog"."default",
  "description" varchar(255) collate "pg_catalog"."default",
  "create_time" timestamp(6),
  "modify_time" timestamp(6)
)
;
comment on column "public"."t_yarn_queue"."id" is 'queue id';
comment on column "public"."t_yarn_queue"."team_id" is 'team id';
comment on column "public"."t_yarn_queue"."queue_label" is 'queue label expression';
comment on column "public"."t_yarn_queue"."description" is 'description of the queue';
comment on column "public"."t_yarn_queue"."create_time" is 'create time';
comment on column "public"."t_yarn_queue"."modify_time" is 'modify time';

alter table "public"."t_yarn_queue" add constraint "t_yarn_queue_pkey" primary key ("id");
alter table "public"."t_yarn_queue" add constraint "unique_team_id_queue_label" unique("team_id", "queue_label");


-- -----------------------------------------
-- trigger for table with modify_time field
-- -----------------------------------------
create or replace function "public"."update_modify_time"() returns trigger as
$$
begin
    new.modify_time= timezone('UTC-8'::text, (now())::timestamp(0) without time zone);
    return new;
end
$$
language plpgsql;

create trigger "streampark_t_alert_config_modify_time_tri" before update on "public"."t_alert_config" for each row execute procedure "public"."update_modify_time"();
create trigger "streampark_t_app_build_pipe_modify_time_tri" before update on "public"."t_app_build_pipe" for each row execute procedure "public"."update_modify_time"();
create trigger "streampark_t_access_token_modify_time_tri" before update on "public"."t_access_token" for each row execute procedure "public"."update_modify_time"();
create trigger "streampark_t_flink_app_modify_time_tri" before update on "public"."t_flink_app" for each row execute procedure "public"."update_modify_time"();
create trigger "streampark_t_flink_project_modify_time_tri" before update on "public"."t_flink_project" for each row execute procedure "public"."update_modify_time"();
create trigger "streampark_t_menu_modify_time_tri" before update on "public"."t_menu" for each row execute procedure "public"."update_modify_time"();
create trigger "streampark_t_role_modify_time_tri" before update on "public"."t_role" for each row execute procedure "public"."update_modify_time"();
create trigger "streampark_t_user_modify_time_tri" before update on "public"."t_user" for each row execute procedure "public"."update_modify_time"();
