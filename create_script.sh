#!/bin/bash
#--------------------------------------------------------------------------------------#
# Created: 04/22/2014 By: Evan Layher (ealayher@ucdavis.edu: UC Davis Medical Center)
# Revised: 06/23/2015 By: Evan Layher
# Reference: github.com/ealayher
#--------------------------------------------------------------------------------------#
# Create new scripts with customized information

## --- LICENSE INFORMATION --- ##
## script_title.sh is the proprietary property of The Regents of the University of California ("The Regents.")

## Copyright © 2014-15 The Regents of the University of California, Davis campus. All Rights Reserved.

## Redistribution and use in source and binary forms, with or without modification, are permitted by nonprofit, 
## research institutions for research use only, provided that the following conditions are met:

## • Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer
## • Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer 
##	in the documentation and/or other materials provided with the distribution. 
## • The name of The Regents may not be used to endorse or promote products derived from this software without specific prior written permission.

## The end-user understands that the program was developed for research purposes and is advised not to rely exclusively on the program for any reason.

## THE SOFTWARE PROVIDED IS ON AN "AS IS" BASIS, AND THE REGENTS HAVE NO OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
## THE REGENTS SPECIFICALLY DISCLAIM ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY, 
## FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
## IN NO EVENT SHALL THE REGENTS BE LIABLE TO ANY PARTY FOR DIRECT, INDIRECT, SPECIAL, INCIDENTAL, EXEMPLARY OR CONSEQUENTIAL DAMAGES, 
## INCLUDING BUT NOT LIMITED TO  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES, LOSS OF USE, DATA OR PROFITS, OR BUSINESS INTERRUPTION, 
## HOWEVER CAUSED AND UNDER ANY THEORY OF LIABILITY WHETHER IN CONTRACT, STRICT LIABILITY OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
## ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

## If you do not agree to these terms, do not download or use the software.  
## This license may be modified only in a writing signed by authorized signatory of both parties.

## For commercial license information please contact copyright@ucdavis.edu.
## --------------------------- ##

#--------------------------- DEFAULT SETTINGS ------------------------------#
default_text_editors=('kwrite' 'gedit' 'emacs' 'vim' 'leafpad') # default text editor commands in order of preference
default_permission_value='755' # '755': Default file permission for new scripts
default_script_number='1'

#----------------------- GENERAL SCRIPT VARIABLES --------------------------#
todays_date=`date +%x` 	# Inputs date inside of script
script_path="$(readlink -f ${BASH_SOURCE[0]})"	# Full path of this script
version_number='2.1'

activate_colors='yes'	# 'yes': Displays messages in color (color_formats) ['yes' or 'no'] [INPUT: '-nc']
activate_help='no'	# 'no': Displays help messeage (script_usage) ['yes' or 'no'] [INPUT: '-h' or '--help']
change_permission='no'	# 'no': Change permission value for one entry ['yes' or 'no'] [INPUT: '[0-7][0-7][0-7]']
display_scripts='no'	# 'no': List script explanations (script_display) ['yes' or 'no'] [INPUT: '-nl']
filename_reader='on'	# 'on': Read in filename
list_settings='no'	# 'no': List user settings (list_user_settings) ['yes' or 'no'] [INPUT: '-l']
open_file='yes'		# 'yes': Open newly created script ['yes' or 'no'] [TURN OFF WITH INPUT: '-i']
open_script='no'	# 'no': Opens this script [ -o or --open ]
p_in='no'		# 'no': Reads in permission level for output file ['yes' or 'no']
reset_template='no'	# 'no': Reset template file (reset_option_file) ['yes' or 'no'] [INPUT: '-r']
suggest_help='no'	# 'no': Suggests help if needed ['yes' or 'no']

#-------------------------------- FUNCTIONS --------------------------------#
create_script () { # Creates, activates and opens new shell script
if [ ${n_script} -eq ${n_script} 2>/dev/null ]; then
script_function="create_script${n_script}"
check_create=(`type -t ${script_function}`)
	if [ ${check_create[0]} == 'function' 2>/dev/null ]; then
	${script_function} > ${filename} # Outputs script
	chmod ${permission_value} ${filename} # Automatically activates script
	echo "${formatgreen}CREATED: ${formatorange}${file_path}${format}"
		if [ ${open_file} == 'yes' 2>/dev/null ]; then
		open_text_editor ${filename} ${text_editors[@]} # open new script
		fi
	else
	echo "${formatred}INVALID FUNCTION: ${formatorange}${script_function}${format}"
	exit_message 99
	fi
else
echo "${formatred}INVALID '${formatorange}-n${formatred}' option: ${formatorange}${n_script}${format}"
exit_message 98
fi
}

