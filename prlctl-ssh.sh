#!/bin/bash
set -e

# get status of vm
# @param $1 vm-name or id
getVmStatus() {
  prlctl list -o status "$1" | tail -1
  return 0
}

# Get default interface of the vm
# @param $1 vm-name or id
getVmIface() {
  prlctl exec "$1" ip route | grep '^default' | sed 's/^.*dev \([^ \t]*\) .*$/\1/'
  return 0
}

# get ip address of vm
# @param $1 vm-name or id
getVmAddr() {
  prlctl exec "$1" ip addr show dev "$(getVmIface "$vm")" | awk '$1 == "inet" { sub("/.*", "", $2); print $2 }'
  return 0
}

IFS='@' read -r -a array <<< "$1"

user=${array[0]}
vm=${array[1]}
running=0

while [ $running = 0  ]; do
  state="$(getVmStatus "$vm")"
  case "$state" in
    running )   addr="$(getVmAddr "$vm")"
                running=1
                ;;
    suspended ) echo "Resuming virtual machine $vm"
                prlctl resume "$vm"
                sleep 5 
                ;;
    stopped )   echo "Starting virtual machine $vm"
                prlctl start "$vm"
                sleep 10
                ;;
    *)          echo "Unknown status $state of virtual machine $vm"
                running=1;
                ;;
  esac
done

if [ "$addr" ]; then
  ssh "$user@$addr"
fi
