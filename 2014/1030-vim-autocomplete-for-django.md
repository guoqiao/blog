Title: Django 的 vim 自动补全

Vim 的补全分很多种:

* 基于上下文的补全, 例如 vim 自带的, 用ctrl+n触发
* 基于编程语言的语法补全, 例如 YouCompleteMe
* 基于代码段的补全, 例如SnipMate和UltiSnip

第一种太弱, 而且自带, 就不讨论.

第二种, YouCompleteMe很强大, 用上了之后就离不开了. 例如, 当你导入模块, 输入名字和点后, 子模块就自动列出来了. 函数名, 类名, 变量名也都能自动补全, 是 Visual Studio 那样的自动触发, 很方便, 几乎是开发中不可缺少的. 

但是, 这种补全的作用有限. 例如在 Django 的 html 模版中, 输入 block, 你希望自动展开为 {% block foo %}{% endblock %}之类的, 它就爱莫能助了. 这时需要代码段补全.

第三种, 就是前面说的代码段补全.  SnipMate使用 VimL 编写, 但它依赖tlib, vim-adon-mw-utils 等库. UltiSnip 需要你的 vim 有 Python支持(vim --version | grep python查看), 但速度更快, 功能更强大. 这两个的代码段语法不同, 这个 github 项目同时搜集了两者支持的代码段:

    https://github.com/honza/vim-snippets
    
作者在 readme 里还比较了一下两个插件, 他推荐UltiSnip.

应该说, 有这两种补全配合起来, 写代码就已经很舒服了.但是, 很不幸, YouCompleteMe使用 tab 键出发, 而UltiSnip默认也是 tab, 两者会冲突.

之前多翻尝试, 没有很好的解决办法, 只好把UltiSnip映射成ctrl+j, 但是很不自然. 在 stack overflow 上找到了一个两全其美的解决方案, 借助另外一个插件 SuperTab 实现:

    " if you use Vundle, load plugins:
    Bundle 'ervandew/supertab'
    Bundle 'Valloric/YouCompleteMe'
    Bundle 'SirVer/ultisnips'
    
    " make YCM compatible with UltiSnips (using supertab)
    let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
    let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
    let g:SuperTabDefaultCompletionType = '<C-n>'
    
    " better key bindings for UltiSnipsExpandTrigger
    let g:UltiSnipsExpandTrigger = "<tab>"
    let g:UltiSnipsJumpForwardTrigger = "<tab>"
    let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"
    
这样两者都能使用 Tab 补全了.

例如, 在 django 的 html 模版里, 输入 { 然后按 tab, 就会自动展开为 {{ var }}, % 则展开为 {% var %}. 这其实是UltiSnip调用了 vim-snippets 中的 htmldjango.snippet 文件中的代码段. 还有更多, 你可以浏览一遍该文件, 这样以后写代码就能节省些时间.

而在 python 或其它编程语言的文件里, 写代码时会自动弹出补全列表, 与原来一样, 还是按 tab 就会在候选列表见切换. 这是YouCompleteMe在起作用, 非常自然.

后记: 之前就是因为vim的补全不能和谐工作, 因此尝试了下 Sublime Text. ST 确实很赞, 简单装好插件, 上面的补全功能就能完美使用了.  Cmd+P 快速打开文件也非常好用, 还支持 Vim 模式. 但是用了几天下来, 还是不习惯, 因为无法摆脱鼠标或触摸板. 而且因为多开了一个 app, 窗口的切换频率大幅增加. 而窗口切换是十分打断工作思路的一个操作.