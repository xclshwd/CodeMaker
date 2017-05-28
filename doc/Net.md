1、代码结构
        -->openservice
            1、ftpclient
            2、ftpserver
            3、iptctool
            4、networkservice
            5、networktool
            6、ntpclient
        -->wireless
            1、3g
                --daemon守护进程，后天程序
                --dialup
                --dialup_new
                --dialup_v3.0
                --stmcommon
            2、wifi
            3、驱动

2、main主流程
    -->CServiceManager *serviceImpl = new CServiceManager()
    -->serviceImpl->StartComplete()//注册看门狗，广播模块启动完成，启动ftpserver线程
    -->serviceImpl->GetServiceParameter()//获取参数
    -->serviceImpl->TaskSchedule()
                    ##喂狗
                    ##m_Discovery->TaskSchedule()（快捷设置、手动搜索ipc、ui一键同步远程列表、poe，手动修改ipc地址，重连）

3、CServiceManager构造函数
    --> m_Discovery = new CDiscovery(m_handleMessageClient, m_szMainIfname, m_DeviceType, m_eProductType, m_nPoeNum);
    --> m_N9DiscoveryThread = new CN9DiscoveryThread();有线搜索
    --> m_netDeviceThread = new CNetDeviceThread(szDeviceName, m_szMainIfname, szLanIfname, m_nPoeNum);
    --> m_WifiManage = Networkservice::CWifiManage::GetWifiInstance();//new CWifiManage();单例模式
    --> CDialupManage* pDialupManage = CDialupManage::GetDialupInstance();单例模式
    --> m_NTPClientThread = new CNTPClientThread();
    --> m_FtpManage = new CFtpManage(m_szMainIfname);
    --> RegisterConcernMessage();

4、CDiscovery构造函数
    --> m_pN9Discovery = new CN9DiscoveryThread(handleMessageClient, szInterface, nDeviceType, ProductType, nPoeNum);

5、CDialupManage构造函数
    -->











