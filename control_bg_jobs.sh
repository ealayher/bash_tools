#!/bin/bash
#--------------------------------------------------------------------------------------#
# Created: 06/22/2015 By: Evan Layher (evan.layher@psych.ucsb.edu)
# Revised: 10/21/2015 By: Evan Layher
# Revised: 09/09/2016 By: Evan Layher # Added safety measures
#--------------------------------------------------------------------------------------#
# Control the amount of background processes (&) that are active in a shell script
# Source this function (or copy it into script of interest)
# Input 'control_bg_jobs' below background processes

# EXAMPLE:
# for x in $(seq 1 1 1000); do # Process 1 thru 1000
# 	sleep 1 &                  # Send job to background with '&'
# 	control_bg_jobs            # Go to next iteration if background jobs <= 'max_bg_jobs'
# done
#--------------------------------------------------------------------------------------#
max_bg_jobs='5' # Maximum number of background processes (1-10)

control_bg_jobs () { # Controls number of background processes
	if [ "${max_bg_jobs}" -eq '1' 2>/dev/null ]; then
		wait # Proceed after all background processes are finished
	else
		if [ "${max_bg_jobs}" -gt '1' 2>/dev/null ] && [ "${max_bg_jobs}" -le '10' 2>/dev/null ]; then 
			true # Make sure variable is defined and valid number
		elif [ "${max_bg_jobs}" -gt '10' 2>/dev/null ]; then
			echo "RESTRICTING BACKGROUND PROCESSES TO 10"
			max_bg_jobs='10' # Background jobs should not exceed '10' (Lowers risk of crashing)
		else # If 'max_bg_jobs' not defined as integer
			echo "INVALID VALUE: max_bg_jobs='${max_bg_jobs}'"
			max_bg_jobs='1'
		fi
	
		job_count=($(jobs -p)) # Place job IDs into array
		if ! [ "$?" -eq '0' ]; then
			echo "JOB COUNT FAIL (control_bg_jobs): RESTRICTING BACKGROUND PROCESSES"
			max_bg_jobs='1'
			wait
		else
			if [ "${#job_count[@]}" -ge "${max_bg_jobs}" ]; then
				sleep 0.2
				control_bg_jobs
			fi
		fi # if ! [ "$?" -eq '0' ]
	fi # if [ "${max_bg_jobs}" -eq '1' 2>/dev/null ]
} # control_bg_jobs
