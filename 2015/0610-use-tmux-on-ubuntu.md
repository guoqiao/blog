Title: Use Tmux on Ubuntu

Spliting terminal windows is usefull. Tmux is the best to do this.

## Basic Usage: 
In your terminal, run `tmux`, then you are in it.

For now, no big difference. Just a few more chars at the bottom.

There's a concept of 'prefix key' for Tmux, just like the leader key for Vim.

The default prefix key is Ctrl + b, press that before you press any of following:

	%    	: split horizontally
	"    	: split vertically
	Ctrl + o: rotate to next pane

If one window is not enough for you, you can:

	Ctrl + c: create window
	Ctrl + n: next window
	Ctrl + p: prev window

type `exit` to close pane or window. If you forget, do this:

	?       : get help for all shortcuts

Normally, that's all you need to know most of the time.

## Advanced
Tmux will read the conf file at: ~/.tmux.conf or /etc/tmux.conf

On Ubuntu, if you install tmux by apt-get, you can find ~/.tmux.conf already generated there.
What's more, in that file, it change the prerfix key to Ctrl + a instead of b, because a is easier to reach than b.
However, in most app like Terminal, Ctrl + a is used for going back to begin of line, I don't want to change that. Also, this change is not friendly to new user, which makes Ctrl + b doesn't work while user is reading the official document. So I prefer to modify the default .tmux.conf from ubuntu.

After you make the change in .tmux.conf and start a new instance of tmux, you may find it doesn't take effect, even you restart the terminal app. This is because the tmux server is still running in the background, you can run this cmd to restart it:

	tmux kill-server

or, just source the conf file again:

	tmux source-file ~/.tmux.conf

And, in the .tmux.conf file from Ubuntu, you may see this:

	# Allow us to reload our Tmux configuration while using Tmux
	bind r source-file ~/.tmux.conf \; display "Reloaded!"

That means you can press `Ctrl + b r` to run source-file on Ubuntu.

Also, you can use | and - to split window h or v, which is much easier to remember.

Now, just enjoy Tmux.