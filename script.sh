#!/bin/bash
# ARCH
uname -a
# CPU PHYSICAL CORES
grep "physical id" /proc/cpuinfo | wc -l
# CPU VIRTUAL CORES
cpuv=$(grep "processor" /proc/cpuinfo | wc -l)
# RAM
# USED RAM
free --mega | awk '$1 == "Mem:" {print $3}'
# TOTAL RAM
free --mega | awk '$1 == "Mem:" {print $2}'
# USED RAM (%)
free --mega | awk '$1 == "Mem:" {printf("(%.2f%%)\n", $3/$2*100)}'
# DISK
# USED DISK STORAGE
df -m | grep "/dev/" | grep -v "/boot" | awk '{memory_use += $3} END {print memory_use}'
# TOTAL DISK STORAGE
df -m | grep "/dev/" | grep -v "/boot" | awk '{memory_result += $2} END {printf ("%.0fGb\n"), memory_result/1024}'
# USED DISK STORAGE (%)
df -m | grep "/dev/" | grep -v "/boot" | awk '{use += $3} {total += $2} END {printf("(%d%%)\n"), use/total*100}'
# CPU LOAD (%)
vmstat 1 4 | tail -1 | awk '{print $15}'
# LAST BOOT
who -b | awk '$1 == "system" {print $3 " " $4}'
# LVM USAGE
if [ $(lsblk | grep "lvm" | wc -l) -gt 0 ]; then echo yes; else echo no; fi
# TCP CONNECTIONS
ss -ta | grep ESTAB | wc -l
# USER LOG
users | wc -w
# NETWORK
hostname -I
ip link | grep "link/ether" | awk '{print $2}'
# SUDO
journalctl _COMM=sudo | grep COMMAND | wc -l

