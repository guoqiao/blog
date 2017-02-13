Title: 在 Vim 中 使用 zencoding 插件快速编写 html 代码

Date: 2012-09-12 15:30:59

Tags: html , vim , zencoding

## 安装

下载 [zencoding的Vim插件](http://www.vim.org/scripts/script.php?script_id=2981)并解压后, 可以得到三个文件夹

你只需要将这三个文件夹拷贝到 ~/.vim 目录, 与已有文件夹合并即可. (Windows 上是 .../Program Files/Vim/vimfiles 文件夹.

这样安装就完成了.

## 基本标签补全

zencoding 的基本功能是可以补全所有的 html 标签. 注意它工作在插入模式下

例如, 你用 Vim 打开某个 html 文件, 进入插入模式, 并且输入标签 `p`

当你快速按下 "`Ctrl+y+,`" 之后(注意最后是个逗号), 标签就会被补全为:

    &lt;p&gt;&lt;/p&gt

    `

    其它的标签, 如 html, body, div, span, h1等等, 操作都一样

    需要注意的是, 我在实际使用中发现, 按下 `Ctrl+y+,` 的速度要快. 如果中间有停顿, 得到的结果就会是输入一个逗号而已.

    ## 使用 `+`

    很多 html 标签是一起出现的, 例如, `ul` 下必定有 `li`

    你可以输入 `ul+` , 补全后就可以得到:

    `&lt;ul&gt

        &lt;li&gt;&lt;/li&gt

    &lt;/ul&gt

    `

    类似的还有 `ol+`, `dl+`, `table+`, `tr+`, `map+`, `select+`, `optg+`. 你可以亲自试一试.

    ## 用标签包裹代码

    假如你有如下一段文字:

    `lin

    lin

    lin

    lin

    `

    你希望用 'code' 标签将他们包裹起来, 只需要进入行选模式选中它们, 然后按下 `Ctrl+y+,`

    此时, Vim 下方的命令行会提示你输入 Tag. 你可以输入 `code` 然后回车, 就会得到:

    `&lt;code&gt;lin

        lin

        lin

        line&lt;/code&gt

    `

    ## 生成代码段

    ### html

    Web开发人员经常需要从头创建一个 html 文件, 这个过程是重复劳动. zencoding 可以帮你完成这件事

    例如, 当你输入 `html:5` 然后按下 `Ctrl+y+,` 你就会得到如下内容:

    `&lt;!DOCTYPE HTML&gt

    &lt;html lang="en"&gt

    &lt;head&gt

        &lt;meta charset="UTF-8"&gt

        &lt;title&gt;&lt;/title&gt

    &lt;/head&gt

    &lt;body&gt;

    &lt;/body&gt

    &lt;/html&gt

    `

    有人可能奇怪为什么要写 `html:5` ? 直接写 `html` 不是更方便

    因为 `html` 也是基本标签, 如果你只写 `html`, 补全后得到的结果是:

    `&lt;html&gt;&lt;/html&gt

    `

    事实上, 后面的 ":5" 你可以认为是 html 的版本, 你还可以写 `html:xml`, `html:4`, `html:4s`, `html:xt`, `html:xs`, `html:xxs`

    这比前面的简单标签补全更高级一些, 它更像是带名称的代码片段

    例如, 输入 `html:4t` 补全后得到的内容是:

    `&lt;!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"&gt

    &lt;html lang="en"&gt

    &lt;head&gt

        &lt;meta http-equiv="Content-Type" content="text/html;charset=UTF-8"&gt

        &lt;title&gt;&lt;/title&gt

    &lt;/head&gt

    &lt;body&gt;

    &lt;/body&gt

    &lt;/html&gt

    `

    ### link

    除了 `html` 标签之外, 其它一些标签也能生成代码片段. 例如 `link`

    "link:css":

    `&lt;link media="all" rel="stylesheet" href="style.css" type="text/css" /&gt

    `

    "link:rss":

    `&lt;link rel="alternate" href="rss.xml" type="application/rss+xml" title="RSS" /&gt

    `

    `link` 后的类型还可以是 `atom`, `favicon`, `print`, `touch` 等.

    ### input

    在表单里, 经常要用到各种类型的 `input`. 例如:

    `input:text`, 'inout,t':

    `&lt;input id="" name="" type="text" /&gt

    `

    除此意外还有 `form:get`, `form:post` 等等.

    ## `Ctrl+y+/` 注释代码

    相信不少人都觉得在 html 中注释代码挺费劲的. zencoding 同样可以帮到你. 假如你有如下代码块:

    `&lt;div&gt

        hello worl

    &lt;/div&gt

    `

    你把光标移动到 `div` 标签上, 然后按下 `Ctrl+y+/` , 代码会变为:

    `&lt;!-- &lt;div&gt

        hello worl

    &lt;/div&gt; --&gt

    `

    再次按下, 则会取消注释.

    ## `Ctrl+y+a` 生成链接

    如果你将光标放在一个链接上, 例如 `http://www.google.com`, 然后按下 `Ctrl+y+a` , 你会得到:

    `&lt;a href="http://www.google.com"&gt;Google&lt;/a&gt

    `

    如果链接是 `http://www.bing.com`, 你会得到:

    `&lt;a href="http://www.bing.com"&gt;必应 Bing&lt;/a&gt

    `

    注意这其中的 "Google" , "必应 Bing" 这部分是自动添加的, 很智能吧

    很可能是通过访问该url并获取title得到的.

    ## `Ctrl+y+i` 获取图片大小

    假如你有如下图片:

    `&lt;img src="foo.png" /&gt

    `

    光标移动到img标签上，按下 `ctrl + y + i` , zencoding 会自动获取 `foo.png` 的大小并插入宽高属性

    看起来像这个样子:

    `&lt;img src="foo.png" width="32" height="48" /&gt

    `

    由于浏览器都要求 img 标签需要设定宽度和高度, 这个功能不仅省去了不少输入, 还避免了你打开图片查看大小然后又切换回来的过程, 还是非常贴心的.

    ## 更强大的 CSS 选择器语法

    输入 `ul&gt;li*3` 并 'Ctrl+y+,' 补全后, 你会得到:

    `&lt;ul&gt

        &lt;li&gt;&lt;/li&gt

        &lt;li&gt;&lt;/li&gt

        &lt;li&gt;&lt;/li&gt

    &lt;/ul&gt

    `

    你还可以指定各标签的id 和 class. 例如 `ul#id_ul&gt;li.item#id_li_$*3`:

    `&lt;ul id="id_ul"&gt

        &lt;li id="id_li_1" class="item"&gt;&lt;/li&gt

        &lt;li id="id_li_2" class="item"&gt;&lt;/li&gt

        &lt;li id="id_li_3" class="item"&gt;&lt;/li&gt

    &lt;/ul&gt

    `

    你还可以通过 `+` 号同时创建多个标签. 例如输入 `ul#ul_id&gt;li#li_id_$*3&gt;p+a`, 补全后得到:

    `&lt;ul id="ul_id"&gt

        &lt;li id="li_id_1"&gt

            &lt;p&gt;&lt;/p&gt

            &lt;a href=""&gt;&lt;/a&gt

        &lt;/li&gt

        &lt;li id="li_id_2"&gt

            &lt;p&gt;&lt;/p&gt

            &lt;a href=""&gt;&lt;/a&gt

        &lt;/li&gt

        &lt;li id="li_id_3"&gt

            &lt;p&gt;&lt;/p&gt

            &lt;a href=""&gt;&lt;/a&gt

        &lt;/li&gt

    &lt;/ul&gt

    `

    你也可以选中多行已有的文本,对他们进行操作. 假如你有如下几行文本:

    `lin

    lin

    lin

    lin

    `

    选中后, 按下 `Ctrl+y+,`, 下方的命令行会提示你输入 Tag

    你可以输入 `ul&gt;li*` 并回车, 就会得到:

    `&lt;ul&gt

        &lt;li&gt;line&lt;/li&gt

        &lt;li&gt;line&lt;/li&gt

        &lt;li&gt;line&lt;/li&gt

        &lt;li&gt;line&lt;/li&gt

    &lt;/ul&gt;

总之, 这种语法基本和CSS选择器一致, 你可以按需生成各种复杂的 html 代码结构

当然, 这个已经是接近奇技淫巧一类了, 更多细节可参考官方文档.