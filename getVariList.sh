#!/bin/sh
#encode begin                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
#endcode end

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

		
		
	
		
function init()
{
        sid=`basename $0`
        export pid="${pid}-->$sid"
        theFiledir=`echo $(cd "$(dirname "$0")"; pwd)`
        cd ${theFiledir}
		logFile='/data/shelllog/getVariList.log'
}
function getSysInitList_sys()
{  echo -e "
		select distinct (case when b.idcid=1 then b.lanip else b.telecomip end) 
				from  t_product_server a ,t_server_fixedassets b
			where a.MasterDbId=b.id and a.plat<>'PW' and b.custommodel=2 and b.assetos=2  and OpenTime >date(now()) and OpenTime <adddate(DATE(NOW()),INTERVAL  $days day) and status=$status " | mysql -u${center_mysqlUser} -p${center_mysqlPwd} db_center_game -N >> waitProc_list.txt
}
function getRenameList_sys()
{  echo -e "
		select distinct (select (case when idcid=1 then lanip else TelecomIP end ) ip from  t_server_fixedassets where id=b.masterdbid) connectIP
		from t_server_mergeplan_server a ,t_product_server b 
		where a.minorserverid=b.serverid and  a.PlanId=$PlanId and b.status=0" | mysql -u${center_mysqlUser} -p${center_mysqlPwd} db_center_game -N >> waitProc_list.txt
}
function getRenameList()
{    
    
	echo -e "set @_i=0;
				select concat('host',@_i:=@_i+1,'_',plat,'_',b.serverid,'_',(select (case when idcid=1 then lanip else TelecomIP end ) ip from  t_server_fixedassets where id=b.masterdbid),'_',(select CustomName from t_server_dblist where id=b.dbid)) xx,
				concat('ansible_ssh_host=',(select (case when idcid=1 then lanip else TelecomIP end ) ip from  t_server_fixedassets where id=b.masterdbid)) connectIP,
				concat('dbname=',dbname) dbname,
				concat('todbname=del_',dbname,'_',date_format(now(),'%Y%m%d%H%i%s')) todbname ,
				concat('dblogname=',dblogname) dblogname,
				concat('todblogname=del_',dblogname,'_',date_format(now(),'%Y%m%d%H%i%s')) todblogname ,
				concat('dbmartname=db_mart_',serverid) dbmartname,
				concat('todbmartname=del_db_mart_',serverid,'_',date_format(now(),'%Y%m%d%H%i%s')) todbmartname 
				from t_server_mergeplan_server a ,t_product_server b 
				where a.minorserverid=b.serverid and  a.PlanId=$PlanId	and b.status=0" | mysql -u${center_mysqlUser} -p${center_mysqlPwd} db_center_game -N >> waitProc_list.txt
}


function getVariList()
{    
    
	echo -e "select distinct TelecomIP from t_product_server a,t_server_fixedassets t where t.id=a.SlaveDbId and a.status in (1) and a.Platid not in (100,999)" | mysql -u${center_mysqlUser} -p${center_mysqlPwd} db_center_game -N >> waitProc_list.txt
}

