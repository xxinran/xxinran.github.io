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





iscsi/scsi over rdma

RDMA provides Channel based IO.  This channel allows an application using an RDMA device
to directly read and write remote virtual memory.  





The registration process pins the memory pages (to prevent the pages from being swapped out
and to keep physical <-> virtual mapping).  



The registration process writes the virtual to physical address table to the network adapter.
When registering memory, permissions are set for the region. Permissions are local write, remote
read, remote write, atomic, and bind  

Every MR has a remote and a local key (r_key, l_key). Local keys are used by the local HCA to
access local memory, such as during a receive operation. Remote keys are given to the remote
HCA to allow a remote process access to system memory during RDMA operations.  





Scatter Gather  - > what's the size??

If we have completion with bad status in a WR, the rest of the completions will be all be bad (and
the Work Queue will be moved to error state)   - > why ??