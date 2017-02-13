Title: PostgreSQL Notes for Ubuntu

## Naming
A lot of smart developers are terrible at naming. Microsoft is a good(bad?) example, as well as PostgreSQL.
`PostgreSQL` or `Postgres`, which one is right? As to [official history](http://www.postgresql.org/about/history/):

    PostgreSQL, originally called Postgres

So the right name should be `PostgreSQL` now, `Postgres` is the old name and should be deprecated.
However, in [wikipedia](https://en.wikipedia.org/wiki/PostgreSQL), it begins with:

    PostgreSQL, often simply Postgres, is an ...

So the fact is, people use `Postgres` for short, and that's why I was confused.
To be consistent, I will always use `PostgreSQL` to refer to this awesome database who doesn't know what it's name should be.

## Install

install server and client:

    sudo apt-get install postgresql postgresql-client

(so far, package names look ok.)

This will install:

- a daemon process called `postgres`(should be `postgresd` or `postgresqld` strictly, right?)
- a command line client  called `psql`(should be `postgresql`)
- a service called `postgresql`(this name looks alright)
- a database, a database role, and a linux user all called`postgres`(no password yet)
- some helpful commands like `createuser` and `createdb`(looks like system commands, but actually not)

OT: as you can see, PostgreSQL does have really terrible naming. Chaos.

Make sure service is running:

    sudo service postgresql status

Check the linux user has been created:

    cat /etc/passwd | grep postgres

## login and authentication
In PostgreSQL, database users are called `roles`, just like the default user `postgres` here.
Usage of psql:

    psql [OPTION]... [DBNAME [USERNAME]]

By default, you need a full command to login to a specific db:

    psql -h 127.0.0.1 -p 5432 -d exampledb -U dbuser

Or simpler:

    psql -h 127.0.0.1 -p 5432 exampledb dbuser

Then it will ask for password.
The -h and -p can be ignored if db is running on localhost:

    psql exampledb dbuser

And, if you have a user with the same name in your linux system and switched to or logined in as that user,
you will be able to login without authentication:

    psql exampledb

Even better, if the db also has the same name, you can just do:

    psql

For example, after installation, we already have a db, a role and a system user with the same name `postgres`.
So, if we switch to this user first:

    sudo su - postgres

then we try to login in with:

    psql

You will see:

    postgres=#

You logged in! Magic, right?
Now you can run sql commands here, for example, show version:

    select version();

## Built-in Commands
In PostgreSQL, there are some built-in commands, all starts with `\`.
For example, if you try `\conninfo` in the above shell, you will see something like:


    postgres=# \conninfo
    You are connected to database "postgres" as user "postgres" on host "127.0.0.1" at port "5432".
    SSL connection (cipher: DHE-RSA-AES256-GCM-SHA384, bits: 256)

You can use `\?` to list all available commands. Some useful ones:

    \? - list all commands
    \h CMD - help CMD
    \l - list all db
    \du - list all roles(users)
    \d - list all table in current db
    \d TABLE - list structure of TABLE
    \conninfo - current conn info
    \password [USER] - set password for current user or USER
    \q - quit

It will be useful to set the password for the default `postgres` user now,
then you can login to it from other client or system, other than reply on system user to bypass authtication.

## Create new user and db via db shell:
The default `postgres` user is already quite handy for developing or learning.
But normally, we don't use the default user in our project.
To create your own user and db:

    sudo -u postgres
    createuser --superuser dbuser
    createdb --owner dbuser exampledb
    psql
    \password dbuser
    \q

(Remember the `createuser` and `createdb` commands are installed by postgresql installer, not system ones.)
Then you can login to this db with:

    psql exampledb dbuser

Also, with the default user, you still need to switch user every time with `sudo su - postgres` even for developing or learning.
If we create a db user and a db with the same name to our current linux user,
that will be even handy. For example, my linux user name is `joeg`, so I can do:

    sudo -u postgres
    createuser --superuser joeg
    createdb --owner joeg joeg
    psql
    \password joeg
    \q

Now if I login as joeg, I can login to my db shell with just `psql` any time.

## Import sql file to your db
Use `-f` option in linux shell:

    psql -f exampledb.sql [exampledb [dbuser]]

Or use `\i` command in db shell:

    psql [exampledb [dbuser]]
    \i /path/to/exampledb.sql

Another way is to use this command:

    pg_restore -U postgres -d exampledb /path/to/dump

## Create new user and db with sql:
You can also do the above task in a traditinal sql way:
login as postgres user, then:

    CREATE USER dbuser WITH PASSWORD 'password';
    CREATE DATABASE exampledb OWNER dbuser;
    GRANT ALL PRIVILEGES ON DATABASE exampledb to dbuser;

## GUI client
If you don't like cli client, you can try:

    sudo apt-get install pgadmin3

## SQL autocomplete
SQL commands look wired and are hard to remember, right?
For MySQL, there is a cli client called [mycli](https://github.com/dbcli/mycli) can save you out form SQL.
Also, for PostgreSQL, the alternative is [pgcli](https://github.com/dbcli/pgcli).

One wired thing I found in pgcli is, somehow the `\password` command is missing.
So at the beginning, you will need to use pgcli to set the password first.

Install it, and it will help you a lot.

## Notes
To drop a db:

    dropdb -h HOST -U USER DBNAME

To create a db:

    createdb -h HOST -U USER -O USER DBNAME

To restore a db from dump:

    pg_restore -h HOST -U USER -d DBNAME /path/to/dump

