#!/bin/bash
#--------------------------------------------------------------------------------------#
# Created: 06/22/15 By: Evan Layher (evan.layher@psych.ucsb.edu)
# Revised: 10/21/15 By: Evan Layher # (1.2): Mac compatible plus minor alterations
# Revised: 12/13/17 By: Evan Layher # (1.3): Minor updates
#--------------------------------------------------------------------------------------#
# Create template function with backslashes before $ " \ ` characters
# Then copy and paste this function into 'create_script.sh'
#--------------------------- DEFAULT SETTINGS ------------------------------#
text_editors=('kwrite' 'kate' 'gedit' 'open -a /Applications/BBEdit.app' 'open') # GUI text editor commands in preference order
script_number='1' # Default script number

#------------------------- SCRIPT HELP MESSAGE -----------------------------#
usage () { # Help message: '-h' or '--help' option
	echo "${red}HELP MESSAGE: ${gre}${script_path}${whi}
${ora}DESCRIPTION${whi}: Make 'create_script' function and copy into 'create_script.sh'
     
${ora}USAGE${whi}: Input template script and script number
 [${ora}1${whi}] ${gre}${script_path}${ora} ${HOME}/template.sh ${red}5${whi}
     
${ora}OPTIONS${whi}: Can input multiple options in any order
 ${pur}-h${whi} or ${pur}--help${whi} Display this message
 ${pur}-nc${whi}  Prevent color printing in terminal
 ${pur}-o${whi} or ${pur}--open${whi} Open this script
     
${ora}DEFAULT SETTINGS${whi}:
 script number: ${gre}${script_number}${whi}
     
${ora}VERSION: ${gre}${version}${whi}
${red}END OF HELP: ${gre}${script_path}${whi}"
	exit_message 0
} # usage

#----------------------- GENERAL SCRIPT VARIABLES --------------------------#
script_path="${BASH_SOURCE[0]}" # Full path of this script
version='1.3'

	###--- 'yes' or 'no' options (inputs do the opposite of default) ---###
activate_colors='yes' # 'yes': Display messages in color [INPUT: '-nc']
activate_help='no'    # 'no' : Display help message      [INPUT: '-h' or '--help']
open_file='yes'       # 'yes': Open newly created script [INPUT: '-i']
open_script='no'      # 'no' : Open this script          [INPUT: '-o' or '--open']
suggest_help='no'     # 'no' : Suggest help (within script option: '-nh')

#-------------------------------- FUNCTIONS --------------------------------#
option_eval () { # Evaluates command line options
	if [ "${1}" == '-h' 2>/dev/null ] || [ "${1}" == '--help' 2>/dev/null ] || \
	   [ "${1}" == '-i' 2>/dev/null ] || [ "${1}" == '-nc' 2>/dev/null ] || \
	   [ "${1}" == '-o' 2>/dev/null ] || [ "${1}" == '--open' 2>/dev/null ]; then
		activate_options "${1}"
	elif [ -f "${1}" ]; then
		input_file="${1}"
	elif ! [ -z "${1}" 2>/dev/null ] && [ "${1}" -eq "${1}" 2>/dev/null ]; then
		script_number="${1}"
	else
		bad_inputs+=("${1}")
	fi
} # option_eval

activate_options () { # Activate input options
	if [ "${1}" == '-h' ] || [ "${1}" == '--help' ]; then
		activate_help='yes'  # Display help message
	elif [ "${1}" == '-i' ]; then
		open_file='no'       # Do NOT open created file
	elif [ "${1}" == '-nc' ]; then
		activate_colors='no' # Do NOT display messages in color
	elif [ "${1}" == '-o' ] || [ "${1}" == '--open' ]; then
		open_script='yes'    # Open this script
	else # if option is undefined (for debugging)
		bad_inputs+=("ERROR:activate_options:${1}")
	fi
} # activate_options

color_formats () { # Print colorful terminal text
	if [ "${activate_colors}" == 'yes' 2>/dev/null ]; then
		whi=$(tput setab 0; tput setaf 7) # Black background, white text
		red=$(tput setab 0; tput setaf 1) # Black background, red text
		ora=$(tput setab 0; tput setaf 3) # Black background, orange text
		gre=$(tput setab 0; tput setaf 2) # Black background, green text
		blu=$(tput setab 0; tput setaf 4) # Black background, blue text
		pur=$(tput setab 0; tput setaf 5) # Black background, purple text
		formatreset=$(tput sgr0)          # Reset to default terminal settings
	fi
} # color_formats

