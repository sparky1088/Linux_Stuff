# Don't use with firewalld
# 

## This script is intended to connect to a vpn on a remote network and forward IP address to be local IPs. 
## It is a horrible round about way to do a site to site vpn for people who can't figure out their end correctly

## LOC.AL.IP.AD1 This is a local IP address on the network that has nothing on it currently
## You can add more address as seen in the comments.
## LOC.AL.SUB.NET is the subnet in the format of IP.AD.DR.0/Sub eg 10.10.8.0/22
## REM.OTE.IP.AD1 is the remote IP address that we are forwarding to. 

echo "1" > /proc/sys/net/ipv4/ip_forward
nic="eno1"
ipreg="10.10.9.161" # system management ip

ip addr add LOC.AL.IP.AD1/Sub dev $nic # we use this internal ip and foward all traffice to their ip
#ip addr add LOC.AL.IP.AD2/Sub dev $nic # we use this internal ip and foward all traffice to their ip
#ip addr add LOC.AL.IP.AD3/Sub dev $nic # we use this internal ip and foward all traffice to their ip
#ip addr add LOC.AL.IP.AD4/Sub dev $nic # we use this internal ip and foward all traffice to their ip
#ip addr add LOC.AL.IP.AD5/Sub dev $nic # we use this internal ip and foward all traffice to their ip
#ip addr add LOC.AL.IP.AD6/Sub dev $nic # we use this internal ip and foward all traffice to their ip
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
# Accept all packetes going to LOC.AL.IP.AD1
iptables -A INPUT -i $nic -p tcp -d LOC.AL.IP.AD1 -m state --state NEW -j ACCEPT
#iptables -A INPUT -i $nic -p tcp -d LOC.AL.IP.AD2 -m state --state NEW -j ACCEPT
#iptables -A INPUT -i $nic -p tcp -d LOC.AL.IP.AD3 -m state --state NEW -j ACCEPT
#iptables -A INPUT -i $nic -p tcp -d LOC.AL.IP.AD4 -m state --state NEW -j ACCEPT
#iptables -A INPUT -i $nic -p tcp -d LOC.AL.IP.AD5 -m state --state NEW -j ACCEPT
#iptables -A INPUT -i $nic -p tcp -d LOC.AL.IP.AD6 -m state --state NEW -j ACCEPT
# Forward those packats to 10.10.200.40
iptables -A FORWARD -i $nic -o tun0 -s LOC.AL.SUB.NET -d REM.OTE.IP.AD1 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
#iptables -A FORWARD -i $nic -o tun0 -s LOC.AL.SUB.NET -d REM.OTE.IP.AD2 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
#iptables -A FORWARD -i $nic -o tun0 -s LOC.AL.SUB.NET -d REM.OTE.IP.AD3 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
#iptables -A FORWARD -i $nic -o tun0 -s LOC.AL.SUB.NET -d REM.OTE.IP.AD4 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
#iptables -A FORWARD -i $nic -o tun0 -s LOC.AL.SUB.NET -d REM.OTE.IP.AD5 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
#iptables -A FORWARD -i $nic -o tun0 -s LOC.AL.SUB.NET -d REM.OTE.IP.AD6 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT

# Accept return packages
iptables -A FORWARD -i tun0 -o $nic -d LOC.AL.SUB.NET -m state --state ESTABLISHED,RELATED -j ACCEPT

# logging rule to debug in system logs
#iptables -A FORWARD -j LOG --log-prefix "IPTables-Dropped: " --log-level 4

iptables -t nat -A PREROUTING  -p tcp -m tcp -i $nic -s LOC.AL.SUB.NET/22 -d LOC.AL.IP.AD1 -j DNAT --to-destination 10.10.200.40
#iptables -t nat -A PREROUTING  -p tcp -m tcp -i $nic -s LOC.AL.SUB.NET/22 -d LOC.AL.IP.AD2 -j DNAT --to-destination 10.10.200.41
#iptables -t nat -A PREROUTING  -p tcp -m tcp -i $nic -s LOC.AL.SUB.NET/22 -d LOC.AL.IP.AD3 -j DNAT --to-destination 10.10.200.42
#iptables -t nat -A PREROUTING  -p tcp -m tcp -i $nic -s LOC.AL.SUB.NET/22 -d LOC.AL.IP.AD4 -j DNAT --to-destination 10.10.200.43
#iptables -t nat -A PREROUTING  -p tcp -m tcp -i $nic -s LOC.AL.SUB.NET/22 -d LOC.AL.IP.AD5 -j DNAT --to-destination 10.10.200.44
#iptables -t nat -A PREROUTING  -p tcp -m tcp -i $nic -s LOC.AL.SUB.NET/22 -d LOC.AL.IP.AD6 -j DNAT --to-destination 10.10.200.45
iptables -t nat -A POSTROUTING -o tun0 -p tcp -m tcp -d REM.OTE.IP.AD1 -j SNAT --to-source $srcip
#iptables -t nat -A POSTROUTING -o tun0 -p tcp -m tcp -d REM.OTE.IP.AD2 -j SNAT --to-source $srcip
#iptables -t nat -A POSTROUTING -o tun0 -p tcp -m tcp -d REM.OTE.IP.AD3 -j SNAT --to-source $srcip
#iptables -t nat -A POSTROUTING -o tun0 -p tcp -m tcp -d REM.OTE.IP.AD4 -j SNAT --to-source $srcip
#iptables -t nat -A POSTROUTING -o tun0 -p tcp -m tcp -d REM.OTE.IP.AD5 -j SNAT --to-source $srcip
#iptables -t nat -A POSTROUTING -o tun0 -p tcp -m tcp -d REM.OTE.IP.AD6 -j SNAT --to-source $srcip
