#!/bin/bash

<<comment1
File Name       :   bf0001_fcal.sh
Created         :   Feb 2, 2018
Description     :   Based on user's input,this script figure out processing dates.
Latest Updated  :   5/5/2018
Update Notes    :   5/5/2018    bf0002_nextXmonths.sh & bf0003_numdaysinmonth.sh are combined. 
                :   x/x/xxxx     blah blah blah blah...
comment1


#How to use this function:
#In order to call this function, write this in your script
#source file.sh
#    a=()    <= declare an array
#    a=$(fcal $b $c)
#
#file.sh - this file name
#a       - name of an array  (output)
#b       - forecasting month  (input)
#c       - forecasting year (input)

#Output data in array, a, is in the format of 'm:dd'.
#example -      1:16 1:21 1:26 1:31
#example -      a[0]=1:16

#the rest of function:
#fcal_fmmm : calculates forecasting month in the format of three characters
#           i.e. input forecasting month = 3 => output is mar

#fcal_fMmm : calculates forecasting month in the format of three characters
#            with the first character with uppercase. 
#           i.e. input forecasting month = 3 => output is Mar

#fcal_icm : calculates initial condition month based on forecasting month input.
#           output is an integer.
#           i.e. input forecasting month = 3 => output is 2

#fcal_icmmd :   calculates initial condition month and day in the format of mmd
#               witht the input of forecsting month and year                
#               i.e. input forecasting month & year= 4 2018 => output is 0312 0317 0322 0327.

#fcal_icmmm : cacluates initial condition month in the format of three characters.
#           i.e. input forecasting month = 3 thus ic month = 2    =>  output is feb

#fcal_icmmmd : calculates intial condtion date in the format of mmmd.
#           i.e. input forecasting month/year => output is feb10 feb15 feb20 feb25

#fcal_icy : calculates initial condition year. 
#           i.e. input forecasting (month, year) = (3,2018) => output is 2018
#           i.e. input forecasting (month, year) = (1,2018) => output is 2017

#fcal_mmm2mm : calculates month in two digit format (i.e. 04) based on month 
#              in 3-character format (i.e. apr).
#           i.e. input month = mar => output is 03
#           i.e. input month = dec => output is 12


#=============================================================
#       Instruction for 'nextXmonths' Functions
#=============================================================
#instruction:
#source file.sh
#    a=()    <= declare an array
#    a+=( $(nextXmonths $b $c $d $e) )
#
# file.sh - this file name
# a       - name of an array  (output)
# b       - forecasting year  (input)
# c       - forecasting month (input)
# d       - starting month shift
# e       - number of next months
# *note: input 'd' let users shift starting month. d=0 will starting month is $c. d=1 set starting month to be $d+1. 
#        d=-1 sets starting month to be $d-1. The allowed shift range is (-12 12)
#
# For instance, if your inputs are
# b=2018 
# c=1
# d=1
# e=10
# outputs will be:
# 02:2018 03:2018 04:2018 05:2018 06:2018 07:2018 08:2018 09:2018 10:2018 11:2018
#
# Another example:
# b=2018 
# c=1
# d=-1
# e=9
# outputs will be:
# 12:2017 01:2018 02:2018 03:2018 04:2018 05:2018 06:2018 07:2018 08:2018

# *note: input 'e' is a number of consecutive month that user need from starting month. For instance,
#        user need 5 month total including starting month, enter 5. If starting month is January, the output
#        will be Jan, Feb, Mar, Apr, and May. 


#nextXmonths_mmmyyyy : give the same output as nextXmonths except that months are in the format of three characters
#                       i.e. mar, Mar, apr, Apr
#                       a=$(nextXmonths_mmmyyyy $b $c $d $e $f )
# a       - name of an array  (output)
# b       - forecasting year  (input)
# c       - forecasting month (input)
# d       - starting month shift
# e       - number of next months
# f       - "l" or "u". "l" for lowercase (i.e. mar). "u" for upper case (i.e. Mar)

#example
#input:     a=$(nextXmonths_mmmyyyy 2018 3 0 9 u)
#output:    Mar:2018 Apr:2018 May:2018 Jun:2018 Jul:2018 Aug:2018 Sep:2018 Oct:2018 Nov:2018

#input:     a=$(nextXmonths_mmmyyyy 2018 3 0 9 l )
#output:    mar:2018 apr:2018 may:2018 jun:2018 jul:2018 aug:2018 sep:2018 oct:2018 nov:2018


