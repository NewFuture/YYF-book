#!/usr/bin/env bash
# ubuntu 一间安装和配置虚拟机环境
# install VirtualBox Vagrant and Git
sudo apt install -y virtualbox vagrant git
# clone  source code
git clone https://github.com/YunYinORG/YYF.git
# init
./YYF/init.cmd