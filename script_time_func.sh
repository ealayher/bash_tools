#!/bin/bash
#--------------------------------------------------------------------------------------#
#Created: 08/31/2014 By: Evan Layher (ealayher@ucdavis.edu: UC Davis Medical Center)
#Latest Revision: 12/13/2014 By: Evan Layher
#--------------------------------------------------------------------------------------#
# Calculates the amount of time it takes to run a shell script
# Simply source this script and input: script_time_func

# EXAMPLE:
#--------------------------------------------------------------------------------------#
#!/bin/sh
#source ${HOME}/.ealayher_code/script_time_func.sh
#echo "Science is awesome"
#script_time_func
#exit 0
#--------------------------------------------------------------------------------------#

## --- LICENSE INFORMATION --- ##
## script_time_func.sh is the proprietary property of The Regents of the University of California ("The Regents.")

## Copyright © 2014 The Regents of the University of California, Davis campus. All Rights Reserved.

## Redistribution and use in source and binary forms, with or without modification, are permitted by nonprofit, 
## research institutions for research use only, provided that the following conditions are met:

## • Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer
## • Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer 
##	in the documentation and/or other materials provided with the distribution. 
## • The name of The Regents may not be used to endorse or promote products derived from this software without specific prior written permission.

## The end-user understands that the program was developed for research purposes and is advised not to rely exclusively on the program for any reason.

## THE SOFTWARE PROVIDED IS ON AN "AS IS" BASIS, AND THE REGENTS HAVE NO OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
## THE REGENTS SPECIFICALLY DISCLAIM ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY, 
## FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
## IN NO EVENT SHALL THE REGENTS BE LIABLE TO ANY PARTY FOR DIRECT, INDIRECT, SPECIAL, INCIDENTAL, EXEMPLARY OR CONSEQUENTIAL DAMAGES, 
## INCLUDING BUT NOT LIMITED TO  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES, LOSS OF USE, DATA OR PROFITS, OR BUSINESS INTERRUPTION, 
## HOWEVER CAUSED AND UNDER ANY THEORY OF LIABILITY WHETHER IN CONTRACT, STRICT LIABILITY OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
## ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

## If you do not agree to these terms, do not download or use the software.  
## This license may be modified only in a writing signed by authorized signatory of both parties.

## For commercial license information please contact copyright@ucdavis.edu.
## --------------------------- ##

#------------------------- GENERAL SCRIPT VARIABLES ------------------------#
STARTTIME=`date +%s` ### This will be used to calculate the PROCESS TIME:.
DAY_and_TIME_at_start=`date +%x' '%r`
script_time_func_path="$(readlink -f ${BASH_SOURCE[0]})"
#------------------------- CALCULATES PROCESS TIME: ------------------------#
specific_start_time () {
echo "STARTED : ${DAY_and_TIME_at_start}"
echo "FINISHED: `date +%x' '%r`"
}

script_time_func () {
ENDTIME=`date +%s`
SCRIPTTIME=$(($ENDTIME - $STARTTIME))
if [ $SCRIPTTIME -lt 60 ];then
specific_start_time 
echo "PROCESS TIME: $SCRIPTTIME second(s)."
elif [ $SCRIPTTIME -lt 3600 ];then
specific_start_time 
echo "PROCESS TIME: $(($SCRIPTTIME / 60)) minute(s) and $(($SCRIPTTIME % 60)) second(s)."
elif [ $SCRIPTTIME -lt 86400 ];then
specific_start_time 
echo "PROCESS TIME: $(($SCRIPTTIME / 3600)) hour(s) $(($SCRIPTTIME % 3600 / 60)) minute(s) and $(($SCRIPTTIME % 60)) second(s)."
elif [ $SCRIPTTIME -ge 86400 ];then
specific_start_time 
echo "PROCESS TIME: $(($SCRIPTTIME / 86400)) day(s) $(($SCRIPTTIME % 86400 / 3600)) hour(s) $(($SCRIPTTIME % 3600 / 60)) minute(s) and $(($SCRIPTTIME % 60)) second(s)."
else
echo "Not a valid time measurment for 'script_time_func.sh'"
fi
}

#---------------------------------- CODE -----------------------------------#
ealayher_code_dir="${HOME}/.ealayher_code"

# Creates master copy of script
if ! [ -d ${ealayher_code_dir} ]; then
mkdir ${ealayher_code_dir}
fi
cp ${script_time_func_path} ${ealayher_code_dir}
