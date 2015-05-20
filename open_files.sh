#!/bin/bash
#--------------------------------------------------------------------------------------#
# Created: 05/05/2015 By: Evan Layher (ealayher@ucdavis.edu: UC Davis Medical Center)
# Revised: 05/19/2015 By: Evan Layher
#--------------------------------------------------------------------------------------#
# Open files in background from command line
#-------------------------------- VARIABLES --------------------------------#
text_editors=('kwrite' 'gedit' 'emacs' 'vim' 'leafpad') # text editor commands in order of preference

#----------------------- GENERAL SCRIPT VARIABLES --------------------------#
todays_date=`date +%Y%m%d`		# Date: (e.g. 20150101)
script_path="$(readlink -f ${BASH_SOURCE[0]})"	# Full path of this script

activate_colors='yes'	# 'yes': Displays messages in color (color_formats) ['yes' or 'no'] [INPUT: '-nc']
activate_help='no'	# 'no': Displays help messeage (script_usage) ['yes' or 'no'] [INPUT: '-h' or '--help']
open_script='no'	# 'no': Opens this script ['yes' or 'no'] [INPUT: '-o' or '--open']

bad_inputs=()		# (): Array of bad inputs (invalid_input_message)

#-------------------------------- FUNCTIONS --------------------------------#
option_eval () { # Evaluates command line options
if [ ${1} == '-h' 2>/dev/null ] || [ ${1} == '--help' 2>/dev/null ] || [ ${1} == '-nc' 2>/dev/null ] || \
[ ${1} == '-o' 2>/dev/null ] || [ ${1} == '--open' 2>/dev/null ]; then
activate_options ${1}
elif [ ${1:0:1} == '-' 2>/dev/null ]; then
	if ! [ -f ${1} ]; then
	bad_inputs+=("${1}")
	fi
fi
}

activate_options () {
if [ ${1} == '-h' ] || [ ${1} == '--help' ]; then
activate_help='yes'	# Display help message
elif [ ${1} == '-nc' ]; then
activate_colors='no'	# Do not display in color
elif [ ${1} == '-o' ] || [ ${1} == '--open' ]; then
open_script='yes'	# Open this script
else
bad_inputs+=("ERROR:activate_options:${1}")
fi
}

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
}

open_text_editor () { # Open file
valid_text_editor='no'
for i_text_editor in ${text_editors[@]}; do
${i_text_editor} ${file_to_open} 2>/dev/null &
check_text_pid=(`ps --no-headers -p $!`) # Check pid is running
	if [ ${#check_text_pid[@]} -gt 0 ]; then
	valid_text_editor='yes'
	break
	fi
done
if [ ${valid_text_editor} == 'no' 2>/dev/null ]; then
echo "NO VALID TEXT EDITORS: ${@:2}"
exit 99
fi
}

#-------------------------------- MESSAGES ---------------------------------#
script_usage () { # Script explanation
echo "${formatred}HELP MESSAGE: ${formatgreen}${script_path}${format}
${formatorange}DESCRIPTION${format}: Open files in background
     
${formatorange}ADVICE${format}: Create an alias inside your ${formatorange}${HOME}/.bashrc${format} file
(e.g. ${formatgreen}alias e='${script_path}'${format})
     
${formatorange}USAGE${format}: Enter files, open text editor or create new files
 [${formatorange}1${format}] ${formatgreen}e ${formatorange}examplefile1.sh examplefile2.sh${format}
     
${formatorange}OPTIONS${format}: Can input multiple options in any order
 ${formatblue}-h${format} or ${formatblue}--help${format}  Display this message
 ${formatblue}-nc${format}  Prevent color printing in terminal
 ${formatblue}-o${format} or ${formatblue}--open${format} Open this script
     
${formatorange}DEFAULT SETTINGS${format}:
 text editors: ${formatgreen}${text_editors[@]}${format}
     
${formatred}END OF HELP: ${formatgreen}${script_path}${format}"
exit_message
}

re_enter_input_message () { # Displays invalid input message
clear
echo "${formatred}INVALID INPUT: ${formatorange}${@}${format}"
echo "${formatblue}PLEASE RE-ENTER INPUT${format}"
}


exit_message () { # Reset colors before exit
printf "${formatreset}\n"
exit 0
}

#---------------------------------- CODE -----------------------------------#
for inputs; do # Reads through all inputs
option_eval ${inputs}
done

color_formats # Activates or inhibits colorful output

# Echo invalid input (begin with '-')
if [ ${#bad_inputs[@]} -gt 0 ]; then
re_enter_input_message ${bad_inputs[@]}
fi

if [ ${activate_help} == 'yes' ]; then # -h or --help
script_usage
elif [ ${open_script} == 'yes' ]; then # -o or --open
file_to_open=${script_path}
open_text_editor
exit_message
fi

if [ -z ${1} ]; then
file_to_open=''
open_text_editor
else
	for i_file in ${@}; do
	file_to_open=${i_file}
	open_text_editor
	done
fi

exit_message