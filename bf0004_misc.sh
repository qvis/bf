#!/bin/bash

<<comment1
File Name      	:      	misc.sh
Created		    :      	Apr 12, 2018
Description    	:       Miscellaneous bash functions.
Updated On     	:      	x/x/xxxx
Update Notes   	:      	x/x/xxxx    blah blah blah blah...

List of Functions (ALPHABETICAL ORDER):
strindex    : find a character index.


comment1


#strindex instruction:
#In order to call this function, source this file in your script as:
#   source file.sh
#   a=$(strindex "b" "c")
#
# file.sh   - this file name
# a         - output variable 
# b         - a string
# c         - a character that you want to find an index for
#
#sample:
#   x="abcdefg.hijklmn.x"
#   i=$(strindex "$x" ".")
#   output: 7

function strindex() { 
      x="${1%%$2*}"
        [[ "$x" = "$1" ]] && echo -1 || echo "${#x}"
    }


