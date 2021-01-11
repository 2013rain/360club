####  NFS共享（linux与linux之间共享文件夹）

- 服务端和客户端安装

  NFS server需要至少安装两个软件nfs-utils 和rpcbind。客户端只要安装rpcbind。

    ```
   rpm -qa nfs-utils rpcbind

   ```

  安装完nfs服务一般会自动生成配置文件exports，如果没有就自己创建一个 /etc/exports

  ```
  yum install -y nfs-utils  rpcbind  
  cat /etc/exports
  ```

  创建共享目录,将文件所有者指定为nfsnobody。nfsnobody用户在安装nfs时会自动创建

  如果不指定共享用户，则nfs系统在分配权限时会以用户uid为主，客户端如果用root账户会在服务器被自动降级至nfsnobody。

  ```
  mkdir  -p /data/nfs  
  chown -R nfsnobody:nfsnobody  /data/nfs`
  ```

- server配置文件

- - gitbook init
  - gitbook install
  - gitbook build 项目位置  生成位置

- 部署web

  - 静态部署
  - 端口映射