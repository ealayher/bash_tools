#!/bin/bash
#--------------------------------------------------------------------------------------#
# Created: 06/22/15 By: Evan Layher (ealayher@ucdavis.edu: UC Davis Medical Center)
# Revised: 06/22/15 By: Evan Layher
#--------------------------------------------------------------------------------------#
# Create template function with backslashes before $ " \ ` characters
# Then copy and paste this function into 'create_script.sh'
#--------------------------- DEFAULT SETTINGS ------------------------------#
text_editors=('kwrite' 'gedit' 'emacs' 'vim' 'leafpad') # text editor commands in order of preference
script_number='1' # Default script number

#----------------------- GENERAL SCRIPT VARIABLES --------------------------#
script_path="$(readlink -f ${BASH_SOURCE[0]})"	# Full path of this script
version_number='1.0'

activate_colors='yes'	# 'yes': Displays messages in color (color_formats) ['yes' or 'no'] [INPUT: '-nc']
activate_help='no'	# 'no': Displays help messeage (script_usage) ['yes' or 'no'] [INPUT: '-h' or '--help']
open_file='yes'		# 'yes': Open newly created script ['yes' or 'no'] [TURN OFF WITH INPUT: '-i']
open_script='no'	# 'no': Opens this script ['yes' or 'no'] [INPUT: '-o' or '--open']
suggest_help='no'	# 'no': Suggests help if needed ['yes' or 'no']

#-------------------------------- FUNCTIONS --------------------------------#
option_eval () { # Evaluates command line options
if [ ${1} == '-h' 2>/dev/null ] || [ ${1} == '--help' 2>/dev/null ] || [ ${1} == '-i' 2>/dev/null ] || \
[ ${1} == '-nc' 2>/dev/null ] || [ ${1} == '-o' 2>/dev/null ] || [ ${1} == '--open' 2>/dev/null ]; then
activate_options ${1}
elif [ -f ${1} ]; then
input_file=`readlink -f ${1}`
elif ! [ -z ${1} 2>/dev/null ] && [ ${1} -eq ${1} 2>/dev/null ]; then
script_number="${1}"
else
bad_inputs+=("${1}")
fi
} # option_eval

activate_options () {
if [ ${1} == '-h' ] || [ ${1} == '--help' ]; then
activate_help='yes'	# Display help message
elif [ ${1} == '-i' ]; then
open_file='no'		# Do not open file when it is created
elif [ ${1} == '-nc' ]; then
activate_colors='no'	# Do not display in color
elif [ ${1} == '-o' ] || [ ${1} == '--open' ]; then
open_script='yes'	# Open this script
else
bad_inputs+=("ERROR:activate_options:${1}")
fi
} # activate_options

color_formats () { # Print colorful terminal text
if [ ${activate_colors} == 'yes' 2>/dev/null ]; then
format=`tput setab 0; tput setaf 7` 	 	# Black background, white text
formatblue=`tput setab 0; tput setaf 4`  	# Black background, blue text
formatgreen=`tput setab 0; tput setaf 2` 	# Black background, green text
formatorange=`tput setab 0; tput setaf 3`  	# Black background, orange text
formatred=`tput setab 0; tput setaf 1` 	# Black background, red text
formatreset=`tput sgr0`				# Reset to default terminal settings
else
format=''	# No formatting
formatblue=''	# No formatting
formatgreen=''	# No formatting
formatorange=''	# No formatting
formatred=''	# No formatting
fi
} # color_formats

