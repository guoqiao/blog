Title: django数据保存不生效问题

Date: 2012-11-13 15:18:10

### 问题描述

有如下一段代码：

    objs = models.Person.objects.filter(name = 'xxx'

    if objs.count()

        objs[0].age = 2

        objs[0].save(

    `

    这里假设name为xxx的Person有且仅有一个，代码的目的就是将其age字段更新为20.

    但是很奇怪，这段代码没有生效。执行后，该Person的age字段没有变化。

    作为尝试，将代码修改如下：

    `objs = models.Person.objects.filter(name = 'xxx'

    if objs.count()

        obj = objs[0

        obj.age = 2

        obj.save()

此时再运行，age字段被成功更新。

### 推测原因

在第一段代码中，每次用下标去取对象，取到的都是新的一份。

所以调用save时，上一行对age的设置已经丢失了。

但是，django的ORM不是应该有缓存吗？请求达人指点。