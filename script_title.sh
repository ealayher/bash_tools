#!/bin/bash
#--------------------------------------------------------------------------------------#
#Created: 04/22/2014 By: Evan Layher (ealayher@ucdavis.edu: UC Davis Medical Center)
#Latest Revision: 02/11/2015 By: Evan Layher
#--------------------------------------------------------------------------------------#
# Quickly create new scripts that include header information and common variables and functions

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
activate_colors='yes'	# 'yes': To activate color settings set equal to 'yes' otherwise 'no'
text_editor='kwrite' 	# 'kwrite': Input the command that calls your favorite text editor
#text_editor='' 	# Uncomment to prevent script from opening after creation

#----------------------- GENERAL SCRIPT VARIABLES --------------------------#
today=`date +%Y%m%d`		# Date: (e.g. 20150101)
day_time=`date +%x" "%r`	# Date and time: (e.g. 01/01/2015 12:00:00 AM)
script_path="$(readlink -f ${BASH_SOURCE[0]})"	# Full path of this script
todaysdate=`date +%x` 	# Will include todays date in your new script whenever you input: $todaysdate
filename="" 		# '': Filename of new script
yes_or_no=""		# '': Prompt to activate script
filename_reader='on'	# 'on': Read in filename
activate_help='no'	# 'no': Displays help messeage (script_usage) [ -h or --help ]
open_script='no'	# 'no': Opens this script [ -o or --open ]
bad_inputs=()		# (): Array of bad inputs

