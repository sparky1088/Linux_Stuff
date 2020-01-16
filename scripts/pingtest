#!/bin/bash

## this is a simple ping test and writes failures to file called test
## It is currently broken

ping -c 1 10.10.10.1
    if [ "$?" -ge 1 ]
        then echo $(date) >> pingtest
    fi
