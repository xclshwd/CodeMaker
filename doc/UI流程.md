1、UI目录结构
    -->BaseVersion各个模块xml和style
            ##LogSearchGui      -->theme/xml 日志查询
            ##LongTransportGui  -->theme/xml 智能交通
            ##OperationMenu     -->theme/xml 业务菜单
            ##ParameterSetGui   -->theme/xml 设置
            ##PreviewGui        -->theme/xml
            ##RecordSearchGui   -->theme/xml 录像查询
            ##SMSGui            -->theme/xml
            ##StateSearchGui    -->theme/xml 状态查询
            ##TelephoneCalls    -->theme/xml 通讯
            ##BaseGuiConfig.xml 加载module各个库<path>ui/module/libLogSearch.so</path>
                                            主题<interfacefile>ui/BaseVersion/LogSearchGui/xml/LogSearch.xml</interfacefile>
                                            样式<themefile>ui/BaseVersion/LogSearchGui/theme/LogSearch_style.xml</themefile>
    -->BusinessModule
    -->icons 图标
    -->language 语言全球化
    -->module 模块库
            ##libGuiInterface.so
            ##libLogSearch.so
            ##libLongTransport.so 
            ##libOperationMenu.so 
            ##libParameterSet.so 
            ##libPreViewGui.so 
            ##libRecordSearch.so 
            ##libSMSGui.so 
            ##libStateSearch.so 
            ##libTelephoneCalls.so
    -->theme
            ##Style.xml 
    -->xml 控件主题样式
            ##Calendar_Style.xml 
            ##Calendar_Window.xml
            ##DataTable.xml 
            ##DefaultAndSave.xml 
            ##Dialog.xml 
            ##headline.xml 
            ##IpCalls.xml 
            ##Keyboard.xml
            ##Login.xml 
            ##MainMenu.xml 
            ##NoteInfo.xml 
            ##SmallKeyboard.xml 
            ##system_interface.xml 

2、UI源文件结构
    -->guiprocess
            ##BusOldGui
            ##DriverUseGui
            ##GuiInterface
            ##LogSearch
            ##LongTransport
            ##MainGui
            ##NoticeInfoGui
            ##OperationMenu
            ##ParameterSet
            ##PreViewGui
            ##RecordSearch
            ##StateSearch
            ##TelephoneCalls
            ##resources

            ##SMSGui
            ##SpotGui
            ##LCDDisplay
            ##LCDGui
    -->guitoolkit
            ##backend       设备接口层(设备输入和显示类管理)
            ##builder
            ##canvas        开源库canvas封装各个控件类
            ##eventloop     事件循环
            ##FontLibOpt    共享字体库加载
            ##general       gui宏定义和调试工具类
            ##PicParser     图标解析类
            ##qrencode      字符串生成二维码开源库
            ##widget        控件窗体
            ##wmanager      管理类
            ##CGuiTKCartoonManage.cpp
            ##CGuiTKParseCommon.cpp
            ##GuiTK.cpp

3、UI启动流程
    -->创建gui管理类 CGuiManager* pGuiManager            -->3.1
    -->创建消息管理类 CServiceManager *serviceManager    -->3.2
    -->注册看门狗 serviceManager->StartComplete()
    -->输入、输出设备初始化 GuiTKInitial(0, NULL)        -->3.3
    -->GUI业务管理器初始化 pGuiManager->InitGuiManager   -->3.1
    -->等待av模块加载完成 pGuiManager->WaitModuleFinish()
    -->菜单退出时间清零 pGuiManager->ResetAutoExitTime()
    -->主循环开始 GuiTKRun()
    -->反注册消息看门狗 serviceManager->StopComplete()
    -->清除内存 pGuiManager->DelInstance()

