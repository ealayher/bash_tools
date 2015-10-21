#!/bin/bash
#--------------------------------------------------------------------------------------#
# Created: 10/19/2015 By: Evan Layher (evan.layher@psych.ucsb.edu)
# Revised: 10/21/2015 By: Evan Layher
# Reference: github.com/ealayher
#--------------------------------------------------------------------------------------#
# Output absolute path of directory or file (equivalent to linux 'readlink -f' function)
# If input is not a valid file path then simply outputs the input

mac_readlink () { # Get absolute path of a file
	input_path="${1}"
	cwd="$(pwd)" # Current working directory path

	if [ -e "${input_path}" ]; then # if file or directory exists
		cd "$(dirname ${input_path})"
		abs_path="$(pwd)/$(basename ${input_path})"
		cd "${cwd}" # Change directory back to original directory
	fi

	if [ -e "${abs_path}" ] && ! [ -z "${abs_path}" ]; then
		echo "${abs_path}"
	else # Invalid input or script error
		echo "${input_path}" # echo original input
	fi
} # mac_readlink