#-------------------------------- FUNCTIONS --------------------------------#
create_script () { #Creates, activates and opens new shell script
echo "#!/bin/bash
#--------------------------------------------------------------------------------------#
#Created: $todaysdate By: Evan Layher (ealayher@ucdavis.edu: UC Davis Medical Center)
#Latest Revision: $todaysdate By: Evan Layher
#--------------------------------------------------------------------------------------#
#
#-------------------------------- VARIABLES --------------------------------#


#--------------------------- DEFAULT SETTINGS ------------------------------#
max_bg_jobs='10'	# '10': Max number of background processes allowed within this script
text_editor='kwrite' 	# 'kwrite': Input the command that calls your favorite text editor

#----------------------- GENERAL SCRIPT VARIABLES --------------------------#
STARTTIME=\`date +%s\` 			# Script start time (in seconds).
DAY_and_TIME_at_start=\`date +%x' '%r\`	# Script start time (day and time).
today=\`date +%Y%m%d\`			# Date: (e.g. 20150101)
day_time=\`date +%x\" \"%r\`		# Date and time: (e.g. 01/01/2015 12:00:00 AM)
script_path=\"\$(readlink -f \${BASH_SOURCE[0]})\"	# Full path of this script

activate_colors='yes'	# 'yes': Displays messages in color (color_formats) ['yes' or 'no']
activate_help='no'	# 'no': Displays help messeage (script_usage) ['yes' or 'no'] [INPUT: '-h' or '--help']
clear_screen='yes'	# 'yes': Clears screen before running script ['yes' or 'no'] [INPUT: '-cs']
display_exit='yes'	# 'yes': Displays an exit message ['yes' or 'no'] [INPUT: '-nm']
open_script='no'	# 'no': Opens this script ['yes' or 'no'] [INPUT: '-o' or '--open']
show_time='yes'		# 'yes': Displays script process time ['yes' or 'no'] [INPUT: '-nt']
suggest_help='no'	# 'no': Suggests help if needed ['yes' or 'no']
bad_inputs=()		# (): Array of bad inputs (invalid_input_message)

#-------------------------------- FUNCTIONS --------------------------------#
control_bg_jobs () { # Controls number of background processes
job_count=\`jobs -p |wc -l\`
if [ \${job_count} -ge \${max_bg_jobs} ]; then
sleep 1
control_bg_jobs
fi
}

option_eval () { # Evaluates command line options
if [ \${1} == '-cs' 2>/dev/null ] || [ \${1} == '-h' 2>/dev/null ] || [ \${1} == '--help' 2>/dev/null ] || [ \${1} == '-nc' 2>/dev/null ] || [ \${1} == '-nt' 2>/dev/null ] || [ \${1} == '-nm' 2>/dev/null ] || [ \${1} == '-o' 2>/dev/null ] || [ \${1} == '--open' 2>/dev/null ]; then
activate_options \${1}
elif [ \${1:0:1} == '-' 2>/dev/null ]; then # Checks invalid options
bad_inputs+=(\"\${1}\")
fi
}

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
show_time='no'
else
echo \"\${formatred}ERROR\${format}: \${formatgreen}activate_options\${format} function\"
exit_message 99 -nt
fi
}

color_formats () { # Print colorful text within terminal
if [ \${activate_colors} == 'yes' 2>/dev/null ]; then
format=\`tput setab 0; tput setaf 7\` 	 	# Black background, white text
formatblue=\`tput setab 0; tput setaf 4\`  	# Black background, blue text
formatorange=\`tput setab 0; tput setaf 3\`  	# Black background, orange text
formatgreen=\`tput setab 0; tput setaf 2\` 	# Black background, green text
formatred=\`tput setab 0; tput setaf 1\` 	# Black background, red text
formatReset=\`tput sgr0\`			# Reset to default terminal settings
else
format=''	# No formatting
formatblue=''	# No formatting
formatorange=''	# No formatting
formatgreen=''	# No formatting
formatred=''	# No formatting
fi
}

check_whole_number () { # Checks for integers
if ! [ -z \${1} 2>/dev/null ] && [ \${1} -eq \${1} 2>/dev/null ]; then
num=\${1}
else
num=''
fi
}

#-------------------------------- MESSAGES ---------------------------------#
script_usage () { # Script explanation
echo \"\${formatred}HELP MESSAGE: \${formatgreen}\${script_path}\${format}
\${formatorange}DESCRIPTION\${format}:
   
\${formatorange}USAGE\${format}:
   
\${formatorange}OPTIONS\${format}: Can input multiple options in any order
    -cs              Prevent screen from clearing before script processes
    -h or --help     Display this message
    -nc              Prevent color printing in terminal
    -nm              Prevent exit message from displaying
    -nt              Prevent script process time from displaying
    -o or --open     Open this script
   
\${formatred}END OF HELP: \${formatgreen}\${script_path}\${format}\"
exit_message 0 -nt -nm
}

invalid_input_message () { # Displays if there are any invalid inputs
if [ \${#bad_inputs[@]} -gt 0 ]; then
suggest_help='yes'
echo \"\${formatred}INVALID INPUT\"
printf '%s\n' \${bad_inputs[@]}
printf \"\${format}\"
fi
}

specific_start_time () { # Script process time message
echo \"STARTED : \${DAY_and_TIME_at_start}\"
echo \"FINISHED: \`date +%x' '%r\`\"
}

script_time_func () { # Script process time calculation
ENDTIME=\`date +%s\`
SCRIPTTIME=\$((\$ENDTIME - \$STARTTIME))
if [ \$SCRIPTTIME -lt 60 ];then
specific_start_time 
echo \"PROCESS TIME: \$SCRIPTTIME second(s).\"
elif [ \$SCRIPTTIME -lt 3600 ];then
specific_start_time 
echo \"PROCESS TIME: \$((\$SCRIPTTIME / 60)) minute(s) and \$((\$SCRIPTTIME % 60)) second(s).\"
elif [ \$SCRIPTTIME -lt 86400 ];then
specific_start_time 
echo \"PROCESS TIME: \$((\$SCRIPTTIME / 3600)) hour(s) \$((\$SCRIPTTIME % 3600 / 60)) minute(s) and \$((\$SCRIPTTIME % 60)) second(s).\"
elif [ \$SCRIPTTIME -ge 86400 ];then
specific_start_time 
echo \"PROCESS TIME: \$((\$SCRIPTTIME / 86400)) day(s) \$((\$SCRIPTTIME % 86400 / 3600)) hour(s) \$((\$SCRIPTTIME % 3600 / 60)) minute(s) and \$((\$SCRIPTTIME % 60)) second(s).\"
else
echo \"\${formatred}ERROR: \${formatorange}script_time_func\${format}\"
fi
}

exit_message () { # Message before exiting script
if [ -z \${1} 2>/dev/null ] || ! [ \${1} -eq \${1} 2>/dev/null ]; then
exit_type='0'
else
exit_type=\${1}
fi
for exit_inputs; do
	if [ \${exit_inputs} == '-nt' 2>/dev/null ]; then
	show_time='no'
	elif [ \${exit_inputs} == '-nm' 2>/dev/null ]; then
	display_exit='no'
	fi
done
wait # Waits for background processes to finish before exiting
# Suggest help message
if [ \${exit_type} -ne 0 2>/dev/null ] || [ \${suggest_help} == 'yes' 2>/dev/null ]; then
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
printf \"\${formatReset}\n\"
exit \${exit_type}
}

#---------------------------------- CODE -----------------------------------#
for inputs; do # Reads through all inputs
option_eval \${inputs}
done

if [ \${clear_screen} != 'no' 2>/dev/null ]; then
clear	# Clears screen unless activation of input option: -cs
fi

color_formats # Activates or inhibits colorful output
invalid_input_message # Display invalid inputs

# Display help message or open file
if [ \${activate_help} == 'yes' ]; then
script_usage
elif [ \${open_script} == 'yes' ]; then
echo \"\${formatgreen}\${script_path}\${format}\"
\${text_editor} \${script_path} 2>/dev/null || \
echo \"\${formatred}BAD TEXT EDITOR\${format}: text_editor=\${formatgreen}\${text_editor}\${format}\"
exit_message 0 -nt -nm
fi

exit_message 0" >$filename # Outputs script

#----Do not edit code below---------#
chmod 755 $filename # Automatically activates script
echo "${formatgreen}CREATED${format}:${file_path}"

# Checks to see if variable "text_editor" is blank
if [ -z $text_editor ]; then
exit_message 0
else
${text_editor} ${file_path} 2>/dev/null || \
echo "${formatred}BAD TEXT EDITOR${format}: text_editor=${formatgreen}${text_editor}${format}"
exit_message 1
fi
}

option_eval () { # Evaluates command line options
if [ ${1} == '-h' 2>/dev/null ] || [ ${1} == '--help' 2>/dev/null ] || [ ${1} == '-nc' 2>/dev/null ] || \
[ ${1} == '-o' 2>/dev/null ] || [ ${1} == '--open' 2>/dev/null ]; then
activate_options ${1}
elif [ ${1:0:1} == '-' ]; then # Checks invalid options
bad_inputs+="${1} "
else
	if [ ${filename_reader} != 'off' 2>/dev/null ]; then
	filename=${1}
	filename_reader='off'
	fi
fi
}

activate_options () {
if [ ${1} == '-h' ] || [ ${1} == '--help' ]; then
activate_help='yes'
elif [ ${1} == '-nc' ]; then
activate_colors='no'
elif [ ${1} == '-o' ] || [ ${1} == '--open' ]; then
open_script='yes'
else
echo "${formatred}ERROR${format}:${formatgreen}activate_options${format} function"
exit_message 1
fi
}

color_formats () { # Print colorful text within terminal
if [ ${activate_colors} == 'yes' 2>/dev/null ]; then
format=`tput setab 0; tput setaf 7` 	 # Black background, white text
formatorange=`tput setab 0; tput setaf 3`  # Black background, orange text
formatgreen=`tput setab 0; tput setaf 2` # Black background, green text
formatred=`tput setab 0; tput setaf 1` 	 # Black background, red text
formatReset=`tput sgr0`			 # Reset to default terminal settings
else
format=''	# No formatting
formatorange=''	# No formatting
formatgreen=''	# No formatting
formatred=''	# No formatting
fi
}

prompt_user_input () {
printf "${format}Please input filename (i.e. ${formatgreen}example.sh${format}):"
read -r filename
if [ ${#filename} -eq 0 ]; then
prompt_user_input
fi
}

read_filename () { # Input file name
file_path="`pwd`/$filename"
if [ -f ${file_path} ]; then # Checks if file already exists
echo "${formatred}WARNING FILE EXISTS${format}: ${formatgreen}${file_path}${format}"
printf "${formatorange}OVERWRITE? ${format}ENTER [${formatred}y${format}/${formatred}n${format}]:"
read -r yes_or_no # User input to overwrite existing file
	if [ -z $yes_or_no ]; then
	exit_message 1
	elif [ $yes_or_no == 'y' ] || [ $yes_or_no == 'Y' ]; then
	create_script
	elif [ $yes_or_no == 'n' ] || [ $yes_or_no == 'N' ]; then
	prompt_user_input
	read_filename
	else
	exit_message 2
	fi
else
create_script
fi
}
#-------------------------------- MESSAGES ---------------------------------#
script_usage () { # Script explanation
clear
echo "${formatred}HELP MESSAGE: ${formatgreen}${script_path} ${formatorange}${day_time}${format}
${formatorange}ADVICE${format}: Create an alias inside your ${HOME}/.bashrc file to call script
(e.g. ${formatgreen}alias kt='${script_path}${format}')
   
${formatorange}USAGE${format}: (if alias inside .bashrc file is '${formatgreen}kt${format}')
kt new_script_file_name.sh [options]...
   
${formatorange}OPTIONS${format}: Can input multiple options in any order
    -h or --help     Display this message
    -nc              Prevent color printing in terminal
    -o or --open     Open this script
   
${formatred}END OF HELP: ${formatgreen}${script_path}${format}"
exit_message 0
}

invalid_input_message () { # Displays if there are any invalid inputs
if [ ${#bad_inputs[@]} -gt 0 ]; then
echo "${formatred}INVALID INPUT"
printf '%s\n' ${bad_inputs[@]}
printf "${format}"
fi
}

exit_message () { # Message before exiting script
if [ -z ${1} ]; then
exit_type='0'
else
exit_type=${1}
fi
wait # Waits for background processes to finish before exiting
echo "${formatred}EXITING SCRIPT:${formatgreen} ${script_path}"
printf "${formatReset}\n"
exit ${exit_type}
}

#---------------------------------- CODE -----------------------------------#
clear
for inputs; do # Reads through all inputs
option_eval ${inputs}
done

color_formats # Activates or inhibits colorful output
invalid_input_message # Display invalid inputs

# Display help message or open file
if [ ${activate_help} == 'yes' 2>/dev/null ]; then
script_usage
elif [ ${open_script} == 'yes' 2>/dev/null  ]; then
echo "${formatgreen}${script_path}${format}"
${text_editor} ${script_path} 2>/dev/null || \
echo "${formatred}BAD TEXT EDITOR${format}: text_editor=${formatgreen}${text_editor}${format} "
exit_message 1
elif [ -z ${filename} ]; then
prompt_user_input
read_filename
else
read_filename
fi

exit_message 0

