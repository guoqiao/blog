Title: Celery的多站点支持

Celery是Django网站用于实现后台任务的利器. 但是阅读其文档就会发现,其配置文件仅支持单个app.
它无法像nginx, uwsgi或者supervisor那样,提供一个文件夹, 里面为每个app提供单独的配置文件.

如果你只有一台服务器,而上面有多个Django站点,都需要使用Celery,你要怎么办呢?

目前知道的办法似乎是继续使用django-celery这个django app.
然后, 在supervisor中创建多个配置文件,启动对应app的celery进程.

    cd /etc/supervisor/conf.d
    touch app1.conf
    touch app2.conf
    vim app1.conf

示例配置文件如下:

    [program:app1]
    directory=/path/to/app1/root
    command = python manage.py celery worker
    user = www-data
    autostart=true
    autorestart=true
    redirect_stderr=true
    environment=PATH="/path/to/app1/venv/bin"
    environment=LC_ALL="zh_CN.UTF-8"

你可能注意到最后两行都是environment. 没错, 它是用来设置环境变量的.
第一行将你的虚拟环境的bin加入到PATH环境变量, 那么当你执行python时,就会使用虚拟环境中的python. 等同于激活了虚拟环境.

第二行是给supervisor设置字符集. 
之前我的电子书网站[ readfree.me ](http://readfree.me)出现中文名书籍出现编码问题,无法读取文件,也无法推送.
我的系统里明明已经设置了编码为中文以及UTF8, 并且在调试时毫无问题.
但是一旦uwsgi后台启动站点, 以及supervisor后台启动celery任务, 就会出现问题.
当时猜到是因为环境变量的问题,但是不知道如何设置,困扰很久.
后来终于在stackoverflow上找到这种设置环境变量的方法, 解决问题.
注意变量值两侧的引号不能少,否则将无法识别.
uwsgi也是类似的设置. 问题同样被解决.

    vim /etc/uwsgi/vassals/app1.ini:

    [uwsgi]
    chdir=/path/to/app1/root/
    pythonpath=/path/to/app1/root/
    virtualenv=/path/to/app1/venv
    module=wsgi:application
    env=DJANGO_SETTINGS_MODULE=settings
    env=LC_ALL=zh_CN.UTF-8
    ;plugins=python
    master=True
    vacuum=True
    socket=/tmp/%n.sock
    chmod-socket = 666
    pidfile=/tmp/%n.pid
    daemonize=/var/log/uwsgi/%n.log
    uid=www-data
    gid=www-data
    enable-threads = true
    threads = 5
    processes = 4
