Linux 安装 YYF 虚拟机
=========================

1. 安装virtualbox
2. 安装vagrant
3. 下载源码 init



## 安装virtualbox和vagrant

### Ubuntu
```bash
sudo apt install -y virtualbox vagrant git
```

##  clone 初始化yyf
clone源码

```bash
git clone https://github.com/YunYinORG/YYF.git
```

初始化环境
```bash
cd YYF 
./init.cmd
```

正常情况一路回车即可(首次会自动下载一个350M的镜像)

