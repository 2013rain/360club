#   旧笔记本做个人服务器

- 安装
  - 首先需要安装一个系统   
    旧笔记本配置比较低，联想昭阳E49L （双核，升级内存后4G,加固态ssd和光驱托架扩展磁盘）   
    首先安装linux系统，因为U盘安装对BIOS设置不熟悉，找到restart的load default才找到识别的usb启动。  
    安装后连接网络，对旧软件进行更新，因为有些服务类软件依赖版本关系，新版本大部分都支持。  
    ```
	yum update -y
	```
  - 合上盖子不休眠  
    systemd 处理某些电源相关的 ACPI事件，可以通过从 /etc/system/logind.conf以下选项进行配置：  
	
	>HandlePowerKey按下电源键后的行为，默认power off
	>
	>HandleSleepKey 按下挂起键后的行为，默认suspend
	>
	>HandleHibernateKey 按下休眠键后的行为，默认hibernate
	>
	>HandleLidSwitch 合上笔记本盖后的行为，默认suspend

    触发的行为可以有

    >ignore、power off、reboot、halt、suspend、hibernate、hybrid-sleep、lock 或 exec。

    如果要合盖不休眠只需要把HandleLidSwitch选项设置为如下即可：  
    HandleLidSwitch=lock  
    注意：设置完成保存后运行下列命令才生效。  

    ```
	systemctl restart systemd-logind  
	```

  - 关掉防火墙
    因为个人用的服务器，不需要每次安装一个软件对端口开放一次，所以个人用的，干脆直接关掉防火墙吧,

    >  centos来说
    >
    >  查看防火墙状态~]# service iptables status
    >
    >  停止防火墙 ~]# service iptables stop 
    >
    >  启动防火墙 ~]# service iptables start 
    >
    >  重启防火墙 ~]# service iptables restart  
    >
    >  永久关闭防火墙 ~]# chkconfig iptables off
    >  永久关闭后重启 ~]# chkconfig iptables on　
    >
    >  开启80端口
    >
    >  vim /etc/sysconfig/iptables
    >
    >  \# 加入如下代码
    >
    >  -A INPUT -m state --state NEW -m tcp -p tcp --dport 80 -j ACCEPT
    >
    >  我安装的是fodera,没有安装iptables，以下方式可选
    >
    >  查看firewall服务状态~]# systemctl status firewalld
    >
    >  开启firewall服务~]# service firewalld start
    >
    >  关闭firewall服务~]# service firewalld stop
    >
    >  查询端口是否开放~]# firewall-cmd --query-port=8080/tcp
    >
    >  开放80端口~]# firewall-cmd --permanent --add-port=80/tcp
    >
    >  移除端口~]# firewall-cmd --permanent --remove-port=8080/tcp
    >
    >  停止firewall ~]# systemctl stop firewalld.service
    >
    >  禁止firewall开机启动~]# systemctl disable firewalld.service
    >
    >  安装iptables防火墙 ~]# yum install iptables-services
    >
    >  安装了iptable就可以使用上面iptables的几种命令了
    >
    >  
    >  重启防火墙使配置生效 ~]# systemctl restart iptables.service
    >
    > 设置防火墙开机启动 ~]# systemctl enable iptables.service 

- 不管怎么着，反正是在笔记本上安装了个linux，接下来要做什么呢？  
  docker?嗯，好主意，那就安装上docker吧。参考docker官网教程就行，命令复制粘贴，网络好的话分分钟搞定。  
  端口映射？内网穿透？说吧，你还想怎么折腾舍不得扔掉的笔记本。。那后续我再把我实现了的方案给你们都透露下。

- 部署web
  - 安装个openresty就行
  - 安装上git,node,gitbook，能编写，能提交已经很好了
