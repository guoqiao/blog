Title: Mac OS X 上 Sublime Text 3 的配置

在上一篇文章中, 我使用 homebrew 安装 Python 来替代系统自带的 Python 以达到全局 pip 安装时不需要 sudo 的目的. 虽然做到了, 但是也带来了一系列副作用. 对我影响较大的一个是: Vim 的杀手级插件 YouCompleteMe 不工作了. 虽然通过重装 Python, MacVim 以及 YCM 解决了:

	brew update; brew uninstall python; brew uninstall macvim; brew install python; brew install macvim --override-system-vim; ~/.vim/bundle/YouCompleteMe/install.sh

但是随后我的 Vim 还是出现了各种奇怪的现象. 基于这个原因, 我决定再次折腾下 Sublime  Text 3, 以下简称 ST.

## 我的必备插件
* [Package Control](https://packagecontrol.io/installation): 很奇怪这个为什么不是 ST 自带的?
* SideBarEnhancements: 类似于NERDTree, 文件树增强, 在左侧的文件树上增加各种功能菜单
* [Vintageous](https://github.com/guillermooo/Vintageous): Vim 模拟插件, ST 自带的 Vintage 的替代品.
* [Anaconda](https://github.com/DamnWidget/anaconda): 类似于YCM, 实现 Python 等多种语言的语法跳转, 检查, 格式化等
* Emmet: HTML展开必备
* SCSS: 高亮 CSS 以及 SCSS
* [Djaneiro](https://github.com/squ1b3r/Djaneiro): Django 以及 Python 代码段展开

ST还有很多优秀的插件. 不过插件宜少不宜多, 以上是我精简到最少的结果(其实是为了定位冲突, 后面会讲到).

## 我的主要配置 Preferences -> Settings -> User

    "always_show_minimap_viewport": true,
    "draw_minimap_border": true, # 让 minimap 里的当前位置更显眼点.
    "highlight_line": true, # ST 里我经常找不到光标在哪儿, 这个开启后可以高亮当前行
    "highlight_modified_tabs": true, # 修改了而尚未保存的 tab, 会用橘黄色显示
    "ignored_packages":
    [
        "Vintage"
    ], # 因为我使用了更好的 Vinageous, 所以自带的 Vintage 要ignore掉.
    "show_encoding": true, # 显示文件编码
    "show_full_path": true, # 标题栏上显示完整路径, 有时候不小心开错了文件, 这样能帮你早点发现.
    "show_line_endings": true,
    "open_files_in_new_window": false, #  在 Finder 里打开文件时, 不会新开窗口了.
    "vintageous_use_ctrl_keys": true, # 这样 ST 里的 Vim 就支持 Ctrl + v 列选了.
    "vintageous_use_sys_clipboard": true, # 让 Vim 与系统公用剪切板
    "word_separators": "./\\()\"':,.;<>~!@#$%^&*|+=[]{}`~?" # 去掉了 "-"

##  快捷键的修改 Preferences -> Key Bindings -> User

使用 iTerm 时, 我经常用 ⌘ + ← 以及 ⌘ + → 左右切换标签, 很好记, 用起来也很顺手. 到了 ST 里, 你需要用Mac默认的 ⌘ + Shift + [ 和 ⌘ + Shift + ] 来实现. 由于切换文件tab的操作十分频繁, 这个复杂的快捷键效率有点低.

此外, 我也经常在 iTerm 里用 ⌘ + T 新建tab, 而在 ST 里, ⌘ + T 和 ⌘ + P 的功能都是呼出 Command Palette. 其实有 ⌘ + P 就够了.

基于以上两点, 我增加了如下快捷键配置:

    { "keys": ["super+left"], "command": "prev_view" },
    { "keys": ["super+right"], "command": "next_view" },
    { "keys": ["super+t"], "command": "new_file" },

这下用起来顺手多了^_^

## Vintageous 的配置

我使用 Vintageous 取代自带的 Vintage 的一个重要原因就是它支持自定义的vim配置文件, 尽管功能还比较简陋. 配置文件的路径是:

~/Library/Application Support/Sublime Text 3/Packages/User/.vintageousrc

你需要自己创建它. 我目前的配置如下:

    :map ; :
    :map 0 ^
    :map <space> $
    :map j gj
    :map k gk

没错, 每行配置前需要带上冒号, 与标准的 Vim 配置文件格式不同. 也不知道设计者是怎么想的. 此外另外一个踩到的坑是: 文件最后必须有个空行, 否则死活不生效T_T

第一行的映射, 是我之所以这么需要这个配置文件的最重要原因. 因为我多年来都在 Vim 里将 ; 映射到 : 这样不用每次按 Shift, 已经完全习惯了, 以至于根本回不去. 最杯具的是有一次在同事Dan的电脑上调试代码, 习惯了直接按 ; + w 保存文件(其实没有保存你懂的). 结果出现了各种匪夷所思的奇怪现象, 让我以为全世界都坏掉了... 三个小时之后, 我放弃了. 然后Dan自己试了试, 就好了...这才发现原来是保存姿势不对. 知道真相的我眼泪差点掉下来, 沮丧的对Dan说: "I want to kill myself..."

有了这个映射之后, 只要在 Vim 模式下随时按下分号, ST 底部就会出现 Vim 的命令行了, 很方便. (Vintageous将命令行的位置移动到了底部, 更符合 Vim 用户的习惯.)

2,3两行配置是因为, 在 Vim 里, 移动光标到行首和行尾分别是 ^ 和 $. 需要按 Shift 以及数字键, 非常不方便. 默认时, 0 是回到每行第一个光标位置, 而不是第一个字符处, 用处不大. map 0 ^ 后, 充分利用了0这个键, 很好的解决了移到行首的问题. 但移动到行尾用什么键比较好呢? 一开始我用的 map 9 $ 来解决. 用着倒也顺手, 但后来发现如果想要重复一个命令, 而碰巧需要9的时候, 例如 9j, 这时就悲剧了...
同时, space 是键盘上最大的键, 但 Vim 里默认它只是向右移动一格光标, 绝对是大材小用了. 不少 Vimer 将它映射为 leader , 是个不错的注意. 不过我已经习惯了用逗号做 leader, 所以没必要再浪费空格键. 这个 space 到底要映射成什么, 我一直没想好. 直到有天灵机一动, 发现映射成$不是正合我意吗?

最后两行是为了解决自动换行时用 Vim 的 j 和 k 移动光标的痛苦.

这就是我上面这几行配置的来历.

关于 Vintageous 的另外一个值得一提的问题是, Vim 里默认 Ctrl + v 是列选, 而在 ST 里 Ctrl 键做了别的映射, 因此Vintageous无法使用列选. 为解决这个问题, 只要像我前面的配置文件那样, 加上这个就可以了:

    "vintageous_use_ctrl_keys": true, # 这样 ST 里的 Vim 就支持 Ctrl + v 列选了.


## Vintageous 中的gg命令与 Djaneiro 冲突
到目前, ST 与 Vim 完美结合, 一切都很美好. 但是...我在一天的使用中, 发现按 gg 回文件顶部时, 经常没有反应, 或者要停滞一下, 偶尔又正常. 由于 gg 操作很频繁, 所以这是个挺头疼的问题.

一开始我怀疑是 OS X 系统按键重复的延时设置问题, 不过试了下类似的 yy 以及 dd 命令, 都很正常, 只有 gg 无法正常工作. 因此我开始怀疑是某个插件的快捷键与 gg 有冲突. 在 Google 搜到了[这个](https://github.com/guillermooo/Vintageous/issues/282)和[这个](https://github.com/guillermooo/Vintageous/issues/249), 跟我的情况有点类似, 但不相同. 于是我开始逐个删除我的插件并测试. 这就是为什么我目前安装的插件只有前面那几个. 在这个过程中还发现, gg 的问题只会出现在 Python 文件中, 而在 txt 以及 html 等文件里完全正常.

最后发现这个冲突是由于 Djaneiro 导致的, 尝试了一些解决办法, 未果. 只好把这个 bug 提交到 github, 希望后续能有解决方案.
