---
title: 如何构建docker image
date: 2021-01-28 22:31:29
tags: docker
categories: docker
typora-root-url: ../_posts
---

```shell
$ docker image inspect ubuntu
        "RootFS": {
            "Type": "layers",
            "Layers": [
                "sha256:bacd3af13903e13a43fe87b6944acd1ff21024132aad6e74b4452d984fb1a99a",
                "sha256:9069f84dbbe96d4c50a656a05bbe6b6892722b0d1116a8f7fd9d274f4e991bf6",
                "sha256:f6253634dc78da2f2e3bee9c8063593f880dc35d701307f30f65553e0f50c18c"
            ]
        },
```



rootfs

bootfs

chroot

aufs

xfs

Overlay2

copy on write 

Writeout 

init-layer - non commit



<img src="/docker-image/image-20210203234917452.png" alt="image-20210203234917452" style="zoom:70%;" />



## 如何构建docker image

步骤：

1. 编写一个dockerfile
2. docker build构建镜像
3. docker run运行镜像
4. docker push发布镜像

### DockerFile构建过程

#### **基础知识：**

1. 每个保留关键字都是大写
2. 顺序执行
3. #表示注释
4. 每一个指令都会创建提交一个新的镜像层。

#### DockerFile指令

![image-20210128174810881](docker-image/image-20210128174810881-1611828531908.png)


#### CMD  和 ENTRYPOINT的区别

```shell
# docker run image-id 
CMD ["ls","-a"]  # 指定容器启动时要运行的命令，最后一个有效，可被替代。在docker run时不能被追加参数
ENTRYPOINT ["ls", ["-a"]] # 指定容器启动时要运行的命令，可以在docker run的时候追加参数
 													# 比如 docker run xxx "-l"
```

##### 测试CMD

写了两个CMD，在docker run的时候，发现只执行了最后一个，并没有echo出"Hello"，也不能追加参数，会报错。

```shell
[vagrant@localhost dockerfile]$ cat docker-cmd-test
FROM centos
CMD ["echo", "Hello"]
CMD ["ls", "-a"]

[vagrant@localhost dockerfile]$ docker run cmdtest
.
..
.dockerenv
bin
dev
etc
...

# 尝试追加一个参数，想达到ls -al的效果，失败。
[vagrant@localhost dockerfile]$ docker run cmdtest -l
docker: Error response from daemon: OCI runtime create failed: container_linux.go:370: starting container process caused: exec: "-l": executable file not found in $PATH: unknown.

# 但是可以在docker run的后面直接加命令。
[vagrant@localhost dockerfile]$ docker run cmdtest ls -al
total 0
drwxr-xr-x.   1 root root   6 Jan 30 11:26 .
drwxr-xr-x.   1 root root   6 Jan 30 11:26 ..
-rwxr-xr-x.   1 root root   0 Jan 30 11:26 .dockerenv
lrwxrwxrwx.   1 root root   7 Nov  3 15:22 bin -> usr/bin
drwxr-xr-x.   5 root root 340 Jan 30 11:26 dev
...
```

##### 测试ENTRYPOINT

```shell
[vagrant@localhost dockerfile]$ cat  docker-cmd-entrypoint
FROM centos
ENTRYPOINT ["echo","Hello"]
ENTRYPOINT ["ls","-a"]

# 发现ENTRYPOINT也是只执行最后一个
[vagrant@localhost dockerfile]$ docker run entrypoint
.
..
.dockerenv
bin
dev
etc
home
lib

# 但是ENTRYPOINT可以追加参数
[vagrant@localhost dockerfile]$ docker run entrypoint -l
total 0
drwxr-xr-x.   1 root root   6 Jan 30 11:31 .
drwxr-xr-x.   1 root root   6 Jan 30 11:31 ..
-rwxr-xr-x.   1 root root   0 Jan 30 11:31 .dockerenv
lrwxrwxrwx.   1 root root   7 Nov  3 15:22 bin -> usr/bin
drwxr-xr-x.   5 root root 340 Jan 30 11:31 dev
drwxr-xr-x.   1 root root  66 Jan 30 11:31 etc
```



#### COPY和ADD的区别

add会自动解压

##### COPY测试

```shell
[vagrant@localhost dockerfile]$ tree .
.
|-- copy01
|-- copy02
|-- test-dir/
    |-- sub-dir/
    |   |-- test3
    |-- test1
    |-- test2
[vagrant@localhost dockerfile]$ cat docker-copy
FROM centos
COPY copy01 .
COPY copy02 /home
COPY test-dir .  # 不会拷贝目录，只拷贝目录下的文件和目录

# 如果不指定WORKDIR，默认是在跟目录下面
[root@e4a55c64ff8f /]# ls
bin  copy01  dev  etc  home  lib  lib64  lost+found  media  mnt  opt  proc  root  run  sbin  srv  sys  tmp  usr  var

# COPY可以指定目的路径
[root@e4a55c64ff8f home]# ls
copy02

# 不会拷贝目录，只拷贝目录下的文件和目录
[root@e8be2eb3f129 /]# ls
bin  copy01  dev  etc  home  lib  lib64  lost+found  media  mnt  opt  proc  root  run  sbin  srv  sub-dir  sys  test1  test2  tmp  usr  var
[root@e8be2eb3f129 /]# cd sub-dir/
[root@e8be2eb3f129 sub-dir]# ls
test3
```

此外，COPY还可以用来实现[multi-stage(多阶段构建)](https://www.cnblogs.com/sparkdev/p/8508435.html)，就是一个dockerfile里有多个FROM，每个 FROM 指令代表一个 stage 的开始部分。我们可以把一个 stage 的产物拷贝到另一个 stage 中。

##### ADD测试

除了不能用在 multistage 的场景下，ADD 命令可以完成 COPY 命令的所有功能，并且还可以完成两类超酷的功能：

- 解压压缩文件并把它们添加到镜像中
- 从 url 拷贝文件到镜像中

```shell
WORKDIR /app
ADD nickdir.tar.gz .  
# 可以把压缩包自动解压到/app目录下
ADD http://example.com/big.tar.xz /usr/src/things/ 
# 会直接把tar包加入镜像中，不会自动解压，实则增加了镜像的大小，不建议这么做！
```

##### 总结

COPY 命令是为最基本的用法设计的，概念清晰，操作简单。而 ADD 命令基本上是 COPY 命令的超集(除了 multistage 场景)，可以实现一些方便、酷炫的拷贝操作。ADD 命令在增加了功能的同时也增加了使用它的复杂度，比如从 url 拷贝压缩文件时弊大于利。



