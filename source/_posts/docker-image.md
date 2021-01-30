---
title: 如何构建docker image
date: 2021-01-28 22:31:29
tags: docker
categories: docker
typora-root-url: ../_posts
---

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

