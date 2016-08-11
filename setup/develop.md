开发环境配置
==================


开发环境应该尽可能高效和方便，你有两种方式可供选择
* [虚拟机环境](#vm)
* [本机开发环境](#local)


虚拟机环境(推荐) {#vm}
==========
YYF定制了一个集成了YYF所需环境的虚拟机镜像(大约350M),并提供几乎一键安装和自动配置的脚本(`init.cmd`).
可以让不同人在不同系统具有**完全一致的开发环境**，尤其适合团队使用和新手开发。

( 注：虚拟理解只提供服务器运行环境，**代码存和修改仍然在本机**，会自动映射到虚拟机中。)

使用YYF虚拟机镜像你可能需要:

1. 安装 [VirtualBox](https://www.virtualbox.org/wiki/Downloads)(安装即可，不需额外操作); 
2. 下载安装[vagrant](https://www.vagrantup.com/downloads.html);
3. 双击或者运行(`init.cmd`)自动配置


不同系统请参考：
* [Windows下虚拟机环境安装](vm-in-windows.md)
* [Linux下虚拟机环境安装]
* [Mac下虚拟机环境安装]


本机开发环境 {#local}
============
如果你希望在本机上进行开发,你需要安装PHP并配置好必要的扩展即可。(不同人配置相同的环境总能有意想不到的问题)

1. 下载或者编译PHP
2. 下载或者编译YAF扩展
3. 双击或者运行(`init.cmd`)配置

具体可以参考一下内容
* [Windows下配置YYF开发环境](yyf-in-windows.md)
* [Linux下配置YYF开发环境](yyf-in-linux.md)
* [Mac下配置YYF环境]


配置完成
=========
配置完成打开你的测试页面和 [yyf.yunyin.org](https://yyf.yunyin.org/)一样说明基本配置成功

如果遇到问题，可以google，百度，或者在github上留言，如果文档有疏漏之处，[欢迎修改](https://github.com/NewFuture/yyf-book)。
