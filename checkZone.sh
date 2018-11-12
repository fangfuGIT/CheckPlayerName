#!/bin/sh
#encode begin
  #                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
#endcode end
#complie=true

source /etc/profile


        function showMsg()
        {
                errState="$?"
                local showType="$1"
                local showContent="$2"
                local isExit="$3"
                #如果isExit为空，则默认出错时该退出
                if [ "${isExit}" = "" ]; then
                        isExit=1
                fi
                local isIP=`echo ${mysqlHost} | grep -E "172|192|10" | wc -l`
                if [ "${mysqlHost}" = "localhost" ]; then
                        local showExtent="localhost.${siteId}"
                elif [ "${isIP}" -eq "1" ]; then
                        local showExtent="db1(${mysqlHost}).${siteId}"
                else
                        showExtent=''
                fi
                showType=`echo ${showType} | tr 'A-Z' 'a-z'`
                case "${showType}" in
                        errsysmsg)
                                if [ "${errState}" -ne 0 ]; then
                                        echo -e "\033[31;49;1m[`date +%F' '%T`] ${showExtent} Error: ${showContent}\033[39;49;0m" | tee -a ${logFile}
                                        echo -e "\033[31;49;1m[`date +%F' '%T`] Call Relation: bash${pid}\033[39;49;0m" | tee -a ${logFile}
                                        if [ "${isExit}" -eq 1 ]; then
                                                exit 1
                                        fi
                                fi
                        ;;
                        errsys)
                                if [ "$errState" -ne 0 ]; then
                                        exit 1
                                fi
                        ;;
                        errusermsg)
                                echo -e "\033[31;49;1m[`date +%F' '%T`] ${showExtent} Error: ${showContent}\033[39;49;0m"  | tee -a ${logFile}
                                echo -e "\033[31;49;1m[`date +%F' '%T`] Call Relation: bash${pid}\033[39;49;0m" | tee -a ${logFile}
                                if [ "${isExit}" -eq 1 ]; then
                                        exit 1
                                fi
                        ;;
                        warning)
                                echo -e "\033[33;49;1m[`date +%F' '%T`] ${showExtent} Warnning: ${showContent}\033[39;49;0m"  | tee -a ${logFile}
                                echo -e "\033[33;49;1m[`date +%F' '%T`] Call Relation: bash${pid}\033[39;49;0m"  | tee -a ${logFile}
                        ;;
                        msg)
                                echo "[`date +%F' '%T`] ${showExtent} ${showContent}" | tee -a ${logFile}
                        ;;
                        msg2)
                                echo -n "[`date +%F' '%T`] ${showExtent} ${showContent}" | tee -a ${logFile}
                        ;;
                        ok)
                                echo "OK" >> ${logFile}
                                echo -e "\033[32;49;1mOK\033[39;49;0m" 
                        ;;
                        *)
                                echo -e "\033[31;49;1m[`date +%F' '%T`] Error: Call founction showMsg error\033[39;49;0m"  | tee -a ${logFile}
                                exit 1
                        ;;
                esac
        }

        #执行sql语句
        function executeSql()
        {
                sql="$1"
                if [ -z "$mysqlUser" -o "$mysqlUser" = "" -o -z "${mysqlPwd}" -o "${mysqlPwd}" = "" ]; then
                        showMsg "errUserMsg" "mysql user or mysql password is not vaild."
                fi
                if [ "$sql" = "" ]
                then
                        cat | mysql -h${mysqlHost} -u${mysqlUser} -p${mysqlPwd} $useDBName --default-character-set=utf8 -N 
                else
                        echo "$sql" | mysql -h${mysqlHost} -u${mysqlUser} -p${mysqlPwd} $useDBName --default-character-set=utf8 -N 
                fi
        }

        #取得本机的内网IP
        function getLocalInnerIP()
        {
               ifconfig |  grep -o 'inet addr:[0-9.]*' | grep -o '[0-9.]*$' | grep -e '^192\.' -e '^10\.' -e '^172\.'
        }

        #检查指定文件是否存在
        function checkFileExist()
        {
                theFileName="$1"
                if [ ! -f $theFileName ]; then
                        showMsg "errUserMsg" "The file '$theFileName' is not exist."
                fi
        }

        #检查软件是否已安装
        function checkSoftInstall()
        {
                softName="$1"
                which ${softName} &> /dev/null 
                showMsg "errSysMsg" "The software '${softName}' is not install."
        }

        #解密
        function strDecoding()
        {
                encryptCode="$1"
                theCode=`echo ${encryptCode} | sed 's/ME~we/y/g' | sed 's/k8i2UP/x/g' | sed 's/\Ya;q46/w/g' | sed 's/uqcM23/u/g' | sed 's/HA@d/o/g' | sed 's/43w,cv/m/g' | sed 's/(6d:ad/j/g' | sed 's/_iy%wt/b/g' | sed 's/hmdf8d/a/g' | sed 's/gfLNmd/Y/g' |sed 's/o;th}d/W/g' | sed 's/Y82dKH/U/g' | sed 's/q2I%Rr/N/g' | sed 's/Nqdlpd/L/g' | sed 's/@GH(hg/H/g' | sed 's/vTDD)m/D/g' | sed 's/+pH@de/C/g' | sed 's/MHzuvm/A/g' | base64 -d -i`
                theLen=${#theCode}
                i=0
                strHead=''
                strTail=''
                while [ "${i}" -lt "${theLen}" ]; do
                        theStr="${theCode:$i:1}"
                        isOdd=`expr ${i} % 2`
                        if [ "${isOdd}" -eq 1 ]; then
                                strHead="${theStr}${strHead}"
                        else
                                strTail="${strTail}${theStr}"
                        fi
                        i=`expr $i + 1`
                done
                echo "${strTail}${strHead}"
        }

		#确认输入是否正确
prompt()
{
	while true
	do
		echo -e -n "$1 [yes/no/exit]? "
		if [ "$CONFIRM_YES" == "1" ]; then
			echo "yes"
			echo ""
			return 0
		fi
		read PROMPT_ANSWER
		if [ -z "$PROMPT_ANSWER" ]; then
			continue
		else
			if [ "$PROMPT_ANSWER" == "yes" ]; then
				echo ""
				return 0
			elif [ "$PROMPT_ANSWER" == "no" ]; then
				echo ""
				return 1
			elif [ "$PROMPT_ANSWER" == "exit" ]; then
				echo ""
				exit 0
			else
				continue
			fi
		fi
	done
}

		
#获取解密var
get_Vault()
{
	while true
	do
		echo -n "$1"
		stty -echo
		read Vault
		stty echo

		echo ""
		if [ -z "$Vault" ]; then
			continue
		else
			break
		fi
	
	done
}


#初始化变量
function init()
{
        sid=`basename $0`
        export pid="${pid}-->$sid"
        theFiledir=`echo $(cd "$(dirname "$0")"; pwd)`
        cd ${theFiledir}
		logFile='/data/shelllog/scsgwsOpen.log'

}


function main()
{    

	centerServiceIp=183.61.x.x
	:>/var/log/ansible.log
	init
	
	get_Vault "Vault password:"
	if [ -f /tmp/.vault.pass ];then
		rm -fr /tmp/.vault.pass
	fi
	if [ -f $theFiledir/centerSrvIp.cnf ];then
		rm -fr $theFiledir/centerSrvIp.cnf
	fi
	
	if [ -f openarea/$centerServiceIp/tmp/waitProc_list.txt -o -f /tmp/oneMergeScriptList ];then
		rm -fr openarea/$centerServiceIp/tmp/waitProc_list.txt
		rm -fr /tmp/oneMergeScriptList
	fi
	
	echo "$Vault" > /tmp/.vault.pass
	echo "$centerServiceIp">$theFiledir/centerSrvIp.cnf
	
	checkFileExist "/tmp/.vault.pass"
	checkFileExist "$theFiledir/centerSrvIp.cnf"
	checkFileExist "${theFiledir}/getVariList.yml"
   
    ansible-playbook -i centerSrvIp.cnf getVariList.yml -k --vault-password-file=/tmp/.vault.pass
	checkFileExist "openarea/$centerServiceIp/tmp/waitProc_list.txt"
	nullnum=`cat openarea/$centerServiceIp/tmp/waitProc_list.txt|grep -c -w 'null'`
	if [ $nullnum -ge 1 ] ;then 
		showMsg "errusermsg" "waitProc_list.txt have some null ,please check it."
	fi
	IPSERCNT=`cat openarea/$centerServiceIp/tmp/waitProc_list.txt |sed '1,/merge/d'| wc -l`
	array_area_cnt=(`cat openarea/$centerServiceIp/tmp/waitProc_list.txt |sed '1,/merge/d'|awk '{print $1}'|awk -F_ '{for(i=3;i<=NF;++i) printf $i "\t";printf "\n"}'`)
	
	cat openarea/$centerServiceIp/tmp/waitProc_list.txt |sed '1,/merge/d'|head -50
	echo "......"
	echo ''
	echo "Execution script DB slave-server list:"

	cat openarea/$centerServiceIp/tmp/waitProc_list.txt
	prompt "========== Are you sure check this servers ?"

        ansible-playbook -i openarea/$centerServiceIp/tmp/waitProc_list.txt checkArea.yml -k --vault-password-file=/tmp/.vault.pass

	if [ -f /tmp/.vault.pass ];then
		rm -fr /tmp/.vault.pass
	fi
	if [ -f $theFiledir/centerSrvIp.cnf ];then
		rm -fr $theFiledir/centerSrvIp.cnf
	fi
         
         
        cat openarea/$centerServiceIp/tmp/waitProc_list.txt | while read line
        do
            mkdir -p checkallname/$line
            cp -rf openarea/$line/data/checkname/* checkallname/$line
        done
        
           
        rsync -rvltD checkallname/ 10.61.101.173::tongbu_s/checkallname/  

	cat /var/log/ansible.log |sed '/failed:/,+1p'> exec.error

	rm -rf openarea
        rm -rf checkallname
	:>/var/log/ansible.log

} 
main $* 
