---
title: learn - 项目开发中CI的go检查golang-lint
date: 2024-11-21 08:00:00 +0800
categories: ["computer", "project"]
tags: ["computer", "project"]
author: wangfuyu
math: true 
img_path: /static/image/

---

## 项目开发中CI的go检查golang-lint
背景：想要规范开发，不仅仅需要大家帮忙review代码，通过自动化方式更佳贴合团队和个人。
### golang-lint
- 软件下载地址

  > https://github.com/golangci/golangci-lint/releases  
  > 文档说明：https://golangci-lint.run/welcome/install/  
  > 上述文档中的安装，个人还是建议下载安装文件合适，因为有些sh文件里面链接的内容已经很久了，当做参考即可。
  >

- 软件简介

  > golangci-lint is a fast Go linters runner.  
  > It runs linters in parallel, uses caching, supports YAML configuration,
  > integrates with all major IDEs, and includes over a hundred linters.

- 软件简单使用
  > 命令行在开发项目目录中执行
  > ```shell
  > 
  >  golangci-lint run --timeout=5m --disable-all --enable=revive \
  >  --enable=govet --enable=errcheck --enable=goimports --enable=gofmt \
  >  --enable=gosimple --enable=ineffassign --enable=staticcheck \
  >  --enable=unused --enable=typecheck app/web/controller
  > 
  > ```

- 高级点例子
  > 首先配置个yml（yaml）文件吧
  > ```yaml
  > run:
  >   timeout: 5m
  > linters:
  >   disable-all: true
  >   enable:
  >     - goimports
  >     - errcheck
  >     - gosimple
  >     - govet
  >     - ineffassign
  >     - staticcheck
  >     - unused
  >     - revive
  >     - typecheck
  > issues:
  >   exclude-use-default: false  # 使用默认的排除规则
  > linters-settings:
  >   revive:
  >     rules:
  >       - name: var-naming # 变量名不要太教条
  >         disabled: true
  > 
  > ```
  > 保持文件到个人配置目录~/etc/golang-lint.yml  
  > ```shell
  > 
  > golangci-lint run --config ~/etc/golangci.yml app/web/controller model/ service/
  > 
  > ```
  > 检查无误即可提交代码
- 接入CICD
  > 项目内部可以斟酌选择使用gitlib-runner 或者 jenkins
  > 





