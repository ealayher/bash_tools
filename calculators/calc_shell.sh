#!/bin/bash
#--------------------------------------------------------------------------------------#
# Created: 10/22/2015 By: Evan Layher (evan.layher@psych.ucsb.edu)
# Revised: 10/22/2015 By: Evan Layher
#--------------------------------------------------------------------------------------#
# Calculations from shell command line: 'awk_calculations' wrapper
#-------------------------------- VARIABLES --------------------------------#
calc_file="${HOME}/code/awk_calculations.sh"
default_calc=('awk_sum') # which function(s) to calculate if no input
#--------------------------- DEFAULT SETTINGS ------------------------------#
text_editors=('kwrite' 'gedit' 'open -a /Applications/TextWrangler.app' 'open' 'nano' 'emacs') # text editor commands in order of preference

#----------------------- GENERAL SCRIPT VARIABLES --------------------------#
script_start_date_time=`date +%x' '%r` # (e.g. 01/01/2015 12:00:00 AM)
script_path="${BASH_SOURCE[0]}"        # Script path (becomes absolute path later)
version_number='1.0' # Script version number

	###--- 'yes' or 'no' options (inputs do the opposite of default) ---###
activate_colors='yes' # 'yes': Display messages in color [INPUT: '-nc']
activate_help='no'    # 'no' : Display help message      [INPUT: '-h' or '--help']
clear_screen='yes'    # 'yes': Clear screen at start     [INPUT: '-cs']
open_script='no'      # 'no' : Open this script          [INPUT: '-o' or '--open']
suggest_help='no'     # 'no' : Suggest help (within script option: '-nh')

#-------------------------------- FUNCTIONS --------------------------------#
option_eval () { # Evaluate inputs
	if [ "${1}" == '-cs' 2>/dev/null ] || [ "${1}" == '-h' 2>/dev/null ] || \
	[ "${1}" == '--help' 2>/dev/null ] || [ "${1}" == '-nc' 2>/dev/null ] || \
	[ "${1}" == '-o' 2>/dev/null ] || [ "${1}" == '--open' 2>/dev/null ]; then
		activate_options "${1}"
	elif [ "${1}" == '-avg' 2>/dev/null ] || [ "${1}" == 'avg' 2>/dev/null ] || \
	[ "${1}" == 'mean' 2>/dev/null ] || [ "${1}" == 'average' 2>/dev/null ]; then
		calc_types+=("awk_average")
	elif [ "${1}" == '-med' 2>/dev/null ] || [ "${1}" == 'med' 2>/dev/null ] || \
	[ "${1}" == '-median' 2>/dev/null ] || [ "${1}" == 'median' 2>/dev/null ]; then
		calc_types+=("awk_median")
	elif [ "${1}" == '-pow' 2>/dev/null ] || [ "${1}" == 'pow' 2>/dev/null ] || \
	[ "${1}" == '-power' 2>/dev/null ] || [ "${1}" == 'power' 2>/dev/null ]; then
		calc_types+=("awk_power")
	elif [ "${1}" == 'x' 2>/dev/null ] || [ "${1}" == 'prod' 2>/dev/null ] || \
	[ "${1}" == '-product' 2>/dev/null ] || [ "${1}" == 'product' 2>/dev/null ]; then
		calc_types+=("awk_product")
	elif [ "${1}" == '/' 2>/dev/null ] || [ "${1}" == 'div' 2>/dev/null ] || \
	[ "${1}" == 'divide' 2>/dev/null ] || [ "${1}" == 'quotient' 2>/dev/null ]; then
		calc_types+=("awk_quotient")
	elif [ "${1}" == '+' 2>/dev/null ] || [ "${1}" == 'sum' 2>/dev/null ] || \
	[ "${1}" == 'add' 2>/dev/null ] || [ "${1}" == '-add' 2>/dev/null ]; then
		calc_types+=("awk_sum")
	else
		values+=("${1}")
	fi
} # option_eval

