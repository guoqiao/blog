Title: Vagrant network not working for CentOS 7

## Issue
We begin to use Vagrant for a new Django site.
Host: Ubuntu 14.04 64bit
Guest: CentOS 7 64bit
I use private network in Vagrantfile, and the guest CentOS has an IP: 10.0.0.10

I've installed nginx on Guest CentOS, and curl locahost can show the nginx index page.

However, I can ping this IP from Host, but while I curl it, I got this error message:

	 $ curl 10.0.0.10                                        
	curl: (7) Failed to connect to 10.0.0.10 port 80: No route to host


While run this on Host:

	sudo tcpdump -i vboxnet0
	tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
	listening on vboxnet0, link-type EN10MB (Ethernet), capture size 65535 bytes
	17:03:02.748236 IP 10.0.0.1.53255 > 10.0.0.10.http: Flags [S], seq 990711266, win 29200, options [mss 1460,sackOK,TS val 367992 ecr 0,nop,wscale 7], length 0
	17:03:02.748430 IP 10.0.0.10 > 10.0.0.1: ICMP host 10.0.0.10 unreachable - admin prohibited, length 68
	17:03:21.359814 IP 10.0.0.1.17500 > 10.0.0.255.17500: UDP, length 223


## Reason
Looks like there is a firewall on the Guest CentOS:

First, I thought it's iptables:

	[vagrant@localhost ~]$ sudo systemctl status iptables.service 
	iptables.service
	   Loaded: not-found (Reason: No such file or directory)
	   Active: inactive (dead)

It turns out iptabels is not running.

Then, I guess CentOS 7 changed the default firewall program. I found this post:

	http://stackoverflow.com/questions/24729024/centos-7-open-firewall-port

So, there's another one called firewalld on CentOS 7:

	sudo systemctl stop firewalld.service 
	sudo systemctl disable firewalld.service

The first line stops the daemon, but it will start next time when you do Vagrant up. 
The second line will disable the service.

Now, I can visit the site on Guest CentOS now. 
This issue cost me all afternoon to figure it out. ORZ...
