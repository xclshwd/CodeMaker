#!/bin/bash

#工程拷贝目录###
####export PROJECT_DIR=/home/shliu/GitProject/X5-III
export PROJECT_DIR=/home/shliu/GitProject/X1


#release放目录###
#export MODULE_DIR=/home/shliu/6-GitBasicService/release
export MODULE_DIR=/home/shliu/Z-MessageSender/N9M/release

MODULE_LIST=(
"avstreaming"
"basicservice"
"devicemanage"
"storage"
"guiprocess"
"libcommon"
"librmfs"
"libtoolkit"
"networkprotocol"
"networkservice"
"parameter"
"webservice"
"include"
"libisp"
"opensource"
"resources"
"sdk"
"smalltools"
"thirdparty"
"automation"
)

BASICSERVER_LIST=(
"All"
"BasicServiceEx"
"eventmanage"
"BSCommonLibrary"
"AdjTimeManage"
"AlarmManage"
"Area"
"CompositeBusiness"
"FtpBusiness"
"MainboardTest"
"MaintainManage"
"multiplymanage"
"SerialPortManage"
"SwipeCard"
)

echo "module:"
for i in "${!MODULE_LIST[@]}"; do
	echo "$i: ${MODULE_LIST[$i]}"
done
echo -ne "please input module id:"
read _module_;

