Title: 在线生成Homebrew Cask脚本给Mac一键装机

借助[Homebrew Cask](http://caskroom.io/), 我们可以通过命令行来给OS X安装App, 还可以把常用的App安装命令写成脚本,实现一键装机.

这个工具美则美矣,但使用时有一些小问题:

1. 我不是很确定它是否支持我喜欢的App
2. 我不是很确定我想要的App在这个工具里精确的名字

诚然你可以通过brew cask search & info命令来检查, 但是一个一个尝试终究是不方便.
于是蛋疼的我花了几个小时做了这个工具: 

[http://osx-app.com/](http://osx-app.com/)

你现在可以:

1. 在网页上一目了然的浏览支持的App清单
2. 点击App名,可方便的直达主页了解详情
3. 通过模糊查询,快速找到自己想要的App
4. 在线生成脚本并下载保存,不用自己去写了

做的过程中还想过支持brew自身的包, 进一步还可以支持apt-get,yum,pip...
其实全部的命令行包管理工具都可以支持. 另外还可以在线保存App合集什么的.
但这样一来就把坑挖太大了, 而且似乎意义也不是很大.遂决定保持简单.

总之是一个小工具, 和大家分享下. 顺便把前几天注册的域名给用上了.