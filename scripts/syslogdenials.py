#! /usr/bin/python
import re       #for regular expressions - to match ip's
import sys      #for parsing command line opts

############################################################################################################
##  The purpose of this script is to take a Cisco ASA syslog and determine main source of denials
##  This script will not run in python 2.6 or earlier
############################################################################################################

from collections import Counter

DENY_PATTERN = re.compile(r'Deny\s(?P<protocol>.+?)\ssrc.*?:(?P<src>[0-9a-f\.]*)/?.*?\s.*?dst.*?:(?P<dst>[0-9a-f\.]*)((/(?P<dst_port>[0-9]*)\s)|\s)')
LINE_FORMAT='{0:<6.6} {1:<12.12} {2:<12.12} {3:<6.6} {4}'


def process_log_file(logfile):
    """Reads through the log_file, and returns a counter based on Deny-lines."""


    # Process file line by line
    with open(logfile, 'r') as data:
        seen = Counter()

        # find all Deny line and append them in a list
        for line in data :

            # If line has 'Deny ' in it, then check it some more
            if 'Deny ' in line:
                seen.update(DENY_PATTERN.findall(line)) 

    return seen


def print_counter(counter):
    """Pretty print the result of the counter."""

    print(LINE_FORMAT.format('prot', 'source', 'destination',  'port', 'hitcnt'))
    print(LINE_FORMAT.format(*tuple(('------------------',) * 5)))
    for (protocol, src, dst, _, _, dst_port), count in counter.most_common():
        print(LINE_FORMAT.format(protocol, src, dst, dst_port, count))


if __name__ == '__main__':
    # if file is specified on command line, parse, else ask for file
    if sys.argv[1:]:
        print "File: %s" % (sys.argv[1])
        logfile = sys.argv[1]
    else:
        logfile = raw_input("Please enter a file to parse, e.g /var/log/secure: ") or "/var/log/cisco/ASA.log"

    denial_counter = process_log_file(logfile)
    print_counter(denial_counter)
