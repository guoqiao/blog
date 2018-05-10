Title: Install Vim from source on Ubuntu

## Issue
Default Vim on Ubuntu 14.04 has no clipboard support. You can use this to check:

	vim --version | grep clipboard

'+' means support, '-' means not.

Without clipboard support, even you have 'set clipboard=unnamed' in your vimrc, your vim still can't share the system clipboard, which makes copy & paste a pain to me. That's why I need to install vim from source, so I can get the lastest version as well as the clipboard support.

## Steps

Install dependencies:

	sudo apt-get install libncurses5-dev libgnome2-dev libgnomeui-dev \
	    libgtk2.0-dev libatk1.0-dev libbonoboui2-dev \
	    libcairo2-dev libx11-dev libxpm-dev libxt-dev python-dev \
	    ruby-dev mercurial 

Get code:

	hg clone https://vim.googlecode.com/hg/ vim
	cd vim/src

While compible vim, you need to select which features are included:

	http://www.drchip.org/astronaut/vim/vimfeat.html

And, there's some sets for features:

	--with-features= Tiny, Small, Normal, Big, Huge

We will just use the 'Huge' one. However,  some vim plugins need python support, and it's strange pythoninterp is even not in the 'Huge' set. So you need to configure vim like this:

	./configure --prefix=/usr/local --with-features=huge --enable-pythoninterp --enable-python3interp

Then:

	make
	sudo make install

If you run 'which -a vim' now, you can see 2:

	/usr/local/bin/vim
	/usr/bin/vim

You can rm or rename the /usr/bin/vim, then the new vim will work now.

Run this to check:

	vim --version | grep clipboard
