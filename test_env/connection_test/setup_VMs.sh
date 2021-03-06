#!/bin/bash

LOCAL_RT_NAME="vm1"
LOCAL_RT_ADDRESS="192.168.42.253/24"
LOCAL_RT_LLADDRESS="52:54:00:01:00:01"
LOCAL_RT_NETWORK="192.168.42.0/24"
MEC_NAME="vm2"
MEC_ADDRESS="192.168.1.50/24"
MEC_LLADDRESS="52:54:00:02:00:01"
MEC_NETWORK="192.168.1.0/24"
CDC_NAME="vm3"
CDC_ADDRESS="192.168.3.50/24"
CDC_LLADDRESS="52:54:00:03:00:01"
CDC_NETWORK="192.168.3.0/24"
RT_NAME="vm4"
RT_ADDRESS1="192.168.42.254/24"
RT_LLADDRESS1="52:54:00:00:01:01"
RT_ADDRESS2="192.168.1.254/24"
RT_LLADDRESS2="52:54:00:00:01:02"
RT_ADDRESS3="192.168.3.254/24"
RT_LLADDRESS3="52:54:00:00:01:03"


echo "=========== ${RT_NAME} ============"
uvt-kvm ssh ${RT_NAME} "sudo ip addr add ${RT_ADDRESS1} dev ens4"
uvt-kvm ssh ${RT_NAME} "sudo ip neigh add ${LOCAL_RT_ADDRESS%/*} dev ens4 lladdr ${LOCAL_RT_LLADDRESS}"
uvt-kvm ssh ${RT_NAME} "sudo ip link set up  dev ens4"
uvt-kvm ssh ${RT_NAME} "sudo ip addr add ${RT_ADDRESS2} dev ens5"
uvt-kvm ssh ${RT_NAME} "sudo ip neigh add ${MEC_ADDRESS%/*} dev ens5 lladdr ${MEC_LLADDRESS}"
uvt-kvm ssh ${RT_NAME} "sudo ip link set up  dev ens5"
uvt-kvm ssh ${RT_NAME} "sudo ip addr add ${RT_ADDRESS3} dev ens6"
uvt-kvm ssh ${RT_NAME} "sudo ip neigh add ${CDC_ADDRESS%/*} dev ens6 lladdr ${CDC_LLADDRESS}"
uvt-kvm ssh ${RT_NAME} "sudo ip link set up  dev ens6"
uvt-kvm ssh ${RT_NAME} "sudo ip addr"
uvt-kvm ssh ${RT_NAME} "sudo ip route"
uvt-kvm ssh ${RT_NAME} "echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward"
echo ""

echo "=========== ${LOCAL_RT_NAME} ============"
uvt-kvm ssh ${LOCAL_RT_NAME} "sudo ip addr add ${LOCAL_RT_ADDRESS} dev ens4"
uvt-kvm ssh ${LOCAL_RT_NAME} "sudo ip link set up dev ens4"
uvt-kvm ssh ${LOCAL_RT_NAME} "sudo ip route add ${MEC_NETWORK} via ${RT_ADDRESS1%/*} dev ens4"
uvt-kvm ssh ${LOCAL_RT_NAME} "sudo ip route add ${CDC_NETWORK} via ${RT_ADDRESS1%/*} dev ens4"
uvt-kvm ssh ${LOCAL_RT_NAME} "sudo ip neigh add ${RT_ADDRESS1%/*} dev ens4 lladdr ${RT_LLADDRESS1}"
uvt-kvm ssh ${LOCAL_RT_NAME} "sudo ip addr"
uvt-kvm ssh ${LOCAL_RT_NAME} "sudo ip route"
echo ""


echo "=========== ${MEC_NAME} ============"
uvt-kvm ssh ${MEC_NAME} "sudo ip addr add ${MEC_ADDRESS} dev ens4"
uvt-kvm ssh ${MEC_NAME} "sudo ip link set up dev ens4"
uvt-kvm ssh ${MEC_NAME} "sudo ip route add ${LOCAL_RT_NETWORK} via ${RT_ADDRESS2%/*} dev ens4"
uvt-kvm ssh ${MEC_NAME} "sudo ip route add ${CDC_NETWORK} via ${RT_ADDRESS2%/*} dev ens4"
uvt-kvm ssh ${MEC_NAME} "sudo ip neigh add ${RT_ADDRESS2%/*} dev ens4 lladdr ${RT_LLADDRESS2}"
uvt-kvm ssh ${MEC_NAME} "sudo ip addr"
uvt-kvm ssh ${MEC_NAME} "sudo ip route"
echo ""

echo "=========== ${CDC_NAME} ============"
uvt-kvm ssh ${CDC_NAME} "sudo ip addr add ${CDC_ADDRESS} dev ens4"
uvt-kvm ssh ${CDC_NAME} "sudo ip link set up dev ens4"
uvt-kvm ssh ${CDC_NAME} "sudo ip route add ${LOCAL_RT_NETWORK} via ${RT_ADDRESS3%/*} dev ens4"
uvt-kvm ssh ${CDC_NAME} "sudo ip route add ${MEC_NETWORK} via ${RT_ADDRESS3%/*} dev ens4"
uvt-kvm ssh ${MEC_NAME} "sudo ip neigh add ${RT_ADDRESS3%/*} dev ens4 lladdr ${RT_LLADDRESS3}"
uvt-kvm ssh ${CDC_NAME} "sudo ip addr"
uvt-kvm ssh ${CDC_NAME} "sudo ip route"
echo ""

