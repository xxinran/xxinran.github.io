---
title: 在centos上修改源并安装docker
date: 2021-01-30 18:05:57
tags:
- deploy
- docker
categories: deploy
---

### 环境

在mac上用vagrant起了一个centos8的vm。



### 换系统yum源

> 这里换的是清华的源。
>
>  参考：https://mirrors.tuna.tsinghua.edu.cn/help/centos/

建议先备份 `/etc/yum.repos.d/` 内的文件（CentOS 7 及之前为 `CentOS-Base.repo`，CentOS 8 为`CentOS-Linux-*.repo`）

然后编辑 `/etc/yum.repos.d/` 中的相应文件，在 `mirrorlist=` 开头行前面加 `#` 注释掉；并将 `baseurl=` 开头行取消注释（如果被注释的话），把该行内的域名（例如`mirror.centos.org`）替换为 `mirrors.tuna.tsinghua.edu.cn`。

以上步骤可以被下方的命令一步完成

```
sudo sed -e 's|^mirrorlist=|#mirrorlist=|g' \
         -e 's|^#baseurl=http://mirror.centos.org|baseurl=https://mirrors.tuna.tsinghua.edu.cn|g' \
         -i.bak \
         /etc/yum.repos.d/CentOS-*.repo
```

注意其中的`*`通配符，如果只需要替换一些文件中的源，请自行增删。

注意，如果需要启用其中一些 repo，需要将其中的 `enabled=0` 改为 `enabled=1`。

最后，更新软件包缓存

```
sudo yum makecache
```

这时下载常用的软件包就已经变快了。



### 换下载docker的源

> 参考：https://mirrors.tuna.tsinghua.edu.cn/help/docker-ce/

然后我根据docker的官方文档安装docker，发现yum install docker-ce的时候特别慢。原因是官方文档配置的docker源repo是国外的，国外访问很慢。于是去网上找了清华的源。

如果你之前安装过 docker，请先删掉

```
sudo yum remove docker docker-common docker-selinux docker-engine
```

安装一些依赖

```
sudo yum install -y yum-utils device-mapper-persistent-data lvm2
```

根据你的发行版下载repo文件: CentOS/RHEL Fedora

```
wget -O /etc/yum.repos.d/docker-ce.repo https://download.docker.com/linux/centos/docker-ce.repo
```

把软件仓库地址替换为 TUNA，这一步很关键，大部分网上的博客都没有提到，如果没有这一步，其实还是使用的国外的docker官方的源:

```
sudo sed -i 's+download.docker.com+mirrors.tuna.tsinghua.edu.cn/docker-ce+' /etc/yum.repos.d/docker-ce.repo
```

最后安装:

```
sudo yum makecache
sudo yum install docker-ce
```

### 换docker镜像源

docker默认源在国外，同样很慢。我们可以通过修改docker配置更改docker image的源。

```shell
# 查看docker daemon config
$ ls /etc/docker/daemon.json
# 如果文件不存在就创建一个
$ sudo touch /etc/docker/daemon.json
$ vi /etc/docker/daemon.json
{
    "registry-mirrors" : [
    "https://registry.docker-cn.com",
    "https://docker.mirrors.ustc.edu.cn",
    "http://hub-mirror.c.163.com",
    "https://cr.console.aliyun.com/"
  ]
}
$ sudo systemctl restart docker.service
```



### docker permission denied

这个问题特别常见，就是我们在安装完docker之后，发现docker指令必须在root权限下运行，这时因为我们当前的用户没有被加入到docker组里。

#### 解决办法

2.1、添加docker用户组

```shell
groupadd docker 
# 一般都会提示docker用户组存在了。
```

2.2、把当前用户加入docker用户组

```shell
gpasswd -a ${USER} docker
# 或者 sudo usermod -aG docker ${USER} (未验证)
```

3、查看是否添加成功：

```shell
cat /etc/group | grep ^docker
```

4、重启docker

```shell
serivce docker restart
```

5、更新用户组
```shell
newgrp docker 
```

6、测试docker命令是否可以使用sudo正常使用
```shell 
docker ps
```
