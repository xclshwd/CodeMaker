1、加载状态./CenterServer -c /usr/local/etc/init.ini&
        [PROCESS01]
        name=/usr/local/bin/StreamGui
        param=
        delay=100
        [PROCESS02]
        name=/usr/local/bin/DeviceManage
        param=
        delay=400
        [PROCESS03]
        name=/usr/local/bin/avStreaming
        param=
        delay=1300
        ……

2、中心服务器流程
        static unsigned short serverport = 17777;
        static char serverconfig[128] = {"../config/init.ini"}, serverdomain[100] = {"/tmp/unix.domain"};
        -->加载LoadOption(argc, argv)
            ## 命令行解析函数 int getopt(int argc,char * const argv[ ],const char * optstring)-->#include<unistd.h>
               单个字符后接一个冒号：表示该选项后必须跟一个参数
               单个字符后跟两个冒号，表示该选项后可以跟一个参数，也可以不跟

        -->centerserver
            ## 打开socket CSocketUtils::OpenTcpSocket()、CSocketUtils::OpenUnixSocket()
            ## 创建会话管理类 sessionManager = CSessionManager::GetInstance()
            ## 打开监听CSocketUtils::ListenTcpSocket(tcpsocketHandle, serverport)
                        

