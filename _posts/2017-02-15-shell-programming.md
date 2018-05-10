---
layout: post
title:  "Shell Programming Notes"
date:   2018-05-10 23:04:37 +1200
categories: posts
---

## define var and use:

    name="Joe"
    echo $name
    echo ${name}

No space around =

## always use {} for var:

    supervisorctl restart ${USER}:${USER}_gunicorn

that helps to determine the end of var.

## quotes

string in single quote will be used as it is, like raw string. use vars with double quote:

    export name="Joe"
    echo 'this is ${name}'
    >> this is ${name}
    echo "this is ${name}"
    >> this is a Joe


## string length

    echo ${#USER}
    >> 4

## substring

    echo ${USER:0:2}
    >> Jo

same as python index.

## condition statement
if:

    if condition
    then
        cmd1
        cmd2
        ...
        cmdN
    fi

if else:

    if condition
    then
        cmd1
        cmd2
        ...
        cmdN
    else
        cmdX
    fi

if else-if else:

    if condition1
    then
        command1
    elif condition2
        command2
    else
        commandN
    fi

# loop

for loop:

    for var in item1 item2 ... itemN
    do
        cmd
        ...
    done

in one line:

    for var in item1 item2 ... itemN; do command1; command2… done;

while loop:

    while condition
    do
        cmd
    done

infinite while loop:

    while :
    do
        cmd
    done

or:
    while true
    do
        cmd
    done

or:

    for ((;;))

## include or import another file

    source ./function.sh
    . ./function.sh

## params


    for i in $*
    do
        echo $i
    done

    bash run.sh 1 2 3 # will print 1 2 3

    use $1 $2 ... for params

## empty a file

    cat /dev/null > a.txt
