Title: Ubuntu 上"unable to resolve host"问题解决办法

通常,在linux上, 你可以使用hostname命令来修改主机名. 假如你期望的主机名是xxx:

    hostname xxx
    
在ubuntu上,执行完这条命令之后,终端上显示的主机名确实变了.
但是,很不幸,每次你试图使用sudo执行命令时,就会遇到如下错误:

    sudo: unable to resolve host xxx
    
解决方案是:

编辑/etc/hosts文件, 把这一行

    127.0.0.1 localhost
    
修改为:
    
    127.0.0.1 localhost xxx
    
这还不算完, 你还要接续编辑/etc/hostname文件,将内容改为

    xxx

再执行sudo命令看下,应该已经OK了.
