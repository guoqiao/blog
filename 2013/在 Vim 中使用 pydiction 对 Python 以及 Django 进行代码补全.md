Title: 在 Vim 中使用 pydiction 对 Python 以及 Django 进行代码补全

Date: 2013-05-20 16:16:22

## 问题

Vim 中自带有自动补全功能, 输入部分代码后按 Ctrl+N 可以启动

但这种补全是基于上下文的文本, 功能还是太弱了.

## pydiction 介绍

[pydiction](http://www.vim.org/scripts/script.php?script_id=850) 是一个 Vim 插件, 它的功能是对 Python 代码进行补全

具体做法是将 Python 所有的包和函数名列在一个文件里, 当你输入部分代码后按 Tab , 就会列出所有可能的选择.

## 安装

下载并解压 pydiction 后得到如下的目录结构:

    qguo@psyche:~/Desktop$ tree pydiction-1.

    pydiction-1.

    ├── complete-dic

    ├── pydiction.p

    ├── python_pydiction.vi

    └── README.txt

    0 directories, 4 file

    `

    只需要将上述文件拷贝到合适的目录即可完成安装.

    首先是 `python_pydiction.vim` 文件, 有点郁闷的是它的目录会因为操作系统而不同

    对于 Unix/Linux 用户, 你需要将它拷贝到 `~/.vim/after/ftplugin/` 

    对于 Windows 用户, 假设你的 Vim 安装在 `C:vim`, 则你需要将它拷贝到 `C:vimvimfilesftplugin`

    `complete-dict` 就是列举了 Python 关键字和函数等列表的字典文件:

    `--- Python Keywords (These were manually inputted) --

    an

    de

    fo

    i

    rais

    asser

    eli

    fro

    lambd

    retur

    ..

    .__add_

    .__class_

    .__contains_

    .__delattr_

    .__doc_

    .__eq_

    .__format_

    .__ge_

    .__getattribute_

    .__getitem_

    .__getnewargs_

    ..

    `

    `pydiction.py` 是用于生成 `complete-dict` 的 Python 脚本. 列表生成后就可以不需要它了

    `README.txt` 是帮助文件.

    以上三个文件的目录可以任意, 这里我将其放在 `~/.vim/ftplugin/pydiction` 目录中.

    接着在 `Vim` 中完成简单的配置.

    首先请确保你的 `Vim` 配置中启用了插件功能:

    `filetype plugin o

    `

    接下来指定字典文件的目录

    对于 Unix/Linux 用户是

        let g:pydiction_location = '~/.vim/ftplugin/pydiction/complete-dict

    对于 Windows 用户则是

        let g:pydiction_location = 'C:/vim/vimfiles/ftplugin/pydiction/complete-dict'

    到这里, 安装就按成了, 你可以编辑一段 Python 代码, 按 &lt;Ctrl+Tab> 试验下.

    ## 支持 Django

    用 Vim 写 Django 代码时, 那些各种巨长的 import 一定让你烦恼过

    你只需要将  Django 的包名添加到 `complete-dict` 中, 就可以告别这个烦恼了

    不过等等...Django 的包那么多, 莫非要自己写个脚本获取下

    答案是不用. `pydiction.py` 就可以帮你完成这件事

    以下我以 Ubuntu 下的操作为例.

    首先你需要有一个 Django 项目. 现成的或者 `django-admin startproject` 新建一个空的均可

    命令行下 `cd` 到该目录, 执行下述命令设定环境变量:

    `export DJANGO_SETTINGS_MODULE=setting

    export PYTHONPATH=

    `

    接下来, 你需要将 `complete-dict` 和 `pydiction.py` 文件拷贝到当前目录, 然后执行:

    `python pydiction.py django django.conf django.contrib django.core django.db django.dispatch django.forms django.http django.middleware django.shortuts django.template django.templatetags django.utils django.views django.db.model

    `

    执行完成后, Django 相关的包就被追加到 `complete-dict` 文件后了:

    `@@ -93719,3 +93719,16592 @@ formatter.get_bool_opt

     formatter.get_style_by_name(

    --- from pygments.formatter import * --

    

    +--- import django --

    +django.VERSIO

    +django.__builtins_

    +django.__doc_

    +django.__file_

    +django.__name_

    +django.__package_

    +django.__path_

    +django.con

    +django.contri

    ...

将  `complete-dict`  再拷贝回去, Django 的补全就可以用了. 按 Tab 体验下.

## 我的配置

上述配置我已经提交到[GitHub](https://github.com/guoqiao/guoqiao-vimrc)

你可以直接使用我已经将生成好的`complete-dict`的文件.