create database if not exists `streampark` character set utf8mb4 collate utf8mb4_general_ci;
use streampark;

set names utf8mb4;
set foreign_key_checks = 0;

-- ----------------------------
-- table structure for t_app_backup
-- ----------------------------
drop table if exists `t_app_backup`;
create table `t_app_backup` (
  `id` bigint not null auto_increment,
  `app_id` bigint default null,
  `sql_id` bigint default null,
  `config_id` bigint default null,
  `version` int default null,
  `path` varchar(128) collate utf8mb4_general_ci default null,
  `description` varchar(255) collate utf8mb4_general_ci default null,
  `create_time` datetime default null comment 'create time',
  primary key (`id`) using btree
) engine=innodb auto_increment=100000 default charset=utf8mb4 collate=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for t_flink_app
-- ----------------------------
drop table if exists `t_flink_app`;
create table `t_flink_app` (
  `id` bigint not null auto_increment,
  `team_id` bigint not null,
  `job_type` tinyint default null,
  `execution_mode` tinyint default null,
  `resource_from` tinyint default null,
  `project_id` bigint default null,
  `job_name` varchar(255) collate utf8mb4_general_ci default null,
  `module` varchar(255) collate utf8mb4_general_ci default null,
  `jar` varchar(255) collate utf8mb4_general_ci default null,
  `jar_check_sum` bigint default null,
  `main_class` varchar(255) collate utf8mb4_general_ci default null,
  `dependency` text collate utf8mb4_general_ci default null,
  `args` longtext collate utf8mb4_general_ci,
  `options` longtext collate utf8mb4_general_ci,
  `hot_params` text collate utf8mb4_general_ci,
  `user_id` bigint default null,
  `app_type` tinyint default null,
  `duration` bigint default null,
  `job_id` varchar(64) collate utf8mb4_general_ci default null,
  `job_manager_url` varchar(255) collate utf8mb4_general_ci default null,
  `version_id` bigint default null,
  `cluster_id` varchar(45) collate utf8mb4_general_ci default null,
  `k8s_namespace` varchar(63) collate utf8mb4_general_ci default null,
  `flink_image` varchar(128) collate utf8mb4_general_ci default null,
  `state` int default null,
  `restart_size` int default null,
  `restart_count` int default null,
  `cp_threshold` int default null,
  `cp_max_failure_interval` int default null,
  `cp_failure_rate_interval` int default null,
  `cp_failure_action` tinyint default null,
  `dynamic_properties` longtext collate utf8mb4_general_ci,
  `description` varchar(255) collate utf8mb4_general_ci default null,
  `resolve_order` tinyint default null,
  `k8s_rest_exposed_type` tinyint default null,
  `jm_memory` int default null,
  `tm_memory` int default null,
  `total_task` int default null,
  `total_tm` int default null,
  `total_slot` int default null,
  `available_slot` int default null,
  `option_state` tinyint default null,
  `tracking` tinyint default null,
  `create_time` datetime default null comment 'create time',
  `modify_time` datetime default null comment 'modify time',
  `option_time` datetime default null,
  `release` tinyint default 1,
  `build` tinyint default 1,
  `start_time` datetime default null,
  `end_time` datetime default null,
  `alert_id` bigint default null,
  `k8s_pod_template` longtext collate utf8mb4_general_ci,
  `k8s_jm_pod_template` longtext collate utf8mb4_general_ci,
  `k8s_tm_pod_template` longtext collate utf8mb4_general_ci,
  `k8s_hadoop_integration` tinyint default 0,
  `flink_cluster_id` bigint default null,
  `ingress_template` text collate utf8mb4_general_ci,
  `default_mode_ingress` text collate utf8mb4_general_ci,
  `tags` varchar(500) default null,
  primary key (`id`) using btree,
  key `inx_job_type` (`job_type`) using btree,
  key `inx_track` (`tracking`) using btree,
  index `inx_team` (`team_id`) using btree
) engine=innodb auto_increment=100000 default charset=utf8mb4 collate=utf8mb4_general_ci;


-- ----------------------------
-- table structure for t_flink_config
-- ----------------------------
drop table if exists `t_flink_config`;
create table `t_flink_config` (
  `id` bigint not null auto_increment,
  `app_id` bigint not null,
  `format` tinyint not null default 0,
  `version` int not null,
  `latest` tinyint not null default 0,
  `content` text collate utf8mb4_general_ci not null,
  `create_time` datetime default null comment 'create time',
  primary key (`id`) using btree
) engine=innodb auto_increment=100000 default charset=utf8mb4 collate=utf8mb4_general_ci;


