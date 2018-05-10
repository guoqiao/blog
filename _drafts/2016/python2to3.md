Title: Python 2 到 3 升级checklist

今天把readfree.me从python2.7升级到了Python3.5.
本来以为还比较简单，实际上花了快一天。以下是需要修改的地方，做个记录。

## 从`__unicode__`回到`__str__`
全局替换一下即可, 此外，所有带有前缀`u`的字符串都要去掉前缀，而之前当作字节串用的字符串，现在要加上`b`或者`s.encode('utf-8')`
一些用到`hashlib`的地方也都受到了影响

## 绝对导入到相对导入
如果你要导入当前目录下一个文件, 在Python2中，跟导入系统包没差别：

    `import foo`
    `from foo import bar`

而在Python3中，这个导入会报错，你需要使用`相对导入`:

    `import .foo`
    `from .foo import bar`

这样做是有必要的. 在Python2中，如果你在当前目录下建了个与系统包同名的文件，例如`os.py`.
这时，如果你其它代码里使用了`import os`, 你会发现代码开始报出一些奇怪的错误，让你丈二和尚摸不着头脑。
通过上面的机制，这个问题不会发生。

## 获取函数名

在Python2中，你可以这样获取一个函数的名字：

    f.func_name

而到了Python3中，这个属性移除了，你必须这样写：

    f.__name__

在Python语法里，函数其实也是一个对象。所以，确实没有必要让函数特殊化，增加这个`func_name`的属性。新的方式更加和谐统一。
很不幸，`django-annoying`这个包的`render_to`装饰器就使用了这个属性，害我不得不割爱，全部还成了手工的`render`.

## 捕获异常的语法
Python2:

    try:
        ...
    except Exception, e:
        ...

Python3:

    try:
        ...
    except Exception as e:
        ...