activate_options () { # Activate input options
	if [ "${1}" == '-cs' ]; then
		clear_screen='no'    # Do NOT clear screen at start
	elif [ "${1}" == '-h' ] || [ "${1}" == '--help' ]; then
		activate_help='yes'  # Display help message
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
			exit_message 99 -nh
		fi
	else
		echo "${red}MISSING FILE: ${ora}${file_to_open}${whi}"
	fi
} # open_text_editor

#-------------------------------- MESSAGES ---------------------------------#
script_usage () { # Script explanation
	echo "${red}HELP MESSAGE: ${gre}${script_path}${whi}
${ora}DESCRIPTION${whi}: Calculations from command line

${ora}ADVICE${whi}: Create an alias inside your ${ora}${HOME}/.bashrc${whi} file
(e.g. ${gre}alias c='${script_path}'${whi})
     
${ora}USAGE${whi}: Input values and calculation type
 [${ora}1${whi}] ${gre}${script_path}${whi} + ${pur}6.5 32.2 12${whi}
     
${ora}OPTIONS${whi}: Can input multiple options in any order
 ${pur}-cs${whi}  Prevent screen from clearing before script processes
 ${pur}-h${whi} or ${pur}--help${whi}  Display this message
 ${pur}-nc${whi}  Prevent color printing in terminal
 ${pur}-o${whi} or ${pur}--open${whi} Open this script
 
${ora}CALCULATION TYPES${whi}:
AVERAGE : ${pur}avg, -avg, average, mean${whi}
MEDIAN  : ${pur}med, -med, median, -median${whi}
POWER   : ${pur}pow, -pow, power, -power${whi}
PRODUCT : ${pur}x, prod, product, -product${whi}
QUOTIENT: ${pur}/, div, divide, quotient${whi}
SUM     : ${pur}+, add, -add, sum${whi}
     
${ora}DEFAULT SETTINGS${whi}:
 calculations: ${gre}${default_calc[@]}${whi}
 text editors: ${gre}${text_editors[@]}${whi}
     
${ora}VERSION: ${gre}${version_number}${whi}
${red}END OF HELP: ${gre}${script_path}${whi}" |sed "s@,@${whi},${pur}@g"
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
	
	for exit_inputs; do
		if [ "${exit_inputs}" == '-nh' 2>/dev/null ]; then
			suggest_help='no'
		fi
	done

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

if ! [ "${clear_screen}" == 'no' 2>/dev/null ]; then
	clear     # Clears screen unless activation of input option: '-cs'
fi

color_formats # Activates or inhibits colorful output

# Display help message or open file
if [ "${activate_help}" == 'yes' ]; then # '-h' or '--help'
	script_usage
elif [ ${open_script} == 'yes' ]; then   # '-o' or '--open'
	open_text_editor "${script_path}" ${text_editors[@]}
	exit_message 0
fi

# Exit script if invalid inputs found
if [ "${#bad_inputs[@]}" -gt '0' ]; then
	re_enter_input_message ${bad_inputs[@]}
	exit_message 1
elif [ "${#values[@]}" -eq '0' ]; then
	echo "${red}NO VALID INPUTS${whi}"
	exit_message 2
fi

if [ "${#calc_types[@]}" -eq '0' ]; then
	if [ "${#default_calc[@]}" -gt '0' ]; then
		calc_types=(${default_calc[@]})
	else
		echo "${red}NO DEFAULT VALUES SET: ${ora}default_calc${whi}"
		exit_message 3
	fi
fi

calc_types=($(printf '%s\n' ${calc_types[@]} |sort -u)) # sort unique values

if [ -f "${calc_file}" ] || [ -L "${calc_file}" ]; then
	source "${calc_file}"
else
	echo "${red}MISSING CALCULATION FILE: ${ora}${calc_file}${whi}"
	exit_message 4
fi

echo "${pur}VALUES: ${gre}${values[@]}${whi}"
for i_cal in ${calc_types[@]}; do
	answer=$(eval "${i_cal} ${values[@]}")
	echo "${ora}${i_cal}: ${gre}${answer}${whi}" |sed 's@awk_@@g'
done

exit_message 0
