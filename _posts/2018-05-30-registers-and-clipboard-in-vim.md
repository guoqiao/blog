---
layout: post
title:  "Registers and Clipboard in Vim"
date:   2018-05-21 22:00:00 +1200
categories: posts
---

## Vim registers

register | name | remark
---------|---------------|-------------------------
" | unnamed | any text yanked or deleted will go to here, vim default register
+ | unnamedplus | system clipboard for Linux, doesn't exist on OS X and Windows
* | clipboard  | system clipboard for OS X and Windows, selection clipboard for Linux
% | file name | current file name
_ | black hole | any text yanked or deleted to here will be gone, like `/dev/null`
- | small delete | dash, any deleted text less than a line
/ | searched text | last searched text with /, ?, *, #
: | command | last executed command
. | inserted text | last inserted text
# | alternative file | last edited file
= | expression | result of expression on command
0-9 | numbered | 0 for last yanked text, 1-9 for deleted text as a queue
a-z | named | mostly used for macro
A-Z | captial | append to named registers


## View register content
Use command:

    :registers

Or `:reg` for short.

## Copy & Paste

Many new vim users have been annoyed that, Vim doesn't share the system clipboard.
For example, when you copy a line with `yy` in Vim, and try to paste it in an application like Sublime Text with `Ctrl + V`, the line is gone. The same thing happens when you copy text in Sublime Text with `Ctrl + C` and try to paste it in Vim with `p`.

So, what is happening there when we do copy & paste?

In Vim, you are using the unnamed register `"` to exchange by default:

    y,d,x,c --> " --> p

In system, you are using system clipboard, which is the `*` regiter in Vim:

    Ctrl + C --> * --> Ctrl + V

(Let's assume you are on OS X or Windows for now.)

So you can see, the copy & paste world split between Vim and operating system. To fix this, you can add this line in your `.vimrc`:

    set clipboard=unnamed

which will tell Vim to use the the unnamed register `"` other than `*` for system clipboard. And now we have:

    y,d,x,c,Ctrl + C --> " --> p, Ctrl + V

which means Vim and system will share the same clipboard now.

## Linux

On Linux system, things become more complicated then above.

Those smart Linux geeks created a second way to do copy & paste: left click your mouse, select some text(without Ctrl + C), and middle click the mouse to paste.

This seems good so far, but bad news is: this operation will send text into a second clipboard called `selection clipboard`, which is different from the `system clipboard` using by `Ctrl + C` and `Ctrl + V`. So now you have these on Linux system:

    Ctrl + C --> system clipboard --> Ctrl + V
    Mouse left click to select --> selection clipboard --> Mouse middle click to paste

The copy & paste world split into two again.

To make things even worse, in Linux Vim, the register `*` now points to the new selection clipboard, and there is a new unnamedplus register `+` points to system clipboard:

    Ctrl + C --> +(system clipboard) --> Ctrl + V
    Mouse left click to select --> *(selection clipboard) --> Mouse middle click to paste

To make Vim still share the system clipboard, you can add this in `vimrc` instead:

    set clipboard=unnamedplus

Unfortunatelly, this will not work on OS X or Windows, since unnamedplus register `+` doesn't exist there.

## Conclusion

If you need to use the same `vimrc` cross platforms, I recommend you keep this in it:

    set clipboard=unnamed

This works on all 3 systems, except that on Linux, you are using the selection clipboard to interact with Vim.
