---
title: PCIe和SRIOV介绍
description: ' '
abbrlink: 939f8fe8
date: 2021-05-12 17:09:19
tags:
categories:
---

# PCI和PCIe

configuration space register

linux support

## PCI

并行的结构，在一个时钟周期内传输32bits/64bits。

提高时钟频率，或者提高pci总线的位宽。

Host bridge隔离内存物理空间和PCI总线空间，负责进行地址转换。

## PCIe

串行，一个时钟周期只能发送一个bit。所以时钟频率就快的多。

点对点：

8 - 5 - 3

256个bus，32个device， 8个function。

PCI枚举，设备树。



## configuration space register

每个PCI/PCIe设备里都有这张表。

PCI: 256bytes 

PCIe: 4k bytes

前256可以通过IO port来访问，后面的只能MMIO。

MMIO最大要占用的空间： 256 * 32 * 8 * 4K = 256M

BAR： base address register

MSI，MSI-x（message signal interrupt）





