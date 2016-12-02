check_route() {
    local host=$1
    local gw=$2
    local name=$3
    local gateway=`route get $host | awk '/gateway/ {print $2}'`
    if [[ $gateway == $gw ]]
    then
        echo "$name SUCCESS"
    else
        echo "$name Fail"
    fi
}

check_route www.icloud.com 172.20.10.1 icloud
check_route 10.149.173.62 10.149.176.1 gitlab
check_route hani.shinsegae.com 10.149.176.1 hani.shinsegae.com
check_route 10.253.46.61 10.149.176.1 wifimon
check_route s-lab.slack.com 10.149.176.1 slack
check_route ssgslab.atlassian.net 10.149.176.1 ssgslab.atlassian.net
check_route atlassian.net 10.149.176.1 atlassian.net
check_route s-lab.slack.com 10.149.176.1 slack
check_route drive.google.com 172.20.10.1 googledrv

dns=`nslookup shrs.ssg | awk '/Server/ {print $2}'`
if [[ $dns == "10.253.19.18" || $dns == "174.100.25.121" ]]
then
    echo "shrs SUCCESS"
else
    echo "shrs Fail"
fi


