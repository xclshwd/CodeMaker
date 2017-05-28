1、Linux下的IPC－UNIX Domain Socket
    -->概述
        UNIX Domain Socket是在socket架构上发展起来的用于同一台主机的进程间通讯（IPC），它不需要经过网络协议栈，不需要打包拆包、计算校验和、维护序号和应答等，只是将应用层数据从一个进程拷贝到另一个进程。UNIX Domain Socket有SOCK_DGRAM或SOCK_STREAM两种工作模式，类似于UDP和TCP，但是面向消息的UNIX Domain Socket也是可靠的，消息既不会丢失也不会顺序错乱。
        UNIX Domain Socket可用于两个没有亲缘关系的进程，是全双工的，是目前使用最广泛的IPC机制，比如X Window服务器和GUI程序之间就是通过UNIX Domain Socket通讯的。
    -->工作流程
        UNIX Domain socket与网络socket类似，可以与网络socket对比应用。
        上述二者编程的不同如下：
            address family为AF_UNIX
            因为应用于IPC，所以UNIXDomain socket不需要IP和端口，取而代之的是文件路径来表示“网络地址”。
            这点体现在下面两个方面。
                ## 地址格式不同，UNIXDomainsocket用结构体sockaddr_un表示，是一个socket类型的文件在文件系统中的路径，这个socket文件由bind()调用创建，如果调用bind()时该文件已存在，则bind()错误返回。
                ## UNIX Domain Socket客户端一般要显式调用bind函数，而不象网络socket一样依赖系统自动分配的地址。客户端bind的socket文件名可以包含客户端的pid，这样服务器就可以区分不同的客户端。
        UNIX Domain socket的工作流程简述如下（与网络socket相同）。
            服务器端：创建socket—绑定文件（端口）—监听—接受客户端连接—接收/发送数据—…—关闭
            客户端：创建socket—绑定文件（端口）—连接—发送/接收数据—…—关闭

2、struct msghdr的使用
        --> #include<sys/socket.h>
            struct msghdr  { 
                void  * msg_name ;   / *  消息的协议地址  在tcp中，可以设置为NULL* / 
                socklen_t msg_namelen ;   / *  地址的长度  * / 
                struct iovec  * msg_iov ;   / *  多io缓冲区的地址  * / 
                int  msg_iovlen ;   / *  缓冲区的个数  * / 
                void  * msg_control ;   / *  辅助数据的地址  * / 
                socklen_t msg_controllen ;   / *  辅助数据的长度  * / 
                int  msg_flags ;   / *  接收消息的标识  * / 
            } ; 
        -->接口
            ssize_t recvmsg ( int  sockfd ,  struct msghdr  * msg ,   int  flags ) ; 
            ssize_t sendmsg ( int  sockfd ,  struct msghdr  * msg ,   int  flags ) ;
            成功时候返回读写字节数，出错时候返回-1.
            这2个函数只用于套接口，不能用于普通的I/O读写，参数sockfd则是指明要读写的套接口。
            flags用于传入控制信息，一般包括以下几个
                MSG_DONTROUTE             send可用
                MSG_DONWAIT                 send与recv都可用
                MSG_PEEK                        recv可用
                MSG_WAITALL                   recv可用
                MSG_OOB                         send可用
                MSG_EOR                          send recv可用
             
            返回信息都记录在struct msghdr * msg中

            多缓冲区的发送和接收处理就是一个struct iovec的数组，每个成员的io_base都指向了不同的buffer的地址。io_len是指该buffer中的数据长度。而在struct msghdr中的msg_iovlen是指buffer缓冲区的个数，即iovec数组的长度。