-- ----------------------------
-- table structure for t_flink_effective
-- ----------------------------
drop table if exists `t_flink_effective`;
create table `t_flink_effective` (
  `id` bigint not null auto_increment,
  `app_id` bigint not null,
  `target_type` tinyint not null comment '1) config 2) flink sql',
  `target_id` bigint not null comment 'configid or sqlid',
  `create_time` datetime default null comment 'create time',
  primary key (`id`) using btree,
  unique key `un_effective_inx` (`app_id`,`target_type`) using btree
) engine=innodb auto_increment=100000 default charset=utf8mb4 collate=utf8mb4_general_ci;


-- ----------------------------
-- table structure for t_flink_env
-- ----------------------------
drop table if exists `t_flink_env`;
create table `t_flink_env` (
  `id` bigint not null auto_increment comment 'id',
  `flink_name` varchar(128) collate utf8mb4_general_ci not null comment 'flink instance name',
  `flink_home` varchar(255) collate utf8mb4_general_ci not null comment 'flink home path',
  `version` varchar(64) collate utf8mb4_general_ci not null comment 'flink version',
  `scala_version` varchar(64) collate utf8mb4_general_ci not null comment 'scala version of flink',
  `flink_conf` text collate utf8mb4_general_ci not null comment 'flink-conf',
  `is_default` tinyint not null default 0 comment 'whether default version or not',
  `description` varchar(255) collate utf8mb4_general_ci default null comment 'description',
  `create_time` datetime default null comment 'create time',
  primary key (`id`) using btree,
  unique key `un_env_name` (`flink_name`) using btree
) engine=innodb auto_increment=100000 default charset=utf8mb4 collate=utf8mb4_general_ci;


-- ----------------------------
-- table structure for t_flink_log
-- ----------------------------
drop table if exists `t_flink_log`;
create table `t_flink_log` (
  `id` bigint not null auto_increment,
  `app_id` bigint default null,
  `yarn_app_id` varchar(64) collate utf8mb4_general_ci default null,
  `job_manager_url` varchar(255) collate utf8mb4_general_ci default null,
  `success` tinyint default null,
  `exception` text collate utf8mb4_general_ci,
  `option_time` datetime default null,
  `option_name` tinyint default null,
  primary key (`id`) using btree
) engine=innodb auto_increment=100000 default charset=utf8mb4 collate=utf8mb4_general_ci;


-- ----------------------------
-- table structure for t_flink_project
-- ----------------------------
drop table if exists `t_flink_project`;
create table `t_flink_project` (
  `id` bigint not null auto_increment,
  `team_id` bigint not null,
  `name` varchar(255) collate utf8mb4_general_ci default null,
  `url` varchar(255) collate utf8mb4_general_ci default null,
  `refs` varchar(255) collate utf8mb4_general_ci default null,
  `user_name` varchar(64) collate utf8mb4_general_ci default null,
  `password` varchar(64) collate utf8mb4_general_ci default null,
  `prvkey_path` varchar(128) collate utf8mb4_general_ci default null,
  `pom` varchar(255) collate utf8mb4_general_ci default null,
  `build_args` varchar(255) default null,
  `type` tinyint default null,
  `repository` tinyint default null,
  `last_build` datetime default null,
  `description` varchar(255) collate utf8mb4_general_ci default null,
  `build_state` tinyint default -1,
  `create_time` datetime default null comment 'create time',
  `modify_time` datetime default null comment 'modify time',
  primary key (`id`) using btree,
  index `inx_team` (`team_id`) using btree
) engine=innodb auto_increment=100000 default charset=utf8mb4 collate=utf8mb4_general_ci;


-- ----------------------------
-- Table structure for t_flink_savepoint
-- ----------------------------
drop table if exists `t_flink_savepoint`;
create table `t_flink_savepoint` (
  `id` bigint not null auto_increment,
  `app_id` bigint not null,
  `chk_id` bigint default null,
  `type` tinyint default null,
  `path` varchar(255) collate utf8mb4_general_ci default null,
  `latest` tinyint not null default 1,
  `trigger_time` datetime default null,
  `create_time` datetime default null comment 'create time',
  primary key (`id`) using btree
) engine=innodb auto_increment=100000 default charset=utf8mb4 collate=utf8mb4_general_ci;


