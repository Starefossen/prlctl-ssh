#!/bin/bash

# get status of vm
# @param $1 vm-name or id
getVmStatus() {
	prlctl list -o status $1 | tail -1
	
	return 0
}

# get ip address of vm
# @param $1 vm-name or id
getVmAddr() {
	prlctl exec $1 ifconfig eth0 | grep "inet addr" | awk -F: '{print $2}' | awk '{print $1}'
	
	return 0
}

#vm="dev.ubuntu"
vm=$1
stat=`getVmStatus $vm`

if [ $stat == "running" ]
then
	addr=`getVmAddr $vm`
	ssh hans@$addr
	
elif [ $stat == "suspended" ]
then
	prlctl resume $vm
	sleep 5
	addr=`getVmAddr $vm`
	ssh hans@$addr
	
elif [ $stat == "stopped" ]
then	
	prlctl start $vm
	sleep 10
	addr=`getVmAddr $vm` 
	ssh hans@$addr
	
else
	# does not exists
	echo "The VM does not exists!"
fi