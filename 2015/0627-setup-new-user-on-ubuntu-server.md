Title: Setup new user on ubuntu server

## Add a user called 'ubuntu':

    useradd -d /home/ubuntu -m ubuntu

You need both the -d and -m opitons here. If you just run `useradd ubuntu` here, home dir will not be created. You have to create it manually and change the owner. 

Yes, it is that stupid.

## Check user and home dir if you want:

    cat /etc/passwd | grep ubuntu
    ls /home/ubuntu

There is another cmd `users`, which will show all users currently logged in, but not all users on host, even no options to do that.

## Set password:

    passwd ubuntu

It will ask you for the new password.

## Add user to sudo group:
    
    usermod -a -G sudo ubuntu

## Run sudo without password:

    visudo

Tip: default editor will be nano, you can set editor by this, either in terminal or .bashrc|.zshrc:

    export EDITOR='vim'

Append this at the bottom:

    ubuntu ALL=(ALL) NOPASSWD:ALL    

Or for all sudo group:

    %sudo ALL=(ALL) NOPASSWD:ALL    

Tip: you had better put it at the end. If not, some times it will be overrided by following settings and not working. 

## Add user to www-data:
It is also useful to add user to the www-data group:

    usermod -a -G www-data ubuntu

## Check user groups:

    id ubuntu

You will see something like this:

    uid=1000(ubuntu) gid=1000(ubuntu) groups=1000(ubuntu),27(sudo),33(www-data)

## SSH to server
Now, you can login to your ubuntu server with your shinny new user like this:

    ssh ubuntu@xxx.com

It will ask you to input password.

To make things easier, you can config your ssh so you can ssh to server with a short alias and nopassword.
First, create your ssh config:

    cd .ssh
    touch config
    vim config

Add this:

    Host s1
    HostName xxx.com
    User ubuntu

Second, generate your ssh key:

    ssh-keygen -t rsa

Just press enter for default path and empty passphrase.
A key pair has been generated in .ssh: id_rsa && id_rsa.pub

Copy your public key to server:

    ssh-copy-id s1

Sometimes this command does not work, then you can do it manually:
Just add the content of `.ssh/id_rsa.pub` on your localhost to `/home/ubuntu/.ssh/authorized_keys` on server, all done.

Now, you can login with:

    ssh s1

Enjoy!
    
