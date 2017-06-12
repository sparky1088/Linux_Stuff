# Don't use with firewalld

echo "1" > /proc/sys/net/ipv4/ip_forward
nic="eno1"
ipreg="10.10.9.161" # system management ip

ip addr add 10.10.11.35/22 dev $nic # we use this internal ip and foward all traffice to their ip
ip addr add 10.10.11.36/22 dev $nic # we use this internal ip and foward all traffice to their ip
ip addr add 10.10.11.37/22 dev $nic # we use this internal ip and foward all traffice to their ip
ip addr add 10.10.11.38/22 dev $nic # we use this internal ip and foward all traffice to their ip
ip addr add 10.10.11.39/22 dev $nic # we use this internal ip and foward all traffice to their ip
ip addr add 10.10.11.40/22 dev $nic # we use this internal ip and foward all traffice to their ip
srcip=`ip a | grep -A3  tun0  | grep 'inet' | sed 's/.*inet //g' | sed 's/ scope.*//g' | sed 's/\/32//g'` # VPN IP
echo $srcip # echo vpn ip

# Clear iptables
iptables -F
iptables -t nat -F
ip6tables -F

# Default is to Drop packages
iptables -P FORWARD DROP
iptables -P INPUT   DROP
iptables -P OUTPUT  ACCEPT

ip6tables -P FORWARD DROP
ip6tables -P INPUT   DROP
ip6tables -P OUTPUT  ACCEPT

# Allow all localhost
iptables -A INPUT -i lo -m state --state NEW -j ACCEPT

# Accept port 22
iptables -A INPUT -i $nic -p tcp -d $ipreg --dport 22 -m state --state NEW -j ACCEPT

# Allow established connections (the responses to our outgoing traffic)
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
ip6tables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# This is where the magic happens
# Accept all packetes going to 10.10.11.35
iptables -A INPUT -i $nic -p tcp -d 10.10.11.35 -m state --state NEW -j ACCEPT
iptables -A INPUT -i $nic -p tcp -d 10.10.11.36 -m state --state NEW -j ACCEPT
iptables -A INPUT -i $nic -p tcp -d 10.10.11.37 -m state --state NEW -j ACCEPT
iptables -A INPUT -i $nic -p tcp -d 10.10.11.38 -m state --state NEW -j ACCEPT
iptables -A INPUT -i $nic -p tcp -d 10.10.11.39 -m state --state NEW -j ACCEPT
iptables -A INPUT -i $nic -p tcp -d 10.10.11.40 -m state --state NEW -j ACCEPT
# Forward those packats to 10.10.200.40
iptables -A FORWARD -i $nic -o tun0 -s 10.10.8.0/22 -d 10.10.200.40 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -i $nic -o tun0 -s 10.10.8.0/22 -d 10.10.200.41 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -i $nic -o tun0 -s 10.10.8.0/22 -d 10.10.200.42 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -i $nic -o tun0 -s 10.10.8.0/22 -d 10.10.200.43 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -i $nic -o tun0 -s 10.10.8.0/22 -d 10.10.200.44 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -i $nic -o tun0 -s 10.10.8.0/22 -d 10.10.200.45 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT

# Accept return packages
#IN=tun0 OUT=eno1 MAC= SRC=10.10.200.40 DST=10.10.8.85 LEN=60 TOS=0x00 PREC=0x00 TTL=63 ID=0 DF PROTO=TCP SPT=22 DPT=1446 WINDOW=14480 RES=0x00 ACK SYN URGP=0
iptables -A FORWARD -i tun0 -o $nic -d 10.10.8.0/22 -m state --state ESTABLISHED,RELATED -j ACCEPT

# logging rule to debug in system logs
#iptables -A FORWARD -j LOG --log-prefix "IPTables-Dropped: " --log-level 4

iptables -t nat -A PREROUTING  -p tcp -m tcp -i $nic -s 10.10.8.0/22 -d 10.10.11.35 -j DNAT --to-destination 10.10.200.40
iptables -t nat -A PREROUTING  -p tcp -m tcp -i $nic -s 10.10.8.0/22 -d 10.10.11.36 -j DNAT --to-destination 10.10.200.41
iptables -t nat -A PREROUTING  -p tcp -m tcp -i $nic -s 10.10.8.0/22 -d 10.10.11.37 -j DNAT --to-destination 10.10.200.42
iptables -t nat -A PREROUTING  -p tcp -m tcp -i $nic -s 10.10.8.0/22 -d 10.10.11.38 -j DNAT --to-destination 10.10.200.43
iptables -t nat -A PREROUTING  -p tcp -m tcp -i $nic -s 10.10.8.0/22 -d 10.10.11.39 -j DNAT --to-destination 10.10.200.44
iptables -t nat -A PREROUTING  -p tcp -m tcp -i $nic -s 10.10.8.0/22 -d 10.10.11.40 -j DNAT --to-destination 10.10.200.45
iptables -t nat -A POSTROUTING -o tun0 -p tcp -m tcp -d 10.10.200.40 -j SNAT --to-source $srcip
iptables -t nat -A POSTROUTING -o tun0 -p tcp -m tcp -d 10.10.200.41 -j SNAT --to-source $srcip
iptables -t nat -A POSTROUTING -o tun0 -p tcp -m tcp -d 10.10.200.42 -j SNAT --to-source $srcip
iptables -t nat -A POSTROUTING -o tun0 -p tcp -m tcp -d 10.10.200.43 -j SNAT --to-source $srcip
iptables -t nat -A POSTROUTING -o tun0 -p tcp -m tcp -d 10.10.200.44 -j SNAT --to-source $srcip
iptables -t nat -A POSTROUTING -o tun0 -p tcp -m tcp -d 10.10.200.45 -j SNAT --to-source $srcip
