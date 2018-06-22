---
layout: post
title:  "Ansible Notes"
date:   2016-01-01 23:04:37 +1200
categories: posts
---

## What
Ansible is Simple IT Automation. It can finish similar tasks like Fabric, but more.
Fabric is like a library, which provides some functions.
While ansible is like a framework, which provides a workflow.
Both Ansibel and Fabric are based on paramiko, a Python ssh library.

## Features

* No client installation required on target machine
* Target machine can be windows, with PowerShell
* Only supports Python2 so far
* Control machine can not be windows
* Use YAML

## Install

Python dependencies:

    sudo pip install paramiko PyYAML Jinja2 httplib2 six

Install by pip:

    sudo pip install ansible

Run from source:

    git clone git://github.com/ansible/ansible.git --recursive
    cd ./ansible
    source ./hacking/env-setup  # for bash
    source ./hacking/env-setup.fish # for fish

Update from source:

    git pull --rebase
    git submodule update --init --recursive

## Key Points

Conf files are called `inventory`, default is `/etc/ansible/hosts`.

In inventory, you can group servers like ini:

    localhost ansible_connection=local

    [webservers]
    foo.example.com ansible_connection=ssh
    bar.example.com

    [dbservers]
    one.example.com ansible_ssh_user=joe
    two.example.com
    three.example.com:5309

    [loadbalancer]
    node-[0:9].example.com
    node-[a:z].example.com

The above example also shows:
* specify connection(default to ssh)
* specify ssh port(default to 22)
* specify user name(default to current user)
* specify hosts range with numbers and letters

Group vars:

    [atlanta]
    host1
    host2

    [atlanta:vars]
    ntp_server=ntp.atlanta.example.com
    proxy=proxy.atlanta.example.com


Run ad-hoc command:

    ansible atlanta -a "/sbin/reboot" -f 10

This use the default `command` module, so it equals to:

    ansible atlanta -m command -a "/sbin/reboot" -f 10

Use shell module:

    ansible raleigh -m shell -a 'echo $TERM'

Note the single quote, if you use double one, it will get value for current system, not the remote one.


Copy files:

    ansible atlanta -m copy -a "src=/etc/hosts dest=/tmp/hosts"

Question: copy from localhost to remote machines?

Change file meta:

    ansible webservers -m file -a "dest=/srv/foo/a.txt mode=600"
    ansible webservers -m file -a "dest=/srv/foo/b.txt mode=600 owner=mdehaan group=mdehaan"

Create dir:

    ansible webservers -m file -a "dest=/path/to/c mode=755 owner=mdehaan group=mdehaan state=directory"

Delete dir:

    ansible webservers -m file -a "dest=/path/to/c state=absent"

## cfg file load order

* ANSIBLE_CONFIG (一个环境变量)
* ansible.cfg (位于当前目录中)
* .ansible.cfg (位于家目录中)
* /etc/ansible/ansible.cfg


