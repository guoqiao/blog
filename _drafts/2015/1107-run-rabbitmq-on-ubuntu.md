# 在 Ubuntu 12.04 上设置 RabbitMQ

## 安装及管理

安装:

    sudo apt-get install rabbitmq-server

查看状态:

    sudo rabbitmqctl status

注意状态中包含了版本信息:

    {rabbit,"RabbitMQ","2.7.1"}

管理服务:

    sudo service rabbitmq-server start|stop|restart

OS X 上的安装:

    brew install rabbitmq-server

服务并没有默认启动, 你需要在终端中执行:

    rabbitmq-server

## 启用 WebUI 查看服务状态

2.7以后自带了插件以及管理工具, 但默认情况下没有安装到系统目录. 你需要自己链接:

    sudo ln -s /usr/lib/rabbitmq/lib/rabbitmq_server-2.7.1/sbin/rabbitmq-plugins /usr/sbin/
    sudo ln -s /usr/lib/rabbitmq/lib/rabbitmq_server-2.7.1/sbin/rabbitmq-env /usr/sbin/

查看插件列表:

    sudo rabbitmq-plugins list

启用管理工具:

    sudo rabbitmq-plugins enable rabbitmq_management

如果你的版本小于3.0, 默认端口是55672:

    http://localhost:55672

3.0以后, 默认端口是15672:

    http://localhost:15672

![RabbitMQ Management WebUI](https://dl.dropboxusercontent.com/u/55214241/blog/RabbitMQ_Management.png)

这个服务被绑定到0.0.0.0, 所以你可以通过你服务器的任意 ip 或域名加端口来访问.

安装时自带的用户是guest:guest

如果你用 RabbitMQ 来做 Celery 的 Broker, 则对应的 BROKER_URL 如下:

    BROKER_URL = 'amqp://guest:guest@localhost:5672//'

当然这仅限于 RabbitMQ 和 Celery 在同一台服务器的情况. 如果在不同服务器, 则需要配置:

    $ sudo rabbitmqctl add_user myuser mypassword
    $ sudo rabbitmqctl add_vhost myvhost
    $ sudo rabbitmqctl set_user_tags myuser mytag
    $ sudo rabbitmqctl set_permissions -p myvhost myuser ".*" ".*" ".*"

此时对应的URL是:

    BROKER_URL = 'amqp://myuser:mypassword@server-ip:5672//myvhost'
