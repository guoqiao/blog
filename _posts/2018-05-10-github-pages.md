---
layout: post
title:  "使用 GitHub Pages 作为博客"
date:   2018-05-10 21:19:37 +1200
categories: posts
---

## 基本原理
GitHub Pages 是 GitHub 的静态博客托管服务.

第一步，是到 github 新建一个 repo .以下内容均以我为例.

我在 github 的用户名是 `guoqiao`, 那么 repo 的名字必须是 `guoqiao.github.io`. 然后将它 clone 到本地.

此时，我只需要创建一个 index.html 文件并 push:

    touch index.html
    echo "hello, world!" > index.html
    git add index.html
    git commit -m "add index.html"
    git push

然后打开这个网址就能看到我的博客了：

    https://guoqiao.github.io

到这里你应该大致理解了 GitHub Pages 怎么工作.

## Jekyll

如果每次写博客都需要自己生成 html，那就太麻烦了. 这时你就需要静态网站生成工具. GitHub Pages 默认使用的是  [jekyll].

OS X 上的安装步骤：

    brew upgrade ruby  # 升级 ruby 到最新版
    gem install bundler jekyll
    jekyll --version  # 检查是否安装成功

cd到你上一步创建的repo，在这里新建一个site：

    jekyll new . --force

这条命令告诉 jekyll: 在当前目录里新建 site, 忽略已经有的文件.
这时你会看到文件夹里多了很多文件，包括一篇示例博客, 以及 `.gitignore`.
你可以将它们全部提交到 git，作为你开始修改的起点(个人建议).

运行这个命令：

    jekyll serve

此时命令行就会提示你，到这里查看网站：

    http://127.0.0.1:4000/

如果你把这些文件 push 到 GitHub，然后再次访问：

    https://guoqiao.github.io

你会看到你的网站就这样发布了. 接下来，你可以打开 `_config.yml` 文件, 做一些必要的修改. 然后，仿照 `_posts` 文件夹里的示例，开始自己的第一篇博客了.

这种博客方式有如下几个我喜欢的好处：

- 不需要自建服务器
- 可以使用 git 追踪修改
- 可以使用 markdown

[jekyll]: https://jekyllrb.com/
