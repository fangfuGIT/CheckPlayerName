#!/bin/bash
source /etc/profile
function showMsg()
{
        errState="$?"
        local pid=" [pid $$]"
        local showType="$1"
        local showContent="$2"
        local isExit="$3"
        if [ "${isExit}" = "" ]; then
                        isExit=1
        fi

        showType=`echo ${showType} | tr 'A-Z' 'a-z'`
        case "${showType}" in
                errsysmsg)
                                if [ "${errState}" -ne 0 ]; then
                                        echo -e "\n\033[31;49;1m[`date +%F' '%T`]  bash${pid} Error: ${showContent}\033[39;49;0m\n" | tee -a ${logFile}
                                        if [ "${isExit}" -eq 1 ]; then
                                                        exit 1
                                        fi
                                fi
                                ;;
                errsys)
                                if [ "${errState}" -ne 0 ]; then
                                        echo -e "\n\033[31;49;1m[`date +%F' '%T`]  bash${pid} Error: ${showContent}\033[39;49;0m\n" | tee -a ${logFile}
                                        if [ "${isExit}" -eq 1 ]; then
                                                        kill 0
                                                        exit 1
                                        fi
                                fi
                                ;;
                errmsg)
                                echo -e "\n\033[31;49;1m[`date +%F' '%T`]  bash${pid} Error: ${showContent}\033[39;49;0m\n" | tee -a ${logFile}
                                if [ "${isExit}" -eq 1 ]; then
                                                        exit 1
                                fi
                                ;;
                warning)
                                if [ "${errState}" -ne 0 ]; then
                                        echo -e "\n\033[33;49;1m[`date +%F' '%T`] bash${pid} Warn: ${showContent}\033[39;49;0m"  | tee -a ${logFile}
                                fi
                                ;;
                msg)
                                echo -e "\033[32;49;1m[`date +%F' '%T`] bash${pid} ${showContent}\033[39;49;0m" | tee -a ${logFile}
                                ;;
                msg2)
                                echo -n "[`date +%F' '%T`] bash${pid} ${showContent}" | tee -a ${logFile}
                                ;;
                ok)
                                echo -e "\033[32;49;1mOK\033[39;49;0m"  | tee -a ${logFile}
                                ;;
                *)
                                echo -e "\n\033[31;49;1m[`date +%F' '%T`] Error: Call founction showMsg error\033[39;49;0m\n"  | tee -a ${logFile}
                                exit 1
                                ;;
        esac
}



function main()
{    
  game="gamename"
  passwd=$1
  file="minganci.csv"

  if [ -f /tmp/$file ];then
                rm -fr /tmp/$file
  fi

  if [ -f result.txt ];then
     :>result.txt
  fi
   
  if [ -f list.txt ];then
     :>list.txt
  fi  
  
  if [ -f $file ];then
          cp -rf $file /tmp/      
  else
      showMsg "errSysMsg" "The $file is not exist! please check it!"
      exit
  fi
    
  echo "drop table if exists test.mingan"|mysql -uroot -p$passwd --default-character-set=utf8 -N|sed '/Using a password on the command/d'
  echo "create table test.mingan(n varchar(20)) ENGINE=InnoDB DEFAULT CHARSET=utf8"|mysql -uroot -p$passwd --default-character-set=utf8 -N|sed '/Using a password on the command/d'
  echo "load data infile '/tmp/minganci.csv' into table test.mingan fields terminated by ',' lines terminated by '\r\n';"|mysql -uroot -p$passwd --default-character-set=utf8 -N|sed '/Using a password on the command/d'
     showMsg "errSysMsg" "import csv error"
  
  echo "show databases"|mysql -uroot -p$passwd --default-character-set=utf8 -N|sed '/Using a password on the command/d' >> list.txt
#  echo $game > result.txt
  echo "" > result.txt
  cat list.txt | while read dbs
  do
    if [[ ${dbs:0:7} =~ "db_$game" ]]; then
      rolename=`echo "select p.rolename from $dbs.property p,test.mingan t where p.rolename like concat( '%',t.n,'%') and logintime>='2017-10-27'"|mysql -uroot -p$passwd --default-character-set=utf8 -N|sed '/Using a password on the command/d'`
      factionname=`echo "select f.factionname from $dbs.factionlist f,test.mingan t where f.factionname like concat( '%',t.n,'%') and logintime>='2017-10-27'"|mysql -uroot -p$passwd --default-character-set=utf8 -N|sed '/Using a password on the command/d'`
        if [[ $rolename ]];then
          echo $dbs >> result.txt
          echo $rolename >> result.txt
          echo "" >> result.txt
        elif [[ $factionname ]];then
          echo $dbs >> result.txt
          echo $factionname >> result.txt
          echo "" >> result.txt
        fi
      continue
    fi
  done

echo "drop table if exists test.mingan"|mysql -uroot -p$passwd --default-character-set=utf8 -N|sed '/Using a password on the command/d'
}

main $* 