mac_readlink () { # Get absolute path of a file (mac and linux compatible)
	dir_mac=$(dirname "${1}")   # Directory path
	file_mac=$(basename "${1}") # Filename
	wd_mac=$(pwd) # Working directory path

	if [ -d "${dir_mac}" ]; then
		cd "${dir_mac}"
		echo "$(pwd)/${file_mac}" # Print full path
		cd "${wd_mac}" # Change back to original directory
	else
		echo "${1}" # Print input
	fi
} # mac_readlink

open_text_editor () { # Opens input file in background (GUI text editors only)
	open_file="${1}"  # Input file
	valid_editor='no' # Remains 'no' until command is valid
	
	if [ -f "${open_file}" ]; then # If input file exists
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
			echo "${red}NO VALID TEXT EDITOR COMMANDS IN ${ora}text_editors ${red}ARRAY:${whi}"
			printf "${ora}%s${IFS}${whi}" ${text_editors[@]}
			exit_message 99
		fi
	else # Missing input file
		echo "${red}MISSING FILE: ${ora}${open_file}${whi}"
	fi # if [ -f "${open_file}" ]; then
} # open_text_editor

backslash_file () { # Backslash characters '\' '$' '`' '"'
	printf "create_script${script_number} () { # NO DETAILS SPECIFIED\necho \""
	sed -e 's/\\/\\\\/g' -e 's/\$/\\$/g' -e 's/`/\\`/g' -e 's/\"/\\"/g' "${input_file}"
	printf "\"\n} # create_script${script_number}"
} # backslash_file

#-------------------------------- MESSAGES ---------------------------------#
exit_message () { # Message before exiting script
	if [ -z "${1}" 2>/dev/null ] || ! [ "${1}" -eq "${1}" 2>/dev/null ]; then
		exit_type='0'
	else
		exit_type="${1}"
	fi
	
	if [ "${exit_type}" -ne '0' ]; then
		suggest_help='yes'
	fi
	
	# Suggest help message
	if [ "${suggest_help}" == 'yes' 2>/dev/null ]; then
		echo "${ora}FOR HELP: ${gre}${script_path} -h${whi}"
	fi
	
	printf "${formatreset}\n"
	exit "${exit_type}"
} # exit_message

invalid_msg () { # Displays invalid input message
	clear
	echo "${red}INVALID INPUT:${whi}"
	printf "${ora}%s${IFS}${whi}" ${@}
} # invalid_msg

#---------------------------------- CODE -----------------------------------#
script_path=$(mac_readlink "${script_path}") # similar to 'readlink -f' in linux

for inputs; do # Reads through all inputs
	option_eval "${inputs}"
done

color_formats # Activate or prevent colorful output

# Display help message or open script
if [ "${activate_help}" == 'yes' ]; then # '-h' or '--help'
	usage # Display help message
elif [ ${open_script} == 'yes' ]; then   # '-o' or '--open'
	open_text_editor "${script_path}"
	exit_message 0
fi

# Exit script if invalid inputs found
if [ "${#bad_inputs[@]}" -gt '0' ]; then
	invalid_msg ${bad_inputs[@]}
	exit_message 1
fi

if [ -z "${input_file}" ]; then
	echo "${red}MUST SPECIFY INPUT FILE${whi}"
	exit_message 2
fi

pre_ext="${input_file%.*}"
post_ext="${input_file##*.}"

if [ "${#input_file}" -ne "${#pre_ext}" ]; then
	output_file="${pre_ext}_w_backslashes.${post_ext}"
else
	output_file="${input_file}_w_backslashes"
fi

backslash_file > "${output_file}"

if [ -f "${output_file}" ]; then
	echo "${gre}CREATED: ${ora}${output_file}${whi}"
	echo "${ora}FUNCTION TITLE: ${gre}create_script${script_number}${whi}"
		if [ "${open_file}" == 'yes' 2>/dev/null ]; then
			open_text_editor "${output_file}" ${text_editors[@]}
		fi
else
	echo "${red}COULD NOT CREATE: ${ora}${output_file}${whi}"
fi

exit_message 0