open_text_editor () { # Open file [first input file, then text editors]
file_to_open=${1}
valid_text_editor='no'
if [ -f ${file_to_open} ]; then
	for i_text_editor in ${@:2}; do
	${i_text_editor} ${file_to_open} 2>/dev/null &
	check_text_pid=(`ps --no-headers -p $!`) # Check pid is running
		if [ ${#check_text_pid[@]} -gt 0 ]; then
		valid_text_editor='yes'
		break
		fi
	done
	if [ ${valid_text_editor} == 'no' 2>/dev/null ]; then
	echo "${formatred}NO VALID TEXT EDITORS: ${formatorange}${@:2}${format}"
	exit_message 99 -nh -nm -nt
	fi
else
echo "${formatred}MISSING FILE: ${formatorange}${file_to_open}${format}"
fi
} # open_text_editor

backslash_file () { # Backslash characters '\' '$' '`' '"'
printf "create_script${script_number} () { # NO DETAILS SPECIFIED\necho \""
sed -e 's/\\/\\\\/g' -e 's/\$/\\$/g' -e 's/`/\\`/g' -e 's/\"/\\"/g' ${input_file}
printf "\"\n} # create_script${script_number}"
} # backslash_file

#-------------------------------- MESSAGES ---------------------------------#
script_usage () { # Script explanation
echo "${formatred}HELP MESSAGE: ${formatgreen}${script_path}${format}
${formatorange}DESCRIPTION${format}: Make 'create_script' function and copy into 'create_script.sh'
     
${formatorange}USAGE${format}: Input template script and script number
 [${formatorange}1${format}] ${formatgreen}${script_path}${formatgreen} ${HOME}/template.sh 5${format}
     
${formatorange}OPTIONS${format}: Can input multiple options in any order
 ${formatblue}-h${format} or ${formatblue}--help${format}  Display this message
 ${formatblue}-nc${format}  Prevent color printing in terminal
 ${formatblue}-o${format} or ${formatblue}--open${format} Open this script
     
${formatorange}DEFAULT SETTINGS${format}:
 script number: ${formatgreen}${script_number}${format}
 text editors : ${formatgreen}${text_editors[@]}${format}
     
${formatorange}VERSION: ${formatgreen}${version_number}${format}
${formatred}END OF HELP: ${formatgreen}${script_path}${format}"
exit_message 0
} # script_usage

re_enter_input_message () { # Displays invalid input message
clear
echo "${formatred}INVALID INPUT: ${formatorange}${@}${format}"
echo "${formatblue}PLEASE RE-ENTER INPUT${format}"
} # re_enter_input_message

exit_message () { # Message before exiting script
if [ -z ${1} 2>/dev/null ] || ! [ ${1} -eq ${1} 2>/dev/null ]; then
exit_type='0'
else
exit_type=${1}
fi
if [ ${exit_type} -ne 0 ]; then
suggest_help='yes'
fi
# Suggest help message
if [ ${suggest_help} == 'yes' 2>/dev/null ]; then
echo "${formatorange}TO DISPLAY HELP MESSAGE TYPE: ${formatgreen}${script_path} -h${format}"
fi
printf "${formatreset}\n"
exit ${exit_type}
} # exit_message

#---------------------------------- CODE -----------------------------------#
for inputs; do # Reads through all inputs
option_eval ${inputs}
done

color_formats # Activates or inhibits colorful output

# Exit script if invalid inputs found
if [ ${#bad_inputs[@]} -gt 0 ]; then
re_enter_input_message ${bad_inputs[@]}
exit_message 1
fi

if [ ${activate_help} == 'yes' ]; then # -h or --help
script_usage
elif [ ${open_script} == 'yes' ]; then # -o or --open
open_text_editor ${script_path} ${text_editors[@]}
exit_message 0 -nm -nt
elif [ -z ${input_file} ]; then
echo "${formatred}MUST SPECIFY INPUT FILE${format}"
exit_message 2
fi
output_file="${input_file}_w_backslashes"

backslash_file > ${output_file}

if [ -f ${output_file} ]; then
echo "${formatgreen}CREATED: ${formatorange}${output_file}${format}"
echo "${formatorange}FUNCTION TITLE: ${formatgreen}create_script${script_number}${format}"
	if [ ${open_file} == 'yes' 2>/dev/null ]; then
	open_text_editor ${output_file} ${text_editors[@]}
	fi
else
echo "${formatred}COULD NOT CREATE: ${formatorange}${output_file}${format}"
fi

exit_message 0
