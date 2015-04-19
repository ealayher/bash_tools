#!/bin/bash
#--------------------------------------------------------------------------------------#
#Created: 04/22/2014 By: Evan Layher (ealayher@ucdavis.edu: UC Davis Medical Center)
#Revised: 04/18/2015 By: Evan Layher
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
text_editors=('kwrite' 'gedit' 'leafpad') # text editor commands in order of preference
default_permission='755' # '755': Default file permission for new scripts

#----------------------- GENERAL SCRIPT VARIABLES --------------------------#
todays_date=`date +%x` 	# Inputs date inside of script
script_path="$(readlink -f ${BASH_SOURCE[0]})"	# Full path of this script

activate_colors='yes'	# 'yes': Displays messages in color (color_formats) ['yes' or 'no'] [INPUT: '-nc']
activate_help='no'	# 'no': Displays help messeage (script_usage) ['yes' or 'no'] [INPUT: '-h' or '--help']
clear_screen='yes'	# 'yes': Clears screen before running script ['yes' or 'no'] [INPUT: '-cs']
filename_reader='on'	# 'on': Read in filename
open_script='no'	# 'no': Opens this script [ -o or --open ]
p_in='no'		# 'no': Reads in permission level for output file ['yes' or 'no']
perm_val=${default_permission}	# permission value of output file
suggest_help='no'	# 'no': Suggests help if needed ['yes' or 'no']

bad_inputs=()		# (): Array of bad inputs