#nextXmonths_yyyymm : give the same output as nextXmonths except that months are in the format of two digits and year is followed by it.
#input:     a=$(nextXmonths_yyyymm 2018 4 0 9)
#output:    201804 201805 201806 201807 201808 201809 201810 201811 201812


#nextXmonths_seasonalStrMMM
#this function uses nextXmonths_mmmyyyy to get Mmm:yyyy output with the first character in upper case. 
#Then, takes the the first character of three months and concatenate them.
#input:     a+=( $(nextXmonths_seasonalStrMMM 2018 4 9 ) )
#output:    AMJ MJJ JJA JAS ASO SON OND



#=============================================================
#           'numdays' Function Descriptions
#=============================================================
#numdaysinmonth :  calculates number of days in a given month.
#       input a=$(numdaysinmonth $b $c)
#       output a = (number)             

#numdays_Xmonths:  calculates number of days within the input time range
#       input x=$(numdays_Xmonths [int month] [int year] [int shift] [int number of months
#       output x=[int number]
#       i.enumdays=$(numdays_Xmonths $fmonth $fyr 0 9 )

arrmmm=("jan" "feb" "mar" "apr" "may" "jun" "jul" "aug" "sep" "oct" "nov" "dec")
arrNLMdays=(31 28 31 30 31 30 31 31 30 31 30 31)
arrLMdays=(31 29 31 30 31 30 31 31 30 31 30 31)