### SCRIPT TYPES: Must have naming convenction of 'create_script*[0-9] () {' [ e.g. create_script10 () { # Comments ]
create_script1 () { # Advanced script with option file
echo "#!/bin/bash
#--------------------------------------------------------------------------------------#
# Created: ${todays_date} By: Evan Layher (ealayher@ucdavis.edu: UC Davis Medical Center)
# Revised: ${todays_date} By: Evan Layher
# Reference: github.com/ealayher
#--------------------------------------------------------------------------------------#
#
#-------------------------------- VARIABLES --------------------------------#

#--------------------------- DEFAULT SETTINGS ------------------------------#
max_bg_jobs='10' # '10': Max number of background processes
default_text_editors=('kwrite' 'gedit' 'emacs' 'vim' 'leafpad') # text editor commands in order of preference

#----------------------- GENERAL SCRIPT VARIABLES --------------------------#
script_start_time=\`date +%s\` 		# Script start time (in seconds).
script_start_date_time=\`date +%x' '%r\`	# Script start date and time: (e.g. 01/01/2015 12:00:00 AM)
script_path=\"\$(readlink -f \${BASH_SOURCE[0]})\"	# Full path of this script
version_number='1.0'
activate_colors='yes'	# 'yes': Displays messages in color (color_formats) ['yes' or 'no'] [INPUT: '-nc']
activate_help='no'	# 'no': Displays help messeage (script_usage) ['yes' or 'no'] [INPUT: '-h' or '--help']
clear_screen='yes'	# 'yes': Clears screen before running script ['yes' or 'no'] [INPUT: '-cs']
display_exit='yes'	# 'yes': Displays an exit message ['yes' or 'no'] [INPUT: '-nm']
list_settings='no'	# 'no': List user settings (list_user_settings) ['yes' or 'no'] [INPUT: '-l']
open_script='no'	# 'no': Opens this script ['yes' or 'no'] [INPUT: '-o' or '--open']
reset_template='no'	# 'no': Reset template file (reset_option_file) ['yes' or 'no'] [INPUT: '-r']
show_time='yes'		# 'yes': Displays script process time ['yes' or 'no'] [INPUT: '-nt']
suggest_help='no'	# 'no': Suggests help if needed ['yes' or 'no']

#-------------------------------- FUNCTIONS --------------------------------#
control_bg_jobs () { # Controls number of background processes
job_count=\`jobs -p |wc -l\`
if [ \${job_count} -ge \${max_bg_jobs} ]; then
sleep 0.25
control_bg_jobs
fi
} # control_bg_jobs

option_eval () { # Evaluates command line options
if [ \${1} == '-cs' 2>/dev/null ] || [ \${1} == '-h' 2>/dev/null ] || [ \${1} == '--help' 2>/dev/null ] || \\
[ \${1} == '-l' 2>/dev/null ] || [ \${1} == '-nc' 2>/dev/null ] || [ \${1} == '-nt' 2>/dev/null ] || \\
[ \${1} == '-nm' 2>/dev/null ] || [ \${1} == '-o' 2>/dev/null ] || [ \${1} == '--open' 2>/dev/null ] || \\
[ \${1} == '-t' 2>/dev/null ] || [ \${1} == '-tr' 2>/dev/null ] || [ \${1} == '-r' 2>/dev/null ]; then
activate_options \${1}
elif ! [ -z \${t_in} 2>/dev/null ] && [ \${t_in} == 'yes' 2>/dev/null ]; then
add_editors=(\"\${1} \${add_editors[@]}\") # Maintain order of editor inputs
elif ! [ -z \${tr_in} 2>/dev/null ] && [ \${tr_in} == 'yes' 2>/dev/null ]; then
rem_editors+=(\"\${1}\")
elif [ \${1:0:1} == '-' 2>/dev/null ]; then
bad_inputs+=(\"\${1}\")
else
bad_inputs+=(\"\${1}\")
fi
} # option_eval

activate_options () {
t_in='no'  # Do not read in text editor to add
tr_in='no' # Do not read in text editor to remove
if [ \${1} == '-cs' ]; then
clear_screen='no'	# Do not clear screen
elif [ \${1} == '-h' ] || [ \${1} == '--help' ]; then
activate_help='yes'	# Display help message
elif [ \${1} == '-l' ]; then
list_settings='yes'	# List user settings
elif [ \${1} == '-nc' ]; then
activate_colors='no'	# Do not display in color
elif [ \${1} == '-nm' ]; then
display_exit='no'	# Do not display exit message
elif [ \${1} == '-nt' ]; then
show_time='no'		# Do not display script process time
elif [ \${1} == '-o' ] || [ \${1} == '--open' ]; then
open_script='yes'	# Open this script
elif [ \${1} == '-r' ]; then
reset_template='yes'   # Reset option file
elif [ \${1} == '-t' ]; then
t_in='yes'             # Add text editor
list_settings='yes'	# List user settings
elif [ \${1} == '-tr' ]; then
tr_in='yes'            # Remove text editor
list_settings='yes'	# List user settings
else
bad_inputs+=(\"ERROR:activate_options:\${1}\")
fi
} # activate_options

color_formats () { # Print colorful terminal text
if [ \${activate_colors} == 'yes' 2>/dev/null ]; then
format=\`tput setab 0; tput setaf 7\` 	 	# Black background, white text
formatblue=\`tput setab 0; tput setaf 4\`  	# Black background, blue text
formatgreen=\`tput setab 0; tput setaf 2\` 	# Black background, green text
formatorange=\`tput setab 0; tput setaf 3\`  	# Black background, orange text
formatred=\`tput setab 0; tput setaf 1\` 	# Black background, red text
formatreset=\`tput sgr0\`				# Reset to default terminal settings
else
format=''	# No formatting
formatblue=''	# No formatting
formatgreen=''	# No formatting
formatorange=''	# No formatting
formatred=''	# No formatting
fi
} # color_formats

open_text_editor () { # Open file [first input file, then text editors]
file_to_open=\${1}
valid_text_editor='no'
if [ -f \${file_to_open} ]; then
	for i_text_editor in \${@:2}; do
	\${i_text_editor} \${file_to_open} 2>/dev/null &
	check_text_pid=(\`ps --no-headers -p \$!\`) # Check pid is running
		if [ \${#check_text_pid[@]} -gt 0 ]; then
		valid_text_editor='yes'
		break
		fi
	done
	if [ \${valid_text_editor} == 'no' 2>/dev/null ]; then
	echo \"\${formatred}NO VALID TEXT EDITORS: \${formatorange}\${@:2}\${format}\"
	exit_message 99 -nh -nm -nt
	fi
else
echo \"\${formatred}MISSING FILE: \${formatorange}\${file_to_open}\${format}\"
fi
} # open_text_editor

create_option_file () { # Creates .ini file to store user preferences
ealayher_code_dir=\"\${HOME}/.ealayher_code\" # Directory of preference file
option_file=\"\${ealayher_code_dir}/\$(basename \${script_path%.*}).ini\" # .ini file path
if ! [ -d \${ealayher_code_dir} ]; then # Create directory for option file
mkdir \${ealayher_code_dir}
fi
if ! [ -f \${option_file} ]; then # Create option file
echo \"[options]
text_editors=(\${default_text_editors[@]})
\" > \${option_file}
fi
text_editors=(\`awk -F '=' '/text_editors=/ {print \$2}' \${option_file} |sed -e 's@(@@g' -e 's@)@@g'\`)
if [ \${#add_editors[@]} -gt 0 ] || [ \${#rem_editors[@]} -gt 0 ]; then # Change text editors
old_editor_vals=\"text_editors=(\${text_editors[@]})\"
	for i_rem_editor in \${rem_editors[@]} \${add_editors[@]}; do # Removes duplicate inputs
	text_editors=(\`printf ' %s ' \${text_editors[@]} |sed \"s@ \${i_rem_editor} @ @g\"\`)
	done
	for i_add_editor in \${add_editors[@]}; do # Put newest editor in front
	text_editors=(\${i_add_editor} \${text_editors[@]})
	done
	new_editor_vals=\"text_editors=(\${text_editors[@]})\"
sed -i \"s@\${old_editor_vals}@\${new_editor_vals}@g\" \${option_file} # Replace old editors with new editors
text_editors=(\`awk -F '=' '/text_editors=/ {print \$2}' \${option_file} |sed -e 's@(@@g' -e 's@)@@g'\`)
fi
} # create_option_file

vital_command () { # exits script if an essential command fails
command_status=\${1}
command_line_number=\${2}
if ! [ -z \${command_status} ] && [ \${command_status} -ne 0 ]; then
echo \"\${formatred}INVALID COMMAND: LINE \${formatorange}\${command_line_number}\${format}\"
exit_message 98 -nh -nm -nt
fi
} # vital_command

vital_file () { # exits script if an essential file is missing
for vitals; do
	if ! [ -e \${vitals} 2>/dev/null ]; then
	bad_files+=(\"\${vitals}\")
	fi
done
if [ \${#bad_files[@]} -gt 0 ]; then
echo \"\${formatred}MISSING ESSENTIAL FILE(S):\${formatblue}\"
printf '%s\\n' \${bad_files[@]}
exit_message 97 -nh -nm -nt
fi
} # vital_file

reset_option_file () { # -r: Reset user option file
printf \"\${formatorange}RESET OPTIONS FILE? [\${formatgreen}y\${formatorange}/\${formatgreen}n\${formatorange}]:\${format}\"
read -r reset_it
if [ \${reset_it} == 'y' 2>/dev/null ] || [ \${reset_it} == 'Y' 2>/dev/null ]; then
kill \$! 2>/dev/null # Close file before removing
wait \$! 2>/dev/null # Suppress kill message
rm \${option_file} 2>/dev/null
create_option_file
elif [ \${reset_it} == 'n' 2>/dev/null ] || [ \${reset_it} == 'N' 2>/dev/null ]; then
kill \$! 2>/dev/null # Close file before removing
wait \$! 2>/dev/null # Suppress kill message
exit_message 0
else
re_enter_input_message \${reset_it}
reset_option_file
fi
} # reset_option_file

#-------------------------------- MESSAGES ---------------------------------#
script_usage () { # Script explanation
echo \"\${formatred}HELP MESSAGE: \${formatgreen}\${script_path}\${format}
\${formatorange}DESCRIPTION\${format}:
     
\${formatorange}ADVICE\${format}: Create an alias inside your \${formatorange}\${HOME}/.bashrc\${format} file
(e.g. \${formatgreen}alias xx='\${script_path}'\${format})
     
\${formatorange}USAGE\${format}:
 [\${formatorange}1\${format}] \${formatgreen}\${script_path}\${format}
     
\${formatorange}OPTIONS\${format}: Can input multiple options in any order
 \${formatblue}-cs\${format}  Prevent screen from clearing before script processes
 \${formatblue}-h\${format} or \${formatblue}--help\${format}  Display this message
 \${formatblue}-nc\${format}  Prevent color printing in terminal
 \${formatblue}-l\${format}   List default settings
 \${formatblue}-nm\${format}  Prevent exit message from displaying
 \${formatblue}-nt\${format}  Prevent script process time from displaying
 \${formatblue}-o\${format} or \${formatblue}--open\${format} Open this script
 \${formatblue}-r\${format}   Reset option file
 \${formatblue}-t\${format}   Add text editor(s)\${format}
  [\${formatorange}2\${format}] \${formatgreen}\${script_path} \${formatblue}-t \${formatorange}kwrite gedit\$\\{format}
 \${formatblue}-tr\${format}  Remove text editor(s)\${format}
  [\${formatorange}3\${format}] \${formatgreen}\${script_path} \${formatblue}-tr \${formatorange}kwrite gedit\$\\{format}
     
\${formatorange}DEFAULT SETTINGS\${format}:
 text editors: \${formatgreen}\$(grep 'text_editors=' \${option_file} |sed -e 's@text_editors=@@g' -e 's@(@@g' -e 's@)@@g')\${format}
     
\${formatorange}VERSION: \${formatgreen}\${version_number}\${format}
\${formatred}END OF HELP: \${formatgreen}\${script_path}\${format}\"
exit_message 0 -nt -nm
} # script_usage

list_user_settings () { # -l option
create_option_file
echo \"\${formatblue}+---USER SETTINGS---+\${formatorange}\"
echo \"\${formatgreen}Text editors: \${formatorange}\${text_editors[@]}\${format}\"
exit_message 0 -nm -nt
} # list_settings

re_enter_input_message () { # Displays invalid input message
clear
echo \"\${formatred}INVALID INPUT: \${formatorange}\${@}\${format}\"
echo \"\${formatblue}PLEASE RE-ENTER INPUT\${format}\"
} # re_enter_input_message

script_time_message () { # Script process time message
echo \"STARTED : \${script_start_date_time}\"
echo \"FINISHED: \`date +%x' '%r\`\"
} # script_time_message

script_time_func () { # Script process time calculation
script_end_time=\`date +%s\`
script_process_time=\$((\${script_end_time} - \${script_start_time}))
if [ \${script_process_time} -lt 60 ];then
script_time_message 
echo \"PROCESS TIME: \${script_process_time} second(s).\"
elif [ \${script_process_time} -lt 3600 ];then
script_time_message 
echo \"PROCESS TIME: \$((\${script_process_time} / 60)) minute(s) and \$((\${script_process_time} % 60)) second(s).\"
elif [ \${script_process_time} -lt 86400 ];then
script_time_message 
echo \"PROCESS TIME: \$((\${script_process_time} / 3600)) hour(s) \$((\${script_process_time} % 3600 / 60)) minute(s) and \$((\${script_process_time} % 60)) second(s).\"
elif [ \${script_process_time} -ge 86400 ];then
script_time_message 
echo \"PROCESS TIME: \$((\${script_process_time} / 86400)) day(s) \$((\${script_process_time} % 86400 / 3600)) hour(s) \$((\${script_process_time} % 3600 / 60)) minute(s) and \$((\${script_process_time} % 60)) second(s).\"
else
echo \"\${formatred}ERROR: \${formatorange}script_time_func\${format}\"
fi
} # script_time_func

exit_message () { # Message before exiting script
if [ -z \${1} 2>/dev/null ] || ! [ \${1} -eq \${1} 2>/dev/null ]; then
exit_type='0'
else
exit_type=\${1}
fi
if [ \${exit_type} -ne 0 ]; then
suggest_help='yes'
fi
for exit_inputs; do
	if [ \${exit_inputs} == '-nh' 2>/dev/null ]; then
	suggest_help='no'
	elif [ \${exit_inputs} == '-nt' 2>/dev/null ]; then
	show_time='no'
	elif [ \${exit_inputs} == '-nm' 2>/dev/null ]; then
	display_exit='no'
	fi
done
wait # Waits for background processes to finish before exiting
# Suggest help message
if [ \${suggest_help} == 'yes' 2>/dev/null ]; then
echo \"\${formatorange}TO DISPLAY HELP MESSAGE TYPE: \${formatgreen}\${script_path} -h\${format}\"
fi
# Display exit message
if [ \${display_exit} != 'no' 2>/dev/null ]; then # Exit message
echo \"\${formatblue}EXITING SCRIPT:\${formatorange} \${script_path}\${format}\"
fi
# Display script process time
if [ \${show_time} == 'yes' 2>/dev/null ]; then # Script time message
script_time_func 2>/dev/null
fi
printf \"\${formatreset}\\n\"
exit \${exit_type}
} # exit_message

#---------------------------------- CODE -----------------------------------#
for inputs; do # Reads through all inputs
option_eval \${inputs}
done

if [ \${clear_screen} != 'no' 2>/dev/null ]; then
clear	# Clears screen unless activation of input option: -cs
fi

color_formats # Activates or inhibits colorful output

# Exit script if invalid inputs found
if [ \${#bad_inputs[@]} -gt 0 ]; then
re_enter_input_message \${bad_inputs[@]}
exit_message 1
fi

create_option_file # create .ini file

if [ \${activate_help} == 'yes' ]; then # -h or --help
script_usage
elif [ \${open_script} == 'yes' ]; then # -o or --open
open_text_editor \${script_path} \${text_editors[@]}
exit_message 0 -nm -nt
elif [ \${list_settings} == 'yes' 2>/dev/null ]; then # -l option
list_user_settings
elif [ \${reset_template} == 'yes' 2>/dev/null ]; then # -r option
open_text_editor \${option_file} \${text_editors[@]}
reset_option_file
exit_message 0
fi

exit_message 0" 
}

create_script2 () { # Advanced script with option file but no time display
echo "#!/bin/bash
#--------------------------------------------------------------------------------------#
# Created: ${todays_date} By: Evan Layher (ealayher@ucdavis.edu: UC Davis Medical Center)
# Revised: ${todays_date} By: Evan Layher
# Reference: github.com/ealayher
#--------------------------------------------------------------------------------------#
#
#-------------------------------- VARIABLES --------------------------------#

#--------------------------- DEFAULT SETTINGS ------------------------------#
max_bg_jobs='10' # '10': Max number of background processes
default_text_editors=('kwrite' 'gedit' 'emacs' 'vim' 'leafpad') # text editor commands in order of preference

#----------------------- GENERAL SCRIPT VARIABLES --------------------------#
script_path=\"\$(readlink -f \${BASH_SOURCE[0]})\"	# Full path of this script
version_number='1.0'
activate_colors='yes'	# 'yes': Displays messages in color (color_formats) ['yes' or 'no'] [INPUT: '-nc']
activate_help='no'	# 'no': Displays help messeage (script_usage) ['yes' or 'no'] [INPUT: '-h' or '--help']
clear_screen='yes'	# 'yes': Clears screen before running script ['yes' or 'no'] [INPUT: '-cs']
display_exit='yes'	# 'yes': Displays an exit message ['yes' or 'no'] [INPUT: '-nm']
list_settings='no'	# 'no': List user settings (list_user_settings) ['yes' or 'no'] [INPUT: '-l']
open_script='no'	# 'no': Opens this script ['yes' or 'no'] [INPUT: '-o' or '--open']
reset_template='no'	# 'no': Reset template file (reset_option_file) ['yes' or 'no'] [INPUT: '-r']
suggest_help='no'	# 'no': Suggests help if needed ['yes' or 'no']

#-------------------------------- FUNCTIONS --------------------------------#
control_bg_jobs () { # Controls number of background processes
job_count=\`jobs -p |wc -l\`
if [ \${job_count} -ge \${max_bg_jobs} ]; then
sleep 0.25
control_bg_jobs
fi
} # control_bg_jobs

option_eval () { # Evaluates command line options
if [ \${1} == '-cs' 2>/dev/null ] || [ \${1} == '-h' 2>/dev/null ] || [ \${1} == '--help' 2>/dev/null ] || \\
[ \${1} == '-l' 2>/dev/null ] || [ \${1} == '-nc' 2>/dev/null ] || [ \${1} == '-nm' 2>/dev/null ] || \\
[ \${1} == '-o' 2>/dev/null ] || [ \${1} == '--open' 2>/dev/null ] || [ \${1} == '-t' 2>/dev/null ] || \\
[ \${1} == '-tr' 2>/dev/null ] || [ \${1} == '-r' 2>/dev/null ]; then
activate_options \${1}
elif ! [ -z \${t_in} 2>/dev/null ] && [ \${t_in} == 'yes' 2>/dev/null ]; then
add_editors=(\"\${1} \${add_editors[@]}\") # Maintain order of editor inputs
elif ! [ -z \${tr_in} 2>/dev/null ] && [ \${tr_in} == 'yes' 2>/dev/null ]; then
rem_editors+=(\"\${1}\")
elif [ \${1:0:1} == '-' 2>/dev/null ]; then
bad_inputs+=(\"\${1}\")
else
bad_inputs+=(\"\${1}\")
fi
} # option_eval

activate_options () {
t_in='no'  # Do not read in text editor to add
tr_in='no' # Do not read in text editor to remove
if [ \${1} == '-cs' ]; then
clear_screen='no'	# Do not clear screen
elif [ \${1} == '-h' ] || [ \${1} == '--help' ]; then
activate_help='yes'	# Display help message
elif [ \${1} == '-l' ]; then
list_settings='yes'	# List user settings
elif [ \${1} == '-nc' ]; then
activate_colors='no'	# Do not display in color
elif [ \${1} == '-nm' ]; then
display_exit='no'	# Do not display exit message
elif [ \${1} == '-o' ] || [ \${1} == '--open' ]; then
open_script='yes'	# Open this script
elif [ \${1} == '-r' ]; then
reset_template='yes'   # Reset option file
elif [ \${1} == '-t' ]; then
t_in='yes'             # Add text editor
list_settings='yes'	# List user settings
elif [ \${1} == '-tr' ]; then
tr_in='yes'            # Remove text editor
list_settings='yes'	# List user settings
else
bad_inputs+=(\"ERROR:activate_options:\${1}\")
fi
} # activate_options

color_formats () { # Print colorful terminal text
if [ \${activate_colors} == 'yes' 2>/dev/null ]; then
format=\`tput setab 0; tput setaf 7\` 	 	# Black background, white text
formatblue=\`tput setab 0; tput setaf 4\`  	# Black background, blue text
formatgreen=\`tput setab 0; tput setaf 2\` 	# Black background, green text
formatorange=\`tput setab 0; tput setaf 3\`  	# Black background, orange text
formatred=\`tput setab 0; tput setaf 1\` 	# Black background, red text
formatreset=\`tput sgr0\`				# Reset to default terminal settings
else
format=''	# No formatting
formatblue=''	# No formatting
formatgreen=''	# No formatting
formatorange=''	# No formatting
formatred=''	# No formatting
fi
} # color_formats

open_text_editor () { # Open file [first input file, then text editors]
file_to_open=\${1}
valid_text_editor='no'
if [ -f \${file_to_open} ]; then
	for i_text_editor in \${@:2}; do
	\${i_text_editor} \${file_to_open} 2>/dev/null &
	check_text_pid=(\`ps --no-headers -p \$!\`) # Check pid is running
		if [ \${#check_text_pid[@]} -gt 0 ]; then
		valid_text_editor='yes'
		break
		fi
	done
	if [ \${valid_text_editor} == 'no' 2>/dev/null ]; then
	echo \"\${formatred}NO VALID TEXT EDITORS: \${formatorange}\${@:2}\${format}\"
	exit_message 99 -nh -nm
	fi
else
echo \"\${formatred}MISSING FILE: \${formatorange}\${file_to_open}\${format}\"
fi
} # open_text_editor

create_option_file () { # Creates .ini file to store user preferences
ealayher_code_dir=\"\${HOME}/.ealayher_code\" # Directory of preference file
option_file=\"\${ealayher_code_dir}/\$(basename \${script_path%.*}).ini\" # .ini file path
if ! [ -d \${ealayher_code_dir} ]; then # Create directory for option file
mkdir \${ealayher_code_dir}
fi
if ! [ -f \${option_file} ]; then # Create option file
echo \"[options]
text_editors=(\${default_text_editors[@]})
\" > \${option_file}
fi
text_editors=(\`awk -F '=' '/text_editors=/ {print \$2}' \${option_file} |sed -e 's@(@@g' -e 's@)@@g'\`)
if [ \${#add_editors[@]} -gt 0 ] || [ \${#rem_editors[@]} -gt 0 ]; then # Change text editors
old_editor_vals=\"text_editors=(\${text_editors[@]})\"
	for i_rem_editor in \${rem_editors[@]} \${add_editors[@]}; do # Removes duplicate inputs
	text_editors=(\`printf ' %s ' \${text_editors[@]} |sed \"s@ \${i_rem_editor} @ @g\"\`)
	done
	for i_add_editor in \${add_editors[@]}; do # Put newest editor in front
	text_editors=(\${i_add_editor} \${text_editors[@]})
	done
	new_editor_vals=\"text_editors=(\${text_editors[@]})\"
sed -i \"s@\${old_editor_vals}@\${new_editor_vals}@g\" \${option_file} # Replace old editors with new editors
text_editors=(\`awk -F '=' '/text_editors=/ {print \$2}' \${option_file} |sed -e 's@(@@g' -e 's@)@@g'\`)
fi
} # create_option_file

vital_command () { # exits script if an essential command fails
command_status=\${1}
command_line_number=\${2}
if ! [ -z \${command_status} ] && [ \${command_status} -ne 0 ]; then
echo \"\${formatred}INVALID COMMAND: LINE \${formatorange}\${command_line_number}\${format}\"
exit_message 98 -nh -nm
fi
} # vital_command

vital_file () { # exits script if an essential file is missing
for vitals; do
	if ! [ -e \${vitals} 2>/dev/null ]; then
	bad_files+=(\"\${vitals}\")
	fi
done
if [ \${#bad_files[@]} -gt 0 ]; then
echo \"\${formatred}MISSING ESSENTIAL FILE(S):\${formatblue}\"
printf '%s\\n' \${bad_files[@]}
exit_message 97 -nh -nm
fi
} # vital_file

reset_option_file () { # -r: Reset user option file
printf \"\${formatorange}RESET OPTIONS FILE? [\${formatgreen}y\${formatorange}/\${formatgreen}n\${formatorange}]:\${format}\"
read -r reset_it
if [ \${reset_it} == 'y' 2>/dev/null ] || [ \${reset_it} == 'Y' 2>/dev/null ]; then
kill \$! 2>/dev/null # Close file before removing
wait \$! 2>/dev/null # Suppress kill message
rm \${option_file} 2>/dev/null
create_option_file
elif [ \${reset_it} == 'n' 2>/dev/null ] || [ \${reset_it} == 'N' 2>/dev/null ]; then
kill \$! 2>/dev/null # Close file before removing
wait \$! 2>/dev/null # Suppress kill message
exit_message 0
else
re_enter_input_message \${reset_it}
reset_option_file
fi
} # reset_option_file

#-------------------------------- MESSAGES ---------------------------------#
script_usage () { # Script explanation
echo \"\${formatred}HELP MESSAGE: \${formatgreen}\${script_path}\${format}
\${formatorange}DESCRIPTION\${format}:
     
\${formatorange}ADVICE\${format}: Create an alias inside your \${formatorange}\${HOME}/.bashrc\${format} file
(e.g. \${formatgreen}alias xx='\${script_path}'\${format})
     
\${formatorange}USAGE\${format}:
 [\${formatorange}1\${format}] \${formatgreen}\${script_path}\${format}
     
\${formatorange}OPTIONS\${format}: Can input multiple options in any order
 \${formatblue}-cs\${format}  Prevent screen from clearing before script processes
 \${formatblue}-h\${format} or \${formatblue}--help\${format}  Display this message
 \${formatblue}-nc\${format}  Prevent color printing in terminal
 \${formatblue}-l\${format}   List default settings
 \${formatblue}-nm\${format}  Prevent exit message from displaying
 \${formatblue}-o\${format} or \${formatblue}--open\${format} Open this script
 \${formatblue}-r\${format}   Reset option file
 \${formatblue}-t\${format}   Add text editor(s)\${format}
  [\${formatorange}2\${format}] \${formatgreen}\${script_path} \${formatblue}-t \${formatorange}kwrite gedit\$\\{format}
 \${formatblue}-tr\${format}  Remove text editor(s)\${format}
  [\${formatorange}3\${format}] \${formatgreen}\${script_path} \${formatblue}-tr \${formatorange}kwrite gedit\$\\{format}
     
\${formatorange}DEFAULT SETTINGS\${format}:
 text editors: \${formatgreen}\$(grep 'text_editors=' \${option_file} |sed -e 's@text_editors=@@g' -e 's@(@@g' -e 's@)@@g')\${format}
     
\${formatorange}VERSION: \${formatgreen}\${version_number}\${format}
\${formatred}END OF HELP: \${formatgreen}\${script_path}\${format}\"
exit_message 0 -nm
} # script_usage

list_user_settings () { # -l option
create_option_file
echo \"\${formatblue}+---USER SETTINGS---+\${formatorange}\"
echo \"\${formatgreen}Text editors: \${formatorange}\${text_editors[@]}\${format}\"
exit_message 0 -nm
} # list_settings

re_enter_input_message () { # Displays invalid input message
clear
echo \"\${formatred}INVALID INPUT: \${formatorange}\${@}\${format}\"
echo \"\${formatblue}PLEASE RE-ENTER INPUT\${format}\"
} # re_enter_input_message

script_time_message () { # Script process time message
echo \"STARTED : \${script_start_date_time}\"
echo \"FINISHED: \`date +%x' '%r\`\"
} # script_time_message

exit_message () { # Message before exiting script
if [ -z \${1} 2>/dev/null ] || ! [ \${1} -eq \${1} 2>/dev/null ]; then
exit_type='0'
else
exit_type=\${1}
fi
if [ \${exit_type} -ne 0 ]; then
suggest_help='yes'
fi
for exit_inputs; do
	if [ \${exit_inputs} == '-nh' 2>/dev/null ]; then
	suggest_help='no'
	elif [ \${exit_inputs} == '-nm' 2>/dev/null ]; then
	display_exit='no'
	fi
done
wait # Waits for background processes to finish before exiting
# Suggest help message
if [ \${suggest_help} == 'yes' 2>/dev/null ]; then
echo \"\${formatorange}TO DISPLAY HELP MESSAGE TYPE: \${formatgreen}\${script_path} -h\${format}\"
fi
# Display exit message
if [ \${display_exit} != 'no' 2>/dev/null ]; then # Exit message
echo \"\${formatblue}EXITING SCRIPT:\${formatorange} \${script_path}\${format}\"
fi
printf \"\${formatreset}\\n\"
exit \${exit_type}
} # exit_message

#---------------------------------- CODE -----------------------------------#
for inputs; do # Reads through all inputs
option_eval \${inputs}
done

if [ \${clear_screen} != 'no' 2>/dev/null ]; then
clear	# Clears screen unless activation of input option: -cs
fi

color_formats # Activates or inhibits colorful output

# Exit script if invalid inputs found
if [ \${#bad_inputs[@]} -gt 0 ]; then
re_enter_input_message \${bad_inputs[@]}
exit_message 1
fi

create_option_file # create .ini file

if [ \${activate_help} == 'yes' ]; then # -h or --help
script_usage
elif [ \${open_script} == 'yes' ]; then # -o or --open
open_text_editor \${script_path} \${text_editors[@]}
exit_message 0 -nm
elif [ \${list_settings} == 'yes' 2>/dev/null ]; then # -l option
list_user_settings
elif [ \${reset_template} == 'yes' 2>/dev/null ]; then # -r option
open_text_editor \${option_file} \${text_editors[@]}
reset_option_file
exit_message 0
fi

exit_message 0" 
}

create_script3 () { # Advanced script WITHOUT option file
echo "#!/bin/bash
#--------------------------------------------------------------------------------------#
# Created: ${todays_date} By: Evan Layher (ealayher@ucdavis.edu: UC Davis Medical Center)
# Revised: ${todays_date} By: Evan Layher
#--------------------------------------------------------------------------------------#
#
#-------------------------------- VARIABLES --------------------------------#

#--------------------------- DEFAULT SETTINGS ------------------------------#
max_bg_jobs='10' # '10': Max number of background processes
text_editors=('kwrite' 'gedit' 'emacs' 'vim' 'leafpad') # text editor commands in order of preference

#----------------------- GENERAL SCRIPT VARIABLES --------------------------#
script_start_time=\`date +%s\` 		# Script start time (in seconds).
script_start_date_time=\`date +%x' '%r\`	# Script start date and time: (e.g. 01/01/2015 12:00:00 AM)
script_path=\"\$(readlink -f \${BASH_SOURCE[0]})\"	# Full path of this script
version_number='1.0'
activate_colors='yes'	# 'yes': Displays messages in color (color_formats) ['yes' or 'no'] [INPUT: '-nc']
activate_help='no'	# 'no': Displays help messeage (script_usage) ['yes' or 'no'] [INPUT: '-h' or '--help']
clear_screen='yes'	# 'yes': Clears screen before running script ['yes' or 'no'] [INPUT: '-cs']
display_exit='yes'	# 'yes': Displays an exit message ['yes' or 'no'] [INPUT: '-nm']
open_script='no'	# 'no': Opens this script ['yes' or 'no'] [INPUT: '-o' or '--open']
show_time='yes'		# 'yes': Displays script process time ['yes' or 'no'] [INPUT: '-nt']
suggest_help='no'	# 'no': Suggests help if needed ['yes' or 'no']

#-------------------------------- FUNCTIONS --------------------------------#
control_bg_jobs () { # Controls number of background processes
job_count=\`jobs -p |wc -l\`
if [ \${job_count} -ge \${max_bg_jobs} ]; then
sleep 0.25
control_bg_jobs
fi
} # control_bg_jobs

option_eval () { # Evaluates command line options
if [ \${1} == '-cs' 2>/dev/null ] || [ \${1} == '-h' 2>/dev/null ] || [ \${1} == '--help' 2>/dev/null ] || \\
[ \${1} == '-nc' 2>/dev/null ] || [ \${1} == '-nt' 2>/dev/null ] || [ \${1} == '-nm' 2>/dev/null ] || \\
[ \${1} == '-o' 2>/dev/null ] || [ \${1} == '--open' 2>/dev/null ]; then
activate_options \${1}
elif [ \${1:0:1} == '-' 2>/dev/null ]; then
bad_inputs+=(\"\${1}\")
else
bad_inputs+=(\"\${1}\")
fi
} # option_eval

activate_options () {
if [ \${1} == '-cs' ]; then
clear_screen='no'	# Do not clear screen
elif [ \${1} == '-h' ] || [ \${1} == '--help' ]; then
activate_help='yes'	# Display help message
elif [ \${1} == '-nc' ]; then
activate_colors='no'	# Do not display in color
elif [ \${1} == '-nm' ]; then
display_exit='no'	# Do not display exit message
elif [ \${1} == '-nt' ]; then
show_time='no'		# Do not display script process time
elif [ \${1} == '-o' ] || [ \${1} == '--open' ]; then
open_script='yes'	# Open this script
else
bad_inputs+=(\"ERROR:activate_options:\${1}\")
fi
} # activate_options

color_formats () { # Print colorful terminal text
if [ \${activate_colors} == 'yes' 2>/dev/null ]; then
format=\`tput setab 0; tput setaf 7\` 	 	# Black background, white text
formatblue=\`tput setab 0; tput setaf 4\`  	# Black background, blue text
formatgreen=\`tput setab 0; tput setaf 2\` 	# Black background, green text
formatorange=\`tput setab 0; tput setaf 3\`  	# Black background, orange text
formatred=\`tput setab 0; tput setaf 1\` 	# Black background, red text
formatreset=\`tput sgr0\`				# Reset to default terminal settings
else
format=''	# No formatting
formatblue=''	# No formatting
formatgreen=''	# No formatting
formatorange=''	# No formatting
formatred=''	# No formatting
fi
} # color_formats

open_text_editor () { # Open file [first input file, then text editors]
file_to_open=\${1}
valid_text_editor='no'
if [ -f \${file_to_open} ]; then
	for i_text_editor in \${@:2}; do
	\${i_text_editor} \${file_to_open} 2>/dev/null &
	check_text_pid=(\`ps --no-headers -p \$!\`) # Check pid is running
		if [ \${#check_text_pid[@]} -gt 0 ]; then
		valid_text_editor='yes'
		break
		fi
	done
	if [ \${valid_text_editor} == 'no' 2>/dev/null ]; then
	echo \"\${formatred}NO VALID TEXT EDITORS: \${formatorange}\${@:2}\${format}\"
	exit_message 99 -nh -nm -nt
	fi
else
echo \"\${formatred}MISSING FILE: \${formatorange}\${file_to_open}\${format}\"
fi
} # open_text_editor

vital_command () { # exits script if an essential command fails
command_status=\${1}
command_line_number=\${2}
if ! [ -z \${command_status} ] && [ \${command_status} -ne 0 ]; then
echo \"\${formatred}INVALID COMMAND: LINE \${formatorange}\${command_line_number}\${format}\"
exit_message 98 -nh -nm -nt
fi
} # vital_command

vital_file () { # exits script if an essential file is missing
for vitals; do
	if ! [ -e \${vitals} 2>/dev/null ]; then
	bad_files+=(\"\${vitals}\")
	fi
done
if [ \${#bad_files[@]} -gt 0 ]; then
echo \"\${formatred}MISSING ESSENTIAL FILE(S):\${formatblue}\"
printf '%s\\n' \${bad_files[@]}
exit_message 97 -nh -nm -nt
fi
} # vital_file

#-------------------------------- MESSAGES ---------------------------------#
script_usage () { # Script explanation
echo \"\${formatred}HELP MESSAGE: \${formatgreen}\${script_path}\${format}
\${formatorange}DESCRIPTION\${format}:
     
\${formatorange}ADVICE\${format}: Create an alias inside your \${formatorange}\${HOME}/.bashrc\${format} file
(e.g. \${formatgreen}alias xx='\${script_path}'\${format})
     
\${formatorange}USAGE\${format}:
 [\${formatorange}1\${format}] \${formatgreen}\${script_path}\${format}
     
\${formatorange}OPTIONS\${format}: Can input multiple options in any order
 \${formatblue}-cs\${format}  Prevent screen from clearing before script processes
 \${formatblue}-h\${format} or \${formatblue}--help\${format}  Display this message
 \${formatblue}-nc\${format}  Prevent color printing in terminal
 \${formatblue}-nm\${format}  Prevent exit message from displaying
 \${formatblue}-nt\${format}  Prevent script process time from displaying
 \${formatblue}-o\${format} or \${formatblue}--open\${format} Open this script
     
\${formatorange}DEFAULT SETTINGS\${format}:
 text editors: \${formatgreen}\${text_editors[@]}\${format}
     
\${formatorange}VERSION: \${formatgreen}\${version_number}\${format}
\${formatred}END OF HELP: \${formatgreen}\${script_path}\${format}\"
exit_message 0 -nt -nm
} # script_usage

re_enter_input_message () { # Displays invalid input message
clear
echo \"\${formatred}INVALID INPUT: \${formatorange}\${@}\${format}\"
echo \"\${formatblue}PLEASE RE-ENTER INPUT\${format}\"
} # re_enter_input_message

script_time_message () { # Script process time message
echo \"STARTED : \${script_start_date_time}\"
echo \"FINISHED: \`date +%x' '%r\`\"
} # script_time_message

script_time_func () { # Script process time calculation
script_end_time=\`date +%s\`
script_process_time=\$((\${script_end_time} - \${script_start_time}))
if [ \${script_process_time} -lt 60 ];then
script_time_message 
echo \"PROCESS TIME: \${script_process_time} second(s).\"
elif [ \${script_process_time} -lt 3600 ];then
script_time_message 
echo \"PROCESS TIME: \$((\${script_process_time} / 60)) minute(s) and \$((\${script_process_time} % 60)) second(s).\"
elif [ \${script_process_time} -lt 86400 ];then
script_time_message 
echo \"PROCESS TIME: \$((\${script_process_time} / 3600)) hour(s) \$((\${script_process_time} % 3600 / 60)) minute(s) and \$((\${script_process_time} % 60)) second(s).\"
elif [ \${script_process_time} -ge 86400 ];then
script_time_message 
echo \"PROCESS TIME: \$((\${script_process_time} / 86400)) day(s) \$((\${script_process_time} % 86400 / 3600)) hour(s) \$((\${script_process_time} % 3600 / 60)) minute(s) and \$((\${script_process_time} % 60)) second(s).\"
else
echo \"\${formatred}ERROR: \${formatorange}script_time_func\${format}\"
fi
} # script_time_func

exit_message () { # Message before exiting script
if [ -z \${1} 2>/dev/null ] || ! [ \${1} -eq \${1} 2>/dev/null ]; then
exit_type='0'
else
exit_type=\${1}
fi
if [ \${exit_type} -ne 0 ]; then
suggest_help='yes'
fi
for exit_inputs; do
	if [ \${exit_inputs} == '-nh' 2>/dev/null ]; then
	suggest_help='no'
	elif [ \${exit_inputs} == '-nt' 2>/dev/null ]; then
	show_time='no'
	elif [ \${exit_inputs} == '-nm' 2>/dev/null ]; then
	display_exit='no'
	fi
done
wait # Waits for background processes to finish before exiting
# Suggest help message
if [ \${suggest_help} == 'yes' 2>/dev/null ]; then
echo \"\${formatorange}TO DISPLAY HELP MESSAGE TYPE: \${formatgreen}\${script_path} -h\${format}\"
fi
# Display exit message
if [ \${display_exit} != 'no' 2>/dev/null ]; then # Exit message
echo \"\${formatblue}EXITING SCRIPT:\${formatorange} \${script_path}\${format}\"
fi
# Display script process time
if [ \${show_time} == 'yes' 2>/dev/null ]; then # Script time message
script_time_func 2>/dev/null
fi
printf \"\${formatreset}\\n\"
exit \${exit_type}
} # exit_message

#---------------------------------- CODE -----------------------------------#
for inputs; do # Reads through all inputs
option_eval \${inputs}
done

if [ \${clear_screen} != 'no' 2>/dev/null ]; then
clear	# Clears screen unless activation of input option: -cs
fi

color_formats # Activates or inhibits colorful output

# Exit script if invalid inputs found
if [ \${#bad_inputs[@]} -gt 0 ]; then
re_enter_input_message \${bad_inputs[@]}
exit_message 1
fi

if [ \${activate_help} == 'yes' ]; then # -h or --help
script_usage
elif [ \${open_script} == 'yes' ]; then # -o or --open
open_text_editor \${script_path} \${text_editors[@]}
exit_message 0 -nm -nt
fi

exit_message 0" 
}

create_script4 () { # Advanced script WITHOUT option file or time display
echo "#!/bin/bash
#--------------------------------------------------------------------------------------#
# Created: ${todays_date} By: Evan Layher (ealayher@ucdavis.edu: UC Davis Medical Center)
# Revised: ${todays_date} By: Evan Layher
#--------------------------------------------------------------------------------------#
#
#-------------------------------- VARIABLES --------------------------------#

#--------------------------- DEFAULT SETTINGS ------------------------------#
max_bg_jobs='10' # '10': Max number of background processes
text_editors=('kwrite' 'gedit' 'emacs' 'vim' 'leafpad') # text editor commands in order of preference

#----------------------- GENERAL SCRIPT VARIABLES --------------------------#
script_path=\"\$(readlink -f \${BASH_SOURCE[0]})\"	# Full path of this script
version_number='1.0'
activate_colors='yes'	# 'yes': Displays messages in color (color_formats) ['yes' or 'no'] [INPUT: '-nc']
activate_help='no'	# 'no': Displays help messeage (script_usage) ['yes' or 'no'] [INPUT: '-h' or '--help']
clear_screen='yes'	# 'yes': Clears screen before running script ['yes' or 'no'] [INPUT: '-cs']
display_exit='yes'	# 'yes': Displays an exit message ['yes' or 'no'] [INPUT: '-nm']
open_script='no'	# 'no': Opens this script ['yes' or 'no'] [INPUT: '-o' or '--open']
suggest_help='no'	# 'no': Suggests help if needed ['yes' or 'no']

#-------------------------------- FUNCTIONS --------------------------------#
control_bg_jobs () { # Controls number of background processes
job_count=\`jobs -p |wc -l\`
if [ \${job_count} -ge \${max_bg_jobs} ]; then
sleep 0.25
control_bg_jobs
fi
} # control_bg_jobs

option_eval () { # Evaluates command line options
if [ \${1} == '-cs' 2>/dev/null ] || [ \${1} == '-h' 2>/dev/null ] || [ \${1} == '--help' 2>/dev/null ] || \\
[ \${1} == '-nc' 2>/dev/null ] || [ \${1} == '-nm' 2>/dev/null ] || [ \${1} == '-o' 2>/dev/null ] || \\
[ \${1} == '--open' 2>/dev/null ]; then
activate_options \${1}
elif [ \${1:0:1} == '-' 2>/dev/null ]; then
bad_inputs+=(\"\${1}\")
else
bad_inputs+=(\"\${1}\")
fi
} # option_eval

activate_options () {
if [ \${1} == '-cs' ]; then
clear_screen='no'	# Do not clear screen
elif [ \${1} == '-h' ] || [ \${1} == '--help' ]; then
activate_help='yes'	# Display help message
elif [ \${1} == '-nc' ]; then
activate_colors='no'	# Do not display in color
elif [ \${1} == '-nm' ]; then
display_exit='no'	# Do not display exit message
elif [ \${1} == '-o' ] || [ \${1} == '--open' ]; then
open_script='yes'	# Open this script
else
bad_inputs+=(\"ERROR:activate_options:\${1}\")
fi
} # activate_options

color_formats () { # Print colorful terminal text
if [ \${activate_colors} == 'yes' 2>/dev/null ]; then
format=\`tput setab 0; tput setaf 7\` 	 	# Black background, white text
formatblue=\`tput setab 0; tput setaf 4\`  	# Black background, blue text
formatgreen=\`tput setab 0; tput setaf 2\` 	# Black background, green text
formatorange=\`tput setab 0; tput setaf 3\`  	# Black background, orange text
formatred=\`tput setab 0; tput setaf 1\` 	# Black background, red text
formatreset=\`tput sgr0\`				# Reset to default terminal settings
else
format=''	# No formatting
formatblue=''	# No formatting
formatgreen=''	# No formatting
formatorange=''	# No formatting
formatred=''	# No formatting
fi
} # color_formats

open_text_editor () { # Open file [first input file, then text editors]
file_to_open=\${1}
valid_text_editor='no'
if [ -f \${file_to_open} ]; then
	for i_text_editor in \${@:2}; do
	\${i_text_editor} \${file_to_open} 2>/dev/null &
	check_text_pid=(\`ps --no-headers -p \$!\`) # Check pid is running
		if [ \${#check_text_pid[@]} -gt 0 ]; then
		valid_text_editor='yes'
		break
		fi
	done
	if [ \${valid_text_editor} == 'no' 2>/dev/null ]; then
	echo \"\${formatred}NO VALID TEXT EDITORS: \${formatorange}\${@:2}\${format}\"
	exit_message 99 -nh -nm
	fi
else
echo \"\${formatred}MISSING FILE: \${formatorange}\${file_to_open}\${format}\"
fi
} # open_text_editor

vital_command () { # exits script if an essential command fails
command_status=\${1}
command_line_number=\${2}
if ! [ -z \${command_status} ] && [ \${command_status} -ne 0 ]; then
echo \"\${formatred}INVALID COMMAND: LINE \${formatorange}\${command_line_number}\${format}\"
exit_message 98 -nh -nm
fi
} # vital_command

vital_file () { # exits script if an essential file is missing
for vitals; do
	if ! [ -e \${vitals} 2>/dev/null ]; then
	bad_files+=(\"\${vitals}\")
	fi
done
if [ \${#bad_files[@]} -gt 0 ]; then
echo \"\${formatred}MISSING ESSENTIAL FILE(S):\${formatblue}\"
printf '%s\\n' \${bad_files[@]}
exit_message 97 -nh -nm
fi
} # vital_file

#-------------------------------- MESSAGES ---------------------------------#
script_usage () { # Script explanation
echo \"\${formatred}HELP MESSAGE: \${formatgreen}\${script_path}\${format}
\${formatorange}DESCRIPTION\${format}:
     
\${formatorange}ADVICE\${format}: Create an alias inside your \${formatorange}\${HOME}/.bashrc\${format} file
(e.g. \${formatgreen}alias xx='\${script_path}'\${format})
     
\${formatorange}USAGE\${format}:
 [\${formatorange}1\${format}] \${formatgreen}\${script_path}\${format}
     
\${formatorange}OPTIONS\${format}: Can input multiple options in any order
 \${formatblue}-cs\${format}  Prevent screen from clearing before script processes
 \${formatblue}-h\${format} or \${formatblue}--help\${format}  Display this message
 \${formatblue}-nc\${format}  Prevent color printing in terminal
 \${formatblue}-nm\${format}  Prevent exit message from displaying
 \${formatblue}-o\${format} or \${formatblue}--open\${format} Open this script
     
\${formatorange}DEFAULT SETTINGS\${format}:
 text editors: \${formatgreen}\${text_editors[@]}\${format}
     
\${formatorange}VERSION: \${formatgreen}\${version_number}\${format}
\${formatred}END OF HELP: \${formatgreen}\${script_path}\${format}\"
exit_message 0 -nm
} # script_usage

re_enter_input_message () { # Displays invalid input message
clear
echo \"\${formatred}INVALID INPUT: \${formatorange}\${@}\${format}\"
echo \"\${formatblue}PLEASE RE-ENTER INPUT\${format}\"
} # re_enter_input_message

exit_message () { # Message before exiting script
if [ -z \${1} 2>/dev/null ] || ! [ \${1} -eq \${1} 2>/dev/null ]; then
exit_type='0'
else
exit_type=\${1}
fi
if [ \${exit_type} -ne 0 ]; then
suggest_help='yes'
fi
for exit_inputs; do
	if [ \${exit_inputs} == '-nh' 2>/dev/null ]; then
	suggest_help='no'
	elif [ \${exit_inputs} == '-nm' 2>/dev/null ]; then
	display_exit='no'
	fi
done
wait # Waits for background processes to finish before exiting
# Suggest help message
if [ \${suggest_help} == 'yes' 2>/dev/null ]; then
echo \"\${formatorange}TO DISPLAY HELP MESSAGE TYPE: \${formatgreen}\${script_path} -h\${format}\"
fi
# Display exit message
if [ \${display_exit} != 'no' 2>/dev/null ]; then # Exit message
echo \"\${formatblue}EXITING SCRIPT:\${formatorange} \${script_path}\${format}\"
fi
printf \"\${formatreset}\\n\"
exit \${exit_type}
} # exit_message

#---------------------------------- CODE -----------------------------------#
for inputs; do # Reads through all inputs
option_eval \${inputs}
done

if [ \${clear_screen} != 'no' 2>/dev/null ]; then
clear	# Clears screen unless activation of input option: -cs
fi

color_formats # Activates or inhibits colorful output

# Exit script if invalid inputs found
if [ \${#bad_inputs[@]} -gt 0 ]; then
re_enter_input_message \${bad_inputs[@]}
exit_message 1
fi

if [ \${activate_help} == 'yes' ]; then # -h or --help
script_usage
elif [ \${open_script} == 'yes' ]; then # -o or --open
open_text_editor \${script_path} \${text_editors[@]}
exit_message 0 -nm
fi

exit_message 0"
} # create_script4

create_script5 () { # Basic script with exit message
echo "#!/bin/bash
#--------------------------------------------------------------------------------------#
# Created: ${todays_date} By: Evan Layher (ealayher@ucdavis.edu: UC Davis Medical Center)
# Revised: ${todays_date} By: Evan Layher
#--------------------------------------------------------------------------------------#
#
#-------------------------------- VARIABLES --------------------------------#

#--------------------------- DEFAULT SETTINGS ------------------------------#
text_editors=('kwrite' 'gedit' 'emacs' 'vim' 'leafpad') # text editor commands in order of preference

#----------------------- GENERAL SCRIPT VARIABLES --------------------------#
script_path=\"\$(readlink -f \${BASH_SOURCE[0]})\"	# Full path of this script
version_number='1.0'
activate_colors='yes'	# 'yes': Displays messages in color (color_formats) ['yes' or 'no'] [INPUT: '-nc']
activate_help='no'	# 'no': Displays help messeage (script_usage) ['yes' or 'no'] [INPUT: '-h' or '--help']
clear_screen='yes'	# 'yes': Clears screen before running script ['yes' or 'no'] [INPUT: '-cs']
display_exit='yes'	# 'yes': Displays an exit message ['yes' or 'no'] [INPUT: '-nm']
open_script='no'	# 'no': Opens this script ['yes' or 'no'] [INPUT: '-o' or '--open']
suggest_help='no'	# 'no': Suggests help if needed ['yes' or 'no']

#-------------------------------- FUNCTIONS --------------------------------#
option_eval () { # Evaluates command line options
if [ \${1} == '-cs' 2>/dev/null ] || [ \${1} == '-h' 2>/dev/null ] || [ \${1} == '--help' 2>/dev/null ] || \\
[ \${1} == '-nc' 2>/dev/null ] || [ \${1} == '-nm' 2>/dev/null ] || [ \${1} == '-o' 2>/dev/null ] || \\
[ \${1} == '--open' 2>/dev/null ]; then
activate_options \${1}
elif [ \${1:0:1} == '-' 2>/dev/null ]; then
bad_inputs+=(\"\${1}\")
else
bad_inputs+=(\"\${1}\")
fi
} # option_eval

activate_options () {
if [ \${1} == '-cs' ]; then
clear_screen='no'	# Do not clear screen
elif [ \${1} == '-h' ] || [ \${1} == '--help' ]; then
activate_help='yes'	# Display help message
elif [ \${1} == '-nc' ]; then
activate_colors='no'	# Do not display in color
elif [ \${1} == '-nm' ]; then
display_exit='no'	# Do not display exit message
elif [ \${1} == '-o' ] || [ \${1} == '--open' ]; then
open_script='yes'	# Open this script
else
bad_inputs+=(\"ERROR:activate_options:\${1}\")
fi
} # activate_options

color_formats () { # Print colorful terminal text
if [ \${activate_colors} == 'yes' 2>/dev/null ]; then
format=\`tput setab 0; tput setaf 7\` 	 	# Black background, white text
formatblue=\`tput setab 0; tput setaf 4\`  	# Black background, blue text
formatgreen=\`tput setab 0; tput setaf 2\` 	# Black background, green text
formatorange=\`tput setab 0; tput setaf 3\`  	# Black background, orange text
formatred=\`tput setab 0; tput setaf 1\` 	# Black background, red text
formatreset=\`tput sgr0\`				# Reset to default terminal settings
else
format=''	# No formatting
formatblue=''	# No formatting
formatgreen=''	# No formatting
formatorange=''	# No formatting
formatred=''	# No formatting
fi
} # color_formats

open_text_editor () { # Open file [first input file, then text editors]
file_to_open=\${1}
valid_text_editor='no'
if [ -f \${file_to_open} ]; then
	for i_text_editor in \${@:2}; do
	\${i_text_editor} \${file_to_open} 2>/dev/null &
	check_text_pid=(\`ps --no-headers -p \$!\`) # Check pid is running
		if [ \${#check_text_pid[@]} -gt 0 ]; then
		valid_text_editor='yes'
		break
		fi
	done
	if [ \${valid_text_editor} == 'no' 2>/dev/null ]; then
	echo \"\${formatred}NO VALID TEXT EDITORS: \${formatorange}\${@:2}\${format}\"
	exit_message 99 -nh -nm
	fi
else
echo \"\${formatred}MISSING FILE: \${formatorange}\${file_to_open}\${format}\"
fi
} # open_text_editor

vital_command () { # exits script if an essential command fails
command_status=\${1}
command_line_number=\${2}
if ! [ -z \${command_status} ] && [ \${command_status} -ne 0 ]; then
echo \"\${formatred}INVALID COMMAND: LINE \${formatorange}\${command_line_number}\${format}\"
exit_message 98 -nh -nm
fi
} # vital_command

vital_file () { # exits script if an essential file is missing
for vitals; do
	if ! [ -e \${vitals} 2>/dev/null ]; then
	bad_files+=(\"\${vitals}\")
	fi
done
if [ \${#bad_files[@]} -gt 0 ]; then
echo \"\${formatred}MISSING ESSENTIAL FILE(S):\${formatblue}\"
printf '%s\\n' \${bad_files[@]}
exit_message 97 -nh -nm
fi
} # vital_file

#-------------------------------- MESSAGES ---------------------------------#
script_usage () { # Script explanation
echo \"\${formatred}HELP MESSAGE: \${formatgreen}\${script_path}\${format}
\${formatorange}DESCRIPTION\${format}:
     
\${formatorange}ADVICE\${format}: Create an alias inside your \${formatorange}\${HOME}/.bashrc\${format} file
(e.g. \${formatgreen}alias xx='\${script_path}'\${format})
     
\${formatorange}USAGE\${format}:
 [\${formatorange}1\${format}] \${formatgreen}\${script_path}\${format}
     
\${formatorange}OPTIONS\${format}: Can input multiple options in any order
 \${formatblue}-cs\${format}  Prevent screen from clearing before script processes
 \${formatblue}-h\${format} or \${formatblue}--help\${format}  Display this message
 \${formatblue}-nc\${format}  Prevent color printing in terminal
 \${formatblue}-nm\${format}  Prevent exit message from displaying
 \${formatblue}-o\${format} or \${formatblue}--open\${format} Open this script
     
\${formatorange}DEFAULT SETTINGS\${format}:
 text editors: \${formatgreen}\${text_editors[@]}\${format}
     
\${formatorange}VERSION: \${formatgreen}\${version_number}\${format}
\${formatred}END OF HELP: \${formatgreen}\${script_path}\${format}\"
exit_message 0 -nm
} # script_usage

re_enter_input_message () { # Displays invalid input message
clear
echo \"\${formatred}INVALID INPUT: \${formatorange}\${@}\${format}\"
echo \"\${formatblue}PLEASE RE-ENTER INPUT\${format}\"
} # re_enter_input_message

exit_message () { # Message before exiting script
if [ -z \${1} 2>/dev/null ] || ! [ \${1} -eq \${1} 2>/dev/null ]; then
exit_type='0'
else
exit_type=\${1}
fi
if [ \${exit_type} -ne 0 ]; then
suggest_help='yes'
fi
for exit_inputs; do
	if [ \${exit_inputs} == '-nh' 2>/dev/null ]; then
	suggest_help='no'
	elif [ \${exit_inputs} == '-nm' 2>/dev/null ]; then
	display_exit='no'
	fi
done
# Suggest help message
if [ \${suggest_help} == 'yes' 2>/dev/null ]; then
echo \"\${formatorange}TO DISPLAY HELP MESSAGE TYPE: \${formatgreen}\${script_path} -h\${format}\"
fi
# Display exit message
if [ \${display_exit} != 'no' 2>/dev/null ]; then # Exit message
echo \"\${formatblue}EXITING SCRIPT:\${formatorange} \${script_path}\${format}\"
fi
printf \"\${formatreset}\\n\"
exit \${exit_type}
} # exit_message

#---------------------------------- CODE -----------------------------------#
for inputs; do # Reads through all inputs
option_eval \${inputs}
done

if [ \${clear_screen} != 'no' 2>/dev/null ]; then
clear	# Clears screen unless activation of input option: -cs
fi

color_formats # Activates or inhibits colorful output

# Exit script if invalid inputs found
if [ \${#bad_inputs[@]} -gt 0 ]; then
re_enter_input_message \${bad_inputs[@]}
exit_message 1
fi
if [ \${activate_help} == 'yes' ]; then # -h or --help
script_usage
elif [ \${open_script} == 'yes' ]; then # -o or --open
open_text_editor \${script_path} \${text_editors[@]}
exit_message 0 -nm
fi

exit_message 0"
} # create_script5

create_script6 () { # Basic script WITHOUT exit message
echo "#!/bin/bash
#--------------------------------------------------------------------------------------#
# Created: ${todays_date} By: Evan Layher (ealayher@ucdavis.edu: UC Davis Medical Center)
# Revised: ${todays_date} By: Evan Layher
#--------------------------------------------------------------------------------------#
#
#-------------------------------- VARIABLES --------------------------------#

#--------------------------- DEFAULT SETTINGS ------------------------------#
text_editors=('kwrite' 'gedit' 'emacs' 'vim' 'leafpad') # text editor commands in order of preference

#----------------------- GENERAL SCRIPT VARIABLES --------------------------#
script_path=\"\$(readlink -f \${BASH_SOURCE[0]})\"	# Full path of this script
version_number='1.0'
activate_colors='yes'	# 'yes': Displays messages in color (color_formats) ['yes' or 'no'] [INPUT: '-nc']
activate_help='no'	# 'no': Displays help messeage (script_usage) ['yes' or 'no'] [INPUT: '-h' or '--help']
clear_screen='yes'	# 'yes': Clears screen before running script ['yes' or 'no'] [INPUT: '-cs']
open_script='no'	# 'no': Opens this script ['yes' or 'no'] [INPUT: '-o' or '--open']
suggest_help='no'	# 'no': Suggests help if needed ['yes' or 'no']

#-------------------------------- FUNCTIONS --------------------------------#
option_eval () { # Evaluates command line options
if [ \${1} == '-cs' 2>/dev/null ] || [ \${1} == '-h' 2>/dev/null ] || [ \${1} == '--help' 2>/dev/null ] || \\
[ \${1} == '-nc' 2>/dev/null ] || [ \${1} == '-o' 2>/dev/null ] || [ \${1} == '--open' 2>/dev/null ]; then
activate_options \${1}
elif [ \${1:0:1} == '-' 2>/dev/null ]; then
bad_inputs+=(\"\${1}\")
else
bad_inputs+=(\"\${1}\")
fi
} # option_eval

activate_options () {
if [ \${1} == '-cs' ]; then
clear_screen='no'	# Do not clear screen
elif [ \${1} == '-h' ] || [ \${1} == '--help' ]; then
activate_help='yes'	# Display help message
elif [ \${1} == '-nc' ]; then
activate_colors='no'	# Do not display in color
elif [ \${1} == '-o' ] || [ \${1} == '--open' ]; then
open_script='yes'	# Open this script
else
bad_inputs+=(\"ERROR:activate_options:\${1}\")
fi
} # activate_options

color_formats () { # Print colorful terminal text
if [ \${activate_colors} == 'yes' 2>/dev/null ]; then
format=\`tput setab 0; tput setaf 7\` 	 	# Black background, white text
formatblue=\`tput setab 0; tput setaf 4\`  	# Black background, blue text
formatgreen=\`tput setab 0; tput setaf 2\` 	# Black background, green text
formatorange=\`tput setab 0; tput setaf 3\`  	# Black background, orange text
formatred=\`tput setab 0; tput setaf 1\` 	# Black background, red text
formatreset=\`tput sgr0\`				# Reset to default terminal settings
else
format=''	# No formatting
formatblue=''	# No formatting
formatgreen=''	# No formatting
formatorange=''	# No formatting
formatred=''	# No formatting
fi
} # color_formats

open_text_editor () { # Open file [first input file, then text editors]
file_to_open=\${1}
valid_text_editor='no'
if [ -f \${file_to_open} ]; then
	for i_text_editor in \${@:2}; do
	\${i_text_editor} \${file_to_open} 2>/dev/null &
	check_text_pid=(\`ps --no-headers -p \$!\`) # Check pid is running
		if [ \${#check_text_pid[@]} -gt 0 ]; then
		valid_text_editor='yes'
		break
		fi
	done
	if [ \${valid_text_editor} == 'no' 2>/dev/null ]; then
	echo \"\${formatred}NO VALID TEXT EDITORS: \${formatorange}\${@:2}\${format}\"
	exit_message 99 -nh
	fi
else
echo \"\${formatred}MISSING FILE: \${formatorange}\${file_to_open}\${format}\"
fi
} # open_text_editor

vital_command () { # exits script if an essential command fails
command_status=\${1}
command_line_number=\${2}
if ! [ -z \${command_status} ] && [ \${command_status} -ne 0 ]; then
echo \"\${formatred}INVALID COMMAND: LINE \${formatorange}\${command_line_number}\${format}\"
exit_message 98 -nh
fi
} # vital_command

vital_file () { # exits script if an essential file is missing
for vitals; do
	if ! [ -e \${vitals} 2>/dev/null ]; then
	bad_files+=(\"\${vitals}\")
	fi
done
if [ \${#bad_files[@]} -gt 0 ]; then
echo \"\${formatred}MISSING ESSENTIAL FILE(S):\${formatblue}\"
printf '%s\\n' \${bad_files[@]}
exit_message 97 -nh
fi
} # vital_file

#-------------------------------- MESSAGES ---------------------------------#
script_usage () { # Script explanation
echo \"\${formatred}HELP MESSAGE: \${formatgreen}\${script_path}\${format}
\${formatorange}DESCRIPTION\${format}:
     
\${formatorange}USAGE\${format}:
 [\${formatorange}1\${format}] \${formatgreen}\${script_path}\${format}
     
\${formatorange}OPTIONS\${format}: Can input multiple options in any order
 \${formatblue}-cs\${format}  Prevent screen from clearing before script processes
 \${formatblue}-h\${format} or \${formatblue}--help\${format}  Display this message
 \${formatblue}-nc\${format}  Prevent color printing in terminal
 \${formatblue}-o\${format} or \${formatblue}--open\${format} Open this script
     
\${formatorange}DEFAULT SETTINGS\${format}:
 text editors: \${formatgreen}\${text_editors[@]}\${format}
     
\${formatorange}VERSION: \${formatgreen}\${version_number}\${format}
\${formatred}END OF HELP: \${formatgreen}\${script_path}\${format}\"
exit_message 0
} # script_usage

re_enter_input_message () { # Displays invalid input message
clear
echo \"\${formatred}INVALID INPUT: \${formatorange}\${@}\${format}\"
echo \"\${formatblue}PLEASE RE-ENTER INPUT\${format}\"
} # re_enter_input_message

exit_message () { # Message before exiting script
if [ -z \${1} 2>/dev/null ] || ! [ \${1} -eq \${1} 2>/dev/null ]; then
exit_type='0'
else
exit_type=\${1}
fi
if [ \${exit_type} -ne 0 ]; then
suggest_help='yes'
fi
for exit_inputs; do
	if [ \${exit_inputs} == '-nh' 2>/dev/null ]; then
	suggest_help='no'
	fi
done
# Suggest help message
if [ \${suggest_help} == 'yes' 2>/dev/null ]; then
echo \"\${formatorange}TO DISPLAY HELP MESSAGE TYPE: \${formatgreen}\${script_path} -h\${format}\"
fi
printf \"\${formatreset}\\n\"
exit \${exit_type}
} # exit_message

#---------------------------------- CODE -----------------------------------#
for inputs; do # Reads through all inputs
option_eval \${inputs}
done

if [ \${clear_screen} != 'no' 2>/dev/null ]; then
clear	# Clears screen unless activation of input option: -cs
fi

color_formats # Activates or inhibits colorful output

# Exit script if invalid inputs found
if [ \${#bad_inputs[@]} -gt 0 ]; then
re_enter_input_message \${bad_inputs[@]}
exit_message 1
fi

if [ \${activate_help} == 'yes' ]; then # -h or --help
script_usage
elif [ \${open_script} == 'yes' ]; then # -o or --open
open_text_editor \${script_path} \${text_editors[@]}
exit_message 0
fi

exit_message 0"
} # create_script6

create_script7 () { # Basic script with functions
echo "#!/bin/bash
#--------------------------------------------------------------------------------------#
# Created: ${todays_date} By: Evan Layher (ealayher@ucdavis.edu: UC Davis Medical Center)
# Revised: ${todays_date} By: Evan Layher
#--------------------------------------------------------------------------------------#
#
#-------------------------------- VARIABLES --------------------------------#

#--------------------------- DEFAULT SETTINGS ------------------------------#
text_editors=('kwrite' 'gedit' 'emacs' 'vim' 'leafpad') # text editor commands in order of preference

#----------------------- GENERAL SCRIPT VARIABLES --------------------------#
script_path=\"\$(readlink -f \${BASH_SOURCE[0]})\"	# Full path of this script
version_number='1.0'
activate_colors='yes'	# 'yes': Displays messages in color (color_formats) ['yes' or 'no'] [INPUT: '-nc']
activate_help='no'	# 'no': Displays help messeage (script_usage) ['yes' or 'no'] [INPUT: '-h' or '--help']
clear_screen='yes'	# 'yes': Clears screen before running script ['yes' or 'no'] [INPUT: '-cs']
open_script='no'	# 'no': Opens this script ['yes' or 'no'] [INPUT: '-o' or '--open']
suggest_help='no'	# 'no': Suggests help if needed ['yes' or 'no']

#-------------------------------- FUNCTIONS --------------------------------#
option_eval () { # Evaluates command line options
if [ \${1} == '-cs' 2>/dev/null ] || [ \${1} == '-h' 2>/dev/null ] || [ \${1} == '--help' 2>/dev/null ] || \\
[ \${1} == '-nc' 2>/dev/null ] || [ \${1} == '-o' 2>/dev/null ] || [ \${1} == '--open' 2>/dev/null ]; then
activate_options \${1}
elif [ \${1:0:1} == '-' 2>/dev/null ]; then
bad_inputs+=(\"\${1}\")
else
bad_inputs+=(\"\${1}\")
fi
} # option_eval

activate_options () {
if [ \${1} == '-cs' ]; then
clear_screen='no'	# Do not clear screen
elif [ \${1} == '-h' ] || [ \${1} == '--help' ]; then
activate_help='yes'	# Display help message
elif [ \${1} == '-nc' ]; then
activate_colors='no'	# Do not display in color
elif [ \${1} == '-o' ] || [ \${1} == '--open' ]; then
open_script='yes'	# Open this script
else
bad_inputs+=(\"ERROR:activate_options:\${1}\")
fi
} # activate_options

color_formats () { # Print colorful terminal text
if [ \${activate_colors} == 'yes' 2>/dev/null ]; then
format=\`tput setab 0; tput setaf 7\` 	 	# Black background, white text
formatblue=\`tput setab 0; tput setaf 4\`  	# Black background, blue text
formatgreen=\`tput setab 0; tput setaf 2\` 	# Black background, green text
formatorange=\`tput setab 0; tput setaf 3\`  	# Black background, orange text
formatred=\`tput setab 0; tput setaf 1\` 	# Black background, red text
formatreset=\`tput sgr0\`				# Reset to default terminal settings
else
format=''	# No formatting
formatblue=''	# No formatting
formatgreen=''	# No formatting
formatorange=''	# No formatting
formatred=''	# No formatting
fi
} # color_formats

open_text_editor () { # Open file [first input file, then text editors]
file_to_open=\${1}
valid_text_editor='no'
if [ -f \${file_to_open} ]; then
	for i_text_editor in \${@:2}; do
	\${i_text_editor} \${file_to_open} 2>/dev/null &
	check_text_pid=(\`ps --no-headers -p \$!\`) # Check pid is running
		if [ \${#check_text_pid[@]} -gt 0 ]; then
		valid_text_editor='yes'
		break
		fi
	done
	if [ \${valid_text_editor} == 'no' 2>/dev/null ]; then
	echo \"\${formatred}NO VALID TEXT EDITORS: \${formatorange}\${@:2}\${format}\"
	exit_message 99 -nh
	fi
else
echo \"\${formatred}MISSING FILE: \${formatorange}\${file_to_open}\${format}\"
fi
} # open_text_editor

#-------------------------------- MESSAGES ---------------------------------#
script_usage () { # Script explanation
echo \"\${formatred}HELP MESSAGE: \${formatgreen}\${script_path}\${format}
\${formatorange}DESCRIPTION\${format}:
     
\${formatorange}USAGE\${format}:
 [\${formatorange}1\${format}] \${formatgreen}\${script_path}\${format}
     
\${formatorange}OPTIONS\${format}: Can input multiple options in any order
 \${formatblue}-cs\${format}  Prevent screen from clearing before script processes
 \${formatblue}-h\${format} or \${formatblue}--help\${format}  Display this message
 \${formatblue}-nc\${format}  Prevent color printing in terminal
 \${formatblue}-o\${format} or \${formatblue}--open\${format} Open this script
     
\${formatorange}DEFAULT SETTINGS\${format}:
 text editors: \${formatgreen}\${text_editors[@]}\${format}
     
\${formatorange}VERSION: \${formatgreen}\${version_number}\${format}
\${formatred}END OF HELP: \${formatgreen}\${script_path}\${format}\"
exit_message 0
} # script_usage

re_enter_input_message () { # Displays invalid input message
clear
echo \"\${formatred}INVALID INPUT: \${formatorange}\${@}\${format}\"
echo \"\${formatblue}PLEASE RE-ENTER INPUT\${format}\"
} # re_enter_input_message

exit_message () { # Message before exiting script
if [ -z \${1} 2>/dev/null ] || ! [ \${1} -eq \${1} 2>/dev/null ]; then
exit_type='0'
else
exit_type=\${1}
fi
if [ \${exit_type} -ne 0 ]; then
suggest_help='yes'
fi
for exit_inputs; do
	if [ \${exit_inputs} == '-nh' 2>/dev/null ]; then
	suggest_help='no'
	fi
done
# Suggest help message
if [ \${suggest_help} == 'yes' 2>/dev/null ]; then
echo \"\${formatorange}TO DISPLAY HELP MESSAGE TYPE: \${formatgreen}\${script_path} -h\${format}\"
fi
printf \"\${formatreset}\\n\"
exit \${exit_type}
} # exit_message

#---------------------------------- CODE -----------------------------------#
for inputs; do # Reads through all inputs
option_eval \${inputs}
done

if [ \${clear_screen} != 'no' 2>/dev/null ]; then
clear	# Clears screen unless activation of input option: -cs
fi

color_formats # Activates or inhibits colorful output

# Exit script if invalid inputs found
if [ \${#bad_inputs[@]} -gt 0 ]; then
re_enter_input_message \${bad_inputs[@]}
exit_message 1
fi

if [ \${activate_help} == 'yes' ]; then # -h or --help
script_usage
elif [ \${open_script} == 'yes' ]; then # -o or --open
open_text_editor \${script_path} \${text_editors[@]}
exit_message 0
fi

exit_message 0"
} # create_script7

create_script8 () { # Header information only
echo "#!/bin/bash
#--------------------------------------------------------------------------------------#
# Created: ${todays_date} By: Evan Layher (ealayher@ucdavis.edu: UC Davis Medical Center)
# Revised: ${todays_date} By: Evan Layher
#--------------------------------------------------------------------------------------#
#
#-------------------------------- VARIABLES --------------------------------#

#---------------------------------- CODE -----------------------------------#"
} # create_script8

option_eval () { # Evaluates command line options
check_permission=($(echo ${1} |grep '[0-7][0-7][0-7]'))
if [ ${1} == '-h' 2>/dev/null ] || [ ${1} == '--help' 2>/dev/null ] || [ ${1} == '-i' 2>/dev/null ] || [ ${1} == '-l' 2>/dev/null ] || \
[ ${1} == '-n' 2>/dev/null ] || [ ${1} == '-nc' 2>/dev/null ] || [ ${1} == '-nl' 2>/dev/null ] || \
[ ${1} == '-o' 2>/dev/null ] || [ ${1} == '--open' 2>/dev/null ] || [ ${1} == '-p' 2>/dev/null ] || \
[ ${1} == '-t' 2>/dev/null ] || [ ${1} == '-tr' 2>/dev/null ] || [ ${1} == '-r' 2>/dev/null ]; then
activate_options ${1}
elif ! [ -z ${n_in} 2>/dev/null ] && [ ${n_in} == 'yes' 2>/dev/null ]; then # Add text editors
	if [ ${1} -eq ${1} 2>/dev/null ] && [ ${1} -gt 0 2>/dev/null ] && [ -z ${n_script} 2>/dev/null ]; then
	n_script=${1}
	else
	bad_inputs+=("-n:${1}")
	fi
n_in='no'
elif ! [ -z ${p_in} 2>/dev/null ] && [ ${p_in} == 'yes' 2>/dev/null ]; then
	if [ ${#check_permission[@]} -eq 1 ] && [ ${#check_permission[0]} -eq 3 ] && [ -z ${old_p_value} 2>/dev/null ]; then
	create_option_file
	old_p_value=`grep '^permission_value=' ${option_file}`
	sed -i "s@${old_p_value}@permission_value=${check_permission[0]}@g" ${option_file}
	else
	bad_inputs+=("-p:${1}")
	fi
elif [ ${#check_permission[@]} -eq 1 ] && [ ${#check_permission[0]} -eq 3 ]; then
change_permission='yes'
new_permission_value=${check_permission[0]} # Set permission value for this entry without chaning default
elif ! [ -z ${t_in} 2>/dev/null ] && [ ${t_in} == 'yes' 2>/dev/null ]; then # Add text editor
add_editors=("${1} ${add_editors[@]}") # Maintain order of editor inputs
elif ! [ -z ${tr_in} 2>/dev/null ] && [ ${tr_in} == 'yes' 2>/dev/null ]; then # Remove text editor
rem_editors+=("${1}")
elif [ ${1:0:1} == '-' 2>/dev/null ]; then
bad_inputs+=("${1}")
else
	if [ ${filename_reader} != 'off' 2>/dev/null ]; then
	filename=${1}
	filename_reader='off'
	else
	bad_inputs+=("${1}")
	fi
fi
} # option_eval

activate_options () {
n_in='no' 	# Do not read in 'n' numbers
p_in='no' 	# Do not read in new 'p' default
t_in='no'	# Do not read in text editors to add
tr_in='no'	# Do not read in text editors to remove
if [ ${1} == '-h' ] || [ ${1} == '--help' ]; then
activate_help='yes'	# Display help message
elif [ ${1} == '-i' ]; then
open_file='no'		# List user settings
elif [ ${1} == '-l' ]; then
list_settings='yes'	# List user settings
elif [ ${1} == '-n' ]; then
n_in='yes'		# Which script number to create
elif [ ${1} == '-nc' ]; then
activate_colors='no'	# Do not display in color
elif [ ${1} == '-nl' ]; then
display_scripts='yes'	# List script explanations
elif [ ${1} == '-o' ] || [ ${1} == '--open' ]; then
open_script='yes'	# Open this script
elif [ ${1} == '-p' ]; then
p_in='yes'		# Input new permission value
list_settings='yes'	# List user settings
elif [ ${1} == '-r' ]; then
reset_template='yes'   # Reset option file
elif [ ${1} == '-t' ]; then
t_in='yes'		# Add text editor
list_settings='yes'	# List user settings
elif [ ${1} == '-tr' ]; then
tr_in='yes'		# Remove text editor
list_settings='yes'	# List user settings
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
	exit 99
	fi
else
echo "${formatred}MISSING FILE: ${formatorange}${file_to_open}${format}"
fi
} # open_text_editor

create_option_file () { # Creates .ini file to store user preferences
ealayher_code_dir="${HOME}/.ealayher_code" # Directory of preference file
option_file="${ealayher_code_dir}/`basename ${script_path%.*}`.ini" # .ini file path

if ! [ -d ${ealayher_code_dir} ]; then # Create directory for option file
mkdir ${ealayher_code_dir}
fi

if ! [ -f ${option_file} ]; then # Create option file
echo "[options]
permission_value=${default_permission_value}
text_editors=(${default_text_editors[@]})
" > ${option_file}
fi

permission_value=(`awk -F '=' '/permission_value=/ {print $2}' ${option_file}`)
text_editors=(`awk -F '=' '/text_editors=/ {print $2}' ${option_file} |sed -e 's@(@@g' -e 's@)@@g'`)

if [ ${#add_editors[@]} -gt 0 ] || [ ${#rem_editors[@]} -gt 0 ]; then # Change text editors
old_editor_vals="text_editors=(${text_editors[@]})"
	for i_rem_editor in ${rem_editors[@]} ${add_editors[@]}; do # Removes duplicate inputs
	text_editors=(`printf ' %s ' ${text_editors[@]} |sed "s@ ${i_rem_editor} @ @g"`)
	done
	for i_add_editor in ${add_editors[@]}; do # Put newest editor in front
	text_editors=(${i_add_editor} ${text_editors[@]})
	done
	new_editor_vals="text_editors=(${text_editors[@]})"
sed -i "s@${old_editor_vals}@${new_editor_vals}@g" ${option_file}
text_editors=(`awk -F '=' '/text_editors=/ {print $2}' ${option_file} |sed -e 's@(@@g' -e 's@)@@g'`)
fi
} # create_option_file

prompt_user_input () { # Prompt user to input filename
printf "${formatorange}INPUT FILENAME (e.g. ${formatgreen}example.sh${formatorange}):${format}"
read -r filename
if [ ${#filename} -eq 0 ]; then
clear
prompt_user_input
fi
} # prompt_user_input

read_filename () { # Check if file exists
file_path="`pwd`/${filename}"
if [ -f ${file_path} ]; then # Checks if file already exists
echo "${formatred}FILE EXISTS: ${formatgreen}${file_path}${format}"
printf "${formatorange}OVERWRITE? [${formatred}y${formatorange}/${formatred}n${formatorange}]:${format}"
read -r overwrite_file # User input to overwrite existing file
	if [ ${overwrite_file} == 'y' 2>/dev/null ] || [ ${overwrite_file} == 'Y' 2>/dev/null ]; then
	create_script
	elif [ ${overwrite_file} == 'n' 2>/dev/null ] || [ ${overwrite_file} == 'N' 2>/dev/null ]; then
	prompt_user_input
	read_filename
	elif [ ${overwrite_file} == 'q' 2>/dev/null ] || [ ${overwrite_file} == 'Q' 2>/dev/null ]; then
	exit_message 0
	else
	clear
	echo "${formatred}INVALID INPUT: ${formatorange}${overwrite_file}${format}"
	echo "${formatorange}TO QUIT INPUT [${formatred}q${formatorange}]${format}"
	read_filename
	fi
else
create_script
fi
} # read_filename

reset_option_file () { # -r: Reset user option file
printf "${formatorange}RESET OPTIONS FILE? [${formatgreen}y${formatorange}/${formatgreen}n${formatorange}]:${format}"
read -r reset_it
if [ ${reset_it} == 'y' 2>/dev/null ] || [ ${reset_it} == 'Y' 2>/dev/null ]; then
kill $! 2>/dev/null # Close file before removing
wait $! 2>/dev/null # Suppress kill message
rm ${option_file} 2>/dev/null
create_option_file
elif [ ${reset_it} == 'n' 2>/dev/null ] || [ ${reset_it} == 'N' 2>/dev/null ]; then
kill $! 2>/dev/null # Close file before removing
wait $! 2>/dev/null # Suppress kill message
exit_message 0
else
re_enter_input_message ${reset_it}
reset_option_file
fi
} # reset_option_file

#-------------------------------- MESSAGES ---------------------------------#
script_usage () { # Script explanation
echo "${formatred}HELP MESSAGE: ${formatgreen}${script_path}${format}
${formatorange}DESCRIPTION${format}: Create script in working directory
     
${formatorange}ADVICE${format}: Create an alias inside your ${formatorange}${HOME}/.bashrc${format} file
(e.g. ${formatgreen}alias cs='${script_path}'${format})
     
${formatorange}USAGE${format}: Input filename of new script and permission value of new file (if not default)
  [${formatorange}1${format}] ${formatgreen}cs${formatorange} examplefile1.sh${format} # Permission is default
  [${formatorange}2${format}] ${formatgreen}cs${formatorange} examplefile1.sh ${formatgreen}744${format}
  
${formatorange}OPTIONS${format}: Can input multiple options in any order
 ${formatblue}-h${format} or ${formatblue}--help${format}  Display this message
 ${formatblue}-i${format}   Do not open script file after it is created
 ${formatblue}-l${format}   List default settings
 ${formatblue}-n${format}   Which script number to create (create_script*[0-9])
  [${formatorange}3${format}] ${formatgreen}cs ${formatblue}-n ${formatorange}1${format}
 ${formatblue}-nc${format}  Prevent color printing in terminal
 ${formatblue}-nl${format}  List comments for each script
 ${formatblue}-o${format} or  ${formatblue}--open${format}  Open this script
 ${formatblue}-p${format}   Change default permission value
  [${formatorange}4${format}] ${formatgreen}cs ${formatblue}-p ${formatorange}755${format}
 ${formatblue}-r${format}   Reset option file
 ${formatblue}-t${format}   Add text editor(s)
  [${formatorange}5${format}] ${formatgreen}cs ${formatblue}-t ${formatorange}kwrite gedit${format}
 ${formatblue}-tr${format}  Remove text editor(s)
  [${formatorange}6${format}] ${formatgreen}cs ${formatblue}-tr ${formatorange}kwrite gedit${format}
     
${formatorange}DEFAULT SETTINGS${format}:
 Script types: ${formatgreen}`grep -c 'create_script*[0-9] ()' ${script_path}`${format}
 Text editors: ${formatgreen}${text_editors[@]}${format}
 Script file permission: ${formatgreen}${permission_value}${format}
${formatorange}VERSION: ${formatgreen}${version_number}${format}
${formatred}END OF HELP: ${formatgreen}${script_path}${format}"
exit_message 0
}

list_user_settings () { # -l option
create_option_file
echo "${formatblue}+---USER SETTINGS---+${formatorange}"
echo "${formatgreen}Permission value: ${formatorange}${permission_value}${format}"
echo "${formatgreen}Text editors: ${formatorange}${text_editors[@]}${format}"
exit_message 0
} # list_user_settings

script_display () { # -nl option
script_count=(`grep -o 'create_script*[0-9] ()' ${script_path} |grep -o '[0-9]*'`)
creation_scripts=(`grep 'create_script*[0-9] ()' ${script_path} |sed 's@ @+-+@g' |awk -F '#' '{print $2}'`)
for i_count in ${!script_count[@]}; do
echo "${format}[${formatorange}${script_count[${i_count}]}${format}]${formatgreen}$(echo ${creation_scripts[${i_count}]} |sed 's@+-+@ @g')${format}" |sed "s@WITHOUT@${formatred}WITHOUT${formatgreen}@g"
done
exit_message 0
} # script_display

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
# Suggest help message
if [ ${exit_type} -ne 0 2>/dev/null ] || [ ${suggest_help} == 'yes' 2>/dev/null ]; then
echo "${formatorange}TO DISPLAY HELP MESSAGE TYPE: ${formatgreen}${script_path} -h${format}"
fi
printf "${formatreset}\n"
exit ${exit_type}
} # exit_message

#---------------------------------- CODE -----------------------------------#
for inputs; do # Reads through all inputs
option_eval ${inputs}
done

clear
color_formats # Activates or inhibits colorful output

# Exit script if invalid inputs found
if [ ${#bad_inputs[@]} -gt 0 ]; then
suggest_help='yes'
re_enter_input_message ${bad_inputs[@]}
exit_message 1
fi

create_option_file # create .ini file

if [ ${change_permission} == 'yes' 2>/dev/null ]; then
permission_value=${new_permission_value} # Change permission for one entry
fi

if [ -z ${n_script} 2>/dev/null ]; then
n_script=${default_script_number} # Create default template
fi

# Display help message or open file
if [ ${activate_help} == 'yes' 2>/dev/null ]; then
script_usage
elif [ ${open_script} == 'yes' ]; then # -o or --open option
echo "${formatorange}SCRIPT: ${formatgreen}${script_path}${format}"
open_text_editor ${script_path} ${text_editors[@]}
exit_message 0
elif [ ${list_settings} == 'yes' 2>/dev/null ]; then # -l option
list_user_settings
elif [ ${display_scripts} == 'yes' 2>/dev/null ]; then # -nl option
script_display
elif [ ${reset_template} == 'yes' 2>/dev/null ]; then # -r option
open_text_editor ${option_file} ${text_editors[@]}
reset_option_file
exit_message 0
elif [ -z ${filename} ]; then
prompt_user_input
read_filename
else
read_filename
fi

exit_message 0

