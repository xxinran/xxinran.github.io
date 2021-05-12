---
title: rdma介绍
description: ' '
abbrlink: '9e990020'
date: 2021-05-11 16:29:17
tags:
categories:
---

# Overview

## DMA

![image-20210511163124035](rdma/image-20210511163124035.png)

在同一台Host上，不通过CPU的move来做数据搬移。 

Free up CPU

## RDMA

Remote DMA, cross host. 

secure direct memory to memory data communication without CPU 



![image-20210511163734543](rdma/image-20210511163734543.png)



iMC: intergrated memory controller.

blue dot line: control path, need cpu to setup

red line: data path, without cpu

<img src="rdma/image-20210511164132817.png" alt="image-20210511164132817" style="zoom:80%;" />

map NIC hw resource into user space

verbs API

message level  



# Protocol Introduction

![image-20210511165341492](rdma/image-20210511165341492.png)

 



# Details（ROCEv2）