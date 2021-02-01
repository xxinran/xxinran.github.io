---
title: Docker Compose
date: 2021-02-01 18:12:38
tags:
categories:
---

##  简介

通过yaml文件定义多个容器和它们的依赖关系。

通过一条命令可以起运行多个容器。

## 安装

1. 用国内源下载

```shell
$ curl -L https://get.daocloud.io/docker/compose/releases/download/1.25.4/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose

```

2. 授权

```shell
$ chmod +x /usr/local/bin/docker-compose
$ export PATH=$PATH:/usr/local/bin
```

3. 验证
```shell
$ docker-compose version
docker-compose version 1.25.4, build 8d51620a
docker-py version: 4.1.0
CPython version: 3.7.5
OpenSSL version: OpenSSL 1.1.0l  10 Sep 2019
```

## 例子

```shell

```

