Title: vimgrep的简单使用

Date: 2012-08-31 10:11:25

在当前目录下查找:

:vimgrep word *

递归查找子文件夹:

:vimgrep word **

查到结果后, 使用下面的命令在结果之间导航:

:cnext (:cn) 当前页下一个结果

:cprevious (:cp) 当前页上一个结果

:clist (:cl) 打开quickfix窗口，列出所有结果，不能直接用鼠标点击打开，只能看

:copen (:cope) 打开quickfix窗口，列出所有结果，可以直接用鼠标点击打开

:ccl[ose] 关闭 quickfix 窗口。

ctrl + ww 切换编辑窗口和quickfix窗口，在quickfix里面和编辑窗口一样jk表示上下移动，回车选中进入编辑窗口

功能很强大, 但是可能需要根据个人爱好进一步映射快捷键才好用