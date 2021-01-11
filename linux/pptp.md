#### pptp服务搭建

- 安装服务端

  - 配置PPTP 需要使用 TCP 1723 通信端口
    telent xx.xx.xx.xx 1723 

  - 软件配置

    安装ppp和pptpd
    > yum -y install ppp pptpd

    配置相关参数

    >  1. 配置pptpd
    >  1.1.运行 vim  /etc/pptpd.conf 编辑配置文件，删除下列两行命令符前面的 # ，保存后退出
    >      localip 192.168.0.1  
    >      remoteip 192.168.0.234-238,192.168.0.245  
    >
    >  1.2.运行 vi /etc/ppp/options.pptpd 编辑配置文件，删除下列两行命令符前面的 #，并写入当地DNS,我用华为云的dns，保存后退出
    >  ​    ms-dns 100.125.1.250
    >  ​    ms-dns 100.125.129.250  
    >
    >  1.3.运行 vi /etc/ppp/chap-secrets 配置VPN账号和密码
    >  ​    username pptpd password *
    >  ​      #格式
    >  ​      #username为拨号时的用户名
    >  ​      #pptpd为pptpd服务                       
    >  ​      #password为拨号时的密码
    >  ​      #*为任意分配IP地址
    >
    >  1.4.运行 vi /etc/ppp/ip-up 设置最大传输单元 MTU
    >  ​      在命令符 [ -x /etc/ppp/ip-up.local ] && /etc/ppp/ip-up.local “$@” 后面添加 ifconfig ppp0 mtu 1472

  - 开启服务器内核转发

    >  1.运行 vi /etc/sysctl.conf 编辑配置文件，添加 net.ipv4.ip_forward = 1 的配置，保存后退出。
    >   2.运行 sysctl -p 使修改后的参数生效。

  - 防火墙规则(可选，如果关闭了防火墙)

    >     1.运行 iptables -t nat -A POSTROUTING -s 192.168.0.0/24 -j MASQUERADE 开启 iptables 转发规则
    >      2.运行 vi /etc/sysconfig/iptables 配置iptables规则
    >        nat表里面添加:
    >        #-s 后面是pptpd.conf里面localip那个网段 
    >        #-o 后面是外网网卡设备名 
    >        #–to-source 后面是外网网卡地址 
    >        -A POSTROUTING -s 192.168.2.0/24 -o eth2 -j SNAT –to-source 192.168.1.42
    >    
    >        filter表里面配置：
    >        #pptpd的端口是1723 
    >        -A INPUT -p tcp -m state –state NEW -m tcp –dport 1723 -j ACCEPT 
    >        #pptp协议需要放开gre协议 
    >        -A INPUT -p gre -j ACCEPT 
    >        #修改mss为1356，-s后面是pptp客户端地址段，以免有些网站上不去 
    >        -A FORWARD -p tcp –syn -s 192.168.2.0/24 -j TCPMSS –set-mss 1356 
    >        #注释掉下面这个选项，vpn服务器就可以转发数据包，需要转发链默认规则是允许 
    >        #-A FORWARD -j REJECT –reject-with icmp-host-prohibited
    >    
    >       3.保存、重启iptables
    >     ​     service iptables save
    >     ​     service iptables restart

  - 解决周期自动断开情况

    >    运行vim /etc/ppp/options.xl2tpd ，录入内容
    >    ```shell
    >    lock
    >    lcp-echo-interval 0
    >    lcp-echo-failure 0
    >    ```
    >    

  - 重启服务

    >    1.重启PPTP服务：systemctl restart pptpd
    >    2.如果本机也修改了防火墙端口。重启iptables：systemctl restart iptables
    >    3.配置开机自启
    >    ​    systemctl enable pptpd.service
    >    ​    systemctl enable iptables.service



- 使用

  - Windows 访问VPN

    > 1.打开 网络和共享中心
    > 2.选择 设置新的连接或网络 --> 连接到工作区 --> 使用我的Internet连接(VPN)
    > 3.Internet地址 填入服务器ip
    > 4.输入上面配置的用户名和密码，连接即可

  - centos登录VPN

    > 1. centos 7 命令行下可使用pptpsetup进行pptp拨号，首先安装ppp，pptp和pptp-setup三个包，使用pptpsetup进行连接
    >
    > `yum install ppp pptp pptp-setup -y`
    >
    > 2. 使用pptpsetup进行连接
    >
    >    命令：pptpsetup --createVPN名字 --server VPNip --username username --password password --encrypt --start
    >
    >    `pptpsetup --create vpn --server xxxx --username xxxx --password xxxx --encrypt --start`
    >
    >    有以下提示即为成功:
    >
    >    > Connect: ppp0 <--> /dev/pts/1
    >    > CHAP authentication succeeded
    >    > MPPE 128-bit stateless compression enabled
    >    > local  IP address 192.168.160.13
    >    > remote IP address 192.168.160.1
    >
    > 3. 查看是否成功
    >
    >    使用`ifconfig`命令，可以看到会多了一个`ppp0`网口
    >
    >    然后ping服务器的ip会成功（远程开启了icmp）
    >
    > 4. 添加默认路由（可以不执行）
    >
    >    `route add default dev ppp0`
    >
    > 5. 断开连接
    >
    >    `pkill pptp`
    >
    > 6. 可能的问题
    >
    >    ```
    >    # pptpsetup --create vpn --server xxxx --username xxxx --password xxxx --encrypt --start
    >    Using interface ppp0
    >    Connect: ppp0 <--> /dev/pts/1
    >    EAP: unknown authentication type 26; Naking
    >    EAP: peer reports authentication failure
    >    Connection terminated.
    >    ```
    >
    >    解决方法：
    >
    >    ```
    >    # vim /etc/ppp/options
    >    refuse-pap
    >    refuse-eap
    >    refuse-chap
    >    refuse-mschap
    >    require-mppe
    >    ```

