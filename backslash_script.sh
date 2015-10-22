#!/bin/bash
#--------------------------------------------------------------------------------------#
# Created: 06/22/15 By: Evan Layher (evan.layher@psych.ucsb.edu)
# Revised: 10/21/15 By: Evan Layher # (1.2): Mac compatible plus minor alterations
#--------------------------------------------------------------------------------------#
# Create template function with backslashes before $ " \ ` characters
# Then copy and paste this function into 'create_script.sh'
#--------------------------- DEFAULT SETTINGS ------------------------------#
text_editors=('kwrite' 'gedit' 'open -a /Applications/TextWrangler.app' 'open' 'nano' 'emacs') # text editor commands in order of preference
script_number='1' # Default script number

#----------------------- GENERAL SCRIPT VARIABLES --------------------------#
script_path="${BASH_SOURCE[0]}" # Full path of this script
version_number='1.2'

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
	else # if option is not defined here (for debugging)
		bad_inputs+=("ERROR:activate_options:${1}")
	fi
} # activate_options

color_formats () { # Print colorful terminal text
	if [ "${activate_colors}" == 'yes' 2>/dev/null ]; then
		whi=`tput setab 0; tput setaf 7` # Black background, white text
		red=`tput setab 0; tput setaf 1` # Black background, red text
		ora=`tput setab 0; tput setaf 3` # Black background, orange text
		gre=`tput setab 0; tput setaf 2` # Black background, green text
		blu=`tput setab 0; tput setaf 4` # Black background, blue text
		pur=`tput setab 0; tput setaf 5` # Black background, purple text
		formatreset=`tput sgr0`          # Reset to default terminal settings
	fi
} # color_formats

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

open_text_editor () { # Opens input file
	file_to_open="${1}"
	valid_text_editor='no'
	
	if [ -f "${file_to_open}" ]; then
		for i in ${!text_editors[@]}; do # Loop through indices
			${text_editors[i]} "${file_to_open}" 2>/dev/null &
			pid="$!" # Background process ID
			check_text_pid=(`ps "${pid}" |grep "${pid}"`) # Check if pid is running
			
			if [ "${#check_text_pid[@]}" -gt '0' ] && [ "${check_text_pid[0]}" == "${pid}" 2>/dev/null ]; then
				valid_text_editor='yes'
				break
			fi
		done

		if [ "${valid_text_editor}" == 'no' 2>/dev/null ]; then
			echo "${red}NO VALID TEXT EDITORS: ${ora}${text_editors[@]}${whi}"
			exit_message 99
		fi
	else
		echo "${red}MISSING FILE: ${ora}${file_to_open}${whi}"
	fi
} # open_text_editor

backslash_file () { # Backslash characters '\' '$' '`' '"'
	printf "create_script${script_number} () { # NO DETAILS SPECIFIED\necho \""
	sed -e 's/\\/\\\\/g' -e 's/\$/\\$/g' -e 's/`/\\`/g' -e 's/\"/\\"/g' "${input_file}"
	printf "\"\n} # create_script${script_number}"
} # backslash_file

#-------------------------------- MESSAGES ---------------------------------#
script_usage () { # Script explanation
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
 text editors : ${gre}${text_editors[@]}${whi}
     
${ora}VERSION: ${gre}${version_number}${whi}
${red}END OF HELP: ${gre}${script_path}${whi}"
	exit_message 0
} # script_usage

re_enter_input_message () { # Displays invalid input message
	clear
	echo "${red}INVALID INPUT: ${ora}"
	printf '%s\n' ${@}
	echo "${pur}PLEASE RE-ENTER INPUT${whi}"
} # re_enter_input_message

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
		echo "${ora}TO DISPLAY HELP MESSAGE TYPE: ${gre}${script_path} -h${whi}"
	fi
	
	printf "${formatreset}\n"
	exit "${exit_type}"
} # exit_message

#---------------------------------- CODE -----------------------------------#
script_path=$(mac_readlink "${script_path}") # equivalent to 'readlink -f' in linux

for inputs; do # Reads through all inputs
	option_eval "${inputs}"
done

color_formats # Activates or inhibits colorful output

# Display help message or open file
if [ "${activate_help}" == 'yes' ]; then # '-h' or '--help'
	script_usage
elif [ ${open_script} == 'yes' ]; then   # '-o' or '--open'
	open_text_editor "${script_path}" ${text_editors[@]}
	exit_message 0 -nm -nt
fi

# Exit script if invalid inputs found
if [ "${#bad_inputs[@]}" -gt '0' ]; then
	re_enter_input_message ${bad_inputs[@]}
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
