Title: Sublime Text 3 上手日志

作为一名 Python/Django Web 开发人员, 使用 Vim 有4年多了, 花了很多时间在配置上. 但是依然有很多地方不尽如人意. 因此最近打算尝试下 Sublime Text. 把一些基本的配置记录在这里.

## 配置文件
ST 的默认配置在 Preference -> Settings - Default, 格式是 JSON. 不过这个文件是只读的, 你需要参考这个文件, 然后在 Settings - User 里面覆盖对应选项, 来达到自定义配置的目的.

## 开启 Vim 模式
ST 自带的 Vim 模式的包, 不过默认被忽略掉了. 在 Preference -> Settings - Default 的最下面, 可以看到:

    "ignored_packages": ["Vintage"]
    
要开启它, 只需在Settings - User加上:

    "ignored_packages": [],
    
此时打开文件, 就会自动进入 Vim 的命令模式. 如果你希望默认是插入模式, 可以增加这个配置:

	"vintage_start_in_command_mode": false,
	
作为一个 Vimer, 最不能割舍的是 Vim 无需鼠标随心所欲移动光标的高效. 但最烦的也是繁琐的配置, 各种快捷键以及冲突. 使用 ST 并开启 Vim 模式后, 就有了一个各取所长的基础, 可以比较舒服的过渡了.

## 重复按键问题
在 os x 里, 持续按住一个键, 是不会重复起作用的. 例如在 ST 里使用 Vim 模式, 我习惯按住 j 来持续移动. 但是发现移不动, 只移了一行. 可以执行如下命令禁止 os x 的这个行为:

    defaults write -g ApplePressAndHoldEnabled -bool false


## 打开项目
对于单独的文件, 你可以右键用 ST 打开, 比较方便. 而对于项目(文件夹), 则需要先打开 ST, 然后在 File 菜单里去 Open, 略有不便. 而且关闭后打开, ST 并不会记住上次打开的项目, 要重新开启, 也不够人性化. 可能有解决方案, 待研究.(如果直接叉掉窗口,是记不住的.但如果 Cmd + Q, 是可以的.)

如果想打开多个项目, 需要将新项目文件夹拖拽到左侧的树上. 如果直接通过菜单打开, 会重新开启一个实例.

## 在项目中快速查找文件并打开

    CMD + P
    
## Package Control
安装包管理工具:

    https://sublime.wbond.net/installation
    
呼出包管理工具的快捷键:

    CMD + Shift + P 
    
然后输入 install 可以找到安装包的命令, 删除包则输入 remove.
    
## 在命令行中使用
在你的 shell 配置文件中设置别名:

    alias subl="'/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl'"
    
注意这里双引号中间还有一层单引号, 否则会报错.
然后, 你就可以在终端中使用 subl foo.txt 来打开文件了, 文件夹也可以.


## Emmet
ST 里面, 按 Tab 可以自带补全. 但是默认的不太智能, 需要安装 Emmet.
安装方法: 

    Preferences -> Package Control -> Package Control: Install Package -> Emmet  -> 重启 ST
    
此时, 找个 html 文件, 输入:

    .foo#bar
    
然后按 Tab, 就可以展开为:

    <div class="foo" id="bar"></div>
    
比 Vim 的 [Ctrl + y + ,] 要易用太多.