#!/bin/bash

export LC_ALL="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export LANG="en_US.UTF-8"

help_info(){
        echo "version:20170421"
        echo "EXAMPLES:"
        echo "   $0        shutdown"
        echo "   $0        restart"
        echo "   $0        start"
        echo "   $0        approot_$(date +%Y%m%d%H%M)"
}

tomcat_start(){
        if ! ps -ef |grep [j]ava|grep  "tomcat" >/dev/null 2>&1 ;then
                cd /data/tomcat/tomcat/bin/&& ./startup.sh >/dev/null
                sleep 1
                if ps -ef |grep [j]ava|grep  "tomcat" >/dev/null 2>&1 ;then
                        echo "tomcat is start succeed"
                else
                        echo "tomcat is start failed" 
                        exit 1
                fi
        else
        echo  "tomcat  is   running"
        exit 1
        fi
}


tomcat_shutdown(){
        if ps -ef |grep [j]ava|grep  "tomcat" >/dev/null 2>&1 ;then
                tomcat_pid=$(ps -ef |grep [j]ava|grep "tomcat"|awk '{print $2}')
                kill -9 $tomcat_pid && cd /data/tomcat/tomcat && rm -rf work/*
                sleep 2
                if ps -ef |grep [j]ava|grep -q "tomcat";then
                        echo "tomcat is shutdown failed"
                        exit 1
                else
                        echo "tomcat is shutdown succeed" 
                fi
        else
                echo "tomcat  is not running"

        fi

}

if  [ $# -ne 1 ]
then
    help_info
    exit 1
fi
tomcat_status="$1"

case $tomcat_status in
                start|START)
                   tomcat_start $i
        ;;
                approot_*)
                   if  [[ -d /data/tomcat/code/$tomcat_status ]];then
                      tomcat_shutdown $i &&
                      cd /data/tomcat &&
                      rm -rf approot &&
                      ln -s code/$tomcat_status approot &&
                      if  [[ -d /data/tomcat/code ]];then
                         echo $(ls -l approot|awk '{print $9,$10,$11}')
                      else
                         echo $(ls -l approot|awk '{print $9,$10,$11}')

                      fi
                      tomcat_start $i
                   else
                      echo "/data/tomcat/code/$tomcat_status is not exist!"
                   fi
        ;;
                shutdown|SHUTDOWN)
                   tomcat_shutdown $i
        ;;
                restart|RESTART)
                   tomcat_shutdown $i &&
                   tomcat_start $i
        ;;
                *)
                   echo "Usage: \$1 {start|shutdown|restart|approot_2015101111}"
        ;;
esac
