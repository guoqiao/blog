Title: PostgreSQL Notes for Ubuntu

## Naming
PostgreSQL is the right name, originally called Postgres

## Install

Install:

    sudo apt-get install postgresql postgresql-client

Service:

    sudo service postgresql status|start|stop|restart

Check the linux user has been created:

    cat /etc/passwd | grep postgres

This will install:

- a daemon process called `postgres`
- a command line client  called `psql`
- a service called `postgresql`
- a database, a database role, and a linux user all called`postgres`(no password yet)

It will also install following PostgreSQL Client Applications:

    clusterdb -- cluster a PostgreSQL database
    createdb -- create a new PostgreSQL database
    createlang -- install a PostgreSQL procedural language
    createuser -- define a new PostgreSQL user account
    dropdb -- remove a PostgreSQL database
    droplang -- remove a PostgreSQL procedural language
    dropuser -- remove a PostgreSQL user account
    ecpg -- embedded SQL C preprocessor
    pg_basebackup -- take a base backup of a PostgreSQL cluster
    pg_config -- retrieve information about the installed version of PostgreSQL
    pg_dump --  extract a PostgreSQL database into a script file or other archive file
    pg_dumpall -- extract a PostgreSQL database cluster into a script file
    pg_isready -- check the connection status of a PostgreSQL server
    pg_receivexlog -- streams transaction logs from a PostgreSQL cluster
    pg_restore --  restore a PostgreSQL database from an archive file created by pg_dump
    psql --  PostgreSQL interactive terminal
    reindexdb -- reindex a PostgreSQL database
    vacuumdb -- garbage-collect and analyze a PostgreSQL database

## login and authentication
In PostgreSQL, database users are called `roles`, just like the default user `postgres` here.
Usage of psql:

    psql [OPTION]... [DBNAME [USERNAME]]

full cmd:

    psql -h 127.0.0.1 -p 5432 -d exampledb -U dbuser
    psql -h 127.0.0.1 -p 5432 exampledb dbuser

DBNAME and USERNAME can be options or args.
All options above have default value:

    -h: 127.0.0.1
    -p: 5432
    -U: $USER (current linux username)
    -d: $USER (current linux username)

    psql exampledb dbuser
    psql exampledb
    psql

For example, after installation, we already have a db, a role and a system user with the same name `postgres`.
So, if we switch to this user first:

    sudo su - postgres

then we try to login in with:

    psql

This equals to:

    psql -h 127.0.0.1 -p 5432 -U postgres -d postgres

You will see:

    postgres=#

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

show all users:

    \du

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

## allow remote connections:

allow access from ip:

    vim /etc/postgresql/9.5/main/postgresql.conf

examples:

    listen_addresses='localhost'
    listen_addresses='10.10.10.10,192.168.1.10'
    listen_addresses='*'


set authentication rules:

    vim /etc/postgresql/9.5/main/pg_hba.conf

append a line to end. Examples:

    host   all    all     0.0.0.0/0   trust  # trust anyone
    host   all    all     0.0.0.0/0   md5  # send encrypted password
    host   pact   joeg     192.168.196.15/16   trust


## Notes
To drop a db:

    dropdb -h HOST -U USER DBNAME

To create a db:

    createdb -h HOST -U USER -O USER DBNAME

To restore a db from dump:

    pg_restore -h HOST -U USER -d DBNAME /path/to/dump


