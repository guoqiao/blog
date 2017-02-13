Title: Git中文件的三种形态

Date: 2012-09-05 12:02:44

Tags: git , hg

git中的文件有三种形态:

*   `working copy

*   `staged

*   `committed`

通常, 你使用 `git` 的工作流程如下:

*   你在自己存放代码的目录下对文件进行的增删改操作, 都是在 `working copy` 中, 不涉及任何git命令

*   当使用 `git add` 命令时, 这些增删改操作才会进入`staged`状态

*   当使用 `git commit` 命令时, `staged`状态中的修改才会被真的提交到代码库

*   当使用 `git push` 命令时, 你本地代码库中已经提交的修改才会推送到远程仓库.

我之前一直使用HG. 虽然同为DVCS(分布式源代码管理系统), 但HG中没有`staged`这个概念

要理解这个模型, 你可以想象自己是流水线上的工人

你在自己的工作台(`working copy`)上工作(cp, touch, vim, rm...), 制作好的工件逐个放上(`git add`)一个传送带(`staged`)

当你觉得工作可以告一段落, 你开动传送带(`git commit`), 上面的工件则逐个按顺序落入一个箱子(代码仓库)保存起来(`committed`).

这里 `git add` 的概念与 `HG` 中的 `hg add` 概念完全不同.

`HG` 中, `hg add` 会把一个新文件直接放入代码仓库中, 进入 `committed` 状态

删除文件, 则是 `hg rm`

修改文件后, 只需要 `hg commit` 该文件, 就完成提交.

也就是说, 在 `HG` 中, 要完成增删改操作, 分别对应着如下的命令:

*   增: `hg add

*   删: `hg rm

*   改: `hg commit`

而 `git` 中, 文件的增删改都是本地操作, 与代码库无关:

*   增: cp, touch, vim..

*   删: r

*   改: vim, nano, gedit...

然后, 这三种操作都要经过 `git add` 命令, 才进入 `staged` 状态, 准备提交

接着, 只有执行 'git commit', 这些修改才算是真的提交了.

从上面的比较可知, hg 是 `Python` 写成, 因此保持了 `Python` 社区一贯的 `Pythonic` 风格, 追求方便, 快捷

而 git, 因同样出自 Linus 之手, 与 Linux 一样, 显示出严谨和理性, 但理解上手则较困难.