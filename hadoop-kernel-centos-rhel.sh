#!/bin/bash
# Bash script to set the Kernel settings for Hadoop installations
# v1.5 dereksdata 20160826
# 
#   1.0 Initial release 
#   1.1 Updated for Linux kernel 2.6 changes
#   1.2 Updated for 10Gbe (1Gbe safe) defaults
#   1.3 Added rerun-safe, SetProperty duplicate entry safety
#   1.4 20160822 Added verified changes from Tagar
#   1.5 20160826 Moved THP disable to rc.local and additional socket tuning

SetProperty() {
	key=$(printf %s "$1" | sed 's/[][()\.^$?*+]/\\&/g')
	value=$(printf %s "$2" | sed 's/[][()\.^$?*+]/\\&/g')
	if grep -q "$key[ \t]*=" "$3"; then
		sed -c -i "s/\($key[ \t]*=[ \t]*\).*/\1$value/" "$3"
	else		
        sed -i -e '$a\' "$3"
		echo "$1=$2" >> "$3"
	fi
}

# Stock Hadoop vm. settings 
SetProperty "vm.swappiness" "1" "/etc/sysctl.conf"
SetProperty "vm.overcommit_memory" "1" "/etc/sysctl.conf"
SetProperty "vm.overcommit_ratio" "50" "/etc/sysctl.conf"

# For large impala commits
SetProperty "vm.dirty_background_ratio" "5" "/etc/sysctl.conf"
SetProperty "vm.dirty_ratio" "10" "/etc/sysctl.conf"

# Stock Hadoop fs. settings 
SetProperty "fs.file-max" "6544018" "/etc/sysctl.conf"

# Disable ipv6
SetProperty "net.ipv6.conf.all.disable_ipv6" "1" "/etc/sysctl.conf"
SetProperty "net.ipv6.conf.default.disable_ipv6" "1" "/etc/sysctl.conf"
SetProperty "net.ipv6.conf.lo.disable_ipv6" "1" "/etc/sysctl.conf"

# 10Gbe tuning - usually acceptable for 1Gbe as well
SetProperty "net.ipv4.tcp_rmem" "32768 65536 16777216" "/etc/sysctl.conf"
SetProperty "net.ipv4.tcp_wmem" "32768 65536 16777216" "/etc/sysctl.conf"
SetProperty "net.ipv4.tcp_congestion_control" "htcp" "/etc/sysctl.conf"
SetProperty "net.ipv4.tcp_sack " "0" "/etc/sysctl.conf"
SetProperty "net.ipv4.tcp_timestamps" "0" "/etc/sysctl.conf"
SetProperty "net.core.netdev_max_backlog" "250000" "/etc/sysctl.conf"

# Socket tuning
SetProperty "net.core.somaxconn" "16384" "/etc/sysctl.conf"
SetProperty "net.core.rmem_max" "134217728" "/etc/sysctl.conf"
SetProperty "net.core.wmem_max" "134217728" "/etc/sysctl.conf"
SetProperty "net.core.rmem_default" "262144" "/etc/sysctl.conf"
SetProperty "net.core.wmem_default" "262144" "/etc/sysctl.conf"

# ipv4 security settings
SetProperty "net.ipv4.conf.all.accept_source_route" "0" "/etc/sysctl.conf"
SetProperty "net.ipv4.conf.default.accept_source_route" "0" "/etc/sysctl.conf"
SetProperty "net.ipv4.icmp_echo_ignore_broadcasts" "1" "/etc/sysctl.conf"
SetProperty "net.ipv4.icmp_ignore_bogus_error_responses" "1" "/etc/sysctl.conf"
SetProperty "net.ipv4.tcp_syncookies" "1" "/etc/sysctl.conf"
SetProperty "net.ipv4.tcp_max_syn_backlog" "4096" "/etc/sysctl.conf"
SetProperty "net.ipv4.tcp_synack_retries" "3" "/etc/sysctl.conf"
SetProperty "net.ipv4.conf.all.log_martians" "1" "/etc/sysctl.conf"
SetProperty "net.ipv4.conf.default.log_martians" "1" "/etc/sysctl.conf"
SetProperty "net.ipv4.conf.default.rp_filter" "1" "/etc/sysctl.conf"

# ipv4 tuning
SetProperty "net.ipv4.ip_local_port_range" "1024 65000" "/etc/sysctl.conf"
SetProperty "net.ipv4.tcp_tw_reuse" "1" "/etc/sysctl.conf"
SetProperty "net.ipv4.tcp_moderate_rcvbuf" "1" "/etc/sysctl.conf"
SetProperty "net.ipv4.tcp_retries2" "3" "/etc/sysctl.conf"
SetProperty "net.ipv4.tcp_keepalive_time" "600" "/etc/sysctl.conf"
SetProperty "net.ipv4.tcp_keepalive_probes" "5" "/etc/sysctl.conf"
SetProperty "net.ipv4.tcp_keepalive_intvl" "15" "/etc/sysctl.conf"
SetProperty "net.ipv4.tcp_fin_timeout" "10" "/etc/sysctl.conf"
SetProperty "net.ipv4.ip_forward" "0" "/etc/sysctl.conf"

# Controls the System Request debugging functionality of the kernel
SetProperty "kernel.sysrq" "0" "/etc/sysctl.conf"

# Controls whether core dumps will append the PID to the core filename.
# Useful for debugging multi-threaded applications.
SetProperty "kernel.core_uses_pid" "1" "/etc/sysctl.conf"

# Controls the maximum size of a message, in bytes
SetProperty "kernel.msgmnb" "65536" "/etc/sysctl.conf"

# Controls the default maxmimum size of a mesage queue
SetProperty "kernel.msgmax" "65536" "/etc/sysctl.conf"

# Controls the maximum shared segment size, in bytes
SetProperty "kernel.shmmax" "68719476736" "/etc/sysctl.conf"

sysctl -p

# File and process limits
if ! grep -q "* - nofile 65536" /etc/security/limits.conf; then
    echo "* - nofile 65536" >>  /etc/security/limits.conf
fi
if ! grep -q "* - nproc 65536" /etc/security/limits.conf; then
    echo "* - nproc 65536" >>  /etc/security/limits.conf
fi

# Disable THP
if ! grep -q redhat_transparent_hugepage /etc/rc.local; then
    echo "echo never > /sys/kernel/mm/redhat_transparent_hugepage/enabled" >> /etc/rc.local
    echo "echo never > /sys/kernel/mm/redhat_transparent_hugepage/defrag" >> /etc/rc.local
fi
