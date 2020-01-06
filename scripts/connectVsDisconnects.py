#! /usr/bin/python

############################################################################################################
## The purpose of this script is to take a Cisco ASA syslog and determine the number of connections to 
## the VPN vs Disconnects as a measurement of someone attempting to login who does not have credentials.
############################################################################################################

f = open(raw_input("Please type in the path to your file and press 'Enter': ") or "/var/log/cisco/ASA.log")
data = f.read()
f.close()

msg713050 = data.count('713050')
msg713049 = data.count('713049')

print ("Difference of:", abs(msg713050 - msg713049))