3.1 创建gui管理类CGuiManager
    -->构造函数
            ##成员变量初始化
            ##创建配置文件解析类m_pConfigParser(CConfigParser)
                LoadGuiConfigFromFile()主配置文件(ui/BaseVersion/BaseGuiConfig.xml/ui/BusinessModule/BusinessGuiConfig.xml)
                ParseSubGui("subgui"节点)
                   1、样式 
                            <subgui name="PreViewGui">
                                <id>0</id>
                                <firstwindow>PreViewWindow</firstwindow>
                                <path>ui/module/libPreViewGui.so</path>
                                <desc>0000000</desc>
                                <version>1.0.0</version>
                                <createtime>20141224</createtime>
                                <interfacefile>ui/BaseVersion/PreviewGui/xml/PreViewGui.xml</interfacefile>
                                <themefile>ui/BaseVersion/PreviewGui/theme/Preview_style.xml</themefile>
                                <preview>true</preview>
                                <show>false</show>
                            </subgui>

                    2、GuiItem* pGuiItem
                            struct GuiItem
                            {
                                int     nId;
                                int     nFatherId;
                                string strModuleName;
                                string strFirstWindow;
                                string strGuiPath;//库路径
                                string strDescription;//菜单名称
                                string strVersion;
                                string strCreateTime;
                                string strInterfaceFile;//xml接口文件
                                string strThemeFile;//主题样式文件
                                string strImageName;
                                bool   bPreview;
                                bool    bBaseVersion;
                                bool    bShow;//显示开关
                            };
                    3、m_GuiItemList[name] = pGuiItem

                    4、GuiInfo* pGuiInfo  = new GuiInfo -->AddGuiInfo()
                                                              -->m_GuiInfoList[name] = pGuiInfo (bBaseVersion ==true)
                                                              -->m_BusinessGuiInfoList[name] = pGuiInfo(bBaseVersion ==false)
                                                        -->LoadInterfaceThread (遍历m_GuiInfoList、m_BusinessGuiInfoList)




    -->初始化 InitGuiManager
            ##LoadGlobalParameter()
                    1、加载参数库
                    2、初始参数
            ##LoadTask()
                    1、动态加载m_GuiItemList库文件
                    2、放到列表m_GuiInfoList 、m_BusinessGuiInfoList，供LoadInterfaceThread遍历调用
            ##GetDefaultOutputMode(true)//获取输出模式和开机画面
            ##SetOsdSize(800, 480)//osd宽高
            ##InitFbSize()//初始化fb帧buffer宽高
            ##LoadInterface()
                    1、加载语音 LoadLanguage(languageID)
                    2、加载主题样式 CGuiTKWidgetEngine::GetInstance()->LoadThemeFile("ui/theme/Style.xml")
                    3、加载默认主题样式 LoadDefaultThemeStyle()
                    4、加载字体库 LoadFontLib()
                    5、加载语音图标 LoadPicPath(languageID)
                    6、初始化远程文件客户端接口
                    7、创建 CGuiTKXulParser* pBuilder = new CGuiTKXulParser()
                           --LoadGuiFunctionAndMessage(pBuilder)
                           --pBuilder->SetGuiLanguage(m_nLanguage)
                           --CreateNormalThread(LoadInterfaceThread, (void*)pBuilder, &Pid)
    -->LoadInterfaceThread
            ## CGuiTKWidgetEngine* pTheme = CGuiTKWidgetEngine::GetInstance()
            ## CGuiTKXulParser *pbuilder = (CGuiTKXulParser *)para
                    1、加载系统xml文件 pbuilder->LoadFromFile("ui/xml/system_interface.xml")
                    2、加载遍历 m_GuiInfoList
                            --pTheme->LoadThemeFile(pGui->m_pGuiItem->strThemeFile.c_str())
                            --pbuilder->LoadFromFile(pGui->m_pGuiItem->strInterfaceFile.c_str())
                    3、加载遍历 m_BusinessGuiInfoList
                            --pTheme->LoadThemeFile(pGui->m_pGuiItem->strThemeFile.c_str())
                            --pbuilder->LoadFromFile(pGui->m_pGuiItem->strInterfaceFile.c_str())
    -->LoadFromFile(const char *FileName, CGuiTKWidget *PreWidget, void *Para)
            ## 加载类型<interface> ... </interface>
                    1、LinkFile -->ParseLinkFile(xmlTmpNode, PreWidget, Para) -->LoadFromFile()
                    2、property -->多个name怎么解析？
                    3、<object class="Window" name="PreViewWindow"> ... </object>  -->ParseObject(xmlTmpNode, PreWidget)
                           -- value = xmlNode->Attribute("class")
                           -- Widget = CreateWidget(value) 
                                        1、控件：Window Button ScrollBar Editbox Selectbox SelectboxGroup NoteBar Container 
                                                 Form TimeTable DataTable LabelBar Static PopupMenu DropdownList CompartLine DragBar Calendar KeyBoard Dialog DataBar
                                        2、"name" Widget->setObjectName(value)
                                        3、遍历子元素
                                                --property
                                                --LinkFile-->ParseLinkFile-->LoadFromFile()
                                                --object -->ParseObject(xmlTmpNode, Widget)
                                                --signal -->ParseSignal(xmlTmpNode, Widget) -->connectSignals()
                                        4、AddSpecialSignal("ValueChange", "HANDLE_ADD_MODIFY_WIDGET", Widget);
                                                --WT_DROPDOWNLIST WT_EDITBOX WT_DRAGBAR WT_SELECTBOX WT_SELECTBOXGROUP
                                        5、Widget->ParseWidgetAttr(property, parent)
                                                --ParseWidgetBasicAttr(property)
                                                  [X Y W H ResolutionSize name visible Drag Tooltips LinkWinName FocusEnable]
                                                --ParseWidgetPersonalityAttr(property, parent)


