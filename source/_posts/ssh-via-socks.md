---
title: 公司内部ssh设置socks代理
tags:
  - ssh
  - socks
  - network
categories: 'deploy, network, intel'
abbrlink: a9be766e
date: 2021-01-29 14:40:50
---

<!-- more -->

> [Proxy at Intel - Intelpedia](https://intelpedia.intel.com/Proxy_at_Intel)
>
> 因为公司设置了vpn，所以通过公司电脑访问外网时需要通过代理（http, https, socks等）。



#### 起因

在部署hexo时，用到了git deployer。这个deployer在每次`hexo deploy`的时候会通过ssh链接我的github账号的xxx.github.io项目，连接报错。

```shell
# 看一下hexo的_config.yml文件

$ cat _config.yml  | grep -A10 deploy
## Docs: https://hexo.io/docs/one-command-deployment
deploy:
  type: git
  repository: git@github.com:xxinran/xxinran.github.io.git
  branch: main
```

在sshkey上传成功的情况下，测试ssh连接github

```shell
ssh -T git@github.com  #失败
```

后来发现是ssh没有配置代理，有两个方案：

1. 设置http代理（失败了）
2. 设置socks代理（成功）

#### 如何设置socks代理

在[公司文档](https://intelpedia.intel.com/Proxy_at_Intel#Using_openssh_to_connect_out_via_SOCKS_proxy)中看到，可以通过设置socks代理，建立对外部的ssh连接。

需要修改`.ssh/config`文件：

```shell
# linux
Host *
   ProxyCommand nc -X 5 -x proxy-xxx.intel.com:1080 %h %p

# windows上需要把nc命令改成connect，参数-S表示是socks代理。
$ cat ~/.ssh/config | tail -5
Host github.com
   HostName github.com
   User git
   ProxyCommand connect -S proxy-xxx.intel.com:1080 %h %p
   ForwardAgent yes
```

之后就可以成功ssh连接github了。

但是`ping proxy-xxx.intel.com`是ping不通的，应该是公司关闭了。