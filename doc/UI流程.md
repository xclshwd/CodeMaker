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
                                            类型<themefile>ui/BaseVersion/LogSearchGui/theme/LogSearch_style.xml</themefile>
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
    -->libtoolkit/guitoolkit
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
                                                --signal -->ParseSignal(xmlTmpNode, Widget)
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


3.3 设备初始化 GuiTKInitial(0, NULL)
    -->CGuiTKInput *input = CGuiTKInput::GetInstance()设别输入层
            ## add(bind(&CGuiTKInput::dispatch, this, _1), _inputHandle, (void *) _inputHandle);
            ## dispatch 

    -->CGuiTKMainLoop *loop = CGuiTKMainLoop::GetInstance()

3.4 主循环开始 GuiTKRun()
    -->CGuiTKMainLoop *loop = CGuiTKMainLoop::GetInstance()
            ##loop->run()

3.5 CGuiTKMainLoop
            


