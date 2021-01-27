---
title: hexo+github
date: 2021-01-27 19:15:38
tags:
---

### 安装nodejs，git

```
sudo apt install npm
sudo apt install nodejs
sudo apt install git
```

### 注册github帐号，创建github repo，命名为`xxinran.github.io`

### 安装Hexo

```
sudo npm install -g hexo-cli
```

检查各项都已经成功安装：

```
node -v
hexo -v
```

### 创建本地博客的repo

```
hexo init blog
```

运行后在当前目录下会生成一个blog目录。未来所有的博客主题，博文，配置都在这个目录里。

```
cd blog
```

会发现目录结构如下：

```
├── _config.yml  # hexo的配置文件，主题，标题，格式等都在这里指定
├── db.json
├── node_modules/
├── package.json
├── package-lock.json
├── public/
├── scaffolds/
├── source/ # 博客的静态页面的源文件，博文的md文件就存放在这里
└── themes/ # 存放各种主题的源码
```

接下来在`blog`目录下运行`npm install` 来安装hexo所需的依赖。

在`blog/source/_posts/hello-world.md`里有一个例子，我们先用这个例子，看看效果，运行：

```
hexo server 
or
hexo s
```

可以看到Hexo运行在本地的4000端口，在浏览器中访问`localhost:4000`，就会看到上述hello-world的示例页面。

我们也可以通过 `hexo new first-try`去创建一个新的md文件，可以在这个md文件里写博文，这时在4000端口我们就可以看到新的博文。（应该是需要重新运行`hexo s`，这里没有验证）

### 连接gihub和hexo

#### 上传SSH公钥

```
ssh-keygen
# copy ssh public to Github Account
```

输入`ssh -T git@github.com`，测试添加ssh是否成功。如果看到Hi后面是你的用户名，就说明成功了.

#### 在Hexo的配置文件中指定向Github Page部署

```
vim ～/blog/_config.yml
```

在deploy选项中填写Github信息， 例如：

```
deploy:
type: git
repository: git@github.com:xxinran/xxinran.github.io.git
branch: master
```

#### 生成静态文件，并部署到gihub上去。

```
# generate static files
hexo generate
or 
hexo g

# deploy to Github
hexo deploy
or
hexo d
```

这一步有可能会报错`Deployer not found: git`：

- 需要安装`npm install hexo-deployer-git --save`。
- 需要配置gitconfig。

#### 打开[Github Page](https://xxinran.github.io/)验证。

### Notes

- 每次修改完blog的配置，或者新建删除post，draft等，都需要先`hexo clean`，在重新`hexo g & hexo d`。





>  参考文档： https://hexo.io/zh-cn/docs/configuration.html
>  https://zhuanlan.zhihu.com/p/71164003

# 主题配置

- 在blog目录下拉取想要应用的主题

```shell
git clone https://github.com/iissnan/hexo-theme-next themes/next
```

- 打开站点配置文件 _config.yml，找到 theme 字段，并将其值更改为 next。

  ```shell
  theme: next
  ```

- 切换Schema

  ```shell
  scheme: Pisces
  ```

- 更新github上的主题

  改完配置之后都要运行hexo clean & hexo generate & hexo deploy，为了方便，可以在blog目录下加入一个新的脚本deploy.sh：

  > 这里涉及到 “push hexo code”, 在多设备管理中会讲到 ）

  ```shell
  #!/bin/bash
  DIR=`dirname $0`
  
  # Generate blog
  echo "Generate and deploy..."
  hexo clean
  hexo generate & hexo deploy
  # hexo d -g
  
  sleep 10
  
  # Push hexo code
  echo "Push hexo code"
  git add .
  current_date=`date "+%Y-%m-%d %H:%M:%S"`
  git commit -m "Blog updated: $current_date"
  
  sleep 2
  git push origin hexo
  
  echo "=====>Finish!<====="
  ```

- 更新脚本权限：

  ```shell
  chmod 755 deploy.sh
  ```

  以后每次推送只要运行./deploy.sh即可。
