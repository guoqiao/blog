Title: ubuntu中deb包的依赖关系获取

Date: 2013-04-19 13:17:10

以`python-dev`为例。

## 直接依赖

    apt-cache depends python-de

    `

    显示当前包的依赖，但不递归。即依赖的依赖不会被显示。

    输出：

    `python-de

      依赖: pytho

      依赖: python2.7-de

      替换: python2.

      替换: python2.7:i38

      冲突: python-dev:i38

    `

    ## 反向依赖

    `apt-cache rdepends python-de

    `

    显示依赖当前包的包。这里`rdepends`中的`r`表示`reverse`, 即“反向”。

    输出：

    `python-de

    Reverse Depends

      libboost-python1.49-de

      python-minimal:i38

      python-dev:i38

      python:i38

      shedski

      .....

      pytho

      libboost-python1.49-de

      cytho

    `

    ## 依赖汇总

    `apt-cache showpkg python-de

    `

    显示当前包的依赖关系汇总，相当于前两个命令的合集：

    `Package: python-de

    Versions:

    .....

    Reverse Depends:

      libboost-python1.49-dev,python-de

      python-minimal:i386,python-dev 2.

      python-dev:i386,python-de

      .....

      python,python-dev 2.6.5-

      libboost-python1.49-dev,python-de

      cython,python-de

    Dependencies:

    2.7.3-0ubuntu7 - python (5 2.7.3-0ubuntu7) python2.7-dev (2 2.7.3) .....

    Provides:

    .....

    `

    ## 递归依赖

    如果想获取某个包依赖的所有包，也就是递归依赖，则需要借助`apt-rdepends`.

    安装：

    `sudo apt-get install apt-rdepend

    `

    与`apt-cache rdepends`不同，`apt-rdepends`中的`r`表示`recursive`，也就是递归依赖。 使用：

    `apt-rdepends python-de

    `

    输出：

    `Reading package lists... Don

    Building dependency tree      

    Reading state information... Don

    python-de

      Depends: python (= 2.7.3-0ubuntu7

      Depends: python2.7-dev (&gt;= 2.7.3

    pytho

      Depends: python-minimal (= 2.7.3-0ubuntu7

      Depends: python2.7 (&gt;= 2.7.3

    .....

    zlib1g-de

      Depends: libc-de

      Depends: libc6-de

      Depends: zlib1g (= 1:1.2.7.dfsg-13

    `

    你还可以使用`--dotty`或`-d`选项将依赖关系输出成`springgraph`所使用的`.dot`格式：

    `apt-rdepends --dotty python-de

    `

    输出：

    `Reading package lists... Don

    Building dependency tree      

    Reading state information... Don

    digraph packages 

    concentrate=true

    size="30,40"

    "python-dev" [shape=box]

    "python-dev" -&gt; "python"

    "python-dev" -&gt; "python2.7-dev"

    .....

    "zlib1g-dev" -&gt; "libc-dev"

    "zlib1g-dev" -&gt; "libc6-dev"

    "zlib1g-dev" -&gt; "zlib1g"

    

    `

    而有了`.dot`格式，你可以进一步使用`dot`工具，将依赖树输出为图片：

    `apt-rdepends --dotty python-dev | dot -T png &gt; deps.png

图片如下： [![deps](http://blog.guoqiao.me/wp-content/uploads/2013/04/deps.png)](http://blog.guoqiao.me/wp-content/uploads/2013/04/deps.png)

`apt-rdepends`在离线部署服务器时可能比较有用。你可以提前分析并下载好所有需要的deb包，然后离线安装。