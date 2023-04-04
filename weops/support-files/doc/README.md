## 嘉为蓝鲸mysql插件使用说明

## 使用说明

### 插件功能
采集器会定期执行SQL查询语句，例如 show global status 和 show slave status 等，获取相应的指标数据。

### 版本支持

操作系统支持: linux, windows

是否支持arm: 支持

**组件支持版本：**

MySQL >= 5.6

MariaDB >= 10.3

**是否支持远程采集:**

是

### 参数说明

| **参数名**              | **含义**                                                                                             | **是否必填** | **使用举例**       |
|----------------------|----------------------------------------------------------------------------------------------------|----------|----------------|
| --mysqld.host        | mysql服务地址                                                                                          | 否        | 127.0.0.1      |
| --mysqld.port        | mysql服务端口号                                                                                         | 否        | 3306           |
| --mysqld.username    | mysql登录账户名                                                                                         | 否        | monitor        |
| --mysqld.password    | mysql登录账户名的密码                                                                                      | 否        | Monitor123!    |
| --config.my-cnf      | 采集指标配置文件, 包含目标IP, 目标端口, 数据库用户名, 数据库密码l等内容。**注意！该参数在平台层面为文件参数，进程中该参数值为采集配置文件路径(上传文件即可，平台会补充文件路径)！** | 是        | 上传内容满足规范的文件    |
| --log.level          | 日志级别                                                                                               | 否        | info           |
| --web.listen-address | exporter监听id及端口地址                                                                                  | 否        | 127.0.0.1:9601 |


**采集配置文件(client.cnf)**

说明：[client]是MySQL客户端配置文件的一个段名，该段中的配置项用于连接MySQL服务端，"[client]"为固定内容，不可更改。下面是client段中常用的配置项及其含义：

* host：MySQL服务端的IP地址或域名。
* port：MySQL服务端监听的端口号，默认为3306。
* user：MySQL服务端的登录用户名。
* password：MySQL服务端的登录密码。

需要注意的是，在使用mysql exporter时，可以通过命令行参数（例如--config.my-cnf）指定一个自定义的MySQL客户端配置文件。
此外，如果在命令行参数中设置了--mysqld.xxx，那么该参数将覆盖掉客户端配置文件中对应的参数。如果命令行参数未设置，那么MySQL客户端将会从客户端配置文件中读取对应参数的值。
因此，在使用mysql exporter时，需要注意参数的优先级关系，以免产生意想不到的结果。

```config
[client]
host = 127.0.0.1
port = 3306
user = weops
password = 123456
```

### 使用指引

1. 连接MySQL
      ```shell
        mysql -u[username] -p[password] -h[host] -P[port]
      ```

2. 创建账户及授权
    ```sql
      CREATE USER '[username]'@'%' IDENTIFIED BY '[password]';
      GRANT PROCESS, SELECT, REPLICATION CLIENT ON *.* TO '[username]'@'%';
    ```

    在 MariaDB 10.5+ 版本中，为了支持增量备份，引入了一种新的权限 REPLICA MONITOR。该权限允许用户监视复制进程，并查询与备份有关的信息。
    当 mysql exporter 用于监控 MariaDB 10.5+ 版本的数据库时，它需要使用 REPLICA MONITOR 权限来获取与备份有关的信息。如果没有授予监控用户 REPLICA MONITOR 权限，则无法获取这些信息，导致监控数据不完整或无法正常工作。
    因此，在 MariaDB 10.5+ 版本中，需要使用 GRANT 命令为监控用户授予 REPLICA MONITOR 权限。
    ```sql
      GRANT REPLICA MONITOR ON *.* TO '[username]'@'%';
    ```

### 指标简介

