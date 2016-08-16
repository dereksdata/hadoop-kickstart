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

# Stock Hadoop net. settings
net.core.somaxconn=16384
net.core.netdev_max_backlog=16384
net.core.rmem_max=134217728
net.core.wmem_max=134217728

# Disable ipv6
net.ipv6.conf.all.disable_ipv6=1
net.ipv6.conf.default.disable_ipv6=1
net.ipv6.conf.lo.disable_ipv6=1

# ipv4 tuning 
net.ipv4.ip_local_port_range="4096 61000"
net.ipv4.tcp_rmem=32768 65536 16777216
net.ipv4.tcp_wmem=32768 65536 16777216
net.ipv4.tcp_fin_timeout=30
net.ipv4.tcp_retries2=10
net.ipv4.tcp_synack_retries=3
net.ipv4.tcp_max_syn_backlog = 4096
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_sack=0
net.ipv4.tcp_dsack=0
net.ipv4.tcp_keepalive_time=600
net.ipv4.tcp_keepalive_probes=5
net.ipv4.tcp_keepalive_intvl=15
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