-- ----------------------------
-- Table structure for t_flink_sql
-- ----------------------------
drop table if exists `t_flink_sql`;
create table `t_flink_sql` (
  `id` bigint not null auto_increment,
  `app_id` bigint default null,
  `sql` text collate utf8mb4_general_ci,
  `dependency` text collate utf8mb4_general_ci,
  `version` int default null,
  `candidate` tinyint not null default 1,
  `create_time` datetime default null comment 'create time',
  primary key (`id`) using btree
) engine=innodb auto_increment=100000 default charset=utf8mb4 collate=utf8mb4_general_ci;


-- ----------------------------
-- Table structure for t_menu
-- ----------------------------
drop table if exists `t_menu`;
create table `t_menu` (
  `menu_id` bigint not null auto_increment comment 'menu/button id',
  `parent_id` bigint not null comment 'parent menu id',
  `menu_name` varchar(64) collate utf8mb4_general_ci not null comment 'menu button name',
  `path` varchar(64) collate utf8mb4_general_ci default null comment 'routing path',
  `component` varchar(64) collate utf8mb4_general_ci default null comment 'routing component component',
  `perms` varchar(64) collate utf8mb4_general_ci default null comment 'authority id',
  `icon` varchar(64) collate utf8mb4_general_ci default null comment 'icon',
  `type` char(2) collate utf8mb4_general_ci default null comment 'type 0:menu 1:button',
  `display` tinyint collate utf8mb4_general_ci not null default 1 comment 'whether the menu is displayed',
  `order_num` int default null comment 'sort',
  `create_time` datetime default null comment 'create time',
  `modify_time` datetime default null comment 'modify time',
  primary key (`menu_id`) using btree
) engine=innodb auto_increment=100000 default charset=utf8mb4 collate=utf8mb4_general_ci;


-- ----------------------------
-- Table structure for t_message
-- ----------------------------
drop table if exists `t_message`;
create table `t_message` (
  `id` bigint not null auto_increment,
  `app_id` bigint default null,
  `user_id` bigint default null,
  `type` tinyint default null,
  `title` varchar(255) collate utf8mb4_general_ci default null,
  `context` text collate utf8mb4_general_ci,
  `is_read` tinyint default 0,
  `create_time` datetime default null comment 'create time',
  primary key (`id`) using btree,
  key `inx_mes_user` (`user_id`) using btree
) engine=innodb auto_increment=100000 default charset=utf8mb4 collate=utf8mb4_general_ci;


-- ----------------------------
-- Table of t_team
-- ----------------------------
drop table if exists `t_team`;
create table `t_team` (
  `id` bigint not null auto_increment comment 'team id',
  `team_name` varchar(64) collate utf8mb4_general_ci not null comment 'team name',
  `description` varchar(255) collate utf8mb4_general_ci default null,
  `create_time` datetime default null comment 'create time',
  `modify_time` datetime default null comment 'modify time',
  primary key (`id`) using btree,
  unique key `team_name_idx` (`team_name`) using btree
) engine = innodb default charset = utf8mb4 collate = utf8mb4_general_ci;

-- ----------------------------
-- Table of t_variable
-- ----------------------------
drop table if exists `t_variable`;
create table `t_variable` (
  `id` bigint not null auto_increment,
  `variable_code` varchar(128) collate utf8mb4_general_ci not null comment 'Variable code is used for parameter names passed to the program or as placeholders',
  `variable_value` text collate utf8mb4_general_ci not null comment 'The specific value corresponding to the variable',
  `description` text collate utf8mb4_general_ci default null comment 'More detailed description of variables',
  `creator_id` bigint collate utf8mb4_general_ci not null comment 'user id of creator',
  `team_id` bigint collate utf8mb4_general_ci not null comment 'team id',
  `desensitization` tinyint not null default 0 comment '0 is no desensitization, 1 is desensitization, if set to desensitization, it will be replaced by * when displayed',
  `create_time` datetime default null comment 'create time',
  `modify_time` datetime default null comment 'modify time',
  primary key (`id`) using btree,
  unique key `un_team_vcode_inx` (`team_id`,`variable_code`) using btree
) engine=innodb auto_increment=100000 default charset=utf8mb4 collate=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for t_role
-- ----------------------------
drop table if exists `t_role`;
create table `t_role` (
  `role_id` bigint not null auto_increment comment 'user id',
  `role_name` varchar(64) collate utf8mb4_general_ci not null comment 'role name',
  `create_time` datetime default null comment 'create time',
  `modify_time` datetime default null comment 'modify time',
  `description` varchar(255) collate utf8mb4_general_ci default null comment 'description',
  primary key (`role_id`) using btree
) engine=innodb auto_increment=100000 default charset=utf8mb4 collate=utf8mb4_general_ci;


