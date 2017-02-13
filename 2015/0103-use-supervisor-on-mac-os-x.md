Title: 在 Mac OS X 上使用 supservisor 来管理后台进程

## 问题

在 Mac 上, 你可以使用 brew 很方便的安装 mongo, redis 等服务. 美中不足的是, 在使用它们前, 你需要手动开启它们, 并保留控制台. 作为一个懒人, 我比较厌烦每次都要开启服务. 同时作为一个强迫症患者, 我不喜欢看到太多的 Terminal 标签开在那里. 如果能将这些服务后台化, 就可以解决这两个烦恼.

在 Mac 上, 这类问题的官方答案可能是 launchctl. 不过老实说, 我非常讨厌这个东西. 原因后面会提到. 我希望像在 Linux 上一样, 使用 supervisor 来管理后台进程. 

## 安装 supervisor

在 Ubuntu 上, 你可以且应该这样安装:

	apt-get install supervisor

除了安装可执行程序本身, 还会创建默认的配置文件和目录:

	/etc/supervisord.conf
	/etc/supervisor/cond.d/

在 Mac 上, 你无法使用 apt-get, 经测试, 也无法使用 brew. 由于 supervisor 是一个 Python 包, 因此可以使用 pip 来安装:

	pip install supervisor

但这样安装后, 是不会创建配置文件的. 你需要自己手工创建. 为求简便, 这里不创建配置文件子目录, 而是直接把所有配置写在supervisord.conf本身:

	[unix_http_server]
	file=/tmp/supervisor.sock                       ; path to your socket file

	[supervisord]
	logfile=/var/log/supervisord/supervisord.log    ; supervisord log file
	logfile_maxbytes=50MB                           ; maximum size of logfile before rotation
	logfile_backups=10                              ; number of backed up logfiles
	loglevel=error                                  ; info, debug, warn, trace
	pidfile=/var/run/supervisord.pid                ; pidfile location
	nodaemon=false                                  ; run supervisord as a daemon
	minfds=1024                                     ; number of startup file descriptors
	minprocs=200                                    ; number of process descriptors
	user=root                                       ; default user
	childlogdir=/var/log/supervisord/               ; where child log files will live

	[rpcinterface:supervisor]
	supervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface

	[supervisorctl]
	serverurl=unix:///tmp/supervisor.sock         ; use a unix:// URL  for a unix socket

	[program:mongod]
	command=/usr/local/bin/mongod

	[program:redis-server]
	command=/usr/local/bin/redis-server

## 使用 launchctl 来启动 supervisor 自身

虽然 supervisor 可以很好的管理后台进程, 但是其自身的自启动还是需要借助其它工具. 在 Linux 上, 你可以用Upstart, SystemVInit, Sysytemd等. 而在 Mac 上, 还是要借助 launchctl 的帮助. 谁叫这是在 Mac 的地盘上呢? 好消息是, 你只用配置这一次, 以后其它的需要后台启动的服务, 就可以全部交给 supervisor 了.

下面介绍配置的步骤, 顺便吐槽为什么我不喜欢 launchctl .

launchctl 的配置文件可以存放于这些目录: 

	~/Library/LaunchAgents         Per-user agents provided by the user.
	/Library/LaunchAgents          Per-user agents provided by the administrator.
	/Library/LaunchDaemons         System wide daemons provided by the administrator.
	/System/Library/LaunchAgents   Mac OS X Per-user agents.
	/System/Library/LaunchDaemons  Mac OS X System wide daemons.

(配置文件目录太多. 每次添加文件都头大)

这里我在 ~/Library/LaunchAgents 目录下, 创建一个 supervisord.plist 文件, 内容如下:


	<?xml version="1.0" encoding="UTF-8"?>
	<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
	<plist version="1.0">
	<dict>
	    <key>KeepAlive</key>
	    <dict>
	        <key>SuccessfulExit</key>
	        <false/>
	    </dict>
	    <key>Label</key>
	    <string>supervisord</string>
	    <key>ProgramArguments</key>
	    <array>
	        <string>/usr/local/bin/supervisord</string>
	        <string>-n</string>
	        <string>-c</string>
	        <string>/etc/supervisord.conf</string>
	    </array>
	    <key>RunAtLoad</key>
	    <true/>
	</dict>
	</plist>

(配置文件的格式非常奇葩, 本来一行配置可以搞定的事, 它需要一个 n 行的 xml 配置文件, 每个命令参数都需要写在单独的节点里, 及其繁琐, Java 程序员可能比较习惯)

接下来, 你可以启动 supervisor 了:

	launchctl load ~/Library/LaunchAgents/supervisord.plist

(这个命令也非常不友好, 例如: 要不要 sudo? 为什么是 load 而不是常规的 start? 为什么要用配置文件的路径而不用名字?)

## 管理进程

每次修改或增删了配置文件, 都需要执行:

	sudo supervisorctl update

这个在刚开始使用 sv 时可能会带来一些困惑. 如果你不执行, 而只是 restart 某个进程, sv 使用的还是以前的版本.