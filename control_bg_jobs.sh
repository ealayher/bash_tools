#!/bin/bash
#--------------------------------------------------------------------------------------#
# Created: 06/22/15 By: Evan Layher (evan.layher@psych.ucsb.edu)
# Revised: 10/21/15 By: Evan Layher
#--------------------------------------------------------------------------------------#
# Control the amount of background processes (&) that are active in a shell script
# Source this function (or copy it into script of interest)
# Input 'control_bg_jobs' below background processes

# EXAMPLE:
# for x in `seq 1 1 1000`; do # Process 1 thru 1000
# sleep 1 &                   # Send job to background with '&'
# control_bg_jobs             # Go to next iteration if background jobs <= 'max_bg_jobs'
# done
#--------------------------------------------------------------------------------------#
max_bg_jobs='10' # Maximum number of background processes

control_bg_jobs () { # Controls number of background processes
	job_count=`jobs -p |wc -l`
	if [ "${job_count}" -ge "${max_bg_jobs}" ]; then
		sleep 0.25     # Check every 0.25 seconds
		control_bg_jobs
	fi
} # control_bg_jobs


