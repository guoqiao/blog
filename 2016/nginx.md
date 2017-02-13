title: Nginx Notes

Read before start:

    http://wiki.nginx.org/Pitfalls
    http://wiki.nginx.org/QuickStart
    http://wiki.nginx.org/Configuration

## Permission

- Never chmod 777
- Easy way to check permissons for all:

    `namei -om /path/to/check`

## Examples
Location:

    server {
        server_name www.example.com;
        root /var/www/nginx-default/;
        location / {
            # [...]
        }
        location /foo {
            # [...]
        }
        location /bar {
            # [...]
        }
    }

Multiple index:

    http {
        index index.php index.htm index.html;
        server {
            server_name www.example.com;
            location / {
                # [...]
            }
        }
        server {
            server_name example.com;
            location / {
                # [...]
            }
            location /foo {
                # [...]
            }
        }
    }


Redirect:

    server {
        server_name www.example.com;
        return 301 $scheme://example.com$request_uri;
    }
    server {
        server_name example.com;
        # [...]
    }

Check file exists:

    server {
        root /var/www/example.com;
        location / {
            try_files $uri $uri/ /index.html;
        }
    }


The above conf means: if $uri doesn’t exist, try $uri/, if that doesn’t exist try a fallback location(/index.html).

Try files and fallback to proxy:

    server {
        server_name _;
        root /var/www/site;
        location / {
            try_files $uri $uri/ @proxy;
        }
        location @proxy {
            include fastcgi_params;
            fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
            fastcgi_pass unix:/tmp/phpcgi.socket;
        }
    }

Or this one:

    server {
        server_name _;
        root /var/www/site;
        location / {
            try_files $uri $uri/ /index.php;
        }
        location ~ \.php$ {
            include fastcgi_params;
            fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
            fastcgi_pass unix:/tmp/phpcgi.socket;
        }
    }

Disable SSLv3 and provide TLS only:

    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;


Django Simple Example:

    server {
        listen          80;
        server_name     domain.com *.domain.com;
        return          301 $scheme://www.domain.com$request_uri;
    }

    server {
        listen   80 default_server;
        server_name  www.domain.com;
        access_log  {path to log file};

        location /static {
            root   {path to site static root}/;
        }

        location /media {
            root   {path to site media root}/;
        }

        location / {
            try_files $uri $uri/ @proxy;
        }

        location @proxy {
            proxy_pass http://0.0.0.0:{PORT};
            proxy_redirect default;

            # various possible options
            # proxy_set_header X-Forwarded-Host $server_name;
            # proxy_set_header X-Real-IP $remote_addr;
            # proxy_set_header X-Forwarded-For $remote_addr;
        }
    }

round-robin load balancing:

    http {
        upstream myapp1 {
            server srv1.example.com;
            server srv2.example.com;
            server srv3.example.com;
        }

        server {
            listen 80;

            location / {
                proxy_pass http://myapp1;
            }
        }
    }


least connected load balancing:

    upstream myapp1 {
        least_conn;
        server srv1.example.com;
        server srv2.example.com;
        server srv3.example.com;
    }


ip-hash load balancing:

    upstream myapp1 {
        ip_hash;
        server srv1.example.com;
        server srv2.example.com;
        server srv3.example.com;
    }

Weighted load balancing:

    upstream myapp1 {
        server srv1.example.com weight=3;
        server srv2.example.com;
        server srv3.example.com;
    }
