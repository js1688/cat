# cat
注意,这个东西弄了很久了,使用的东西都比较老,里面也有不少小bug,如果你需要看最新的,转到:https://github.com/js1688/webrtc-chat

怎么使用

已经收到过很多在校大学生询问怎么使用,鉴于他们对很多东西不了解,所以我在这里面说一下怎么弄

 1.这是个maven项目,你必须先安装maven然后配置maven的环境变量
 
 2.下载源码压缩包 cat-master.zip  解压后进入 找到web.xml文件打开,注释或删除掉web-app这个标签内的内容,这个内容主要是使用tomcat部署https协议的时候进行的http自动跳转到https,如果你是本地使用就要注释掉,如果是服务器,就别注释了
 
 3.Windows,或者mac随便你什么系统使用命令,注意Windows的cmd,mac的终端,进入cat-master这个文件夹,在有pom.xml这个文件的目录位置,然后输入命令 mvn package
 
 4.命令是进行编译打包源码,之后再cat-master文件夹下就能看见一个target文件夹,进入target文件夹后,能看到cat.war这个包
 
 5.在网上下载tomcat8,然后将cat.war 的移动到tomcat8中的webapps目录
 
 6.进入tomcat8的bin目录启动tomcat
 
 7.在浏览器输入地址 http://127.0.0.1:8080/cat/index.jsp    就能进入页面进行体验了
 
 8.注意要求,webrtc据我前几年查到的资料,使用谷歌浏览器进行体验,其它的浏览器我不确定是否都兼容了,只能是127.0.0.1地址可以使用http,其它地址都是只能用https协议,https协议怎么弄,这里涉及到申请域名,和申请证书,不在这里面说了
 
 9.只能在同一个局域网进行webrtc连接,因为涉及到p2p穿透问题,这个后面有时间再看，如果解决了会发布一个完整的。