3、cat /proc/slabinfo 该内核版本最大支持8192k
            name   <active_objs> <num_objs> <objsize> <objperslab> <pagesperslab> : tunables <limit> <batchcount> <sharedfactor> : slabdata <active_slabs> <num_slabs> <sharedavail>
            kmalloc-8192          20     20   8192    4    8 : tunables    0    0    0 : slabdata      5      5      0
            kmalloc-4096        1318   1320   4096    8    8 : tunables    0    0    0 : slabdata    165    165      0
            kmalloc-2048          80     80   2048    8    4 : tunables    0    0    0 : slabdata     10     10      0
            kmalloc-1024         175    176   1024    8    2 : tunables    0    0    0 : slabdata     22     22      0
            kmalloc-512          361    384    512    8    1 : tunables    0    0    0 : slabdata     48     48      0
            kmalloc-256           95     96    256   16    1 : tunables    0    0    0 : slabdata      6      6      0
            kmalloc-128         1579   1632    128   32    1 : tunables    0    0    0 : slabdata     51     51      0
            kmalloc-64          1842   2048     64   64    1 : tunables    0    0    0 : slabdata     32     32      0
            kmalloc-32          5571   5632     32  128    1 : tunables    0    0    0 : slabdata     44     44      0
            kmalloc-192          663    672    192   21    1 : tunables    0    0    0 : slabdata     32     32      0
            kmalloc-96          1006   1008     96   42    1 : tunables    0    0    0 : slabdata     24     24      0
            kmem_cache            32     32    128   32    1 : tunables    0    0    0 : slabdata      1      1      0
            kmem_cache_node      128    128     32  128    1 : tunables    0    0    0 : slabdata      1      1      0
            slab 缓存分配器通过对类似大小的对象进行缓存而提供这种功能，从而避免了常见的碎片问题。
            slab 分配器还支持通用对象的初始化，从而避免了为同一目而对一个对象重复进行初始化。
            slab 分配器还可以支持硬件缓存对齐和着色，不同缓存中的对象占用相同的缓存行，从而提高缓存的利用率并获得更好的性能。

4、查看内核版本
    cat /proc/version
        Linux version 3.0.8 (hjli@gitlab.domain) (gcc version 4.4.1 (Hisilicon_v100(gcc4.4-290+uclibc_0.9.32.1 +eabi+linuxpthread)) ) #33 Mon Dec 12 16:22:59 CST 2016
    uname -a 
        Linux (streamax) 3.0.8 #33 Mon Dec 12 16:22:59 CST 2016 armv7l GNU/Linux

5、线程异常终止处理函数
        -->最经常出现的情形是资源独占锁的使用：线程为了访问临界资源而为其加上锁，但在访问过程中被外界取消，如果线程处于响应取消状态，且采用异步方式响应，或者在打开独占锁以前的运行路径上存在取消点，则该临界资源将永远处于锁定状态得不到释放。外界取消操作是不可预见的，因此的确需要一个机制来简化用于资源释放的编程 
        
        -->在POSIX线程API中提供了一个pthread_cleanup_push()/pthread_cleanup_pop()函数对用于自动释放资源 从pthread_cleanup_push()的调用点到pthread_cleanup_pop()之间的程序段中的终止动作（包括调用 pthread_exit()和取消点终止）都将执行pthread_cleanup_push()所指定的清理函数。在线程宿主函数中主动 调用return， 如果return语句包含 在pthread_cleanup_push()/pthread_cleanup_pop()对中，则不会引起清理函数的执行，反而会导致segment fault。
        
        -->应用
            pthread_cleanup_push(cleanup_handler, NULL);
            ……程序
            pthread_cleanup_pop(1);

6、/bin/bash^M: 坏的解释器: 没有那个文件或目录 ---多个字符‘\r’
   正则表达式 sed -i 's/\r$//' filename   /* －i插入, s替代模式, \r$表示任何以\r结束的字符,*/

7、sudo apt-get update 无法下载错误解决方法----进入终端 sudo rm /var/lib/apt/lists/* -vf

    W: 无法下载http://ppa.launchpad.net/deluge-team/ppa/ubuntu/dists/natty/main/source/Sources 404  Not Found
    W: 无法下载http://ppa.launchpad.net/deluge-team/ppa/ubuntu/dists/natty/main/binary-amd64/Packages 404  Not Found
    E: Some index files failed todownload. They have been ignored, or old ones usedinstead.
 
8、若出现.ibtoolize: AC_CONFIG_MACRO_DIR([m4]) conflicts with ACLOCAL_AMFLAGS=-I错误，
        是因为configure.ac和Makefile.am文件是dos格式导致的，通过dos2unix转换一下。
        在windows上使用git时，建议不转换文件格式
        git config –global core.autocrlf false
        git config –global core.safecrlf true
        git config –global core.eol lf 或者手工直接编辑.gitconfig文件，该文件位于用户主目录下。
9、TDE 海思2D加速引擎
    TDE（Two Dimensional Engine）利用硬件为 OSD（On Screen Display）和 GUI
    （Graphics User Interface）提供快速的图形绘制功能，主要有快速位图搬移、快速色彩
    填充、快速抗闪搬移、快速位图缩放、画点、画水平/垂直线、位图格式转换、位图
    alpha 叠加、位图按位布尔运算、ColorKey操作。











