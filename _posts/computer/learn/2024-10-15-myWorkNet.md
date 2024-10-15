---
title: learn - 组织内网络拓展
date: 2024-10-15 12:00:00 +0800
categories: ["learn", "network"]
tags: ["learn"]
author: wangfuyu
math: true 
img_path: /static/image/

---

## 组织内网络拓展

### 拓扑图

![jpg]({{site.images-path}}软路由图.drawio.png)

### 拓扑说明

- 前提

 倘若有比较严格的地方限制了你的发挥（我说的是上网设备）。  
单个账户只有一个可以链接网络上网，另一个设备又有这方面需求，可以借鉴我的方法。
  或者家里没有路由器，但是房东给了你一个网线和上网账号，你的主机可以上网，室友的主机也想上网，也可以用此方法（省了找购买房东另一个上网账号）。

- 路由器
路由器内部网路。在往外一层就是互联网了。
```shell


```
- 台式主机
区域内的一个局域网中，一个小小的单元。
```shell
2: eno1: （可以上网的）
    inet 10.12.17.110  netmask 255.255.255.0  broadcast 10.12.17.255
       
11: eth0: （借道上网用的）
    inet 192.168.11.1  netmask 255.255.255.0  broadcast 192.168.11.255


```
```shell
#修改/etc/sysctl.conf把net.ipv4.ip_forward = 0改为= 1
sudo iptables -P INPUT ACCEPT
sudo iptables -P FORWARD ACCEPT

sudo iptables -t nat -A POSTROUTING -o eno1 -j MASQUERADE

sudo iptables -t nat -A POSTROUTING  -s 192.168.11.0/24 -d 10.12.17.0/24 -o eno1 -j MASQUERADE

#route add -net 网段 gw 网关 dev eth1
route add -net 192.168.11.0 netmask 255.255.255.0 dev eth0

sudo traceroute 192.168.11.12 -T
```

- 笔记本
另外的设备，也想上网，但是又不想安装太多监控自己的软件。
```shell
#ip:192.168.11.12
#sumway:255.255.255.0
#gw:192.168.11.1
#static
```
```shell
route print -4
#永久路由：
#0.0.0.0 0.0.0.0 192.168.11.1 默认
```

### 说明

请尊重合理要求上网，不就是蹭个网么。