#-------------------------------- FUNCTIONS --------------------------------#
create_script () { #Creates, activates and opens new shell script
echo "#!/bin/bash
#--------------------------------------------------------------------------------------#
#Created: $todays_date By: Evan Layher (ealayher@ucdavis.edu: UC Davis Medical Center)
#Revised: $todays_date By: Evan Layher
#--------------------------------------------------------------------------------------#
#
#-------------------------------- VARIABLES --------------------------------#


#--------------------------- DEFAULT SETTINGS ------------------------------#
max_bg_jobs='10'	# '10': Max number of background processes
text_editors=('kwrite' 'gedit' 'leafpad') # text editor commands in order of preference

#----------------------- GENERAL SCRIPT VARIABLES --------------------------#
script_start_time=\`date +%s\` 		# Script start time (in seconds).
script_start_date_time=\`date +%x' '%r\`	# Script start date and time: (e.g. 01/01/2015 12:00:00 AM)
todays_date=\`date +%Y%m%d\`		# Date: (e.g. 20150101)
script_path=\"\$(readlink -f \${BASH_SOURCE[0]})\"	# Full path of this script

activate_colors='yes'	# 'yes': Displays messages in color (color_formats) ['yes' or 'no'] [INPUT: '-nc']
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
sleep 0.25
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
else
bad_inputs+=(\"ERROR:activate_options:\${1}\")
fi
}

color_formats () { # Print colorful terminal text
if [ \${activate_colors} == 'yes' 2>/dev/null ]; then
format=\`tput setab 0; tput setaf 7\` 	 	# Black background, white text
formatblue=\`tput setab 0; tput setaf 4\`  	# Black background, blue text
formatorange=\`tput setab 0; tput setaf 3\`  	# Black background, orange text
formatgreen=\`tput setab 0; tput setaf 2\` 	# Black background, green text
formatred=\`tput setab 0; tput setaf 1\` 		# Black background, red text
formatReset=\`tput sgr0\`				# Reset to default terminal settings
else
format=''	# No formatting
formatblue=''	# No formatting
formatorange=''	# No formatting
formatgreen=''	# No formatting
formatred=''	# No formatting
fi
}

vital_file () { # exits script if an essential file is missing
bad_files=()	# Array of bad files
for vitals; do
	if ! [ -e \${vitals} 2>/dev/null ]; then
	bad_files+=(\"\${vitals}\")
	fi
done

if [ \${#bad_files[@]} -gt 0 ]; then
echo \"\${formatred}MISSING ESSENTIAL FILE(S):\${formatblue}\"
printf '%s\n' \${bad_files[@]}
exit_message 99 -nm -nt
fi
}

#-------------------------------- MESSAGES ---------------------------------#
script_usage () { # Script explanation
echo \"\${formatred}HELP MESSAGE: \${formatgreen}\${script_path}\${format}
\${formatorange}DESCRIPTION\${format}:
     
\${formatorange}USAGE\${format}:
[\${formatorange}1\${format}] 
     
\${formatorange}OPTIONS\${format}: Can input multiple options in any order
    -cs              Prevent screen from clearing before script processes
    -h or --help     Display this message
    -nc              Prevent color printing in terminal
    -nm              Prevent exit message from displaying
    -nt              Prevent script process time from displaying
    -o or --open     Open this script
     
\${formatorange}DEFAULT SETTINGS\${format}:
     text editors: \${formatgreen}\${text_editors[@]}\${format}
     
\${formatred}END OF HELP: \${formatgreen}\${script_path}\${format}\"
exit_message 0 -nt -nm
}

invalid_input_message () { # Displays invalid inputs
if [ \${#bad_inputs[@]} -gt 0 ]; then
suggest_help='yes'
echo \"\${formatred}INVALID INPUT\"
printf '%s\n' \${bad_inputs[@]}
printf \"\${format}\"
fi
}

script_time_message () { # Script process time message
echo \"STARTED : \${script_start_date_time}\"
echo \"FINISHED: \`date +%x' '%r\`\"
}

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
echo \"\${formatorange}SCRIPT: \${formatgreen}\${script_path}\${format}\"
	for i_text_editor in \${text_editors[@]}; do
	\${i_text_editor} \${script_path} 2>/dev/null
		if [ \$? -eq 0 ]; then
		exit_message 0 -nm -nt
		else
		echo \"\${formatred}INVALID TEXT EDITOR: \${formatorange}\${i_text_editor}\${format}\"
		fi
	done
echo \"\${formatred}NO VALID TEXT EDITORS IN '\${formatorange}text_editors\${formatred}' VARIABLE\${format}\"
exit_message 0 -nt
fi

exit_message 0" > ${filename} # Outputs script

chmod ${perm_val} ${filename} # Automatically activates script
echo "${formatgreen}CREATED: ${formatorange}${file_path}${format}"

# Opens file in first valid text editor
open_file ${filename}
}

option_eval () { # Evaluates command line options
if [ ${1} == '-cs' 2>/dev/null ] || [ ${1} == '-h' 2>/dev/null ] || [ ${1} == '--help' 2>/dev/null ] || [ ${1} == '-nc' 2>/dev/null ] || [ ${1} == '-o' 2>/dev/null ] || [ ${1} == '--open' 2>/dev/null ] || [ ${1} == '-p' 2>/dev/null ]; then
activate_options ${1}
elif [ ${p_in} == 'yes' 2>/dev/null ]; then
check_p_value=`echo ${1} |grep '[0-7][0-7][0-7]'` # 3 digit file permission code
	if ! [ -z ${check_p_value} ] && [ ${#check_p_value} -eq 3 ]; then
	perm_val=${1}
	else
	bad_inputs+=("-p:${1}")
	fi
p_in='no'
else
	if [ ${filename_reader} != 'off' 2>/dev/null ]; then
	filename=${1}
	filename_reader='off'
	else
	bad_inputs+=("${1}")
	fi
fi
}

activate_options () {
p_in='no'
if [ ${1} == '-cs' ]; then
clear_screen='no'	# Do not clear screen
elif [ ${1} == '-h' ] || [ ${1} == '--help' ]; then
activate_help='yes'
elif [ ${1} == '-nc' ]; then
activate_colors='no'
elif [ ${1} == '-o' ] || [ ${1} == '--open' ]; then
open_script='yes'
elif [ ${1} == '-p' ]; then
p_in='yes'
else
bad_inputs+=("ERROR:activate_options:${1}")
fi
}

color_formats () { # Print colorful terminal text
if [ ${activate_colors} == 'yes' 2>/dev/null ]; then
format=`tput setab 0; tput setaf 7` 	 	# Black background, white text
formatblue=`tput setab 0; tput setaf 4`  	# Black background, blue text
formatorange=`tput setab 0; tput setaf 3`  	# Black background, orange text
formatgreen=`tput setab 0; tput setaf 2` 	# Black background, green text
formatred=`tput setab 0; tput setaf 1` 		# Black background, red text
formatReset=`tput sgr0`				# Reset to default terminal settings
else
format=''	# No formatting
formatblue=''	# No formatting
formatorange=''	# No formatting
formatgreen=''	# No formatting
formatred=''	# No formatting
fi
}

prompt_user_input () { # Prompt user to input filename
printf "${formatorange}INPUT FILENAME (e.g. ${formatgreen}example.sh${formatorange}):${format}"
read -r filename
if [ ${#filename} -eq 0 ]; then
prompt_user_input
fi
}

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
}

open_file () { # Open file in text editor
input_file=${1}
if [ -f ${input_file} ]; then
	for i_text_editor in ${text_editors[@]}; do
	${i_text_editor} ${input_file} 2>/dev/null
		if [ $? -eq 0 ]; then
		exit_message 0
		else
		echo "${formatred}INVALID TEXT EDITOR: ${formatorange}${i_text_editor}${format}"
		fi
	done
echo "${formatred}NO VALID TEXT EDITORS IN '${formatorange}text_editors${formatred}' VARIABLE${format}"
exit_message 0
else
echo "${formatred}MISSING: ${formatorange}${input_file}${format}"
fi
}
#-------------------------------- MESSAGES ---------------------------------#
script_usage () { # Script explanation
echo "${formatred}HELP MESSAGE: ${formatgreen}${script_path}${format}
${formatorange}ADVICE${format}: Create an alias inside your ${HOME}/.bashrc file
(e.g. ${formatgreen}alias kt='${script_path}'${format})
     
${formatorange}USAGE${format}: Input filename of new script
(if alias inside .bashrc file is '${formatgreen}kt${format}')
kt ${formatgreen}new_script_file_name.sh ${formatorange}[options]...${format}
     
${formatorange}OPTIONS${format}: Can input multiple options in any order
    -cs              Prevent screen from clearing before script processes
    -h or --help     Display this message
    -nc              Prevent color printing in terminal
    -o or --open     Open this script
    -p               Permission value of output script (3 digit number)
     
${formatorange}DEFAULT SETTINGS${format}:
     Text editors: ${formatgreen}${text_editors[@]}${format}
     Script file permission: ${formatgreen}${default_permission}${format}
     
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
if [ -z ${1} 2>/dev/null ] || ! [ ${1} -eq ${1} 2>/dev/null ]; then
exit_type='0'
else
exit_type=${1}
fi
wait # Waits for background processes to finish before exiting
echo "${formatblue}EXITING SCRIPT:${formatorange} ${script_path}${format}"
printf "${formatReset}\n"
exit ${exit_type}
}

#---------------------------------- CODE -----------------------------------#
for inputs; do # Reads through all inputs
option_eval ${inputs}
done

if [ ${clear_screen} != 'no' 2>/dev/null ]; then
clear	# Clears screen unless activation of input option: -cs
fi

color_formats # Activates or inhibits colorful output
invalid_input_message # Display invalid inputs

# Display help message or open file
if [ ${activate_help} == 'yes' 2>/dev/null ]; then
script_usage
elif [ ${open_script} == 'yes' 2>/dev/null  ]; then
echo "${formatorange}SCRIPT: ${formatgreen}${script_path}${format}"
open_file ${script_path}
elif [ -z ${filename} ]; then
prompt_user_input
read_filename
else
read_filename
fi

exit_message 0

