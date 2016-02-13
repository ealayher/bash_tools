#!/bin/bash
#--------------------------------------------------------------------------------------#
# Created: 10/19/2015 By: Evan Layher (evan.layher@psych.ucsb.edu)
# Revised: 10/21/2015 By: Evan Layher
# Revised: 11/01/2015 By: Evan Layher # Accepts non-file inputs
# Reference: github.com/ealayher
#--------------------------------------------------------------------------------------#
# Output absolute path of directory or file (whether or not file exists)
# Equivalent to linux 'readlink -f' function except also deals with non-files
# If input directory is missing, then output is the input
# EXAMPLE USAGE: x=$(mac_readlink '../test_dir/test_file.sh')

mac_readlink () { # Get absolute path of a file
	dir_mac=$(dirname "${1}")   # Directory path
	file_mac=$(basename "${1}") # Filename
	wd_mac="$(pwd)" # Working directory path

	if [ -d "${dir_mac}" ]; then
		cd "${dir_mac}"
		echo "$(pwd)/${file_mac}" # Print full path
		cd "${wd_mac}" # Change directory back to original directory
	else
		echo "${1}" # Print input
	fi
} # mac_readlink
