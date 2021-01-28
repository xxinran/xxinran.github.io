---
title: 在mac上用vagrant和virtualbox创建虚拟机
date: 2021-01-28 22:23:48
tags: vagrant, virtualbox
Categories: deploy,vm
---

## vagrant介绍

基于ruby，用于创建和部署虚拟化开发环境。它 使用Oracle的开源[VirtualBox](https://baike.baidu.com/item/VirtualBox)虚拟化系统，使用 Chef创建自动化虚拟环境。我们可以使用它来干如下这些事：

- 建立和删除虚拟机

- 配置虚拟机运行参数

- 管理虚拟机运行状态

- 自动配置和安装开发环境ß

- 打包和分发虚拟机运行环境

　　Vagrant的运行，需要**依赖**某项具体的**虚拟化技术**，最常见的有VirtualBox以及VMWare两款，早期，Vagrant只支持VirtualBox，后来才加入了VMWare的支持。现在vagrant支持更多的虚拟化系统，包括kvm，qemu，vmware，甚至docker。但还是以virtualbox为主。

<img src="vagrant-intro/image-20210128223212650.png" alt="image-20210128223212650" style="zoom:50%;" />

### vagrant和virtualbox

virtualbox本身也可以创建vm，只是相对麻烦，vagrant可以调用virtualbox的接口更加方便的创建vm。