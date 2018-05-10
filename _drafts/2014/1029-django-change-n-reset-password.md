Title: 使用 Django 内置的组件实现修改和重置用户密码

Django 项目中, 如果要支持用户修改和重置密码, 要自己写的话, 其实是无趣和琐碎的. 此时, 可以使用内置的组件. 要做的事也很简单:

## urls

在你的 urls.py 下面增加如下内容:

    urlpatterns += patterns('django.contrib.auth.views',
        url(r'^password/change/$', 'password_change', name="password_change"),
        url(r'^password/change/done/$', 'password_change_done', name="password_change_done"),
        url(r'^password/reset/$', 'password_reset', name="password_reset"),
        url(r'^password/reset/done/$', 'password_reset_done', name='password_reset_done'),
        url(r'^password/reset/(?P<uidb64>[0-9A-Za-z]+)-(?P<token>.+)/$', 
            'password_reset_confirm', name="password_reset_confirm"),
        url(r'^password/done/$', 'password_reset_complete', name="password_reset_complete")
    )

## templates

这些view 默认会使用registration文件夹下的 templates:

    registration
    ├── logged_out.html
    ├── password_change_done.html
    ├── password_change_form.html
    ├── password_reset_complete.html
    ├── password_reset_confirm.html
    ├── password_reset_done.html
    ├── password_reset_email.html
    └── password_reset_form.html

你可以从django.contrib.admin的 templates 目录下先拷贝过来, 然后逐一覆盖即可.


 
