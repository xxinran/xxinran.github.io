---
title: nginx-intro
date: 2021-02-01 23:04:57
tags:
categories:
---

## 简介

- 反向代理
- 负载均衡
- 动静分离

## 安装

```shell
$ sudo yum install nginx
$ sudo systemctl start nginx.service
# 访问成功
$ curl localhost:80
```

**测试安装成功**

因为我的测试环境是vagrant vm，所以需要做一个端口映射，这样我们可以在host上访问。

<img src="nginx-intro/image-20210201230936553.png" alt="image-20210201230936553" style="zoom:50%;" />

成功！

<img src="nginx-intro/image-20210201231043622.png" alt="image-20210201231043622" style="zoom:50%;" />

```shell
$ nginx -h
nginx version: nginx/1.14.1
Usage: nginx [-?hvVtTq] [-s signal] [-c filename] [-p prefix] [-g directives]

Options:
...
  -s signal     : send signal to a master process: stop, quit, reopen, reload
  -p prefix     : set prefix path (default: /usr/share/nginx/)
  -c filename   : set configuration file (default: /etc/nginx/nginx.conf)
  -g directives : set global directives out of configuration file

# nginx -s stop 停止
# nginx -s quit 安全退出
# nginx -s reload 重新加载配置文件
```

### nginx配置文件

```shell
$ vim /etc/nginx/nginx.conf
```

可以看到nginx server是监听在80端口的，我们可以修改端口，然后用`nginx -s reload`来生效。

<img src="nginx-intro/image-20210201231634344.png" alt="image-20210201231634344" style="zoom:50%;" />



### 详解nginx.conf

 三部分

```shell
user  www;# 工作进程的属主
 worker_processes  4;# 工作进程数，一般与 CPU 核数等同
 
 #error_log  logs/error.log;
 #error_log  logs/error.log  notice;
 #error_log  logs/error.log  info;
 
 #pid        logs/nginx.pid;
 
 events {
    use epoll;#Linux 下性能最好的 event 模式
    worker_connections  2048;# 每个工作进程允许最大的同时连接数
 }
 
 http {
		upstream xxx{
				server1:port1
				server2:port3
		} 
		
		server {
				location / {
						proxy_pass xxx
				}
		}

 }
```

https://www.cnblogs.com/fengzhongzhuzu/p/8848115.html