| **指标ID**                                               | **指标中文名**                | **维度ID**                                                | **维度含义**                   | **单位** |
|--------------------------------------------------------|--------------------------|---------------------------------------------------------|----------------------------|--------|
| mysql_up                                               | MySQL监控插件运行状态            | -                                                       | -                          | -      |
| mysql_global_status_uptime                             | MySQL服务器运行时间             | -                                                       | -                          | s      |
| mysql_global_status_open_files                         | MySQL打开的文件数              | -                                                       | -                          | -      |
| mysql_global_variables_open_files_limit                | MySQL打开文件数限制             | -                                                       | -                          | -      |
| mysql_global_status_table_open_cache_hits              | MySQL表打开缓存命中数            | -                                                       | -                          | -      |
| mysql_global_status_table_open_cache_misses            | MySQL表打开缓存未命中数           | -                                                       | -                          | -      |
| mysql_global_status_table_open_cache_overflows         | MySQL表打开缓存溢出数            | -                                                       | -                          | -      |
| mysql_global_status_commands_total                     | MySQL执行的命令总数             | command                                                 | 命令类型                       | -      |
| mysql_global_status_handlers_total                     | MySQL处理程序总数              | handler                                                 | 处理程序类型                     | -      |
| mysql_global_status_bytes_received                     | MySQL接收的字节数              | -                                                       | -                          | bytes  |
| mysql_global_status_bytes_sent                         | MySQL发送的字节数              | -                                                       | -                          | bytes  |
| mysql_global_status_open_tables                        | MySQL打开的表总数              | -                                                       | -                          | -      |
| mysql_global_status_opened_tables                      | MySQL当前打开的表数             | -                                                       | -                          | -      |
| mysql_global_variables_table_open_cache                | MySQL表打开缓存数量             | -                                                       | -                          | -      |
| mysql_global_status_open_table_definitions             | MySQL打开的表定义数             | -                                                       | -                          | -      |
| mysql_global_variables_table_definition_cache          | MySQL表定义缓存数量             | -                                                       | -                          | -      |
| mysql_global_status_opened_table_definitions           | MySQL打开的表定义数量            | -                                                       | -                          | -      |
| mysql_global_status_table_locks_immediate              | MySQL立即获得的表锁数            | -                                                       | -                          | -      |
| mysql_global_status_table_locks_waited                 | MySQL等待的表锁数              | -                                                       | -                          | -      |
| mysql_global_status_created_tmp_tables                 | MySQL创建的临时表数             | -                                                       | -                          | -      |
| mysql_global_status_created_tmp_disk_tables            | MySQL创建的磁盘临时表数           | -                                                       | -                          | -      |
| mysql_global_status_created_tmp_files                  | MySQL创建的临时文件数            | -                                                       | -                          | -      |
| mysql_global_status_opened_files                       | MySQL打开的文件数              | -                                                       | -                          | -      |
| mysql_global_status_innodb_num_open_files              | MySQL InnoDB打开的文件数       | -                                                       | -                          | -      |
| mysql_global_variables_innodb_log_file_size            | MySQL InnoDB 日志文件大小      | -                                                       | -                          | bytes  |
| mysql_global_variables_max_connections                 | MySQL最大连接数               | -                                                       | -                          | -      |
| mysql_global_status_aborted_connects                   | MySQL中止的连接数              | -                                                       | -                          | -      |
| mysql_global_status_aborted_clients                    | MySQL中止的客户端连接数           | -                                                       | -                          | -      |
| mysql_global_status_threads_created                    | MySQL创建的线程数              | -                                                       | -                          | -      |
| mysql_global_status_threads_cached                     | MySQL缓存的线程数              | -                                                       | -                          | -      |
| mysql_global_status_threads_connected                  | MySQL当前连接线程数             | -                                                       | -                          | -      |
| mysql_global_status_max_used_connections               | MySQL最大连接线程数             | -                                                       | -                          | -      |
| mysql_global_status_threads_running                    | MySQL正在运行的线程数            | -                                                       | -                          | -      |
| mysql_global_status_queries                            | MySQL总查询数量               | -                                                       | -                          | -      |
| mysql_global_status_slow_queries                       | MySQL慢查询数量               | -                                                       | -                          | -      |
| mysql_global_status_select_full_join                   | MySQL全连接选择数              | -                                                       | -                          | -      |
| mysql_global_status_select_full_range_join             | MySQL全范围连接选择数            | -                                                       | -                          | -      |
| mysql_global_status_select_range                       | MySQL范围选择数               | -                                                       | -                          | -      |
| mysql_global_status_select_range_check                 | MySQL范围检查选择数             | -                                                       | -                          | -      |
| mysql_global_status_select_scan                        | MySQL扫描选择数               | -                                                       | -                          | -      |
| mysql_global_status_questions                          | MySQL问题数量                | -                                                       | -                          | -      |
| mysql_global_status_sort_rows                          | MySQL排序的行数               | -                                                       | -                          | -      |
| mysql_global_status_sort_range                         | MySQL范围排序数               | -                                                       | -                          | -      |
| mysql_global_status_sort_merge_passes                  | MySQL合并排序次数              | -                                                       | -                          | -      |
| mysql_global_status_sort_scan                          | MySQL排序扫描数               | -                                                       | -                          | -      |
| mysql_global_variables_innodb_buffer_pool_size         | MySQL InnoDB缓冲池大小        | -                                                       | -                          | bytes  |
| mysql_global_variables_thread_cache_size               | MySQL线程缓存大小              | -                                                       | -                          | -      |
| mysql_global_variables_key_buffer_size                 | MySQL键缓冲区大小              | -                                                       | -                          | bytes  |
| mysql_global_variables_query_cache_size                | MySQL查询缓存大小              | -                                                       | -                          | bytes  |
| mysql_global_status_qcache_free_memory                 | MySQL查询缓存可用内存            | -                                                       | -                          | bytes  |
| mysql_global_status_innodb_page_size                   | MySQL InnoDB页面大小         | -                                                       | -                          | bytes  |
| mysql_global_status_buffer_pool_pages                  | MySQL缓冲池页面数              | state                                                   | 页面状态                       | -      |
| mysql_global_status_innodb_mem_dictionary              | MySQL InnoDB 存储引擎内存字典使用量 | -                                                       | -                          | bytes  |
| mysql_global_variables_innodb_log_buffer_size          | MySQL InnoDB日志缓冲区大小      | -                                                       | -                          | bytes  |
| mysql_global_status_innodb_log_waits                   | MySQL InnoDB日志等待         | -                                                       | -                          | `      |
| mysql_global_variables_innodb_additional_mem_pool_size | MySQL InnoDB附加内存池大小      | -                                                       | -                          | bytes  |
| mysql_global_variables_innodb_buffer_pool_chunk_size   | MySQL InnoDB缓冲池块大小       | -                                                       | -                          | bytes  |
| mysql_global_variables_innodb_buffer_pool_instances    | MySQL InnoDB缓冲池实例数       | -                                                       | -                          | -      |
| mysql_global_status_qcache_hits                        | MySQL查询缓存命中数             | -                                                       | -                          | -      |
| mysql_global_status_qcache_inserts                     | MySQL查询缓存插入数             | -                                                       | -                          | -      |
| mysql_global_status_qcache_not_cached                  | MySQL未缓存查询数              | -                                                       | -                          | -      |
| mysql_global_status_qcache_lowmem_prunes               | MySQL查询缓存低内存修剪数          | -                                                       | -                          | -      |
| mysql_global_status_qcache_queries_in_cache            | MySQL查询缓存中的查询数           | -                                                       | -                          | -      |
| mysql_slave_status_seconds_behind_master               | MySQL主从延迟时间              | channel_name, connection_name, master_host, master_uuid | 通道名称, 连接名称, 主库主机名, 主库UUID  | s      |
| mysql_slave_status_sql_delay                           | MySQL从服务器SQL延迟           | channel_name, connection_name, master_host, master_uuid | 通道名称, 连接名称, 主库主机名, 主库UUID  | s      |
| mysql_slave_status_slave_io_running                    | MySQL从库IO线程是否运行          | channel_name, connection_name, master_host, master_uuid | 通道名称, 连接名称, 主库主机名, 主库UUID  | -      |
| mysql_slave_status_slave_sql_running                   | MySQL从库SQL线程是否运行         | channel_name, connection_name, master_host, master_uuid | 通道名称, 连接名称, 主库主机名, 主库UUID  | -      |
| mysql_slave_status_read_master_log_pos                 | MySQL从库正在读取的主库日志文件位置     | channel_name, connection_name, master_host, master_uuid | 通道名称, 连接名称, 主库主机名, 主库UUID  | -      |
| mysql_slave_status_relay_log_pos                       | MySQL从库正在执行的中继日志文件位置     | channel_name, connection_name, master_host, master_uuid | 通道名称, 连接名称, 主库主机名, 主库UUID  | -      |
| mysql_slave_status_exec_master_log_pos                 | MySQL从库正在执行的主库日志文件位置     | channel_name, connection_name, master_host, master_uuid | 通道名称, 连接名称, 主库主机名, 主库UUID  | -      |


### 版本日志

#### weops_mysql_exporter 4.2.1

- weops调整

添加“小嘉”微信即可获取mysql监控指标最佳实践礼包，其他更多问题欢迎咨询

<img src="https://wedoc.canway.net/imgs/img/小嘉.jpg" width="50%" height="50%">
