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

| **参数名**              | **含义**                        | **是否必填** | **使用举例**       |
|----------------------|-------------------------------|----------|----------------|
| MYSQL_USER           | mysql登录账户名(环境变量)              | 是        | monitor        |
| MYSQL_PASSWORD       | mysql登录账户名的密码(环境变量),特殊字符不需要转义 | 是        | Monitor123!    |
| --mysqld.host        | mysql服务地址                     | 是        | 127.0.0.1      |
| --mysqld.port        | mysql服务端口号                    | 是        | 3306           |
| --log.level          | 日志级别                          | 否        | info           |
| --web.listen-address | exporter监听id及端口地址             | 否        | 127.0.0.1:9601 |


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
| mysql_table_cache_hit_percent                          | MySQL表缓存命中率              | -                                                       | -                          | -      |
| mysql_global_status_table_open_cache_overflows         | MySQL表打开缓存溢出数            | -                                                       | -                          | -      |
| mysql_global_status_commands_total                     | MySQL执行的命令总数             | command                                                 | 命令类型                       | -      |
| mysql_command_rate                                     | MySQL执行命令速率              | command                                                 | 命令类型                       | cps    |
| mysql_global_status_handlers_total                     | MySQL处理程序总数              | handler                                                 | 处理程序类型                     | -      |
| mysql_handler_total_rate                               | MySQL处理程序操作速率            | handler                                                 | 处理程序类型                     | cps    |
| mysql_global_status_bytes_received                     | MySQL接收的字节数              | -                                                       | -                          | bytes  |
| mysql_received_bytes_rate                              | MySQL接收字节速率              | -                                                       | -                          | Bps    |
| mysql_global_status_bytes_sent                         | MySQL发送的字节数              | -                                                       | -                          | bytes  |
| mysql_sent_bytes_rate                                  | MySQL发送字节速率              | -                                                       | -                          | Bps    |
| mysql_global_status_open_tables                        | MySQL当前打开的表数             | -                                                       | -                          | -      |
| mysql_global_status_opened_tables                      | MySQL打开的表总数              | -                                                       | -                          | -      |
| mysql_table_opens_rate                                 | MySQL打开表数速率              | -                                                       | -                          | -      |
| mysql_global_variables_table_open_cache                | MySQL表打开缓存数量             | -                                                       | -                          | -      |
| mysql_global_status_open_table_definitions             | MySQL打开的表定义数             | -                                                       | -                          | -      |
| mysql_global_variables_table_definition_cache          | MySQL表定义缓存数量             | -                                                       | -                          | -      |
| mysql_global_status_opened_table_definitions           | MySQL打开的表定义数量            | -                                                       | -                          | -      |
| mysql_global_status_table_locks_immediate              | MySQL立即获得的表锁数            | -                                                       | -                          | -      |
| mysql_global_status_table_locks_waited                 | MySQL等待的表锁数              | -                                                       | -                          | -      |
| mysql_global_status_created_tmp_tables                 | MySQL创建的临时表数             | -                                                       | -                          | -      |
| mysql_tmp_tables_rate                                  | MySQL临时表创建速率             | -                                                       | -                          | cps    |
| mysql_global_status_created_tmp_disk_tables            | MySQL创建的磁盘临时表数           | -                                                       | -                          | -      |
| mysql_tmp_disk_tables_rate                             | MySQL磁盘临时表创建速率           | -                                                       | -                          | -      |
| mysql_global_status_created_tmp_files                  | MySQL创建的临时文件数            | -                                                       | -                          | -      |
| mysql_tmp_files_rate                                   | MySQL临时文件创建速率            | -                                                       | -                          | cps    |
| mysql_global_status_opened_files                       | MySQL打开的文件数              | -                                                       | -                          | -      |
| mysql_global_status_innodb_num_open_files              | MySQL InnoDB打开的文件数       | -                                                       | -                          | -      |
| mysql_global_variables_innodb_log_file_size            | MySQL InnoDB 日志文件大小      | -                                                       | -                          | bytes  |
| mysql_global_variables_max_connections                 | MySQL最大连接数               | -                                                       | -                          | -      |
| mysql_global_status_aborted_connects                   | MySQL中止的连接数              | -                                                       | -                          | -      |
| mysql_aborted_connects_increase                        | MySQL中止的连接数增量            | -                                                       | -                          | -      |
| mysql_global_status_aborted_clients                    | MySQL中止的客户端连接数           | -                                                       | -                          | -      |
| mysql_aborted_clients_increase                         | MySQL中止的客户端连接数增量         | -                                                       | -                          | -      |
| mysql_global_status_threads_created                    | MySQL创建的线程数              | -                                                       | -                          | -      |
| mysql_threads_created_rate                             | MySQL新建线程数速率             | -                                                       | -                          | cps    |
| mysql_global_status_threads_cached                     | MySQL缓存的线程数              | -                                                       | -                          | -      |
| mysql_global_status_threads_connected                  | MySQL当前连接线程数             | -                                                       | -                          | -      |
| mysql_global_status_max_used_connections               | MySQL最大连接线程数             | -                                                       | -                          | -      |
| mysql_global_status_threads_running                    | MySQL正在运行的线程数            | -                                                       | -                          | -      |
| mysql_global_status_queries                            | MySQL总查询数量               | -                                                       | -                          | -      |
| mysql_queries_rate                                     | MySQL查询速率                | -                                                       | -                          | cps    |
| mysql_global_status_slow_queries                       | MySQL慢查询数量               | -                                                       | -                          | -      |
| mysql_slow_queries_increase                            | MySQL慢查询增量               | -                                                       | -                          | -      |
| mysql_global_status_select_full_join                   | MySQL全连接选择数              | -                                                       | -                          | -      |
| mysql_select_full_join_increase                        | MySQL全连接查询增量             | -                                                       | -                          | -      |
| mysql_global_status_select_full_range_join             | MySQL全范围连接选择数            | -                                                       | -                          | -      |
| mysql_select_full_range_join_rate                      | MySQL范围联表查询速率            | -                                                       | -                          | -      |
| mysql_global_status_select_range                       | MySQL范围选择数               | -                                                       | -                          | -      |
| mysql_select_range_rate                                | MySQL范围扫描查询速率            | -                                                       | -                          | cps    |
| mysql_global_status_select_range_check                 | MySQL范围检查选择数             | -                                                       | -                          | -      |
| mysql_select_range_check_rate                          | MySQL范围检查查询速率            | -                                                       | -                          | cps    |
| mysql_global_status_select_scan                        | MySQL扫描选择数               | -                                                       | -                          | -      |
| mysql_select_scan_rate                                 | MySQL扫描选择速率              | -                                                       | -                          | -      |
| mysql_global_status_questions                          | MySQL问题数量                | -                                                       | -                          | -      |
| mysql_questions_rate                                   | MySQL问题数速率               | -                                                       | -                          | -      |
| mysql_global_status_sort_rows                          | MySQL排序的行数               | -                                                       | -                          | -      |
| mysql_sort_rows_rate                                   | MySQL排序行数速率              | -                                                       | -                          | -      |
| mysql_global_status_sort_range                         | MySQL范围排序数               | -                                                       | -                          | -      |
| mysql_sort_range_rate                                  | MySQL范围排序速率              | -                                                       | -                          | -      |
| mysql_global_status_sort_merge_passes                  | MySQL合并排序次数              | -                                                       | -                          | -      |
| mysql_sort_merge_passes_rate                           | MySQL合并排序速率              | -                                                       | -                          | -      |
| mysql_global_status_sort_scan                          | MySQL排序扫描数               | -                                                       | -                          | -      |
| mysql_sort_scan_rate                                   | MySQL排序扫描速率              | -                                                       | -                          | -      |
| mysql_global_variables_innodb_buffer_pool_size         | MySQL InnoDB缓冲池大小        | -                                                       | -                          | bytes  |
| mysql_global_variables_thread_cache_size               | MySQL线程缓存大小              | -                                                       | -                          | -      |
| mysql_global_variables_key_buffer_size                 | MySQL键缓冲区大小              | -                                                       | -                          | bytes  |
| mysql_global_variables_query_cache_size                | MySQL查询缓存大小              | -                                                       | -                          | bytes  |
| mysql_global_status_qcache_free_memory                 | MySQL查询缓存可用内存            | -                                                       | -                          | bytes  |
| mysql_global_status_innodb_page_size                   | MySQL InnoDB页面大小         | -                                                       | -                          | bytes  |
| mysql_global_status_buffer_pool_pages                  | MySQL缓冲池页面数              | state                                                   | 页面状态                       | -      |
| mysql_global_status_innodb_mem_dictionary              | MySQL InnoDB 存储引擎内存字典使用量 | -                                                       | -                          | bytes  |
| mysql_global_variables_innodb_log_buffer_size          | MySQL InnoDB日志缓冲区大小      | -                                                       | -                          | bytes  |
| mysql_global_status_innodb_log_waits                   | MySQL InnoDB日志等待         | -                                                       | -                          | -      |
| mysql_global_variables_innodb_additional_mem_pool_size | MySQL InnoDB附加内存池大小      | -                                                       | -                          | bytes  |
| mysql_global_variables_innodb_buffer_pool_chunk_size   | MySQL InnoDB缓冲池块大小       | -                                                       | -                          | bytes  |
| mysql_global_variables_innodb_buffer_pool_instances    | MySQL InnoDB缓冲池实例数       | -                                                       | -                          | -      |
| mysql_global_status_innodb_row_lock_waits              | MySQL InnoDB行锁等待次数       | -                                                       | -                          | -      |
| mysql_global_status_qcache_hits                        | MySQL查询缓存命中数             | -                                                       | -                          | -      |
| mysql_global_status_qcache_inserts                     | MySQL查询缓存插入数             | -                                                       | -                          | -      |
| mysql_global_status_qcache_not_cached                  | MySQL未缓存查询数              | -                                                       | -                          | -      |
| mysql_global_status_qcache_lowmem_prunes               | MySQL查询缓存低内存修剪数          | -                                                       | -                          | -      |
| mysql_global_status_qcache_queries_in_cache            | MySQL查询缓存中的查询数           | -                                                       | -                          | -      |
| mysql_slave_status_seconds_behind_master               | MySQL主从延迟时间              | channel_name, connection_name, master_host, master_uuid | 通道名称, 连接名称, 主库主机名, 主库UUID  | s      |
| mysql_slave_status_sql_delay                           | MySQL从服务器SQL延迟           | channel_name, connection_name, master_host, master_uuid | 通道名称, 连接名称, 主库主机名, 主库UUID  | s      |
| mysql_slave_lag_seconds                                | MySQL从库延迟                | channel_name, connection_name, master_host, master_uuid | 通道名称, 连接名称, 主库主机名, 主库UUID  | s      |
| mysql_slave_status_slave_io_running                    | MySQL从库IO线程是否运行          | channel_name, connection_name, master_host, master_uuid | 通道名称, 连接名称, 主库主机名, 主库UUID  | -      |
| mysql_slave_status_slave_sql_running                   | MySQL从库SQL线程是否运行         | channel_name, connection_name, master_host, master_uuid | 通道名称, 连接名称, 主库主机名, 主库UUID  | -      |
| mysql_slave_status_read_master_log_pos                 | MySQL从库正在读取的主库日志文件位置     | channel_name, connection_name, master_host, master_uuid | 通道名称, 连接名称, 主库主机名, 主库UUID  | -      |
| mysql_slave_status_relay_log_pos                       | MySQL从库正在执行的中继日志文件位置     | channel_name, connection_name, master_host, master_uuid | 通道名称, 连接名称, 主库主机名, 主库UUID  | -      |
| mysql_slave_status_exec_master_log_pos                 | MySQL从库正在执行的主库日志文件位置     | channel_name, connection_name, master_host, master_uuid | 通道名称, 连接名称, 主库主机名, 主库UUID  | -      |


### 版本日志

#### weops_mysql_exporter 4.2.1

- weops调整

#### weops_mysql_exporter 4.2.2

- 连接数据库的用户名、密码参数使用环境变量

#### weops_mysql_exporter 4.2.3

- 密码参数使用密码类型参数隐藏

#### weops_mysql_exporter 4.2.4

- 修复配置参数中的账户和密码中特殊符号不生效的问题

#### weops_mysql_exporter 4.2.5
- 增加平台抓取指标 mysql_global_variables_innodb_buffer_pool_instances

#### weops_mysql_exporter 4.3.1
- 内置衍生指标
- 合并v0.16.0
- 指标含义更正
  mysql_global_status_open_tables	MySQL当前打开的表数
  mysql_global_status_opened_tables	MySQL打开的表总数


添加“小嘉”微信即可获取mysql监控指标最佳实践礼包，其他更多问题欢迎咨询

<img src="https://wedoc.canway.net/imgs/img/小嘉.jpg" width="50%" height="50%">
