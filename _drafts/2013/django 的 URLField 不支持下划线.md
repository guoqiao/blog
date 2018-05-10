Title: django 的 URLField 不支持下划线

Date: 2012-08-31 15:47:33

假如你的model中有如下字段:

    home_page = models.URLField(verify_exists=False, blank=True, null=True

    `

    你在表单上给这个字段填写了如下值:

    `http://django_compressor.readthedocs.org

    `

    提交表单, django会给出错误提示:

    `&gt;输入一个有效的 URL。

    `

    这个链接是可以打开的, 而且还设置了`verify_exists=False, blank=True, null=True`这些参数, 为何还是被认为无效呢? 难道django认为这个url在字面上就是无效的?那么最有可能无效的就是这个下划线了

    查看django源码, 在core.validators模块中找到该字段的校验代码:

    

    class URLValidator(RegexValidator):

        regex = re.compile(

            r'^(?:http|ftp)s?://' # http:// or https://

            r'(?:(?:[A-Z0-9](?:[A-Z0-9-]{0,61}[A-Z0-9])?&#92;.)+(?:[A-Z]{2,6}&#92;.?|[A-Z0-9-]{2,}&#92;.?)|' #domain...

            r'localhost|' #localhost...

            r'&#92;d{1,3}&#92;.&#92;d{1,3}&#92;.&#92;d{1,3}&#92;.&#92;d{1,3})' # ...or ip

            r'(?::&#92;d+)?' # optional port

            r'(?:/?|[/?]&#92;S+)$', re.IGNORECASE)

            .....

    `

    重点在这一行:

    `r'(?:(?:[A-Z0-9](?:[A-Z0-9-]{0,61}[A-Z0-9])?.)+(?:[A-Z]{2,6}.?|[A-Z0-9-]{2,}.?)|'                                                            

    `

    可以看出, django的URLField确实不支持下划线

    个人觉得这应该算是django的一个bug, 稍后我会反馈给django开发小组

    目前规避的方法是暂时用CharField代替URLField:

    `home_page = models.CharField(max_length=511, blank=True, null=True

    