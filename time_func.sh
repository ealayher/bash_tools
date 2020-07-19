#!/bin/bash
#--------------------------------------------------------------------------------------#
# Created: 08/31/2014 By: Evan Layher (1.0) (layher@psych.ucsb.edu)
# Revised: 10/21/2015 By: Evan Layher (1.1)
# Revised: 09/09/2015 By: Evan Layher (1.2) Time output only and allow user input
# Revised: 12/15/2017 By: Evan Layher (1.3) Minor updates
#--------------------------------------------------------------------------------------#
# Display process time of a script
# Simply source this script and input: time_func

# EXAMPLE:
#--------------------------------------------------------------------------------------#
#!/bin/sh
#source time_func.sh
#echo "Science is awesome"
#time_func
#exit 0
#--------------------------------------------------------------------------------------#

## --- LICENSE INFORMATION --- ##
## script_time_func.sh is the proprietary property of The Regents of the University of California ("The Regents.")

## Copyright © 2014-17 The Regents of the University of California, Davis campus. All Rights Reserved.

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

start_time=$(date +%s) # Time in seconds

time_func () { # Script process time calculation
	func_end_time=$(date +%s) # Time in seconds
	input_time="${1}"
	valid_time='yes'
	
	if ! [ -z "${input_time}" ] && [ "${input_time}" -eq "${input_time}" 2>/dev/null ]; then
		func_start_time="${input_time}"
	elif ! [ -z "${start_time}" ] && [ "${start_time}" -eq "${start_time}" 2>/dev/null ]; then
		func_start_time="${start_time}"
	else # If no integer input or 'start_time' undefined
		valid_time='no'
	fi
	
	if [ "${valid_time}" == 'yes' ]; then
		process_time=$((${func_end_time} - ${func_start_time}))
		days=$((${process_time} / 86400))
		hours=$((${process_time} % 86400 / 3600))
		mins=$((${process_time} % 3600 / 60))
		secs=$((${process_time} % 60))
	
		if [ "${days}" -gt '0' ]; then 
			echo "PROCESS TIME: ${days} day(s) ${hours} hour(s) ${mins} minute(s) ${secs} second(s)"
		elif [ "${hours}" -gt '0' ]; then
			echo "PROCESS TIME: ${hours} hour(s) ${mins} minute(s) ${secs} second(s)"
		elif [ "${mins}" -gt '0' ]; then
			echo "PROCESS TIME: ${mins} minute(s) ${secs} second(s)"
		else
			echo "PROCESS TIME: ${secs} second(s)"
		fi
	else # Unknown start time
		echo "UNKNOWN PROCESS TIME"
	fi # if [ "${valid_time}" == 'yes' ]
} # time_func
