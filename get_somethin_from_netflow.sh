#!/usr/bin/env bash
# pwd is ～/PycharmProjects/IPv6_Netflow/src/shell
# 显示日期
start=$1
end=$2
data_path="/home/origin/Documents/data/"


[ -d $data_path/netflows ] || exit 1

# 文件夹不存在则建立 存在则继续执行接下来的逻辑
[ ! -d $data_path/csv ] && mkdir -p $data_path/csv/ || [ -d $data_path/csv ] || exit2


while [ ${start} \< ${end} ]
do
    echo "Start get something from nfcapd."${start}"*......"

    nfdump -q -B -R $data_path/netflows/nfcapd.${start}0000:nfcapd.${start}2355 \
    -o fmt:"%td,%sa,%da,%sp,%dp,%pr,%nh,%smk,%dmk,%sn,%dn" -6 | \
    awk 'BEGIN {FS=",";OFS=",";print "id,td,sa,da,sp,dp,pr,nh,smk,dmk,sn,dn"} \
    gsub(/ /,"",$0) {print NR,$1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11}' \
    > $data_path/csv/${start}.csv

    echo "End get something from nfcapd."${start}"*......"


    start=` date -d "+1 day $start" +%Y%m%d`
done

