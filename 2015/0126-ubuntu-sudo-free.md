Title: Ubuntu 中 sudo 免输密码的配置方法以及不生效的问题

通过下述命令编辑配置文件:

	sudo visudo

添加如下行:

	my-username ALL=(ALL) NOPASSWD: ALL

然后保存即可.

等等, 基本上每篇文章都这么说, 可是...可是, 为什么我每次使用 sudo 时还是被要求输入密码呢?
仔细研究了下, 这个配置文件如下:

	...
	# User privilege specification
	root    ALL=(ALL:ALL) ALL
	my-username   ALL=(ALL) NOPASSWD: ALL  # ---> the line added by me

	# Members of the admin group may gain root privileges
	%admin ALL=(ALL) ALL

	# Allow members of group sudo to execute any command
	%sudo   ALL=(ALL:ALL) ALL

	# See sudoers(5) for more information on "#include" directives:
	#includedir /etc/sudoers.d

我的配置加在了中间, 后面还有几条配置. 很有可能是我的配置被后面的覆盖了. 解决方案是把我的配置移动到最后.

再次试了下, 终于可以了. 要不要这么坑T_T