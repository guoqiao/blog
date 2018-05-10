Title: Redhat Openshift 域名绑定

Date: 2012-09-04 15:47:47

无意间发现了 Redhat Openshift 这个好东东, 于是立即在这里用 Wordpress 搭了个博客, 并打算在这里安家了

我的博客地址是:

    blog-guoqiao.rhcloud.co

    `

    如你所见, 上面的二级域名太长了. 更重要的, 它太不酷了. 我希望可以绑定自己的域名

    我在 Godaddy 注册了域名 guoqiao.me. 现在我希望我能将上面的博客地址映射到 blog.guoqiao.me

    ## 设置CName

    进入 Godaddy 管理后台, 增加一条CName记录:

    `blog     blog-guoqiao.rhcloud.co

    `

    界面提示说一般需要1小时生效, 也可能长达48小时, 总之就是不保障时间

    不过我在实际使用中发现, 几乎是立即就可以生效.

    ## 为应用添加别名

    在 Openshift 的应用页面上, 可以显示当前应用的别名. 但却不能直接在网页上设置. 这点我有点困惑

    根据文档, 用户需要通过 Openshift 提供的命令行客户端进行设置

    我使用的是 Ubuntu, 步骤如下:

1.  安装 ruby 和 gi

    sudo apt-get install ruby-full rubygems git-cor

2.  安装客户

    sudo gem install rh

3.  设置客户

    rhc setu

4.  设置别名

    命令格式:

    `rhc app add-alias -a {appName} --alias {www.yourDomain.com

    `

    这里, 我的应用是 blog, 期望的别名是 blog.guoqiao.me, 则命令为:

    `rhc app add-alias -a blog --alias blog.guoqiao.m

    `

    其他平台的操作可[参考这里](https://openshift.redhat.com/community/developers/install-the-client-tools)

    ## 设置 Wordpress

    有了上面的CName和别名设置, 我现在已经可以用 blog.guoqiao.me 来访问我的博客了.

    (blog-guoqiao.rhcloud.com依然有效)

    不过, 当你在 Wordpress 上点击登录进入后台, 发现url又变回 blog-guoqiao.rhcloud.com 了, 很是郁闷.

    不用担心, 只需要在 Wordpress 后台->Settings->General 中, 将 Worpress Address(URL) 和  Site Address(URL) 修改为如下地址即可:

    `http://blog.guoqiao.me

到这里, 就大功告成了.