---
title: GPU虚拟化
abbrlink: 204fd6f0
date: 2021-04-26 10:25:33
tags:
categories:
---

<!-- more -->

目前流行的几种模式：pass through, sriov, 半虚拟化（mdev passthrough： Intel gvt-g, Nvidia GRID vGPU), 全虚拟化（VMware： vSGA）

学习路径

pci -》 pci dma -》 iommu -》 passthrough

内存页表 - 》 tlb

cache -》 内存

# PCI

Linux PCI设备驱动实际包括**Linux PCI设备驱动**和**设备本身驱动**两部分。

PCI(Periheral Component Interconnect)有三种地址空间：**PCI I/O空间、PCI内存地址空间和PCI配置空间**。

PCI I/O空间和PCI内存地址空间由设备驱动程序使用

而PCI配置空间由Linux PCI初始化代码使用，用于配置PCI设备，比如中断号以及I/O或内存基地址。



内核：遍历和配置

遍历顺序：从host-pci开始，遇到pci bridge就到下一级pci总线继续遍历，直到遍历完成。（深度优先？）

配置：PCI设备中一般都带有一些RAM和ROM 空间，通常的控制/状态寄存器和数据寄存器也往往以RAM区间的形式出现，而这些区间的地址在设备内部一般都是从0开始编址的，那么当总线上挂接了多个设备时，对这些空间的访问就会产生冲突。所以，这些地址都要先映射到系统总线上，再进一步映射到内核的虚拟地址空间。配置就是通过对PCI配置空间的寄存器进行操作从而完成地址的映射。 device physical address -> system virtual address??



# DMA

https://cloud.tencent.com/developer/article/1194593

## Passthrough

**直通模式**的实现依赖于IOMMU的功能。VTD对IOVA的地址转换使得直通设备可以在硬件层次直接使用GPA（Guest Physical Address）地址。GPU直通技术相对于任何其他设备来说，会有额外的PCI 配置空间模拟和MMIO的拦截（参见QEMU VFIO quirk机制）。比如Hypervisor或者Device Module 不会允许虚拟机对GPU硬件关键寄存器的完全的访问权限，一些高权限的操作会被直接拦截。大家或许已经意识到原来直通设备也是有MMIO模拟和拦截的。这对于我们理解GPU 半虚拟化很有帮助。

### libvirt layer

将PCI设备直接分配给guest os时，如果不先从guest中hot-unplug该设备，将无法进行migration。

managed: guest启动时会自动从host上detach， guest shutdown时又重新attach回host。（implict）

unmanged：需要手动从host detach，之后手动re-attach回host。不然libvirt会refuse。（explict）