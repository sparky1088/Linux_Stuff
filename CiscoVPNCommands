### Check Phase 1 Tunnel
ASA# show crypto isakmp sa detail | b [peer IP add]

### Check Phase 2 Tunnel
ASA# show crypto ipsec sa peer [peer IP add]

### Display the PSK
ASA# more system:running-config | b tunnel-group [peer IP add]

### Display Uptime, etc.
ASA# sh vpn-sessiondb detail l2l | b [peer IP add]
ASA# show vpn-sessiondb detail l2l filter name <peer_address>

### Reset IPSec VPN
ASA# clear ipsec sa peer <remote-peer-IP>

### Add remote access (VPN) user
ASA# username USER1 password SomeSecurePassword
username USER1 attributes
 vpn-group-policy VPNPolicy
 service-type remote-access
wr mem

### Remove User
conf t
clear configure username ctaylor
wr mem
