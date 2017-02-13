Title: 如何清空Discourse论坛里的标签

最近用Discourse搭建了一个新西兰华人社区：

    http://nz4cn.com

这个系统里，有分类(category)和标签(tag)两个概念。
在配置的过程中，我添加了一些标签组，每个组下新建了很多标签。
例如一个标签组含有新西兰所有城市，打算用来给帖子标记地理位置。
但后来我改变了思路，这些标签就没有了用处，于是我删除了标签组。
但是我很快发现，当我新建帖子的时候，标签的下拉列表里还是出现了我曾经创建过的所有标签。
列表非常长，严重影响了我给帖子添加标签，也引来用户的不满。

要删除一个使用过的标签，只需点击该标签，进入帖子列表。
在顶部就有删除标签的按钮，比较简单。
但是，对于没有使用过的标签呢？由于没有入口，没法删除。
除非一个一个自己输入到url里，但这样太辛苦了。

能否直接进入Discourse的数据库，将标签删除呢？尝试了一下，发现可以。

首先你需要进入docker容器：

    cd /var/discourse/
    ./launcher enter app  # in docker now

接下来要进入容器里的数据库：

    sudo su - postgres  # switch to postgres user
    psql discourse  # in db now!

列出所有tag相关的表：

    \dt *tag*;  # show all tables with tag in name

得到结果：

     Schema |         Name          | Type  |   Owner
    --------+-----------------------+-------+-----------
     public | category_tag_groups   | table | discourse
     public | category_tags         | table | discourse
     public | instagram_user_infos  | table | discourse
     public | tag_group_memberships | table | discourse
     public | tag_groups            | table | discourse
     public | tag_users             | table | discourse
     public | tags                  | table | discourse
     public | topic_tags            | table | discourse
    (8 rows)

这里真正相关的是`tags`和`topic_tags`两张表。
由于我的论坛还是新建，数据不多，所以我决定直接清空所有的标签，然后通过管理员帐号重新打标签。
注意删除的先后顺序：

    delete from topic_tags;
    delete from tags;

好了，回到网站，发新主题，恼人的标签列表终于消失了😊

