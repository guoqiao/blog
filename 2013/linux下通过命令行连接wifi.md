Title: linux下通过命令行连接wifi

Date: 2012-12-08 21:29:41

1.  扫描可用网络

    iwlist wlan0 scan | grep ESSID

2.  将密码写入配置文件

    wpa&#95;passphrase WIFI-ESSID WIFI-PASSWORD > /etc/wpa&#95;supplicant/wpa_supplicant.conf

3.  建立连接

    wpa&#95;supplicant -Dwext -iwlan0 -c /etc/wpa&#95;supplicant/wpa_supplicant.conf -B

4.  获取地址

    dhclient wlan0