-- ----------------------------
-- Table structure for t_role_menu
-- ----------------------------
drop table if exists `t_role_menu`;
create table `t_role_menu` (
  `id` bigint not null auto_increment,
  `role_id` bigint not null,
  `menu_id` bigint not null,
  primary key (`id`) using btree,
  unique key `un_role_menu_inx` (`role_id`,`menu_id`) using btree
) engine=innodb auto_increment=100000 default charset=utf8mb4 collate=utf8mb4_general_ci;


-- ----------------------------
-- Table structure for t_setting
-- ----------------------------
drop table if exists `t_setting`;
create table `t_setting` (
  `order_num` int default null,
  `setting_key` varchar(64) collate utf8mb4_general_ci not null,
  `setting_value` text collate utf8mb4_general_ci default null,
  `setting_name` varchar(255) collate utf8mb4_general_ci default null,
  `description` varchar(255) collate utf8mb4_general_ci default null,
  `type` tinyint not null comment '1: input 2: boolean 3: number',
  primary key (`setting_key`) using btree
) engine=innodb default charset=utf8mb4 collate=utf8mb4_general_ci;


-- ----------------------------
-- Table structure for t_user
-- ----------------------------
drop table if exists `t_user`;
create table `t_user` (
  `user_id` bigint not null auto_increment comment 'user id',
  `username` varchar(64) collate utf8mb4_general_ci not null comment 'user name',
  `nick_name` varchar(64) collate utf8mb4_general_ci not null comment 'nick name',
  `salt` varchar(26) collate utf8mb4_general_ci default null comment 'salt',
  `password` varchar(64) collate utf8mb4_general_ci not null comment 'password',
  `email` varchar(64) collate utf8mb4_general_ci default null comment 'email',
  `user_type` int  not null comment 'user type 1:admin 2:user',
  `login_type` tinyint default 0 comment 'login type 0:password 1:ldap',
  `last_team_id` bigint default null comment 'last team id',
  `status` char(1) collate utf8mb4_general_ci not null comment 'status 0:locked 1:active',
  `create_time` datetime default null comment 'create time',
  `modify_time` datetime default null comment 'modify time',
  `last_login_time` datetime default null comment 'last login time',
  `sex` char(1) collate utf8mb4_general_ci default null comment 'gender 0:male 1:female 2:confidential',
  `avatar` varchar(128) collate utf8mb4_general_ci default null comment 'avatar',
  `description` varchar(255) collate utf8mb4_general_ci default null comment 'description',
  primary key (`user_id`) using btree,
  unique key `un_username` (`username`) using btree
) engine=innodb auto_increment=100000 default charset=utf8mb4 collate=utf8mb4_general_ci;


-- ----------------------------
-- Table structure for t_member
-- ----------------------------
drop table if exists `t_member`;
create table `t_member` (
  `id` bigint not null auto_increment,
  `team_id` bigint not null comment 'team id',
  `user_id` bigint not null comment 'user id',
  `role_id` bigint not null comment 'role id',
  `create_time` datetime default null comment 'create time',
  `modify_time` datetime default null comment 'modify time',
  primary key (`id`) using btree,
  unique key `un_user_team_role_inx` (`user_id`,`team_id`,`role_id`) using btree
) engine=innodb auto_increment=100000 default charset=utf8mb4 collate=utf8mb4_general_ci;


-- ----------------------------
-- Table of t_app_build_pipe
-- ----------------------------
drop table if exists `t_app_build_pipe`;
create table `t_app_build_pipe`(
  `app_id` bigint,
  `pipe_type` tinyint,
  `pipe_status` tinyint,
  `cur_step` smallint,
  `total_step` smallint,
  `steps_status` text,
  `steps_status_ts` text,
  `error` text,
  `build_result` text,
  `modify_time` datetime default null comment 'modify time',
  primary key (`app_id`) using btree
) engine = innodb auto_increment=100000 default charset = utf8mb4 collate = utf8mb4_general_ci;


