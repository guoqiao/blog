Title: 在Mac OS X上使用pip时避免sudo

在类Unix系统上，安装系统级的包时，都需要管理员权限。命令前都需要加上sudo，然后还要输入密码。更麻烦的是，第一次输入时， 那个sudo经常忘掉，或者不确定要不要sudo，输完发现Permission Denied, 然后加上sudo再来一次。有点像是插USB的感觉，非常让人恼火。

而且轻易使用sudo权限也会给人带来不安全感。万一安装脚本里有bug， 可能会毁掉你的数据甚至系统。

在mac上用过 homebrew 后，安装包时再也不用sudo了， 是不是有一种海阔天空的感觉？ 尽管有些人会谴责这种做法， 认为会带来安全问题。 但是我想说， 这种想法迂腐了。看看人家windows，几乎就没有权限控制。 日常个人使用的电脑， 确实也不值得过分注意本机的权限。这就好像， 我在自己家里， 还要时刻注意规章制度仪表礼节一样, 累不累啊。

作为一名Python程序员，经常要使用pip给系统全局安装一些包， 需要sudo权限。 如果pip也可以像homebrew一样去掉sudo， 是不是会方便很多呢？

一些人可能很快就会想到virtualenv + virtualenvwraper/autoenv 的解决方案。 将python环境安装在当前用户的虚拟环境里， 就不需要sudo权限了。但是使用virtualenvwraper， 每次还是要workon来进入虚拟环境， 时不时会忘掉。 而autoenv虽然可以自动激活虚拟环境， 但会导致每次cd的时候很慢。

我个人并不喜欢在本地使用virtualenv， 除非项目对某些包的版本有特殊的要求， 否则一律使用全局的最新版本。 这样也避免了每次启动一个项目，就需要新建虚拟环境的步骤。有时候临时帮别人调试一些项目， 代码clone过来， syncdb一下， 就可以直接运行了， 方便多了。 但使用系统级的全局包的问题就是， 每次都需要sudo权限来安装新的包。

今天试了如下的解决方案：

使用homebrew安装python：

	brew install python

装完后执行：
	
	which -a python

你会得到：
	
	/usr/bin/python
	/usr/local/bin/python

前者是系统自带的2.7.6版本， 而后者是brew安装的2.7.9版本。为了使用brew的这个新版本， 你可以：

	cd /usr/bin
	sudo mv python python.save
	sudo ln -s /usr/local/bin/python python

这样python就被你替换掉了， 可以检查一下版本：

	python --version

这时， 你用pip安装python的包， 就可以不需要sudo了：

	pip install django

提升了安全性， 也提升了体验， 还节约了时间， 还是挺值得的。