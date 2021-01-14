# subversion

- 安装

- 配置仓库

  - svnadmin create 仓库位置

  - 结合apache进行端口转发访问

    > vim /etc/httpd/conf.d/subversion.conf
    >
    > ```nginx
    > <Location /unicorn>
    >     DAV svn
    >     SVNPath /rain_data/svn/svnrepos/unicorn
    >     SVNListParentPath on
    >     AuthType Basic
    >     AuthName "wangfuyu svn server"
    >     AuthUserFile /rain_data/svn/unicorn_users.conf
    >     #AuthUserFile /rain_data/svn/svnrepos/rain/conf/passwd
    >     Require valid-user
    >     AuthzSVNAccessFile  /rain_data/svn/unicorn_access.conf
    >     #AuthzSVNAccessFile  /rain_data/svn/svnrepos/rain/conf/authz
    > </Location>
    > ```
    >
    > service httpd restart
    >
- 使用

