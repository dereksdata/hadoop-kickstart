### Sysctl section ###
cat >> /etc/sysctl.conf<<EOF
# Stock Hadoop vm. settings 
vm.swappiness=1
vm.overcommit_memory=1
vm.overcommit_ratio=50

# For large impala commits
vm.dirty_background_ratio=5
vm.dirty_ratio=10

# Stock Hadoop fs. settings 
fs.file-max=943718

# Disable ipv6
net.ipv6.conf.all.disable_ipv6=1
net.ipv6.conf.default.disable_ipv6=1
net.ipv6.conf.lo.disable_ipv6=1

# 10Gbe tuning - still acceptalbe for 1Gbe
net.core.rmem_max=134217728
net.core.wmem_max=134217728
net.ipv4.tcp_rmem=32768 65536 16777216
net.ipv4.tcp_wmem=32768 65536 16777216
net.core.netdev_max_backlog = 250000
net.ipv4.tcp_congestion_control=htcp

# Socket max connections 
net.core.somaxconn=16384

# ipv4 security settings
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.conf.default.accept_source_route = 0
net.ipv4.icmp_echo_ignore_broadcasts = 1
net.ipv4.icmp_ignore_bogus_error_responses = 1
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_max_syn_backlog = 4096
net.ipv4.tcp_synack_retries = 3
net.ipv4.conf.all.log_martians = 1
net.ipv4.conf.default.log_martians = 1

# ipv4 tuning 
net.ipv4.ip_local_port_range="4096 61000"
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_moderate_rcvbuf = 1
net.ipv4.tcp_retries2 = 3
net.ipv4.tcp_keepalive_time=600
net.ipv4.tcp_keepalive_probes=5
net.ipv4.tcp_keepalive_intvl=15
net.ipv4.tcp_fin_timeout = 10
EOF
sysctl -p

### Limits section ###
cat >> /etc/security/limits.conf <<EOF
* - nofile 65536
* - nproc  65536
EOF

### Disable THP section ###
if test -f /sys/kernel/mm/redhat_transparent_hugepage/enabled; then
  echo never > /sys/kernel/mm/redhat_transparent_hugepage/enabled
fi
if test -f /sys/kernel/mm/redhat_transparent_hugepage/defrag; then
  echo never > /sys/kernel/mm/redhat_transparent_hugepage/defrag
fi