function getVariList_m()
{
	
	echo -e "
			select (select telecomip from t_server_fixedassets where id=a.masterdbid) masterip,
			(select lanip from t_server_fixedassets where id=a.masterdbid) masterlanip,
			(select telecomip from t_server_fixedassets where id=a.slavedbid) slaveip,
			(select lanip from t_server_fixedassets where id=a.slavedbid) slavelanip,
			concat(a.serverid,'_',b.minorserverid) from t_product_server a,
			(select majorserverid,GROUP_CONCAT(cast(MinorServerId as char) order by MinorServerId  SEPARATOR '_') MinorServerId 
			from db_center_game.t_server_mergeplan_server where planid=${PlanId} group by majorserverid) b
			where a.serverid=b.majorserverid order by masterip" | mysql -u${center_mysqlUser} -p${center_mysqlPwd} db_center_game -N > oneMergeScriptList
					
	echo "[policy]" > waitProc_list.txt
	if [ "$type" == "mergedb" ];then
		echo -e "set @_i=0;
				select  concat('host',@_i:=@_i+1,'_',slaveip) hosts,
				connip,policylogip from (
				select distinct slaveip, 
				concat('ansible_ssh_host=',slaveip) connip,
				concat('policyip=',master_slave_ip) policylogip
				from (select (select ( case when idcid=1 then lanip else TelecomIP end ) from 
				t_product_server a join t_server_dblist c on a.dbid=c.id
				join t_server_fixedassets d on c.masterdbid=d.id
				where a.serverid= minorserverid) slaveip,
				(select TelecomIP  from t_product_server a 
				join t_server_dblist c on a.dbid=c.id
				join t_server_fixedassets d on c.slavedbid=d.id
				where a.serverid= MajorServerId) master_slave_ip,
				(select d.idcid  from t_product_server a 
				join t_server_dblist c on a.dbid=c.id
				join t_server_fixedassets d on c.masterdbid=d.id
				where a.serverid= minorserverid) slaveidc,
				(select d.idcid  from t_product_server a 
				join t_server_dblist c on a.dbid=c.id
				join t_server_fixedassets d on c.masterdbid=d.id
				where a.serverid= MajorServerId) masteridc
				from t_server_mergeplan_server k where planid=${PlanId}
				) h where slaveidc<>masteridc ) p " | mysql -u${center_mysqlUser} -p${center_mysqlPwd} db_center_game -N >> waitProc_list.txt
	elif [ "$type" == "mergelog" ];then
		echo -e "set @_i=0;
				select concat('host',@_i:=@_i+1,'_',slaveip) hosts,connip,policylogip from
				(select distinct slaveip, 
				concat('ansible_ssh_host=',slaveip) connip,
				concat('policyip=',masterip) policylogip
				from (select (select ( case when idcid=1 then lanip else TelecomIP end  )  from 
				t_product_server a join t_server_dblist c on a.dbid=c.id
				join t_server_fixedassets d on c.masterdbid=d.id
				where a.serverid= minorserverid) slaveip,
				(select TelecomIP  from t_product_server a 
				join t_server_dblist c on a.dbid=c.id
				join t_server_fixedassets d on c.masterdbid=d.id
				where a.serverid= MajorServerId) masterip,
				(select d.idcid  from t_product_server a 
				join t_server_dblist c on a.dbid=c.id
				join t_server_fixedassets d on c.masterdbid=d.id
				where a.serverid= minorserverid) slaveidc,
				(select d.idcid  from t_product_server a 
				join t_server_dblist c on a.dbid=c.id
				join t_server_fixedassets d on c.masterdbid=d.id
				where a.serverid= MajorServerId) masteridc
				from t_server_mergeplan_server k where planid=${PlanId}
				) h where slaveidc<>masteridc) p" | mysql -u${center_mysqlUser} -p${center_mysqlPwd} db_center_game -N >> waitProc_list.txt
	fi
	
	echo "[merge]" >> waitProc_list.txt
	if [ "$type" == "mergedb" ];then
		echo -e "select concat('DB_',ip1,'_',serveridlist),ip from (
				select (select  telecomip   from t_server_fixedassets where id=a.masterdbid ) ip1, 
				group_concat(serverid SEPARATOR '_') serveridlist, 
				(select concat('ansible_ssh_host=',(case when idcid=1 then lanip when idcid<>1 then telecomip end ) )  
				from t_server_fixedassets where id=a.slavedbid ) ip from t_product_server a,
				(select majorserverid from db_center_game.t_server_mergeplan_server where planid=${PlanId} group by majorserverid) b
				where a.serverid=b.majorserverid 
				group by a.MasterDbId) k" | mysql -u${center_mysqlUser} -p${center_mysqlPwd} db_center_game -N >> waitProc_list.txt
	elif [ "$type" == "mergelog" ];then
		echo -e "select concat('LOG_',ip1,'_',serveridlist),ip from (
				select (select  telecomip   from t_server_fixedassets where id=a.masterdbid ) ip1, 
				group_concat(serverid SEPARATOR '_') serveridlist, 
				(select concat('ansible_ssh_host=',(case when idcid=1 then lanip when idcid<>1 then telecomip end ) )  
				from t_server_fixedassets where id=a.masterdbid ) ip from t_product_server a,
				(select majorserverid from db_center_game.t_server_mergeplan_server where planid=${PlanId} group by majorserverid) b
				where a.serverid=b.majorserverid 
				group by a.MasterDbId) k" | mysql -u${center_mysqlUser} -p${center_mysqlPwd} db_center_game -N >> waitProc_list.txt
	fi
}


function getDbStructure()
{
mysqldump  -u${center_mysqlUser}  -p${center_mysqlPwd} --skip-opt  --set-gtid-purged=OFF --create-option  -q -d  -R -E   --default-character-set=utf8  db_sgws_1001000 > db_sgws_model.sql
mysqldump  -u${center_mysqlUser}  -p${center_mysqlPwd} --skip-opt  --set-gtid-purged=OFF --create-option  -q -d  -R -E   --default-character-set=utf8  log_sgws_1001000 > db_log_model.sql
mysqldump  -u${center_mysqlUser}  -p${center_mysqlPwd} --skip-opt  --set-gtid-purged=OFF --create-option  -q -d  -R -E   --default-character-set=utf8  db_mart_1001000 > db_mart_model.sql

}
function main()	
	{
	center_mysqlUser=$1
	center_mysqlPwd=$2
	rm -f waitProc_list.txt
	if [ ! -f oneMergeScriptList ];then
		touch oneMergeScriptList
	fi
		getVariList
		showMsg "errsysmsg" "getVariList_openarea error!!"
	}
	
main $*
