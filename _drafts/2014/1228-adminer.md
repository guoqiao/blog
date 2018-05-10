Title: 在 Mac OS X 上使用 Adminer 管理 MySQL 以及 Mongodb


## install mysql
本地开发时我一般使用sqlite。 不过有时候避免不了需要导入现有的MySQL数据进行测试或调试， 这时候就需要在本地安装mysql。
在Mac OS X上安装mysql最快捷的方式是使用homebrew：

	brew install mysql

默认情况下用户是root， 没有密码。装好后，你可以使用如下命令:

进入mysql shell：

	mysql -u root

管理mysql服务：
	
	mysql.server start|stop|restart

现在你可以start你的mysql了。


## phpmyadmin vs adminer
以前，无论是在服务器还是本地， 我一直使用phpmyadmin来管理mysql。虽然界面丑陋，但是用起来倒是十分顺手。 后来， 知道了adminer之后，发现它可以打包为一个文件， 显得十分轻量级。相比而言， phpmyadmin则显得有点重了。
另外， 比起phpmyadmin复杂的选项，adminer的操作界面也要简洁得多。 总体来说， adminer相对来说简洁清新， 值得一试。 而且装好后，发现adminer还支持sqlite, PostgreSQL, Oracle, MS SQL, mongo等一系列数据库，更增加了尝试它的理由。


## config apache
Mac OS X 自带有apache, 你在浏览器中访问http://localhost, 可以看到一个简单的网页显示"It works!", 这就是apache在起作用了。
默认的文档根目录是

	/Library/WebServer/Documents

上述网页对应的就是该目录下的index.html.en文件。

不过，apache默认没有开启php的支持， 而adminer是php写成。你需要编辑配置文件

	vim /etc/apache2/httpd.conf

取消这一行的注释：

	LoadModule php5_module libexec/apache2/libphp5.so


为简单计，这里我也不打算使用apache的Virtual Host功能， 而是直接把adminer部署在已有的文档根目录下。

为方便，先开启Auto Index：

	...
	DocumentRoot "/Library/WebServer/Documents"
	<Directory "/Library/WebServer/Documents">
		...
	    Options FollowSymLinks Multiviews Indexes
	    MultiviewsMatch Any
	    ...

在Options后加上Indexes即可。

记得要重启apache：

	sudo apachectl -k restart


接下来， 就可以部署adminer到这个目录里了。


## install adminer

理论上，从官网下载压缩包并解压，将其中唯一的adminer-4.1.0.php放在/Library/WebServer/Documents目录里, 应该就可以使用了.
但我在实际使用中发现，这样做会报错。即使将文件名改名为index.php也一样。由于我对php和apache都没有进一步了解的兴趣， 因此没有深究。
我尝试了另外一种办法： 直接到github把adminer的代码库clone下来：

	git clone git@github.com:vrana/adminer.git

这里你可能遇到权限问题， 可以考虑将/Library/WebServer/Documents的权限修改下.
到浏览器访问这个目录：http://localhost/adminer/adminer, 已经能够正常显示登录表单了。
服务器写127.0.0.1, 用户名root， 就登录了。 请确保你的mysql已经开启。
(注意默认的服务器localhost是无法连接的， 这是mysql默认配置的限制。)

## mongodb
为了试验用adminer管理mongodb， 特地安装mongo尝试了下。但是遇到一系列php相关问题， 简单记录下：

安装pecl, 参考这篇文章:

	http://jason.pureconcepts.net/2012/10/install-pear-pecl-mac-os-x/

安装php的mongo驱动：

	sudo pecl install mongo

安装php的autoconf:

	brew install autoconf

OS X 上的php.ini:

	cd /etc
	sudo mv php.ini.default php.ini

给配置文件增加写权限：	
	sudo chmod u+w php.ini

增加mongo的php的扩展：

	extension=mongo.so	

重启apache：
	
	sudo apachectl -k restart

此时再访问http://localhost/adminer/adminer, 数据库选mongo， 主机写localhost, 就可以登入了。
这是因为mongo本身是不带有权限管理的， 它认为mongo所在的主机应该是一台安全的机器, 因此权限的问题全部交给操作系统以及网络处理。 相比起mysql繁琐的权限配置， 个人觉得这是一种很聪明的做法。
