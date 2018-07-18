#!/bin/bash

<<comment1
File Name       :    bf0006_cdo.sh
Created         :    June 17, 2018
Description     :    process netcdf file with cdo
Latest Updates  :    xx/xx/xxxx
Update Notes    :    xx/xx/xxxx     blah blah blah blah...
comment1

#Note: the main scripts, which are calling these function has to load the module.
#       Otherwise, these functions don't work.
#Example:
#. /usr/share/modules/init/bash
#module load cdo/1.9.0

#Available functions ( alphabetical order )
#cdo_getmean    :   using cdo infon, get mean values.
#cdo_ymmend     :   using cdo infon, figure out the ending ymm (i.e. 197902)
#                   (input)     :   1. netcdf file name
#                   (output)    :   end yyyymm
#cdo_ymmstart   :   using cdo infon, figure out the starting ymm (i.e. 197901)
#                   (input)     :   1. netcdf file name
#                   (output)    :   start yyyymm

function cdo_getmean(){
    local fnc=$1
    local ind=$2   
    val=`cdo -s infon $fnc | head -$((ind+1)) | tail -1 | cut -d':' -f5 | tr -s '[:space:]'` 
    echo $val
}

function cdo_ymm() {
    #todo: return ending year and month
    local fnc=$1
    local ind=$2
    yy=`cdo -s infon $fnc | head -$((ind+1)) | tail -1 | cut -d':' -f2 | cut -d' ' -f2 | cut -d'-' -f1`
    mm=`cdo -s infon $fnc | head -$((ind+1)) | tail -1 | cut -d':' -f2 | cut -d' ' -f2 | cut -d'-' -f2`
    yymm=$yy$mm

    echo $yymm
}


function cdo_ymmend() {
    #todo: return ending year and month
    local fnc=$1
    yy=`cdo -s infon $fnc | tail -1 | cut -d':' -f2 | cut -d' ' -f2 | cut -d'-' -f1`
    mm=`cdo -s infon $fnc | tail -1 | cut -d':' -f2 | cut -d' ' -f2 | cut -d'-' -f2`
    endyymm=$yy$mm

    echo $endyymm
}


function cdo_ymmstart() {
    #todo: return starting year and month
    local fnc=$1
    yy=`cdo -s infon $fnc | head -2 | tail -1 | cut -d':' -f2 | cut -d' ' -f2 | cut -d'-' -f1`
    mm=`cdo -s infon $fnc | head -2 | tail -1 | cut -d':' -f2 | cut -d' ' -f2 | cut -d'-' -f2`
    startyymm=$yy$mm

    echo $startyymm
}