if [ "${_module_}" -lt "${#MODULE_LIST[@]}" ];then
	MODULE_TYPE=${MODULE_LIST[${_module_}]%(*}
	#echo "export MODULE_TYPE:=${MODULE_TYPE}" >> $_DEF_FILE_PATH_;

	for c in ${MODULE_TYPE}
	do
		case $c in
			avstreaming)
				cp -vf ${MODULE_DIR}/avstreaming/bin/avStreaming  ${PROJECT_DIR}/bin
			;;
			basicservice)
				echo "BasicServer:"
				for i in "${!BASICSERVER_LIST[@]}"; do
					echo "$i: ${BASICSERVER_LIST[$i]}"
				done

				echo -ne "please input BasicModule id:"
				read _basic_;
				if [ "${_basic_}" -lt "${#BASICSERVER_LIST[@]}" ];then
					BASIC_TYPE=${BASICSERVER_LIST[${_basic_}]%(*}

					if [ "${BASIC_TYPE}" = "BasicServiceEx" ];then
						cp -rvf ${MODULE_DIR}/basicservice/BasicService/bin/*  ${PROJECT_DIR}/bin
					elif [ "${BASIC_TYPE}" = "eventmanage" ];then
						cp -vf ${MODULE_DIR}/basicservice/eventmanage/bin/*  ${PROJECT_DIR}/bin
					elif [ "${BASIC_TYPE}" = "BSCommonLibrary" ];then
						cp -vf ${MODULE_DIR}/basicservice/BSCommonLibrary/lib/*  ${PROJECT_DIR}/lib
						cp -vf ${MODULE_DIR}/basicservice/rmfile/lib/*  ${PROJECT_DIR}/lib
					elif [ "${BASIC_TYPE}" = "AdjTimeManage" ];then
						cp -vf ${MODULE_DIR}/basicservice/AdjTimeManage/lib/*  ${PROJECT_DIR}/plugin
					elif [ "${BASIC_TYPE}" = "AlarmManage" ];then
						cp -vf ${MODULE_DIR}/basicservice/AlarmManage/lib/libAlarmManage.so  ${PROJECT_DIR}/plugin
						cp -vf ${MODULE_DIR}/basicservice/AlarmManage/lib/*  ${PROJECT_DIR}/plugin/alarm
						rm -rf ${PROJECT_DIR}/plugin/alarm/libAlarmManage.so
					elif [ "${BASIC_TYPE}" = "Area" ];then
						cp -vf ${MODULE_DIR}/basicservice/Area/lib/*.so  ${PROJECT_DIR}/plugin
					elif [ "${BASIC_TYPE}" = "CompositeBusiness" ];then
						cp -vf ${MODULE_DIR}/basicservice/CompositeBusiness/lib/*.so  ${PROJECT_DIR}/plugin
					elif [ "${BASIC_TYPE}" = "FtpBusiness" ];then
						cp -vf ${MODULE_DIR}/basicservice/FtpBusiness/lib/*.so  ${PROJECT_DIR}/plugin
					elif [ "${BASIC_TYPE}" = "MainboardTest" ];then
						cp -vf ${MODULE_DIR}/basicservice/MainboardTest/lib/*.so  ${PROJECT_DIR}/plugin
					elif [ "${BASIC_TYPE}" = "MaintainManage" ];then
						cp -vf ${MODULE_DIR}/basicservice/MaintainManage/lib/*.so  ${PROJECT_DIR}/plugin
					elif [ "${BASIC_TYPE}" = "multiplymanage" ];then
						cp -vf ${MODULE_DIR}/basicservice/multiplymanage/lib/*.so  ${PROJECT_DIR}/plugin
					elif [ "${BASIC_TYPE}" = "SerialPortManage" ];then
						cp -vf ${MODULE_DIR}/basicservice/SerialPortManage/lib/libPeripheralManage.so  ${PROJECT_DIR}/plugin
						cp -vf ${MODULE_DIR}/basicservice/SerialPortManage/lib/*.so  ${PROJECT_DIR}/plugin/serial
						rm -rf ${PROJECT_DIR}/plugin/serial/libPeripheralManage.so
					elif [ "${BASIC_TYPE}" = "SwipeCard" ];then
						cp -vf ${MODULE_DIR}/basicservice/SwipeCard/lib/*.so  ${PROJECT_DIR}/plugin/swipecard
					elif [ "${BASIC_TYPE}" = "All" ];then
						#BasicService库
						cp -rvf ${MODULE_DIR}/basicservice/BasicService/bin/*  ${PROJECT_DIR}/bin
						#eventmanage
						cp -vf ${MODULE_DIR}/basicservice/eventmanage/bin/*  ${PROJECT_DIR}/bin
						#基础公共库
						cp -vf ${MODULE_DIR}/basicservice/BSCommonLibrary/lib/*  ${PROJECT_DIR}/lib
						cp -vf ${MODULE_DIR}/basicservice/rmfile/lib/*  ${PROJECT_DIR}/lib
						#校时库
						cp -vf ${MODULE_DIR}/basicservice/AdjTimeManage/lib/*  ${PROJECT_DIR}/plugin
						#报警库
						cp -vf ${MODULE_DIR}/basicservice/AlarmManage/lib/libAlarmManage.so  ${PROJECT_DIR}/plugin
						cp -vf ${MODULE_DIR}/basicservice/AlarmManage/lib/*  ${PROJECT_DIR}/plugin/alarm
						rm -rf ${PROJECT_DIR}/plugin/alarm/libAlarmManage.so
						#电子围栏
						cp -vf ${MODULE_DIR}/basicservice/Area/lib/*.so  ${PROJECT_DIR}/plugin
						#综合业务
						cp -vf ${MODULE_DIR}/basicservice/CompositeBusiness/lib/*.so  ${PROJECT_DIR}/plugin
						#文件管理
						cp -vf ${MODULE_DIR}/basicservice/FileManage/lib/*.so  ${PROJECT_DIR}/plugin
						#FtpBusiness
						cp -vf ${MODULE_DIR}/basicservice/FtpBusiness/lib/*.so  ${PROJECT_DIR}/plugin
						#MainboardTest
						cp -vf ${MODULE_DIR}/basicservice/MainboardTest/lib/*.so  ${PROJECT_DIR}/plugin
						#MaintainManage
						cp -vf ${MODULE_DIR}/basicservice/MaintainManage/lib/*.so  ${PROJECT_DIR}/plugin
						#multiplymanage
						cp -vf ${MODULE_DIR}/basicservice/multiplymanage/lib/*.so  ${PROJECT_DIR}/plugin

						#serial
						cp -vf ${MODULE_DIR}/basicservice/SerialPortManage/lib/libPeripheralManage.so  ${PROJECT_DIR}/plugin
						cp -vf ${MODULE_DIR}/basicservice/SerialPortManage/lib/*.so  ${PROJECT_DIR}/plugin/serial
						rm -rf ${PROJECT_DIR}/plugin/serial/libPeripheralManage.so
						#swipecard
						cp -vf ${MODULE_DIR}/basicservice/SwipeCard/lib/*.so  ${PROJECT_DIR}/plugin/swipecard
					fi
				else
					echo "invalid basic!"
					exit 1
				fi

			;;
			devicemanage)
				cp -vf ${MODULE_DIR}/devicemanage/bin/DeviceManage  ${PROJECT_DIR}/bin
			;;
			guiprocess)
				cp -vf ${MODULE_DIR}/guiprocess/lib/*.so  ${PROJECT_DIR}/bin
			;;
			libcommon)
				cp -vf ${MODULE_DIR}/libcommon/bin/*  ${PROJECT_DIR}/bin
				cp -vf ${MODULE_DIR}/libcommon/lib/*  ${PROJECT_DIR}/lib
			;;
			librmfs)
				cp -vf ${MODULE_DIR}/librmfs/lib/*.so  ${PROJECT_DIR}/lib
			;;
			libtoolkit)
				cp -vf ${MODULE_DIR}/libtoolkit/bin/*  ${PROJECT_DIR}/bin
				cp -vf ${MODULE_DIR}/libtoolkit/lib/*.so  ${PROJECT_DIR}/lib
			;;
			networkprotocol)
				cp -vf ${MODULE_DIR}/networkprotocol/bin/*  ${PROJECT_DIR}/bin
				cp -vf ${MODULE_DIR}/networkprotocol/lib/*.so  ${PROJECT_DIR}/lib
			;;
			networkservice)
				cp -vf ${MODULE_DIR}/networkservice/bin/NetworkService ${PROJECT_DIR}/bin
				cp -vf ${MODULE_DIR}/networkservice/bin/ip-down  ${PROJECT_DIR}/bin/bohao/
				cp -vf ${MODULE_DIR}/networkservice/bin/ip-up  ${PROJECT_DIR}/bin/bohao/
				cp -vf ${MODULE_DIR}/networkservice/bin/pppddaemon.bin  ${PROJECT_DIR}/bin/bohao/
			;;
			parameter)
				cp -vf ${MODULE_DIR}/parameter/lib/*  ${PROJECT_DIR}/lib
			;;
			storage)
				cp -vf ${MODULE_DIR}/storage/bin/Storage  ${PROJECT_DIR}/bin
			;;
			webservice)
				cp -vf ${MODULE_DIR}/webservice/bin/*  ${PROJECT_DIR}/bin
				cp -rvf ${MODULE_DIR}/webservice/www/*  ${PROJECT_DIR}/www
			;;
		  *)
		    echo "invalid product:${PRODUCT_TYPE}";	
		    ;;
		esac
	done
else
	echo "invalid product!"
	exit 1
fi
