Title: Using uwsgi the right way

Using uwsgi to deply django site on ubuntu server is quite easy, but there are still something you need to know before making mistakes.

# install

You have 2 ways to install uwsgi on ubuntu: apt-get or pip

## apt-get

if you use apt-get, you need to install python plugin:

    sudo apt-get install uwsgi-plugin-python
    sudo apt-get install uwsgi

And, in your uwsgi ini file for your site, you need to add this:

    plugins=python


## pip

if you use pip, you need to install python-dev first:

    sudo apt-get install python-dev
    sudo pip install uwsgi

And, you don't need the `plugins=python` in ini file anymore.

See the sudo before pip? Yes, uwsgi should be installed in global system.
If you miss the sudo here, you may install it in your virtualenv.
It's meaning-less and you may have some trouble to run it.

# daemonize uwsgi
Daemonize means make uwsgi run on system boot and in background.
According to how you install uwsgi, you have 2 ways.

## apt-get

When you `apt-get install uwsgi` on ubuntu, it's installed as a service automatically. The magic lies in this file:

    /etc/init.d/uwsgi

Files in `/etc/init.d` will be loaded by sysvinit. Then you can mangage your uwsgi service like this:

    sudo /etc/init.d/uwsgi start|stop|restart|reload

or:

    sudo service uwsgi start|stop|restart|reload

the service command can find the service managed by sysvinit

## pip
If you uwsgi is installed by pip, you only got the executeable file in /usr/local/bin/uwsgi, you need to daemonize it yourself.

When you open some of the file in `/etc/init.d/`, you may feel sad:
I just want to register uwsgi as a service, why I need to write so long a script which looks similar to the others? It doesn't make sense.

Good news is that it is quite simple with the help of Upstart, which is an alternative to sysvinit. It use `/etc/init/` instead of `/etc/init.d/`.

Just create a file `/etc/init/uwsgi.conf` with following content:

    description "uWSGI Emperor"
    start on runlevel [2345]
    stop on runlevel [!2345]
    respawn
    exec /usr/local/bin/uwsgi --emperor /etc/uwsgi/vassals/ --logto /var/log/uwsgi.log

and then, you can mangage your uwsgi process like this:

    sudo initctl start|stop|restart|reload| uwsgi

or, still this:

    sudo service uwsgi start|stop|restart|reload

Yes, as you can see, the service command is smart, it can manage service from both sysvinit and Upstart, with the same command.

And, if you have both `/etc/init.d/uwsgi` and `/etc/init/uwsgi.conf`, when you say:

    sudo service uwsgi restart

It will restart the Upstart file `/etc/init/uwsgi.conf`. 
The sysvinit one will be ignored, or something similar.

# uwsgi config for your site
I recomend everyone to use the pip and Upstart way, it's much better then the apt-get way.

If so, you are using the emperor mode of uwsgi, which is very handy and powerful.

Now, you can create a ini file in `/etc/uwsgi/vassals/` like this:

    [uwsgi]
    virtualenv=/path/to/venv/
    chdir=/path/to/proj/root
    module=wsgi:application
    env=DJANGO_SETTINGS_MODULE=settings
    master=True
    vacuum=True
    socket=/tmp/%n.sock
    pidfile=/tmp/%n.pid
    daemonize=/var/log/uwsgi/%n.log

The %n means your file name. For example, my project name is 'readfree', I create a readfree.ini file for it. Then the %n means 'readfree'. You don't need to replace it with real name. uwsgi will do this for you.

And then restart or reload uwsgi:

    sudo service uwsgi restart

Check your socket file:
    
    ll /tmp/*.sock

If it's there, you are successful with uwsgi now:)
You can add more files to vassals, to run multi sites. 
By using sockets, you don't need to assign the port number anymore.

# nginx config for your site
Take domain readfree.me for example:


    server {
        listen          80;
        server_name     www.readfree.me;
        return          301 $scheme://readfree.me$request_uri;
    }

    server {
        listen 80;
        charset utf-8;
        server_name readfree.me;

        location  /static/ {
            alias  /path/to/static/;
        }

        location  /media/ {
            alias /path/to/media/;
        }

        location / {
            try_files $uri @django;
        }

        location @django {
           uwsgi_pass unix:///tmp/readfree.sock;
           include uwsgi_params;
        }
    }

restart nginx, you will see your site!
