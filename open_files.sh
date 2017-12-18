#!/bin/bash
#--------------------------------------------------------------------------------------#
# Created: 05/05/2015 By: Evan Layher (layher@psych.ucsb.edu)
# Revised: 05/19/2015 By: Evan Layher
# Revised: 10/21/2015 By: Evan Layher # Mac compatible and minor changes
# Revised: 12/17/2017 By: Evan Layher # Simplified function
#--------------------------------------------------------------------------------------#
# Open files in background from command line
#-------------------------------- VARIABLES --------------------------------#
text_editors=('kwrite' 'kate' 'gedit' 'open -a /Applications/BBEdit.app' 'open') # GUI text editor commands in preference order

open_text_editor () { # Opens input file in background (GUI text editors only)
	open_file="${1}"  # Input file
	valid_editor='no' # Remains 'no' until command is valid
	
	if ! [ -z "${open_file}" ] && ! [ -f "${open_file}" ]; then # If input file exists
		echo '' > "${open_file}"
	fi
	
	for i in ${!text_editors[@]}; do # Loop through indices
		eval "${text_editors[${i}]} ${open_file} 2>/dev/null &" # eval for complex commands
		pid="$!" # Background process ID
		check_pid=($(ps "${pid}" |grep "${pid}")) # Check if pid is running
			
			if [ "${#check_pid[@]}" -gt '0' ]; then
				valid_editor='yes'
				break
			fi # Break loop when valid command is found
		done

		if [ "${valid_editor}" == 'no' 2>/dev/null ]; then
			echo "NO VALID TEXT EDITOR COMMANDS IN 'text_editors' ARRAY:"
			printf "%s\n" ${text_editors[@]}
			exit 1
		fi
} # open_text_editor

#---------------------------------- CODE -----------------------------------#
if [ -z "${1}" ]; then
	open_text_editor
else
	for i in ${@}; do
		open_text_editor "${i}"
	done
fi