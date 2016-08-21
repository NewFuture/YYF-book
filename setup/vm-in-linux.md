Linux 安装 YYF 虚拟机
=========================

1. 安装virtualbox 和 vagrant
3. 下载源码 init



## 1. 安装virtualbox和vagrant

### Ubuntu
```bash
sudo apt install -y virtualbox vagrant git
```

### Centos
``` bash
# virtualbox
sudo curl http://download.virtualbox.org/virtualbox/rpm/rhel/virtualbox.repo -o /etc/yum.repos.d/virtualbox.repo
sudo yum -y update
sudo yum -y install VirtualBox-5.1 git
# vagrant
curl https://releases.hashicorp.com/vagrant/1.8.5/vagrant_1.8.5_x86_64.rpm -o vagrant.rpm
sudo yum -y localinstall vagrant.rpm

```

##  2. clone 初始化yyf
clone源码

```bash
git clone https://github.com/YunYinORG/YYF.git
```

初始化环境
```bash
./YYF/init.cmd
```

正常情况一路回车即可(首次会自动下载一个350M的镜像)

