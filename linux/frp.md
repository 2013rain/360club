# 内网穿透工具-frp

------

#### 什么是内网穿透
 内网穿透说直白了也就是说用告诉外界如何用一个大家都能访问的ip访问到局域网内的电脑。至于是怎么得到一个大家都能访问的ip(公网ip)，对于普通搬砖工来说也就是购买一台最最便宜的服务器即可，如果是家庭网络拨号分配的是动态公网ip，那么恭喜你，本次就不用看往下看了，一般路由器都带端口映射。  
 内网穿透工具据我知道的有ngrok、frp、Earthworm、sSocks、花生壳等。
#### frp
参考官网地址：[https://gofrp.org/](https://gofrp.org/)  

>frp 是一个专注于内网穿透的高性能的反向代理应用，支持 TCP、UDP、HTTP、HTTPS 等多种协议。可以将内网服务以安全、便捷的方式通过具有公网 IP 节点的中转暴露到公网。 

如果官网打不开（可能是自己网络受限，访问不了那么多地址^_^）,可以从github下载二进制文件使用，下载地址 [https://github.com/fatedier/frp/releases](https://github.com/fatedier/frp/releases)  

#### 简单例子
只要能区分开里面文件名的服务端server(frps)和客户端client(frpc)就行,你看人家多人性化，把最后一个字母就标明了是server还是client。
* server
>启动服务:先下载到任意目录后，进入目录  
>./frps -c ./frps.ini

  cat frps.ini

	```
	[common]
	bind_port = 10086
	vhost_http_port = 10010
	
	```
  没跟你们的端口重复吧（\(^o^)/~），哟吼！这么巧呀！

* client
>链接服务：先下载到任意目录后，进入目录  
>./frpc -c ./frpc.ini 

  cat frpc.ini

	```
	[common]
	server_addr = 120.244.130.251
	server_port = 10086
	
	[ssh]
	type = tcp
	local_ip = 192.168.1.7
	local_port = 22
	remote_port = 6000
	
	[pan]
	type = http
	local_port = 8091
	custom_domains = blog.360club.net
	
	[console]
	type = http
	local_port = 9000
	custom_domains = 360club.picp.net
	```

	这下没重复了？我故意写错了ip地址能直接跑起来才怪，还有口令认证呢（省略了）。

* 访问测试
 在server上配置nginx或者openrestry，其实都是配置nginx作为代理用。配置nginx.conf文件  

```  
	server {
	        listen       443;
	        server_name   blog.360club.net;
	
	        access_log  /rain_data/log/nginx/360club_access.log;
	        error_log  /rain_data/log/nginx/360club_error.log;

	        location / {
	                proxy_set_header X-Real-IP $remote_addr;
	                proxy_http_version 1.1;
	                proxy_set_header Host $host;
	                proxy_set_header Connection "keep-alive";
	                proxy_pass http://120.244.130.251:10010$request_uri;
	        }
	}


	server {
	        listen       80;
	        server_name   360club.picp.net;
	
	        access_log  /rain_data/log/nginx/360club_access.log;
	        error_log  /rain_data/log/nginx/360club_error.log;
	
	        set $web_root /rain_data/source/online/360club/public;
	        location / {
	                 proxy_set_header X-Real-IP $remote_addr;
	                proxy_http_version 1.1;
	                proxy_set_header Host $host;
	                proxy_set_header Connection "keep-alive";
	                proxy_pass http://120.244.130.251:10010$request_uri;
	        }
	}
```
直接访问这两个地址  http://360club.picp.net/ 、https://blog.360club.net


#### 作为本地服务运行

> cat /etc/systemd/system/frpc.service 或者
> cat /usr/lib/systemd/system/frpc.service (我的是Fedora release 27)
> ```
> [Unit]
> Description=frpc
> After=multi-user.targe
> 
> [Service]
> Type=simple
> TimeoutStartSec=30
> ExecStart=/data/soft/frp/frpc -c /data/soft/frp/frpc.ini #启动命令根据自己情况填写目录
> Restart= always
> RestartSec=1min
> ExecStop=/bin/kill $MAINPID
> [Install]
WantedBy=multi-user.target
> ```
>systemctl start frpc.service  手动运行
>systemctl enable frpc.service 开机启动
>systemctl stop frpc.service

#### 结束
可以把个人博客放到家里电脑上，也可以搭建个开源的网盘，以后回去写东西也不用拷贝到U盘了（比如一些没写完的word和ppt）,还能干什么呢？反正我不说了，留给你们发挥。