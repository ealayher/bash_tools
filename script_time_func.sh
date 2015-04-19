#!/bin/bash
#--------------------------------------------------------------------------------------#
#Created: 08/31/2014 By: Evan Layher (ealayher@ucdavis.edu: UC Davis Medical Center)
#Revised: 04/18/2014 By: Evan Layher
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
script_start_time=`date +%s` 			# Script start time (in seconds).
script_start_date_time=`date +%x' '%r` 		# Script start date and time: (e.g. 01/01/2015 12:00:00 AM)
script_path="$(readlink -f ${BASH_SOURCE[0]})" 	# Full path of this script
#------------------------- CALCULATES PROCESS TIME: ------------------------#
script_time_message () { # Displays message
echo "STARTED : ${script_start_date_time}"
echo "FINISHED: `date +%x' '%r`"
}

script_time_func () { # Calculates process time
script_end_time=`date +%s`
script_process_time=$((${script_end_time} - ${script_start_time}))
if [ ${script_process_time} -lt 60 ]; then
script_time_message 
echo "PROCESS TIME: ${script_process_time} second(s)."
elif [ ${script_process_time} -lt 3600 ]; then
script_time_message 
echo "PROCESS TIME: $((${script_process_time} / 60)) minute(s) and $((${script_process_time} % 60)) second(s)."
elif [ ${script_process_time} -lt 86400 ]; then
script_time_message 
echo "PROCESS TIME: $((${script_process_time} / 3600)) hour(s) $((${script_process_time} % 3600 / 60)) minute(s) and $((${script_process_time} % 60)) second(s)."
elif [ ${script_process_time} -ge 86400 ]; then
script_time_message 
echo "PROCESS TIME: $((${script_process_time} / 86400)) day(s) $((${script_process_time} % 86400 / 3600)) hour(s) $((${script_process_time} % 3600 / 60)) minute(s) and $((${script_process_time} % 60)) second(s)."
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
cp ${script_path} ${ealayher_code_dir}
