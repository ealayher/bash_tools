#!/bin/bash
#--------------------------------------------------------------------------------------#
# Created: 05/05/2015 By: Evan Layher (evan.layher@psych.ucsb.edu)
# Revised: 05/19/2015 By: Evan Layher
# Revised: 10/21/2015 By: Evan Layher # Mac compatible and minor changes
#--------------------------------------------------------------------------------------#
# Open files in background from command line
#-------------------------------- VARIABLES --------------------------------#
text_editors=('kwrite' 'gedit' 'open -a /Applications/TextWrangler.app' 'open' 'nano' 'emacs') # text editor

#----------------------- GENERAL SCRIPT VARIABLES --------------------------#
todays_date=`date +%Y%m%d`      # Date: (e.g. 20150101)
script_path="${BASH_SOURCE[0]}" # Script path (becomes absolute path later)

activate_colors='yes' # 'yes': Display messages in color [INPUT: '-nc']
activate_help='no'    # 'no' : Display help message      [INPUT: '-h' or '--help']
open_script='no'      # 'no' : Open this script          [INPUT: '-o' or '--open']

#-------------------------------- FUNCTIONS --------------------------------#
option_eval () { # Evaluates command line options
	if [ "${1}" == '-h' 2>/dev/null ] || [ "${1}" == '--help' 2>/dev/null ] || \
	[ "${1}" == '-nc' 2>/dev/null ] || [ "${1}" == '-o' 2>/dev/null ] || \
	[ "${1}" == '--open' 2>/dev/null ]; then
		activate_options "${1}"
	elif [ "${1:0:1}" == '-' 2>/dev/null ]; then
		if ! [ -f "${1}" ]; then
			bad_inputs+=("${1}")
		fi
	fi
} # option_eval

activate_options () { # Activate input options
	if [ "${1}" == '-h' ] || [ "${1}" == '--help' ]; then
		activate_help='yes'  # Display help message
	elif [ "${1}" == '-nc' ]; then
		activate_colors='no' # Do not display in color
	elif [ "${1}" == '-o' ] || [ "${1}" == '--open' ]; then
		open_script='yes'    # Open this script
	else
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
		exit_message 99 -nh -nm
	fi
} # open_text_editor

#-------------------------------- MESSAGES ---------------------------------#
script_usage () { # Script explanation
echo "${red}HELP MESSAGE: ${gre}${script_path}${whi}
${ora}DESCRIPTION${whi}: Open files in background
     
${ora}ADVICE${whi}: Create an alias inside your ${ora}${HOME}/.bashrc${whi} file
(e.g. ${gre}alias e='${script_path}'${whi})
     
${ora}USAGE${whi}: Enter files, open text editor or create new files
 [${ora}1${whi}] ${gre}e ${ora}examplefile1.sh examplefile2.sh${whi}
     
${ora}OPTIONS${whi}: Can input multiple options in any order
 ${pur}-h${whi} or ${pur}--help${whi} Display this message
 ${pur}-nc${whi}  Prevent color printing in terminal
 ${pur}-o${whi} or ${pur}--open${whi} Open this script
     
${ora}DEFAULT SETTINGS${whi}:
 text editors: ${gre}${text_editors[@]}${whi}
     
${red}END OF HELP: ${gre}${script_path}${whi}"
exit_message
} # script_usage

re_enter_input_message () { # Displays invalid input message
clear
echo "${red}INVALID INPUT: ${ora}${@}${whi}"
echo "${pur}PLEASE RE-ENTER INPUT${whi}"
} # re_enter_input_message

exit_message () { # Reset colors before exit
printf "${formatreset}\n"
exit 0
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
	exit_message 0 -nm
fi

# Exit script if invalid inputs found
if [ "${#bad_inputs[@]}" -gt '0' ]; then
	re_enter_input_message ${bad_inputs[@]}
	exit_message 1
fi

if [ -z "${1}" ]; then
	open_text_editor
else
	for i_file in ${@}; do
		open_text_editor "${i_file}"
	done
fi

exit_message