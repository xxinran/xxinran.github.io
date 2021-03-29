---
title: QAT在Ubuntu18.04上的安装和虚拟化
date: 2021-01-27 20:31:29
tags: qat
categories: deploy
---

本文将介绍QAT c62xx设备在Ubuntu 18.04上的安装部署和虚拟化。

> 参考网站：https://01.org/intel-quickassist-technology

### Prerequisite

```shell
$ uname -a
Linux tme-prc002 5.3.0-53-generic #47~18.04.1-Ubuntu SMP Thu May 7 13:10:50 UTC 2020 x86_64 x86_64 x86_64 GNU/Linux
```

### Updating grub Configuration File

To enable IOMMU and SRIOV

```shell
sudo vim /etc/default/grub
```

Modify `GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"` to `"quiet splash intel_iommu=on"`

Update grub and reboot:

```shell
update-grub
sudo reboot
```

### Building and Installing Software

#### Create a working directory for the software. This directory can be user defined, but

```
$ cd $HOME 
$ mkdir /QAT
$ cd /QAT
```

#### Download the software.

```
curl -O https://01.org/sites/default/files/downloads/intelr-quickassist-technology/qat1.7.l.4.3.0-00033.tar.gz
```

#### Unpack the software.

```
$ tar -zxof <QAT tarball name>  
$ chmod -R o-rwx *
```

#### Install dependencies if needed.

For CentOS:

```
$ yum -y groupinstall "Development Tools"
$ yum -y install pciutils
$ yum -y install libudev-devel
$ yum -y install kernel-devel-$(uname -r)
$ yum -y install gcc
$ yum -y install openssl-devel
```

For Ubuntu:

```
$ apt-get update
$ apt-get install pciutils-dev
$ apt-get install g++
$ apt-get install pkg-config
$ apt-get install libssl-dev
```

#### configure, make and make install the software packages.

```
# suggest to clear up the env if there is a previous or modified version installed
$ make uninstall
$ ./configure --enable-icp-sriov=host  # It fails if missing dependency package.
$ make
$ make install  
$ service qat_service start  
$ service qat_service_vfs start
```

NOTE: in Guest OS, enable the SR-IOV build on the host by using:

```
$ ./configure --enable-icp-sriov=guest
```

#### Verifying SR-IOV On The Host

```
$ lspci | grep 37c9  
# or 
$ lspci -d 8086:37c9
$ lspci -d:37c9
...
01:01.0 Co-processor: Intel Corporation Device 37c9
01:01.1 Co-processor: Intel Corporation Device 37c9
01:01.2 Co-processor: Intel Corporation Device 37c9
...
01:01.7 Co-processor: Intel Corporation Device 37c9
01:02.0 Co-processor: Intel Corporation Device 37c9
01:02.1 Co-processor: Intel Corporation Device 37c9
...
01:02.6 Co-processor: Intel Corporation Device 37c9
01:02.7 Co-processor: Intel Corporation Device 37c9
```

Or using `adf_ctl`

```
$ adf_ctl status
```

This utility can bring up/down device by ourselves.

#### Detailed SR-IOV enabling please refer to the guide.

Please refer to:
https://01.org/sites/default/files/downloads/330689qatvirtualizationappnoterev008us.pdf
