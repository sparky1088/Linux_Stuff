#! /usr/bin/python
import re
import sys

############################################################################################################
## The purpose of this script is to take a Cisco ASA syslog and determine who logged into the VPN
############################################################################################################

vpnConnectionSyslogID = '713120'

#Ask for file or take default location
theFile = open(raw_input("Please type in the path to your file and press 'Enter': ") or "/var/log/cisco/ASA.log",'r')
FILE = theFile.readlines()
theFile.close()
printList = []
COLUMNS = ['date', 'username', 'IP', 'vpngroup']
EMPTY_FIELD = "" # This can be set to anything, the code below should be able to compensate
for line in FILE:
    if (vpnConnectionSyslogID in line):
	#Matching with Regex  in line so we can get specific groups for table building
        match = re.search(r'(?P<date>\S{3} [0-9]{1,2} ([0-9]{1,2}\:?){3}) (?P<hostname>\S+) \%ASA-[0-9]-(?P<MsgID>\S+) Group \= (?P<vpngroup>\S+), (Username \= (?P<username>\S+), )?IP \= (?P<IP>\S+), .*', line)
        printList.append(match.group(*COLUMNS))

columnSize = {}
# Save the size of the column headers
for c in COLUMNS:
    columnSize[c] = len(c)
# Save the size of the largest column
for item in printList:
    for i, c in enumerate(COLUMNS):
        field = item[i]
        if field is None:
            field = EMPTY_FIELD
        columnSize[c] = len(field) if len(field) > columnSize[c] else columnSize[c]

# Left justify the column to add extra padding and straight columns
def lengthen_field(column, field):
    if field is None:
        field = EMPTY_FIELD
    # Left justify the column according to the columnsize of the current column
    return field.ljust(columnSize[COLUMNS[column]])

# Print out the header
def print_header():
    tableWidth = 0
    for i, field in enumerate(COLUMNS):
        sys.stdout.write(" %s " % lengthen_field(i, field))
        tableWidth += columnSize[COLUMNS[i]] + 2
        if i < len(COLUMNS) - 1:
            sys.stdout.write("|")
            tableWidth += 1
        else:
            sys.stdout.write("\n")
    print("-" * tableWidth)

print_header()
# Print out all of the items in a table
for item in printList:
    itemSize = len(item)
    # We need to loop over each column in the row and add padding to each one
    for i, field in enumerate(item):
        sys.stdout.write(" %s " % lengthen_field(i, field))
        if i < itemSize - 1:
            sys.stdout.write("|")
        else:
            sys.stdout.write("\n")
    #print " %s | %s | %s | %s " % item
