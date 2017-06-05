#!/bin/bash

# get status of vm
# @param $1 vm-name or id
getVmStatus() {
  prlctl list -o status $1 | tail -1
  return 0
}

# Get default interface of the vm
# @param $1 vm-name or id
getVmIface() {
  prlctl exec $1 route | grep '^default' | grep -o '[^ ]*$'
  return 0
}

# get ip address of vm
# @param $1 vm-name or id
getVmAddr() {
  prlctl exec $1 ifconfig `getVmIface $vm` | grep "inet addr" | awk -F: '{print $2}' | awk '{print $1}'
  return 0
}

IFS='@' read -a array <<< "$1"

user=${array[0]}
vm=${array[1]}
running=0

while [ $running == 0  ]; do
  state=`getVmStatus $vm`
  case "$state" in
    running )   addr=`getVmAddr $vm`
                running=1
                ;;
    suspended ) echo "Resuming virtual machine $vm"
                prlctl resume $vm
                sleep 5 
                ;;
    stopped )   echo "Starting virtual machine $vm"
                prlctl start $vm
                sleep 10
                ;;
    *)          echo "Unknown status $state of virtual machine $vm"
                running=1;
                ;;
  esac
done

if [ $addr ]
then
  ssh $user@$addr
fi
