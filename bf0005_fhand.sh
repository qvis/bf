#!/bin/bash

<<comment1
File Name       :    bf0005_fhand.sh
Created         :    June 6, 2018
Description     :    Handling files (i.e. cp, mv, rm, etc.).
Latest Updates  :    xx/xx/xxxx
Update Notes    :    xx/xx/xxxx     blah blah blah blah...
comment1

#note: 
#use these function to get function script to cp to a dir of interest.
#function getscr() {

#    #todo: copy scripts.
#    local d=$1 (dir to copy script files to)
#    local f=$2 (script of interest)
#    cd $HMK/scripts/bash
#    source bf0005_fhand.sh
#    fhand_cpscrone $d $f
#    cd - >/dev/null
#    return
#}
#
#function rmscr() {
#    #todo: remove all scripts copied from ~$USER.
#    local d=$1 
#    cd $HMK/scripts/bash
#    source bf0005_fhand.sh
#    fhand_rmscrall $d
#    cd - >/dev/null
#    return
#}


#List of Functions (ALPHABETICAL ORDER):
#fhand_cpfall    :   copy all files in dir1 to dir2.
#                    input - 1 dir origin
#                            2 dir destination
#fhand_cpjpano   :   copy panoply jar files one script 
#                    in $HMK/panoplycl/*.jar
#                    input - 1 current dir
#fhand_cpscrall  :   copy scripts in $HMK/scripts/*.
#                    input - 1 current dir
#fhand_cpscrone  :   copy one script in $HMK/scripts/*.
#                    input - 1 current dir
#                            2 script name
#fhand_getfname  :   place all file names in $1 dir in an array.
#                    input - 1 current dir
#                            2 command (i.e. "*","*.rst")
#fhand_getfnum   :   return number of files in $1 dir.
#                    input - 1 current dir
#                            2 command (i.e. "*","*.rst")
#fhand_rmfall    :   remove all files in dir2 after diff with files originally 
#                    located dir1.
#                    input - 1 dir origin
#                            2 dir destination
#fhand_rmjpano   :   remove panoply jar files from $cdir.
#                    input - 1 current dir
#fhand_rmscrall  :   remove unnecessary scripts from pwd after diff with 
#                    scripts in $HMK/scripts/*.
#                    input - 1 current dir

#global vars

dkn=$HMK/'scripts'
dpano=$HMK/'panoplycl'
arrd=( 'bash' 'python' )

function fhand_cpfall() {
    local odir=$1
    local cdir=$2
    cp -p $odir/* $cdir/.
}

function fhand_cpjpano() {
    local cdir=$1
    cp -p $dpano/*.jar $cdir/.
    return
}
function fhand_cpscrall() {
    #note: $1 is a dir, where scripts are going to be copied. 
    local cdir=$1
    for d in ${arrd[@]}; do cp -p $dkn/$d/* $cdir/.; done
    return
}

function fhand_cpscrone() {
    #note: $1 is a dir, where scripts are going to be copied. 
    local cdir=$1
    local f=$2
    local str=${f:0:1}
    cp -p $dkn/${str}*/$f $cdir/.
    return
}

function fhand_getfname() {
    #note: $1 = directory; $2=command (i.e. "*", "*.tst")
    local dir=$1
    local cm=$2
    
    shopt -s nullglob
    cd $dir
    arr=( $cm )
    cd - > /dev/null
    shopt -u nullglob
    echo ${arr[@]}
}


function fhand_getfnum() {
    #note: $1 = directory; $2=command (i.e. "*", "*.tst")
    local dir=$1
    local cm=$2
    local arr=()

    arr=($(fhand_getfname $dir $cm))
    echo ${#arr[@]}
}


function fhand_rmfall() {
    local odir=$1
    local cdir=$2

    cd $odir
    shopt -s nullglob
    local arr=( * )
    shopt -u nullglob
    cd - >/dev/null

    for f in ${arr[@]};do
        if [ -f $cdir/$f ];then
            if diff "$odir/$f" "$cdir/$f" > /dev/null; then rm $cdir/$f; fi
        fi
    done
    return
}

function fhand_rmjpano() {
    local cdir=$1
    rm -f $cdir/*.jar
    return
}

function fhand_rmscrall() {
    #note: $1 is a dir, where scripts are supposedly exists.
    local cdir=$1

    for d in ${arrd[@]};do
        shopt -s nullglob
        cd $dkn/$d
        local arr=( * )
        cd - >/dev/null
        shopt -u nullglob
            
        dscr=$dkn/$d
        for f in ${arr[@]};do
            if [ -f $cdir/$f ];then
                if diff "$cdir/$f" "$dscr/$f" > /dev/null; then rm $cdir/$f; fi
            fi
        done
    done
    return
}