-- ----------------------------
-- Table of t_flink_cluster
-- ----------------------------
drop table if exists `t_flink_cluster`;
create table `t_flink_cluster` (
  `id` bigint not null auto_increment,
  `address` varchar(150) default null comment 'url address of jobmanager',
  `cluster_id` varchar(45) default null comment 'clusterid of session mode(yarn-session:application-id,k8s-session:cluster-id)',
  `cluster_name` varchar(128) not null comment 'cluster name',
  `options` longtext comment 'json form of parameter collection ',
  `yarn_queue` varchar(128) default null comment 'the yarn queue where the task is located',
  `execution_mode` tinyint not null default 1 comment 'k8s execution session mode(1:remote,3:yarn-session,5:kubernetes-session)',
  `version_id` bigint not null comment 'flink version id',
  `k8s_namespace` varchar(63) default 'default' comment 'k8s namespace',
  `service_account` varchar(64) default null comment 'k8s service account',
  `description` varchar(255) default null,
  `user_id` bigint default null,
  `flink_image` varchar(128) default null comment 'flink image',
  `dynamic_properties` longtext comment 'allows specifying multiple generic configuration options',
  `k8s_rest_exposed_type` tinyint default 2 comment 'k8s export(0:loadbalancer,1:clusterip,2:nodeport)',
  `k8s_hadoop_integration` tinyint default 0,
  `k8s_conf` varchar(255) default null comment 'the path where the k8s configuration file is located',
  `resolve_order` int default null,
  `exception` longtext comment 'exception information',
  `cluster_state` tinyint default 0 comment 'cluster status (0: created but not started, 1: started, 2: stopped)',
  `create_time` datetime default null comment 'create time',
  primary key (`id`,`cluster_name`),
  unique key `id` (`cluster_id`,`address`,`execution_mode`)
) engine=innodb auto_increment=100000 default charset=utf8mb4 collate=utf8mb4_general_ci;


-- ----------------------------
-- Table of t_access_token definition
-- ----------------------------
drop table if exists `t_access_token`;
create table `t_access_token` (
  `id` int not null auto_increment comment 'key',
  `user_id` bigint,
  `token` varchar(1024) character set utf8mb4 collate utf8mb4_general_ci default null comment 'token',
  `expire_time` datetime default null comment 'expiration',
  `description` varchar(255) character set utf8mb4 collate utf8mb4_general_ci default null comment 'description',
  `status` tinyint default null comment '1:enable,0:disable',
  `create_time` datetime default null comment 'create time',
  `modify_time` datetime default null comment 'modify time',
  primary key (`id`) using btree
) engine=innodb auto_increment=100000 default charset=utf8mb4 collate=utf8mb4_general_ci;


-- ----------------------------
-- Table of t_alert_config
-- ----------------------------
drop table if exists `t_alert_config`;
create table `t_alert_config` (
  `id` bigint not null auto_increment primary key,
  `user_id` bigint default null,
  `alert_name` varchar(128) collate utf8mb4_general_ci default null comment 'alert group name',
  `alert_type` int default 0 comment 'alert type',
  `email_params` varchar(255) collate utf8mb4_general_ci comment 'email params',
  `sms_params` text collate utf8mb4_general_ci comment 'sms params',
  `ding_talk_params` text collate utf8mb4_general_ci comment 'ding talk params',
  `we_com_params` varchar(255) collate utf8mb4_general_ci comment 'wechat params',
  `http_callback_params` text collate utf8mb4_general_ci comment 'http callback params',
  `lark_params` text collate utf8mb4_general_ci comment 'lark params',
  `create_time` datetime default null comment 'create time',
  `modify_time` datetime default null comment 'modify time',
  index `inx_alert_user` (`user_id`) using btree
) engine = innodb default charset = utf8mb4 collate = utf8mb4_general_ci;

-- ----------------------------
-- Table of t_external_link
-- ----------------------------
drop table if exists `t_external_link`;
CREATE TABLE `t_external_link` (
  `id` bigint not null auto_increment primary key,
  `badge_label` varchar(64) collate utf8mb4_general_ci default null,
  `badge_name` varchar(64) collate utf8mb4_general_ci default null,
  `badge_color` varchar(64) collate utf8mb4_general_ci default null,
  `link_url` text collate utf8mb4_general_ci default null,
  `create_time` datetime default null COMMENT 'create time',
  `modify_time` datetime default null COMMENT 'modify time'
) engine = innodb default charset=utf8mb4 collate=utf8mb4_general_ci;

-- ----------------------------
-- table structure for t_yarn_queue
-- ----------------------------
drop table if exists `t_yarn_queue`;
create table `t_yarn_queue` (
  `id` bigint not null primary key auto_increment comment 'queue id',
  `team_id` bigint not null comment 'team id',
  `queue_label` varchar(128) collate utf8mb4_general_ci not null comment 'queue label expression',
  `description` varchar(255) collate utf8mb4_general_ci default null comment 'description of the queue label',
  `create_time` datetime default null comment 'create time',
  `modify_time` datetime default null comment 'modify time',
   unique key `unq_team_id_queue_label` (`team_id`, `queue_label`) using btree
) engine = innodb default charset = utf8mb4 collate = utf8mb4_general_ci;

set foreign_key_checks = 1;
