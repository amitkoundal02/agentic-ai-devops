#!/bin/bash
# NAT Instance Configuration Script

# Update packages
yum update -y

# Enable IP forwarding permanently
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
sysctl -p

# Detect outbound interface dynamically (usually eth0, but safer to detect)
OUT_IF=$(ip route | grep '^default' | awk '{print $5}')

# Configure NAT (MASQUERADE)
iptables -t nat -A POSTROUTING -o $OUT_IF -j MASQUERADE

# Allow forwarding from private subnets
iptables -A FORWARD -i $OUT_IF -j ACCEPT
iptables -A FORWARD -o $OUT_IF -m state --state ESTABLISHED,RELATED -j ACCEPT

# Save firewall rules
yum install -y iptables-services
service iptables save
systemctl enable iptables
systemctl start iptables
