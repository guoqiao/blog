Title: 使用HTTPS取代HTTP

Date: 2013-05-29 16:43:47

HTTP协议在传送页面信息时使用的是明文，包括你的密码。如果这些信息被有心人截获，会带来数据安全问题。

## ssl 证书

使用HTTPS需要一个ssl证书。这个证书的获取方式有三种：

1 从权威的第三方授权机构购买,例如[VeriSign](http://www.verisign.com/cn/

2 使用免费证书，例如[StartSSL](http://www.startssl.com/

3 自己生成，参考这里[用openssl自签名证书](http://www.cnblogs.com/xiaozl/archive/2012/10/19/2730492.html)

方法1的问题是太贵，但安全性以及认可度好。一般公司没太大必要购买

方法2的问题是，免费证书有效期只有1年。到时可能会带来一些麻烦

方法3的问题则是，自己生成的证书不受浏览器认可，会弹出警告提示。

## lighttpd 配置

启用ssl.conf

    cd /etc/lighttpd/conf-enable

    ln -s ../conf-available/10-ssl.conf 10-ssl.con

    `

    注意看看10-ssl.conf中的内容，默认是：

    `$SERVER["socket"] == "0.0.0.0:443" 

    ssl.engine = "enable

    ssl.pemfile = "/etc/lighttpd/server.pem

    

    `

    确保这里ssl.pemfile文件的路径指向你的pem文件

    到这里，重启下lighttpd, 你已经可以用https访问你的服务了。

    ## url 重定向

    此时，http和https是共存的，用户还是可以使用http方式访问

    比较好的方法是将http一律重定向到https

    首先需要修改/etc/lighttpd/lighttpd.conf文件，启用mod_redirect模块。这一步骤容易漏掉

    重定向的配置可以参考这里

    [How to redirect HTTP requests to HTTPS](http://redmine.lighttpd.net/projects/1/wiki/HowToRedirectHttpToHttps)

    示例：

    `$HTTP["host"] == "example.com" 

        $HTTP["scheme"] == "https" 

            proxy.server = ( "" =&gt

            (

            "host" =&gt; "127.0.0.1"

            "port" =&gt; "9000

            )

            

        } else $HTTP["scheme"] == "http" 

            url.redirect = ( "(.*)" =&gt; "https://example.com$1" 

        

    }

这里的$1指的是前面括号中匹配的第一项. 这里仅有一个括号，也就是(.*)匹配到的内容

官方文档中写的是$0, 指的是不用括号时正则表达式匹配到的整个字符串

这个语法让第一次看到的人有点困惑，不过和python当中的re.search类似。