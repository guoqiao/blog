Title: Install phpPgAdmin on Ubuntu with Apache2

The pgadmin3 GUI client for PostgreSQL is terrible.
The other choice is the web client [phpPgAdmin](http://phppgadmin.sourceforge.net/).

## Install

    sudo apt-get install phpagadmin

This will install a conf file for apache at `/etc/apache2/conf.d/phppgadmin`, and restart apache.

## Fix apache conf
However, when you visit url `http://localhost/phppgadmin/`, it doesn't work.

The problem is, in the latest version of `/etc/apache2/apache2.conf`, it doesn't load conf files in `conf.d` at all. But it has these lines:

    ...
    # Include the virtual host configurations:
    IncludeOptional sites-enabled/*.conf
    ...

That means it will load `.conf` files in sites-enabled. So we can do:

    sudo ln -s /etc/apache2/conf.d/phppgadmin /etc/apache2/sites-enabled/phppgadmin.conf
    sudo service apache2 restart

Now, if you go to `http://localhost/phppgadmin/`, it works now. Congratulations!

## Fix security conf
But hang on, when I try to login with postgres/PASSWORD (need to set password first, refer to my last post), it fails with a message on top:

    Login disallowed for security reasons.

Then in `/etc/phppgadmin/config.inc.php`, I find this:

    // If extra login security is true, then logins via phpPgAdmin with no
    // password or certain usernames (pgsql, postgres, root, administrator)
    // will be denied. Only set this false once you have read the FAQ and
    // understand how to change PostgreSQL's pg_hba.conf to enable
    // passworded local connections.
    $conf['extra_login_security'] = true;

Since I am using it on localhost, so security doesn't matter here. Change `true` to `false`, and restart apache:

    sudo service apache2 restart

Now, go to `http://localhost/phppgadmin/` and login, it will work. Enjoy :-)
