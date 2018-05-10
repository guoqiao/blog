Title: 跨主机mysql自动备份

以下内容基于ubuntu.

## 问题
假设你的mysql服务运行在 192.168.1.2(下称A), 你想自动备份到 192.168.1.3(下称B).

## 创建账号
登录到A,进入mysql的shell,然后执行:

    grant usage, select, lock tables, show view, event on *.* to 'backup'@'192.168.1.3' identified by '1234';
    
这个命令会在A主机上创建一个mysql用户backup, 密码1234. 它只能从ip地址192.168.1.3(B)访问A,且只拥有只读权限.

这里用到lock tables权限, 是因为后续我会用到 mysqldump. 而 mysqldump 在执行时, 需要lock tables权限.

另外我这里特地用ip地址作为示例. 如果你使用了域名, 则你要确保你的域名DNS配置中设置了域名到ip的反向解析.

## 导出数据
登录到B上, 导出数据的命令是:

    mysqldump -ubackup -p'1234' -h192.168.1.2 --all-databases > all.sql
    
不过,执行这条命令时会遇到警告:

    -- Warning: Skipping the data of table mysql.event. Specify the --events option explicitly.
    
查了下, 你需要在命令中增加一些选项:    
    
    mysqldump -ubackup -p'1234' -h192.168.1.2 --all-databases --events --ignore-table=mysql.event > all.sql
     
你可以把上述命令保存到一个shell脚本,然后使用crontab命令定时执行.