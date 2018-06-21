#!/bin/bash
<<comment1
File Name      	:    bf0000_indof.sh
Created		    :    Jan 24, 2018
Description    	:    Calculate index of an element in an array.
Reference	    :	 https://www.unix.com/shell-programming-and-scripting/136910-how-check-index-array-element-shell-script.html 
Updated On     	:    x/x/xxxx
Update Notes   	:    x/x/xxxx       	blah blah blah blah...
comment1
#=======================================================================
#How to use functions:
#In order to call this function, write
#	source file.sh
#	x=$([name of function] $a ${b[@]})
#file.sh - this file name
#a - an element
#b - an array containing the element, a.
#x - retunred outptut
#
#=======================================================================
#List of Functions (ALPHABETICAL ORDER):
#
#element_contain_str
#            (in)    :   1. substring of interest
#                        2. array
#            (out)   :   an array of elements whose string contains the string of 
#                        interest.
#            desc    :   check to see if any elements in the given array contains
#                        the substring of intest.
#
#IndexOf     (in)    :   1.var of interest
#                        2. array
#            (out)   :   index number (note: index is starting from 1, not 0)
#                        If var of interest doesn't exist in the given array
#                        return 0.
#            desc    :   calculate index of var in array



function element_contain_str() {
    local str=$1; shift
    local arr=()
    local arrout=()

    #todo: add elements to an array
    while [ $str != $1 ]
    do
        arr+=( $1 ); shift
            [ -z "$1" ] && { break; }
    done

    for x in ${arr[@]};do
        if [[ $x == *$str* ]];then
            arrout+=( $x )
        fi
    done
#    echo $a
    echo ${arrout[@]}
}

function IndexOf()    {
	local i=1 S=$1;	shift  
    while [ $S != $1 ]
    do  
	((i++)); shift
        [ -z "$1" ] && { i=0; break; }
    done
	echo $i
}


#arr=( "xxxorangexxx" "xxxbananaxxx" )
#str="orange"
#
#a=($(element_contain_str $str ${arr[@]}))
##echo $a
#echo ${a[@]}

