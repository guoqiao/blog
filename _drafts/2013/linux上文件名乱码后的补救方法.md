Title: linux上文件名乱码后的补救方法

Date: 2013-05-20 15:55:57

我在windows上使用winscp，传了一些电子书到[redfree.me](http://readfree.me/ "http://readfree.me/"), 花了整整一个晚上。 结果下午登录到服务器(ubuntu)一看, 发现杯具鸟，所有文件名都乱码：

[![mess](http://guoqiao.me/wp-content/uploads/2013/05/mess-294x300.png)](http://guoqiao.me/wp-content/uploads/2013/05/mess.png)

windows是gbk编码，而ubuntu是utf-8, 使用winscp时没有注意编码的转换。 google了一把，找到一个[](http://www.j3e.de/linux/convmv/man/ "convmv")工具。 执行如下命令：

    convmv -f gbk -t utf-8 ./**

输出如下：

[![fix](http://guoqiao.me/wp-content/uploads/2013/05/fix.png)](http://guoqiao.me/wp-content/uploads/2013/05/fix.png)

看到熟悉的中文，一阵激动：我的书终于有救了! 不过别急，这只是一个预览，让你看看成不成。根据下面的提示，你需要带上`--notest`参数，才会真的执行。很贴心有木有？ 执行

convmv -f gbk -t utf-8 --notest ./**

文件名转换这才真的完成。