function fcal() {
    local month=$1
    local year=$2
    
    #todo: setup arrays and variables.
    local arrMdays=()
    
    local arrJmonthend=()
    local arrNLJmonthend=(31 59 90 120 151 181 212 243 273 304 334 365)
    local arrLJmonthend=(31 60 91 121 152 182 213 244 274 305 335 366)

    local arrMM=()
    local arrDD=()
    local arrMM4=()
    local arrDD4=()
    local arrFMM4=()
    local arrFDD4=()
    local arr=()

    local numdys=0
    local jfcstd=1
    local daysadded=0
    local daystart=0
    local icmonth=0

    arrJfcst+=("$jfcstd")
    
    if (( $month == 1 ));then 
        icmonth=$((month+11))
    else 
        icmonth=$((month-1))
    fi
    
    #todo: leap year check and copy *Days array to arrJmonthend. Also create arrJfcst with Julidan day for
    #      forecast days.
    local remainder=$(($year % 4))
    
    #todo: calculates julian calendar for the forecasting dates
    if [ $remainder == 0 ]
    then
        #Leap year:  
        arrJmonthend=("${arrLJmonthend[@]}")
        arrMdays=("${arrLMdays[@]}")
        numdys=366
        while [ $jfcstd -lt $numdys ]
        do
            #for leap year, extra day needs to be added to julian day for Febrary 25.
            if [ $jfcstd -eq 56 ]
            then
                jfcstd=$((jfcstd + 6))
            else
                jfcstd=$((jfcstd + 5))
            fi
    
            if [ $jfcstd -lt $numdys ]; then arrJfcst+=("$jfcstd"); fi
        done
    
    else
        #Non-Leap year:
        arrJmonthend=("${arrNLJmonthend[@]}")
        arrMdays=("${arrNLMdays[@]}")
        numdys=365
        while [ $jfcstd -lt $numdys ]
        do
            jfcstd=$((jfcstd + 5))
            if [ $jfcstd -lt $numdys ]; then arrJfcst+=("$jfcstd");    fi
        done
    fi
    
    #todo: calculates month for selected julian day.
    #for ((i=0; i<${#arrJfcst[@]}; i++)); do
    #    jday=${arrJfcst[i]}
    for jday in ${arrJfcst[@]}; do
        for ((ii=0; ii<${#arrJmonthend[@]}; ii++)); do
            local jmonthend=${arrJmonthend[ii]}
            local month=$((ii+1))
    
            if [ $jday -le $jmonthend ]; then
                arrMM+=("$month")
                break
            fi
        done
    done
    #echo ${arrMM[@]}
    
    #todo: figure out day of the month for each forecasting julian day.
    #for ((i=0; i<${#arrMdays[@]}; i++)); do
    #    endday=${arrMdays[i]}
    for endday in ${arrMdays[@]}; do
        for ((ii=$daystart; ii<${#arrJfcst[@]}; ii++)); do
            local jday=${arrJfcst[ii]}
            local jday=$((jday - daysadded))
    
            if [ $jday -le $endday ]; then
                arrDD+=("$jday")                        
            else [ $jday -lt $endday ]
                daysadded=$((daysadded + endday))
                daystart=$ii
                break
            fi
        done    
    done
    
    #todo: figure out dates only for post-processing.
    for ((i=1; i<13; i++))
    do
        local cnt=0
        local arrtMM=()
        local arrtDD=()

        for ((ii=0; ii<${#arrMM[@]}; ii++)); do
            MM=${arrMM[ii]}
            DD=${arrDD[ii]}
            
            if [ $MM -eq $i ]
            then 
                arrtMM+=("$MM")
                arrtDD+=("$DD")
                let cnt++
            fi
        done
    
        #todo: calc starting index    
        sstart=$((cnt-4))
    
        #todo: extract last 4 forecast days of the month    
        for ((iii=$sstart; iii<${#arrtMM[@]}; iii++)); do
            MM4=${arrtMM[iii]}
            DD4=${arrtDD[iii]}
            arrMM4+=("$MM4")
            arrDD4+=("$DD4")
        done
    done
    
    
    #todo: save arrMM4 and arrDD4 elements to a file
    #if [ -f $frm ];then rm $frm; fi
    
    for ((i=0; i<${#arrMM4[@]}; i++)); do
        if [ ${arrMM4[i]} -eq $icmonth ]; then
            #todo: for january forecast, max year should be next year
            if [ $month -eq 1 ]; then
                yrmax=$((year+1))
            else
                yrmax=$year
            fi
    
            arrFMM4+=("${arrMM4[i]}")
            arrFDD4+=("${arrDD4[i]}") 
        fi
    done
    
    
    for ((i=0; i<${#arrFMM4[@]}; i++)); do
        arr+=("${arrFMM4[i]}":"${arrFDD4[i]}")
    done
    
    echo ${arr[@]}
}

function fcal_fmmm() {
    local month=$1
    local fmmm=${arrmmm[$(( month - 1 ))]}

    echo $fmmm
}

function fcal_fMmm() {
    local month=$1
    local fmmm=${arrmmm[$(( month - 1 ))]}
    fMmm="$(tr '[:lower:]' '[:upper:]' <<< ${fmmm:0:1})${fmmm:1}"

    echo $fMmm
}

function fcal_icm() {
    local month=$1  #<== forecasting month
    icm=$(( month - 1 ))

    if (( $icm < 1 ));then
        icm=12
    fi
    echo $icm
}

function fcal_icmmd() {
    local month=$1
    local yr=$2
    local arrtmp=()
    local arrmmd=()

    arrtmp=$(fcal $month $yr)

    for x in ${arrtmp[@]};do
        IFS=':' read -ra mmdd <<< "$x"
        mm=`printf "%02g" ${mmdd[0]}`
        d=`printf "%02g" ${mmdd[1]}`
        arrmmd+=(${mm}${d}) #<=  mmdd[0]=month; mmdd[1]=day
    done
    echo ${arrmmd[@]}


}

function fcal_icmmm() {
    local month=$1  #<== forecasting month

    local icm=$(fcal_icm $fmonth)
    local ind=$(( icm - 1 ))
    local icmmm=${arrmmm[$ind]}

    echo $icmmm
}

function fcal_icmmmd() {
    local month=$1
    local yr=$2
    local arrmmmd=()
    local arrx=$(fcal $month $yr)

    for x in ${arrx[@]}; do
        IFS=":" read -ra var <<< "$x"
        local ind=$(( var[0] - 1 ))
        local int_d=${var[1]}
        local mmm=${arrmmm[$ind]}
        arrmmmd+=( $mmm$int_d )
    done
    
    echo ${arrmmmd[@]}
}

function fcal_icy() {
    local month=$1  #<== forecasting month
    local yr=$2
    local icy

    if (( $month == 1 ));then
        icy=$(( yr - 1 ))
    else 
        icy=$yr
    fi
    echo $icy
}

function fcal_mmm2mm() {
    local mmm=$1

    for (( i=0; i<${#arrmmm[@]}; i++));do
        if [ "${arrmmm[i]}" = "$mmm" ]; then
            ii=$(( i+1 ))
            mm=`printf "%02g" $ii`
            break
        fi
    done

    echo $mm
}


function nextXmonths()    {
    local iny=$1
    local inm=$2
    local insft=$3
    local innextm=$4
    local arrmon=()

    local inyr=0
    local inmon=0

    local a=$(( inm + insft ))

    if (( $insft == 0 )); then
        inyr=$iny
        inmon=$inm
    elif (( $a <= 0 )); then
        inyr=$(( iny - 1 ))
        inmon=$(( 12 + a ))
    elif (( $a > 12 ));then
        inyr=$(( iny + 1 ))
        inmon=$(( a - 12 ))
    else
        inyr=$iny
        inmon=$(( inm + insft ))
    fi


    if (( $(( inmon + innextm - 1 )) < 13 )); then
        local arr=$(seq -f "%02g" $inmon $((inmon + innextm - 1)))
        for x in ${arr[@]};do arrmon+=($x":"$inyr);done
    else
        #note: may to dec- 9months goes to next year ($yrmin+1)
        local arr1=()
        local arr2=()
        #todo: get months all the way up to december. 
        arr1=($(seq -f "%02g" $inmon 12))
        for x in ${arr1[@]};do
            arrmon+=($x":"$inyr)
        done

        #todo: figure out the rest of months in next year ($yrmin +1)
        local numele=${#arr1[@]}
        local maxrange=$(( innextm - numele ))
        local lastnum=${arr1[$((numele-1))]}

        for (( x=0;x<$((maxrange)); x++));do
            local y=$((x + 1))
            arr2+=( `printf "%02g" $y`)
        done
        for x in ${arr2[@]};do
            arrmon+=(`echo $x":"$((inyr+1))`)
        done
    fi
    echo ${arrmon[@]}
}

function nextXmonths_mmmyyyy {
    local iny=$1
    local inm=$2
    local insft=$3
    local innextm=$4
    local ccase=$5
    local arr=()
    local arrout=()

    local arr=$(nextXmonths $iny $inm $insft $innextm)

    if [[ $ccase == "l" ]];then
        for x in ${arr[@]}; do
            IFS=":" read -ra var <<< "$x"
            var2=${var[0]#0}
            local int_m=$(( var2 - 1 ))
            local yr=${var[1]}
            local fmmm=${arrmmm[$int_m]}
            arrout+=( $fmmm":"$yr )
        done
    elif [[ $ccase == "u" ]];then
        for x in ${arr[@]}; do
            IFS=":" read -ra var <<< "$x"
            var2=${var[0]#0}
            local int_m=$(( var2 - 1 ))
            local yr=${var[1]}
            local fmmm=${arrmmm[$int_m]}
            fmmm="$(tr '[:lower:]' '[:upper:]' <<< ${fmmm:0:1})${fmmm:1}"
            arrout+=( $fmmm":"$yr )
        done
    fi

    echo ${arrout[@]}
}

function nextXmonths_yyyymm()   {
    local iny=$1
    local inm=$2
    local insft=$3
    local innextm=$4
    local arrout=()
    local arr=()

    arr=$(nextXmonths $iny $inm $insft $innextm)
    for xx in ${arr[@]};do
        IFS=":" read -ra var2 <<< "$xx"
        arrout+=( "${var2[1]}${var2[0]}" )
    done

    echo ${arrout[@]}
}

function nextXmonths_seasonalStrMMM() {
    local yr=$1
    local fm=$2
    local nextm=$3

    local arr_mmmyyyy=$(nextXmonths_mmmyyyy $yr $fm 0 $nextm u)
    local arr=()

    for x in ${arr_mmmyyyy[@]};do
        y+=${x:0:1}
    done

    for i in $(seq 0 $(( nextm -2 -1)));do
        arr+=(${y:$i:3})
    done
    echo ${arr[@]}
}



function numdaysinmonth()    {
    local mon=$1
    local yr=$2

    lp=$(( yr % 4 ))
    ii=$(( mon - 1 ))

    if (( $lp == 0 ));then
        nummon=${arrLMdays[ii]}
    else
        nummon=${arrNLMdays[ii]}
    fi
    echo $nummon
}

function numdays_Xmonths() {

    local mon0=$1
    local yr0=$2
    local cft=$3
    local nummon=$4

    local arrXmonths=$(nextXmonths $yr0 $mon0 $cft $nummon)  #<== output is in format of mm:yyyy
    local ndays=0
    
    for x in ${arrXmonths[@]}; do
        IFS=":" read -ra var <<<"$x"
        a=${var[0]#0}   #<== month
        b=${var[1]#0}   #<== year
        days=$(numdaysinmonth $a $b)
        ndays=$(( ndays + days ))
    done
    echo $ndays

}