3.2 创建消息管理类 CServiceManager
    -->构造函数
            ## 创建消息客户端_messageClient
            ## CGuiTKMainLoop::GetInstance()->addSourceIdle(bind(&CServiceManager::WaitForEvent, this, _1), NULL);
            ## RegisterConcernMessage()
            ## connectSignals
            ## signalsAction


3.3 设备初始化 GuiTKInitial(0, NULL)
    -->CGuiTKInput *input = CGuiTKInput::GetInstance()设别输入层
            ## add(bind(&CGuiTKInput::dispatch, this, _1), _inputHandle, (void *) _inputHandle);
            ## dispatch 

    -->CGuiTKMainLoop *loop = CGuiTKMainLoop::GetInstance()

3.4 主循环开始 GuiTKRun()
    -->CGuiTKMainLoop *loop = CGuiTKMainLoop::GetInstance()
            ##loop->run()

3.5 主循环CGuiTKMainLoop
    -->run()
    -->addSourceTimer
    -->addSourceIdle 
    -->addSourcePoll 



3.5 增加定时器事件loop->addSourceTimer
        (bind(&CDriverUseGui::RefreshCommonHeadTime, this, _1), 1000, NULL);
        (bind(&CDriverUseGui::RefreshDesktopInfo, this, _1), 1000, NULL);

        GuiManager.cpp :snprintf(num, 64, "%ld", loop->addSourceTimer(handle, interval, data));
        GuiManager.cpp :snprintf(num, 64, "%ld", loop->addSourceTimer(handle, interval, (void *)dialog));

        (bind(&CParameterSetGui::ReFreshBasicWindowPerSecond, this, _1), 1000, NULL);
        (boost::bind(&CParameterSetGui::HandleFuelSetOperateResultTimeOut, this), 60000, NULL);
        (boost::bind(&CParameterSetGui::HandleFuelSetOperateResultTimeOut, this), 20000, NULL);

        (bind(&CPreViewGui::RefreshGuiHandlePerSecond, this, _1), 100, NULL);
        (bind(&CPreViewGui::RefreshPreviewTime, this, _1), 100, NULL);
        (bind(&CPreViewGui::RefreshOtherPreviewInfo, this, _1), 1000, NULL);
        (bind(&CPreViewGui::HandleAutoSequenceAndSpot, this, _1), 1000, NULL);
        (bind(&CPreViewGui::RefreshPreViewStatusPageTime, this, _1), 100, NULL);
        (bind(&CPreViewGui::RefreshPreViewStatusPageOhterStatus, this, _1), 1000, NULL);


3.6 GUI初始化中mainloop增加定时检查事件
    CGuiTKInput : public CGuiTKPollSource
    CInputBackend: public CGuiTKPollSource

    InitSendGetMessageAndTimer 虚函数 各个函数重载

    LoadGuiFinishMessageAndAction 
        -->遍历m_GuiInfoList m_BusinessGuiInfoList
            -->pGui->RegisterNetworkMessage()
            -->pGui->InitSendGetMessageAndTimer()
        -->RegisterGuiManagerMessage()
        -->InitGuiManagerSendGetMessageAndTimer()--->SetGuiPageHandleTimer--->addSourceTimer

3.7 增加休眠addSourceIdle 
        -->CServiceManager::addSourceIdle(boost::bind(&CServiceManager::WaitForEvent, this, _1), NULL);

3.8 鼠标和键盘事件CInputBackend: public CGuiTKPollSource 在win32平台使用
                  CGuiTKInput : public CGuiTKPollSource 在海思平台使用
                  这两个类都继承了CGuiTKPollSource，里面公共接口add，添加poll到mainloop中


