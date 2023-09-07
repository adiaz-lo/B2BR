#!/bin/bash
# ARCH
arch=$(uname -a)
# CPU PHYSICAL CORES
cpup=$(grep "physical id" /proc/cpuinfo | wc -l)
# CPU VIRTUAL CORES
cpuv=$(grep "processor" /proc/cpuinfo | wc -l)
# RAM
# USED RAM
ram_usage=$(free --mega | awk '$1 == "Mem:" {print $3}')
# TOTAL RAM
ram_total=$(free --mega | awk '$1 == "Mem:" {print $2}')
# USED RAM (%)
ram_percentage=$(free --mega | awk '$1 == "Mem:" {printf("%.2f\n", $3/$2*100)}')
# DISK
# USED DISK STORAGE
disk_usage=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{memory_use += $3} END {print memory_use}')
# TOTAL DISK STORAGE
disk_total=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{memory_result += $2} END {printf ("%.0fGb\n"), memory_result/1024}')
# USED DISK STORAGE (%)
disk_percentage=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{use += $3} {total += $2} END {printf("%d\n"), use/total*100}')
# CPU LOAD (%)
cpul=$(vmstat 1 4 | tail -1 | awk '{print $15}')
cpu_op=$(expr 100 - $cpul)
cpu_show=$(printf "%.1f" $cpu_op)
# LAST BOOT
lb=$(who -b | awk '$1 == "system" {print $3 " " $4}')
# LVM USE
lvmu=$(if [ $(lsblk | grep "lvm" | wc -l) -gt 0 ]; then echo yes; else echo no; fi)
# TCP CONNECTIONS
tcpc=$(ss -ta | grep ESTAB | wc -l)
# USER LOG
ulog=$(users | wc -w)
# NETWORK
ip=$(hostname -I | awk '{print $1}')
mac=$(ip link | grep "link/ether" | awk '{print $2}')
# SUDO
sudocmnd=$(journalctl _COMM=sudo | grep COMMAND | wc -l)
# BROADCAST MESSAGE
wall "  Architecture: $arch
        CPU physical: $cpup
        vCPU: $cpuv
        Memory Usage: $ram_usage/${ram_total}MB ($ram_percentage%)
		Disk Usage: $disk_usage/${disk_total} ($disk_percentage%)
        CPU Load: $cpu_show%
        Last Boot: $lb
        LVM Use: $lvmu
        TCP Connections: $tcpc ESTABLISHED
        User Log: $ulog
        Network: IP $ip ($mac)
        Sudo: $sudocmnd cmd"
