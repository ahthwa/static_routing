#!/bin/bash

################################################
# 사내망을 정의하자
################################################
PRIVATE_GATEWAY_WIRED=10.149.172.1
PRIVATE_GATEWAY_WIRELESS=10.149.176.1
TETHERING_GATEWAY=172.20.10.1

PRIVATE_GATEWAY_DOMAINS="
blossom.shinsegae.com
imss.shinsegae.com
mail2.shinsegae.com
ssgdm.shinsegae.com
s-lab.slack.com
ssgslab.atlassian.net
shrs.ssg"

################################################
# default gateway를 변경한다.
################################################
#sudo route change 0.0.0.0 192.168.1.1
sudo route change 0.0.0.0 $TETHERING_GATEWAY

################################################
# 내부 접속 가능한 도메인과 호스트를 추가한다
################################################
# 사내망
sudo route -n add -net 174.100.0.0/16 $PRIVATE_GATEWAY_WIRELESS
sudo route -n add -net 10.253.0.0/16 $PRIVATE_GATEWAY_WIRELESS

set_route() {
    local DOMAIN=$1
    local GATEWAY=$2

    ipaddrs=`nslookup $DOMAIN |awk '/^Address: / { print $2 ; }'`

    # nslookup 이 여러개의 ip 주소를  return할 수 있다
    for each_ip in $ipaddrs
    do
        echo "$host ($ipaddrs) to $GATEWAY"
        sudo route -n add -net $each_ip $GATEWAY
    done
}

# 개별 도메인
for host in ${PRIVATE_GATEWAY_DOMAINS[@]}
do
    set_route $host $PRIVATE_GATEWAY_WIRELESS
done

EXTERNAL_DOMAINS="
drive.google.com
www.facebook.com
www.youtube.com"

for host in ${EXTERNAL_DOMAINS[@]}
do
    set_route $host $TETHERING_GATEWAY
done

################################################
# Domain Name을 모르는 것들은 그냥 ip 주소로
################################################
#. incwebhard
sudo route -n add -host 10.253.42.51 $PRIVATE_GATEWAY_WIRELESS

#  통합관리시스템
sudo route -n add -host 203.3.23.29 $PRIVATE_GATEWAY_WIRELESS

#############

sudo route -n add -host 202.3.20.40 $PRIVATE_GATEWAY_WIRELESS
sudo route -n add -host 10.253.46.56 $PRIVATE_GATEWAY_WIRELESS

# GITLAB
sudo route -n add -net 10.149.173.62 $PRIVATE_GATEWAY_WIRELESS

###########################################################
# 끗
###########################################################
exit 0

###########################################################
# 요건 참고용
###########################################################
# imss.shinsegae.com        210.92.198.4
# mail2.shinsegae.com       174.100.22.141
# ssgdm.shinsegae.com       10.253.21.95
# incwebhard                10.253.42.51
# blossom.shinsegae.com     112.171.14.21
# 통합관리시스템               203.3.23.29
# atlassian                 165.254.227.241
# slack                     52.22.31.14
# youtube                   173.194.120.68
# facebook                  66.220.156.68