3.9 输入、输出设备初始化---backend
    GuiTK.cpp
        -->GuiTKInitial(0, NULL)在main函数里调用的，主要加入mainloop里轮询显示相应触发事件
                --> CGuiTKInput *input = CGuiTKInput::GetInstance();
                    1、#define  INPUT_EVENT_FIFO     "/tmp/inputevent"
                    2、_inputHandle = open(INPUT_EVENT_FIFO, O_RDONLY | O_NONBLOCK);
                    3、add(bind(&CGuiTKInput::dispatch, this, _1), _inputHandle, (void *) _inputHandle);
                    4、在mainloop轮询中触发bind函数dispatch
                    5、dispatch函数实现流程
                            1),GuiTKEvent event;
                            2),CGuiTKDisplay *display = CGuiTKDisplay::GetInstance();
                            3),display->GetMouseMoveArea(DISPLAY_DEVICE_VGA, x, y, width, height)
                            4),循环read(_inputHandle, &event, sizeof(GuiTKEvent))获取event信息
                            5),event.any.type(GUITK_TOUCHTABLE_PRESS,GUITK_TOUCHTABLE_RELEASE,GUITK_TOUCHTABLE_MOVE)
                                处理鼠标和触摸相应的事件，显示相应位置
                --> CGuiTKMainLoop *loop = CGuiTKMainLoop::GetInstance();构造函数初始化

    CGuiTKDisplay.cpp 主要功能与海思接口对接，内存拷贝，填充颜色，鼠标初始化显示等接口
                -->构造函数
                    1,加载海思libGuiFb.so  _SoHandle = dlopen("../lib/libGuiFb.so", RTLD_LAZY);
                    2,加载海思函数接口GuiFrameBuffer.cpp-->CFrameBufferOperate.cpp(封装海思接口)，函数指针
                        _InitDisplayDevice = (InitDisplayDevicePtr)dlsym(_SoHandle, "InitDisplayDevice");
                        _UnInitDisplayDevice = (UnInitDisplayDevicePtr)dlsym(_SoHandle, "UnInitDisplayDevice");
                        _CopyFbMemoryArea = (CopyFbMemoryAreaPtr)dlsym(_SoHandle, "CopyFbMemoryArea");
                        _FillColorToSurface = (FillColorToSurfacePtr)dlsym(_SoHandle, "FillColorToSurface");
                        _InitMouseDisplay = (InitMouseDisplayPtr)dlsym(_SoHandle, "InitMouseDisplay");
                        _UnInitMouseDisplay = (UnInitMouseDisplayPtr)dlsym(_SoHandle, "UnInitMouseDisplay");

                        _SetMouseDisplayPosition = (SetMouseDisplayPositionPtr)dlsym(_SoHandle, "SetMouseDisplayPosition");
                        _SetTransparent = (SetTransparentPtr)dlsym(_SoHandle, "SetTransparent");
                        _SetMessageClient = (SetMessageClientPtr)dlsym(_SoHandle, "SetMessageClient");
                         说明_InitDisplayDevice函数指针 对应海思接口InitDisplayDevice(GuiFrameBuffer.cpp,)
                -->提供设置鼠标显示，fb分辨率和获取接口

    CGuiTKInput.cpp 主要打开inputevent文件描述符，加入mainloop轮询中，读取该文件描述符事件类型，调用display接口显示图标

    GuiTKEvent.cpp 定义事件类型，保存当前鼠标键盘事件和获取

    CDisplayBackend.cpp 在win32平台使用
    CInputBackend.cpp 在win32平台使用


4、开源库canvas
    -->CGuiTKCanvas.cpp 调用cairo接口封装基本的图像绘画接口，直线、矩形，矩形圆角，三角形，图片、文本，箭头等
    -->CGuiTKPixmap.cpp
    -->CGuiTKThemeParser.cpp 解析主题各个属性
    -->CGuiTKWidgetEngine.cpp 控件管理类，提供绘画显示接口 drawButton...，主要调用各个engine的Draw接口
    -->engine/各个控件调用引擎，提供个Draw接口，供gui再封装接口调用
    -->widget/各个控件，提供创建，图片和样式，copyWidget和获取相应的接口，OnPaint-->CGuiTKWidgetEngine-->drawXXX

5、builder 应用层调用UIBuilder，通过xml解析器，创建窗体控件和注册消息句柄
    -->CGuiTKXulParser.cpp 


6、eventloop gui主循环，主要处理定时回调、文件轮询事情处理

7、wmanager 窗体的构建或者销毁，窗体管理类

8、FontLibOpt 字体操作库，共享库

















