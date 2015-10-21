#!/bin/bash
#--------------------------------------------------------------------------------------#
# Created: 04/22/2014 By: Evan Layher (evan.layher@psych.ucsb.edu)
# Revised: 06/23/2015 By: Evan Layher
# Revised: 10/21/2015 By: Evan Layher # Mac compatible (and other minor alterations)
# Reference: github.com/ealayher
#--------------------------------------------------------------------------------------#
# Create new scripts with customized information

## --- LICENSE INFORMATION --- ##
## create_script.sh is the proprietary property of The Regents of the University of California ("The Regents.")

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
text_editors=('kwrite' 'gedit' 'open -a /Applications/TextWrangler.app' 'open' 'nano' 'emacs') # default text editor commands in order of preference
permission_value='755'      # '755': Default file permission for new scripts
default_script_number='1'   # '1'  : 'create_script' functions
script_author='Evan Layher' # Author of script
contact_info='evan.layher@psych.ucsb.edu' # Author contact information

#----------------------- GENERAL SCRIPT VARIABLES --------------------------#
todays_date=`date +%x`          # Inputs date inside of script
script_path="${BASH_SOURCE[0]}" # Script path (becomes absolute path later)
version_number='3.0'            # Script version number

	###--- 'yes' or 'no' options (inputs do the opposite of default) ---###
activate_colors='yes'   # 'yes': Display messages in color [INPUT: '-nc']
activate_help='no'      # 'no' : Display help message      [INPUT: '-h' or '--help']
change_permission='no'  # 'no' : Change permission         [INPUT: '[0-7][0-7][0-7]']
display_scripts='no'    # 'no' : Display script types      [INPUT: '-nl']
filename_reader='on'    # 'on' : Read in filename ('on' or 'off')
list_settings='no'      # 'no' : List user settings        [INPUT: '-l']
open_file='yes'         # 'yes': Open newly created script [INPUT: '-i']
open_script='no'        # 'no' : Open this script          [INPUT: '-o' or '--open']
p_in='no'               # 'no' : Read in permission level for output file

#-------------------------------- FUNCTIONS --------------------------------#
### SCRIPT TYPES: Must have naming convenction of 'create_script*[0-9] () {' [ e.g. create_script10 () { # Comments ]
create_script1 () { # Includes time, exit message, bg functions, vital_command and vital_file
echo "#!/bin/bash
#--------------------------------------------------------------------------------------#
# Created: ${todays_date} By: ${script_author} (${contact_info})
# Revised: ${todays_date} By: ${script_author}
#--------------------------------------------------------------------------------------#
#
#-------------------------------- VARIABLES --------------------------------#

#--------------------------- DEFAULT SETTINGS ------------------------------#
max_bg_jobs='10' # '10': Max number of background processes
text_editors=('kwrite' 'gedit' 'open -a /Applications/TextWrangler.app' 'open' 'nano' 'emacs') # text editor commands in order of preference

#----------------------- GENERAL SCRIPT VARIABLES --------------------------#
script_start_time=\`date +%s\`           # Time in seconds.
script_start_date_time=\`date +%x' '%r\` # (e.g. 01/01/2015 12:00:00 AM)
script_path=\"\${BASH_SOURCE[0]}\"        # Script path (becomes absolute path later)
version_number='1.0' # Script version number

	###--- 'yes' or 'no' options (inputs do the opposite of default) ---###
activate_colors='yes' # 'yes': Display messages in color [INPUT: '-nc']
activate_help='no'    # 'no' : Display help message      [INPUT: '-h' or '--help']
clear_screen='yes'    # 'yes': Clear screen at start     [INPUT: '-cs']
display_exit='yes'    # 'yes': Display an exit message   [INPUT: '-nm']
open_script='no'      # 'no' : Open this script          [INPUT: '-o' or '--open']
show_time='yes'       # 'yes': Display process time      [INPUT: '-nt']
suggest_help='no'     # 'no' : Suggest help (within script option: '-nh')

#-------------------------------- FUNCTIONS --------------------------------#
control_bg_jobs () { # Controls number of background processes
	job_count=\`jobs -p |wc -l\` # Get number of running jobs
	if [ \"\${job_count}\" -ge \"\${max_bg_jobs}\" ]; then
		sleep 0.25
		control_bg_jobs
	fi
} # control_bg_jobs

option_eval () { # Evaluate inputs
	if [ \"\${1}\" == '-cs' 2>/dev/null ] || [ \"\${1}\" == '-h' 2>/dev/null ] || \\
	[ \"\${1}\" == '--help' 2>/dev/null ] || [ \"\${1}\" == '-nc' 2>/dev/null ] || \\
	[ \"\${1}\" == '-nt' 2>/dev/null ] || [ \"\${1}\" == '-nm' 2>/dev/null ] || \\
	[ \"\${1}\" == '-o' 2>/dev/null ] || [ \"\${1}\" == '--open' 2>/dev/null ]; then
		activate_options \"\${1}\"
	elif [ \"\${1:0:1}\" == '-' 2>/dev/null ]; then
		bad_inputs+=(\"\${1}\")
	else
		echo \"\${1}\"
		bad_inputs+=(\"\${1}\")
	fi
} # option_eval

activate_options () { # Activate input options
	if [ \"\${1}\" == '-cs' ]; then
		clear_screen='no'    # Do NOT clear screen at start
	elif [ \"\${1}\" == '-h' ] || [ \"\${1}\" == '--help' ]; then
		activate_help='yes'  # Display help message
	elif [ \"\${1}\" == '-nc' ]; then
		activate_colors='no' # Do NOT display messages in color
	elif [ \"\${1}\" == '-nm' ]; then
		display_exit='no'    # Do NOT display exit message
	elif [ \"\${1}\" == '-nt' ]; then
		show_time='no'       # Do NOT display script process time
	elif [ \"\${1}\" == '-o' ] || [ \"\${1}\" == '--open' ]; then
		open_script='yes'    # Open this script
	else # if option is not defined here (for debugging)
		bad_inputs+=(\"ERROR:activate_options:\${1}\")
	fi
} # activate_options

color_formats () { # Print colorful terminal text
	if [ \"\${activate_colors}\" == 'yes' 2>/dev/null ]; then
		whi=\`tput setab 0; tput setaf 7\` # Black background, white text
		red=\`tput setab 0; tput setaf 1\` # Black background, red text
		ora=\`tput setab 0; tput setaf 3\` # Black background, orange text
		gre=\`tput setab 0; tput setaf 2\` # Black background, green text
		blu=\`tput setab 0; tput setaf 4\` # Black background, blue text
		pur=\`tput setab 0; tput setaf 5\` # Black background, purple text
		formatreset=\`tput sgr0\`          # Reset to default terminal settings
	fi
} # color_formats

mac_readlink () { # Get absolute path of a file
	input_path=\"\${1}\"
	cwd=\"\$(pwd)\" # Current working directory path

	if [ -e \"\${input_path}\" ]; then # if file or directory exists
		cd \"\$(dirname \${input_path})\"
		abs_path=\"\$(pwd)/\$(basename \${input_path})\"
		cd \"\${cwd}\" # Change directory back to original directory
	fi

	if [ -e \"\${abs_path}\" ] && ! [ -z \"\${abs_path}\" ]; then
		echo \"\${abs_path}\"
	else # Invalid input or script error
		echo \"\${input_path}\" # echo original input
	fi
} # mac_readlink

open_text_editor () { # Opens input file
	file_to_open=\"\${1}\"
	valid_text_editor='no'
	
	if [ -f \"\${file_to_open}\" ]; then
		for i in \${!text_editors[@]}; do # Loop through indices
			\${text_editors[i]} \"\${file_to_open}\" 2>/dev/null &
			pid=\"\$!\" # Background process ID
			check_text_pid=(\`ps \"\${pid}\" |grep \"\${pid}\"\`) # Check if pid is running
			
			if [ \"\${#check_text_pid[@]}\" -gt '0' ] && [ \"\${check_text_pid[0]}\" == \"\${pid}\" 2>/dev/null ]; then
				valid_text_editor='yes'
				break
			fi
		done

		if [ \"\${valid_text_editor}\" == 'no' 2>/dev/null ]; then
			echo \"\${red}NO VALID TEXT EDITORS: \${ora}\${text_editors[@]}\${whi}\"
			exit_message 99 -nh -nm -nt
		fi
	else
		echo \"\${red}MISSING FILE: \${ora}\${file_to_open}\${whi}\"
	fi
} # open_text_editor

vital_command () { # exits script if an essential command fails
	command_status=\"\$?\"
	command_line_number=\"\${1}\" # Must input as: vital_command \${LINENO}
	
	if ! [ -z \"\${command_status}\" ] && [ \"\${command_status}\" -ne '0' ]; then
		echo \"\${red}INVALID COMMAND: LINE \${ora}\${command_line_number}\${whi}\"
		exit_message 98 -nh -nm -nt
	fi
} # vital_command

vital_file () { # exits script if an essential file is missing
	for vitals; do
		if ! [ -e \"\${vitals}\" 2>/dev/null ]; then
			bad_files+=(\"\${vitals}\")
		fi
	done
	
	if [ \"\${#bad_files[@]}\" -gt '0' ]; then
		echo \"\${red}MISSING ESSENTIAL FILE(S):\${pur}\"
		printf '%s\\n' \${bad_files[@]}
		exit_message 97 -nh -nm -nt
	fi
} # vital_file

#-------------------------------- MESSAGES ---------------------------------#
script_usage () { # Script explanation
	echo \"\${red}HELP MESSAGE: \${gre}\${script_path}\${whi}
\${ora}DESCRIPTION\${whi}:
     
\${ora}ADVICE\${whi}: Create an alias inside your \${ora}\${HOME}/.bashrc\${whi} file
(e.g. \${gre}alias xx='\${script_path}'\${whi})
     
\${ora}USAGE\${whi}:
 [\${ora}1\${whi}] \${gre}\${script_path}\${whi}
     
\${ora}OPTIONS\${whi}: Can input multiple options in any order
 \${pur}-cs\${whi}  Prevent screen from clearing before script processes
 \${pur}-h\${whi} or \${pur}--help\${whi}  Display this message
 \${pur}-nc\${whi}  Prevent color printing in terminal
 \${pur}-nm\${whi}  Prevent exit message from displaying
 \${pur}-nt\${whi}  Prevent script process time from displaying
 \${pur}-o\${whi} or \${pur}--open\${whi} Open this script
     
\${ora}DEFAULT SETTINGS\${whi}:
 text editors: \${gre}\${text_editors[@]}\${whi}
     
\${ora}VERSION: \${gre}\${version_number}\${whi}
\${red}END OF HELP: \${gre}\${script_path}\${whi}\"
	exit_message 0 -nt -nm
} # script_usage

re_enter_input_message () { # Displays invalid input message
	clear
	echo \"\${red}INVALID INPUT: \${ora}\"
	printf '%s\\n' \${@}
	echo \"\${pur}PLEASE RE-ENTER INPUT\${whi}\"
} # re_enter_input_message

script_time_message () { # Script process time message
	echo \"STARTED : \${script_start_date_time}\"
	echo \"FINISHED: \`date +%x' '%r\`\"
} # script_time_message

script_time_func () { # Script process time calculation
	script_end_time=\`date +%s\`
	script_process_time=\$((\${script_end_time} - \${script_start_time}))
	days=\$((\${script_process_time} / 86400))
	hours=\$((\${script_process_time} % 86400 / 3600))
	mins=\$((\${script_process_time} % 3600 / 60))
	secs=\$((\${script_process_time} % 60))
	time_message=(\"PROCESS TIME: \")
	
	if [ \"\${days}\" -gt '0' ]; then 
		time_message+=(\"\${days} day(s) \${hours} hour(s) \${mins} minute(s) \${secs} second(s)\")
	elif [ \"\${hours}\" -gt '0' ]; then
		time_message+=(\"\${hours} hour(s) \${mins} minute(s) \${secs} second(s)\")
	elif [ \"\${mins}\" -gt '0' ]; then
		time_message+=(\"\${mins} minute(s) \${secs} second(s)\")
	else
		time_message+=(\"\${secs} second(s)\")
	fi
	
	script_time_message
	echo \${time_message[@]}
} # script_time_func

exit_message () { # Message before exiting script
	if [ -z \"\${1}\" 2>/dev/null ] || ! [ \"\${1}\" -eq \"\${1}\" 2>/dev/null ]; then
		exit_type='0'
	else
		exit_type=\"\${1}\"
	fi
	
	if [ \"\${exit_type}\" -ne '0' ]; then
		suggest_help='yes'
	fi
	
	for exit_inputs; do
		if [ \"\${exit_inputs}\" == '-nh' 2>/dev/null ]; then
			suggest_help='no'
		elif [ \"\${exit_inputs}\" == '-nt' 2>/dev/null ]; then
			show_time='no'
		elif [ \"\${exit_inputs}\" == '-nm' 2>/dev/null ]; then
			display_exit='no'
		fi
	done
	
	wait # Waits for background processes to finish before exiting

	# Suggest help message
	if [ \"\${suggest_help}\" == 'yes' 2>/dev/null ]; then
		echo \"\${ora}TO DISPLAY HELP MESSAGE TYPE: \${gre}\${script_path} -h\${whi}\"
	fi
	
	# Display exit message
	if ! [ \"\${display_exit}\" == 'no' 2>/dev/null ]; then # Exit message
		echo \"\${pur}EXITING SCRIPT:\${ora} \${script_path}\${whi}\"
	fi
	
	# Display script process time
	if [ \"\${show_time}\" == 'yes' 2>/dev/null ]; then # Script time message
		script_time_func 2>/dev/null
	fi
	
	printf \"\${formatreset}\\n\"
	exit \"\${exit_type}\"
} # exit_message

#---------------------------------- CODE -----------------------------------#
script_path=\$(mac_readlink \"\${script_path}\") # equivalent to 'readlink -f' in linux

for inputs; do # Reads through all inputs
	option_eval \"\${inputs}\"
done

if ! [ \"\${clear_screen}\" == 'no' 2>/dev/null ]; then
	clear     # Clears screen unless activation of input option: '-cs'
fi

color_formats # Activates or inhibits colorful output

# Display help message or open file
if [ \"\${activate_help}\" == 'yes' ]; then # '-h' or '--help'
	script_usage
elif [ \${open_script} == 'yes' ]; then   # '-o' or '--open'
	open_text_editor \"\${script_path}\" \${text_editors[@]}
	exit_message 0 -nm -nt
fi

# Exit script if invalid inputs found
if [ \"\${#bad_inputs[@]}\" -gt '0' ]; then
	re_enter_input_message \${bad_inputs[@]}
	exit_message 1
fi

exit_message 0"
} # create_script1

create_script2 () { # Includes time, exit message, vital_command and vital_file
echo "#!/bin/bash
#--------------------------------------------------------------------------------------#
# Created: ${todays_date} By: ${script_author} (${contact_info})
# Revised: ${todays_date} By: ${script_author}
#--------------------------------------------------------------------------------------#
#
#-------------------------------- VARIABLES --------------------------------#

#--------------------------- DEFAULT SETTINGS ------------------------------#
text_editors=('kwrite' 'gedit' 'open -a /Applications/TextWrangler.app' 'open' 'nano' 'emacs') # text editor commands in order of preference

#----------------------- GENERAL SCRIPT VARIABLES --------------------------#
script_start_time=\`date +%s\`           # Time in seconds.
script_start_date_time=\`date +%x' '%r\` # (e.g. 01/01/2015 12:00:00 AM)
script_path=\"\${BASH_SOURCE[0]}\"        # Script path (becomes absolute path later)
version_number='1.0' # Script version number

	###--- 'yes' or 'no' options (inputs do the opposite of default) ---###
activate_colors='yes' # 'yes': Display messages in color [INPUT: '-nc']
activate_help='no'    # 'no' : Display help message      [INPUT: '-h' or '--help']
clear_screen='yes'    # 'yes': Clear screen at start     [INPUT: '-cs']
display_exit='yes'    # 'yes': Display an exit message   [INPUT: '-nm']
open_script='no'      # 'no' : Open this script          [INPUT: '-o' or '--open']
show_time='yes'       # 'yes': Display process time      [INPUT: '-nt']
suggest_help='no'     # 'no' : Suggest help (within script option: '-nh')

#-------------------------------- FUNCTIONS --------------------------------#
option_eval () { # Evaluate inputs
	if [ \"\${1}\" == '-cs' 2>/dev/null ] || [ \"\${1}\" == '-h' 2>/dev/null ] || \\
	[ \"\${1}\" == '--help' 2>/dev/null ] || [ \"\${1}\" == '-nc' 2>/dev/null ] || \\
	[ \"\${1}\" == '-nt' 2>/dev/null ] || [ \"\${1}\" == '-nm' 2>/dev/null ] || \\
	[ \"\${1}\" == '-o' 2>/dev/null ] || [ \"\${1}\" == '--open' 2>/dev/null ]; then
		activate_options \"\${1}\"
	elif [ \"\${1:0:1}\" == '-' 2>/dev/null ]; then
		bad_inputs+=(\"\${1}\")
	else
		echo \"\${1}\"
		bad_inputs+=(\"\${1}\")
	fi
} # option_eval

activate_options () { # Activate input options
	if [ \"\${1}\" == '-cs' ]; then
		clear_screen='no'    # Do NOT clear screen at start
	elif [ \"\${1}\" == '-h' ] || [ \"\${1}\" == '--help' ]; then
		activate_help='yes'  # Display help message
	elif [ \"\${1}\" == '-nc' ]; then
		activate_colors='no' # Do NOT display messages in color
	elif [ \"\${1}\" == '-nm' ]; then
		display_exit='no'    # Do NOT display exit message
	elif [ \"\${1}\" == '-nt' ]; then
		show_time='no'       # Do NOT display script process time
	elif [ \"\${1}\" == '-o' ] || [ \"\${1}\" == '--open' ]; then
		open_script='yes'    # Open this script
	else # if option is not defined here (for debugging)
		bad_inputs+=(\"ERROR:activate_options:\${1}\")
	fi
} # activate_options

color_formats () { # Print colorful terminal text
	if [ \"\${activate_colors}\" == 'yes' 2>/dev/null ]; then
		whi=\`tput setab 0; tput setaf 7\` # Black background, white text
		red=\`tput setab 0; tput setaf 1\` # Black background, red text
		ora=\`tput setab 0; tput setaf 3\` # Black background, orange text
		gre=\`tput setab 0; tput setaf 2\` # Black background, green text
		blu=\`tput setab 0; tput setaf 4\` # Black background, blue text
		pur=\`tput setab 0; tput setaf 5\` # Black background, purple text
		formatreset=\`tput sgr0\`          # Reset to default terminal settings
	fi
} # color_formats

mac_readlink () { # Get absolute path of a file
	input_path=\"\${1}\"
	cwd=\"\$(pwd)\" # Current working directory path

	if [ -e \"\${input_path}\" ]; then # if file or directory exists
		cd \"\$(dirname \${input_path})\"
		abs_path=\"\$(pwd)/\$(basename \${input_path})\"
		cd \"\${cwd}\" # Change directory back to original directory
	fi

	if [ -e \"\${abs_path}\" ] && ! [ -z \"\${abs_path}\" ]; then
		echo \"\${abs_path}\"
	else # Invalid input or script error
		echo \"\${input_path}\" # echo original input
	fi
} # mac_readlink

open_text_editor () { # Opens input file
	file_to_open=\"\${1}\"
	valid_text_editor='no'
	
	if [ -f \"\${file_to_open}\" ]; then
		for i in \${!text_editors[@]}; do # Loop through indices
			\${text_editors[i]} \"\${file_to_open}\" 2>/dev/null &
			pid=\"\$!\" # Background process ID
			check_text_pid=(\`ps \"\${pid}\" |grep \"\${pid}\"\`) # Check if pid is running
			
			if [ \"\${#check_text_pid[@]}\" -gt '0' ] && [ \"\${check_text_pid[0]}\" == \"\${pid}\" 2>/dev/null ]; then
				valid_text_editor='yes'
				break
			fi
		done

		if [ \"\${valid_text_editor}\" == 'no' 2>/dev/null ]; then
			echo \"\${red}NO VALID TEXT EDITORS: \${ora}\${text_editors[@]}\${whi}\"
			exit_message 99 -nh -nm -nt
		fi
	else
		echo \"\${red}MISSING FILE: \${ora}\${file_to_open}\${whi}\"
	fi
} # open_text_editor

vital_command () { # exits script if an essential command fails
	command_status=\"\$?\"
	command_line_number=\"\${1}\" # Must input as: vital_command \${LINENO}
	
	if ! [ -z \"\${command_status}\" ] && [ \"\${command_status}\" -ne '0' ]; then
		echo \"\${red}INVALID COMMAND: LINE \${ora}\${command_line_number}\${whi}\"
		exit_message 98 -nh -nm -nt
	fi
} # vital_command

vital_file () { # exits script if an essential file is missing
	for vitals; do
		if ! [ -e \"\${vitals}\" 2>/dev/null ]; then
			bad_files+=(\"\${vitals}\")
		fi
	done
	
	if [ \"\${#bad_files[@]}\" -gt '0' ]; then
		echo \"\${red}MISSING ESSENTIAL FILE(S):\${pur}\"
		printf '%s\\n' \${bad_files[@]}
		exit_message 97 -nh -nm -nt
	fi
} # vital_file

#-------------------------------- MESSAGES ---------------------------------#
script_usage () { # Script explanation
	echo \"\${red}HELP MESSAGE: \${gre}\${script_path}\${whi}
\${ora}DESCRIPTION\${whi}:
     
\${ora}ADVICE\${whi}: Create an alias inside your \${ora}\${HOME}/.bashrc\${whi} file
(e.g. \${gre}alias xx='\${script_path}'\${whi})
     
\${ora}USAGE\${whi}:
 [\${ora}1\${whi}] \${gre}\${script_path}\${whi}
     
\${ora}OPTIONS\${whi}: Can input multiple options in any order
 \${pur}-cs\${whi}  Prevent screen from clearing before script processes
 \${pur}-h\${whi} or \${pur}--help\${whi}  Display this message
 \${pur}-nc\${whi}  Prevent color printing in terminal
 \${pur}-nm\${whi}  Prevent exit message from displaying
 \${pur}-nt\${whi}  Prevent script process time from displaying
 \${pur}-o\${whi} or \${pur}--open\${whi} Open this script
     
\${ora}DEFAULT SETTINGS\${whi}:
 text editors: \${gre}\${text_editors[@]}\${whi}
     
\${ora}VERSION: \${gre}\${version_number}\${whi}
\${red}END OF HELP: \${gre}\${script_path}\${whi}\"
	exit_message 0 -nt -nm
} # script_usage

re_enter_input_message () { # Displays invalid input message
	clear
	echo \"\${red}INVALID INPUT: \${ora}\"
	printf '%s\\n' \${@}
	echo \"\${pur}PLEASE RE-ENTER INPUT\${whi}\"
} # re_enter_input_message

script_time_message () { # Script process time message
	echo \"STARTED : \${script_start_date_time}\"
	echo \"FINISHED: \`date +%x' '%r\`\"
} # script_time_message

script_time_func () { # Script process time calculation
	script_end_time=\`date +%s\`
	script_process_time=\$((\${script_end_time} - \${script_start_time}))
	days=\$((\${script_process_time} / 86400))
	hours=\$((\${script_process_time} % 86400 / 3600))
	mins=\$((\${script_process_time} % 3600 / 60))
	secs=\$((\${script_process_time} % 60))
	time_message=(\"PROCESS TIME: \")
	
	if [ \"\${days}\" -gt '0' ]; then 
		time_message+=(\"\${days} day(s) \${hours} hour(s) \${mins} minute(s) \${secs} second(s)\")
	elif [ \"\${hours}\" -gt '0' ]; then
		time_message+=(\"\${hours} hour(s) \${mins} minute(s) \${secs} second(s)\")
	elif [ \"\${mins}\" -gt '0' ]; then
		time_message+=(\"\${mins} minute(s) \${secs} second(s)\")
	else
		time_message+=(\"\${secs} second(s)\")
	fi
	
	script_time_message
	echo \${time_message[@]}
} # script_time_func

exit_message () { # Message before exiting script
	if [ -z \"\${1}\" 2>/dev/null ] || ! [ \"\${1}\" -eq \"\${1}\" 2>/dev/null ]; then
		exit_type='0'
	else
		exit_type=\"\${1}\"
	fi
	
	if [ \"\${exit_type}\" -ne '0' ]; then
		suggest_help='yes'
	fi
	
	for exit_inputs; do
		if [ \"\${exit_inputs}\" == '-nh' 2>/dev/null ]; then
			suggest_help='no'
		elif [ \"\${exit_inputs}\" == '-nt' 2>/dev/null ]; then
			show_time='no'
		elif [ \"\${exit_inputs}\" == '-nm' 2>/dev/null ]; then
			display_exit='no'
		fi
	done
	
	wait # Waits for background processes to finish before exiting

	# Suggest help message
	if [ \"\${suggest_help}\" == 'yes' 2>/dev/null ]; then
		echo \"\${ora}TO DISPLAY HELP MESSAGE TYPE: \${gre}\${script_path} -h\${whi}\"
	fi
	
	# Display exit message
	if ! [ \"\${display_exit}\" == 'no' 2>/dev/null ]; then # Exit message
		echo \"\${pur}EXITING SCRIPT:\${ora} \${script_path}\${whi}\"
	fi
	
	# Display script process time
	if [ \"\${show_time}\" == 'yes' 2>/dev/null ]; then # Script time message
		script_time_func 2>/dev/null
	fi
	
	printf \"\${formatreset}\\n\"
	exit \"\${exit_type}\"
} # exit_message

#---------------------------------- CODE -----------------------------------#
script_path=\$(mac_readlink \"\${script_path}\") # equivalent to 'readlink -f' in linux

for inputs; do # Reads through all inputs
	option_eval \"\${inputs}\"
done

if ! [ \"\${clear_screen}\" == 'no' 2>/dev/null ]; then
	clear     # Clears screen unless activation of input option: '-cs'
fi

color_formats # Activates or inhibits colorful output

# Display help message or open file
if [ \"\${activate_help}\" == 'yes' ]; then # '-h' or '--help'
	script_usage
elif [ \${open_script} == 'yes' ]; then   # '-o' or '--open'
	open_text_editor \"\${script_path}\" \${text_editors[@]}
	exit_message 0 -nm -nt
fi

# Exit script if invalid inputs found
if [ \"\${#bad_inputs[@]}\" -gt '0' ]; then
	re_enter_input_message \${bad_inputs[@]}
	exit_message 1
fi

exit_message 0"
} # create_script2

create_script3 () { # Includes time, exit message and bg functions
echo "#!/bin/bash
#--------------------------------------------------------------------------------------#
# Created: ${todays_date} By: ${script_author} (${contact_info})
# Revised: ${todays_date} By: ${script_author}
#--------------------------------------------------------------------------------------#
#
#-------------------------------- VARIABLES --------------------------------#

#--------------------------- DEFAULT SETTINGS ------------------------------#
max_bg_jobs='10' # '10': Max number of background processes
text_editors=('kwrite' 'gedit' 'open -a /Applications/TextWrangler.app' 'open' 'nano' 'emacs') # text editor commands in order of preference

#----------------------- GENERAL SCRIPT VARIABLES --------------------------#
script_start_time=\`date +%s\`           # Time in seconds.
script_start_date_time=\`date +%x' '%r\` # (e.g. 01/01/2015 12:00:00 AM)
script_path=\"\${BASH_SOURCE[0]}\"        # Script path (becomes absolute path later)
version_number='1.0' # Script version number

	###--- 'yes' or 'no' options (inputs do the opposite of default) ---###
activate_colors='yes' # 'yes': Display messages in color [INPUT: '-nc']
activate_help='no'    # 'no' : Display help message      [INPUT: '-h' or '--help']
clear_screen='yes'    # 'yes': Clear screen at start     [INPUT: '-cs']
display_exit='yes'    # 'yes': Display an exit message   [INPUT: '-nm']
open_script='no'      # 'no' : Open this script          [INPUT: '-o' or '--open']
show_time='yes'       # 'yes': Display process time      [INPUT: '-nt']
suggest_help='no'     # 'no' : Suggest help (within script option: '-nh')

#-------------------------------- FUNCTIONS --------------------------------#
control_bg_jobs () { # Controls number of background processes
	job_count=\`jobs -p |wc -l\` # Get number of running jobs
	if [ \"\${job_count}\" -ge \"\${max_bg_jobs}\" ]; then
		sleep 0.25
		control_bg_jobs
	fi
} # control_bg_jobs

option_eval () { # Evaluate inputs
	if [ \"\${1}\" == '-cs' 2>/dev/null ] || [ \"\${1}\" == '-h' 2>/dev/null ] || \\
	[ \"\${1}\" == '--help' 2>/dev/null ] || [ \"\${1}\" == '-nc' 2>/dev/null ] || \\
	[ \"\${1}\" == '-nt' 2>/dev/null ] || [ \"\${1}\" == '-nm' 2>/dev/null ] || \\
	[ \"\${1}\" == '-o' 2>/dev/null ] || [ \"\${1}\" == '--open' 2>/dev/null ]; then
		activate_options \"\${1}\"
	elif [ \"\${1:0:1}\" == '-' 2>/dev/null ]; then
		bad_inputs+=(\"\${1}\")
	else
		echo \"\${1}\"
		bad_inputs+=(\"\${1}\")
	fi
} # option_eval

activate_options () { # Activate input options
	if [ \"\${1}\" == '-cs' ]; then
		clear_screen='no'    # Do NOT clear screen at start
	elif [ \"\${1}\" == '-h' ] || [ \"\${1}\" == '--help' ]; then
		activate_help='yes'  # Display help message
	elif [ \"\${1}\" == '-nc' ]; then
		activate_colors='no' # Do NOT display messages in color
	elif [ \"\${1}\" == '-nm' ]; then
		display_exit='no'    # Do NOT display exit message
	elif [ \"\${1}\" == '-nt' ]; then
		show_time='no'       # Do NOT display script process time
	elif [ \"\${1}\" == '-o' ] || [ \"\${1}\" == '--open' ]; then
		open_script='yes'    # Open this script
	else # if option is not defined here (for debugging)
		bad_inputs+=(\"ERROR:activate_options:\${1}\")
	fi
} # activate_options

color_formats () { # Print colorful terminal text
	if [ \"\${activate_colors}\" == 'yes' 2>/dev/null ]; then
		whi=\`tput setab 0; tput setaf 7\` # Black background, white text
		red=\`tput setab 0; tput setaf 1\` # Black background, red text
		ora=\`tput setab 0; tput setaf 3\` # Black background, orange text
		gre=\`tput setab 0; tput setaf 2\` # Black background, green text
		blu=\`tput setab 0; tput setaf 4\` # Black background, blue text
		pur=\`tput setab 0; tput setaf 5\` # Black background, purple text
		formatreset=\`tput sgr0\`          # Reset to default terminal settings
	fi
} # color_formats

mac_readlink () { # Get absolute path of a file
	input_path=\"\${1}\"
	cwd=\"\$(pwd)\" # Current working directory path

	if [ -e \"\${input_path}\" ]; then # if file or directory exists
		cd \"\$(dirname \${input_path})\"
		abs_path=\"\$(pwd)/\$(basename \${input_path})\"
		cd \"\${cwd}\" # Change directory back to original directory
	fi

	if [ -e \"\${abs_path}\" ] && ! [ -z \"\${abs_path}\" ]; then
		echo \"\${abs_path}\"
	else # Invalid input or script error
		echo \"\${input_path}\" # echo original input
	fi
} # mac_readlink

open_text_editor () { # Opens input file
	file_to_open=\"\${1}\"
	valid_text_editor='no'
	
	if [ -f \"\${file_to_open}\" ]; then
		for i in \${!text_editors[@]}; do # Loop through indices
			\${text_editors[i]} \"\${file_to_open}\" 2>/dev/null &
			pid=\"\$!\" # Background process ID
			check_text_pid=(\`ps \"\${pid}\" |grep \"\${pid}\"\`) # Check if pid is running
			
			if [ \"\${#check_text_pid[@]}\" -gt '0' ] && [ \"\${check_text_pid[0]}\" == \"\${pid}\" 2>/dev/null ]; then
				valid_text_editor='yes'
				break
			fi
		done

		if [ \"\${valid_text_editor}\" == 'no' 2>/dev/null ]; then
			echo \"\${red}NO VALID TEXT EDITORS: \${ora}\${text_editors[@]}\${whi}\"
			exit_message 99 -nh -nm -nt
		fi
	else
		echo \"\${red}MISSING FILE: \${ora}\${file_to_open}\${whi}\"
	fi
} # open_text_editor

#-------------------------------- MESSAGES ---------------------------------#
script_usage () { # Script explanation
	echo \"\${red}HELP MESSAGE: \${gre}\${script_path}\${whi}
\${ora}DESCRIPTION\${whi}:
     
\${ora}ADVICE\${whi}: Create an alias inside your \${ora}\${HOME}/.bashrc\${whi} file
(e.g. \${gre}alias xx='\${script_path}'\${whi})
     
\${ora}USAGE\${whi}:
 [\${ora}1\${whi}] \${gre}\${script_path}\${whi}
     
\${ora}OPTIONS\${whi}: Can input multiple options in any order
 \${pur}-cs\${whi}  Prevent screen from clearing before script processes
 \${pur}-h\${whi} or \${pur}--help\${whi}  Display this message
 \${pur}-nc\${whi}  Prevent color printing in terminal
 \${pur}-nm\${whi}  Prevent exit message from displaying
 \${pur}-nt\${whi}  Prevent script process time from displaying
 \${pur}-o\${whi} or \${pur}--open\${whi} Open this script
     
\${ora}DEFAULT SETTINGS\${whi}:
 text editors: \${gre}\${text_editors[@]}\${whi}
     
\${ora}VERSION: \${gre}\${version_number}\${whi}
\${red}END OF HELP: \${gre}\${script_path}\${whi}\"
	exit_message 0 -nt -nm
} # script_usage

re_enter_input_message () { # Displays invalid input message
	clear
	echo \"\${red}INVALID INPUT: \${ora}\"
	printf '%s\\n' \${@}
	echo \"\${pur}PLEASE RE-ENTER INPUT\${whi}\"
} # re_enter_input_message

script_time_message () { # Script process time message
	echo \"STARTED : \${script_start_date_time}\"
	echo \"FINISHED: \`date +%x' '%r\`\"
} # script_time_message

script_time_func () { # Script process time calculation
	script_end_time=\`date +%s\`
	script_process_time=\$((\${script_end_time} - \${script_start_time}))
	days=\$((\${script_process_time} / 86400))
	hours=\$((\${script_process_time} % 86400 / 3600))
	mins=\$((\${script_process_time} % 3600 / 60))
	secs=\$((\${script_process_time} % 60))
	time_message=(\"PROCESS TIME: \")
	
	if [ \"\${days}\" -gt '0' ]; then 
		time_message+=(\"\${days} day(s) \${hours} hour(s) \${mins} minute(s) \${secs} second(s)\")
	elif [ \"\${hours}\" -gt '0' ]; then
		time_message+=(\"\${hours} hour(s) \${mins} minute(s) \${secs} second(s)\")
	elif [ \"\${mins}\" -gt '0' ]; then
		time_message+=(\"\${mins} minute(s) \${secs} second(s)\")
	else
		time_message+=(\"\${secs} second(s)\")
	fi
	
	script_time_message
	echo \${time_message[@]}
} # script_time_func

exit_message () { # Message before exiting script
	if [ -z \"\${1}\" 2>/dev/null ] || ! [ \"\${1}\" -eq \"\${1}\" 2>/dev/null ]; then
		exit_type='0'
	else
		exit_type=\"\${1}\"
	fi
	
	if [ \"\${exit_type}\" -ne '0' ]; then
		suggest_help='yes'
	fi
	
	for exit_inputs; do
		if [ \"\${exit_inputs}\" == '-nh' 2>/dev/null ]; then
			suggest_help='no'
		elif [ \"\${exit_inputs}\" == '-nt' 2>/dev/null ]; then
			show_time='no'
		elif [ \"\${exit_inputs}\" == '-nm' 2>/dev/null ]; then
			display_exit='no'
		fi
	done
	
	wait # Waits for background processes to finish before exiting

	# Suggest help message
	if [ \"\${suggest_help}\" == 'yes' 2>/dev/null ]; then
		echo \"\${ora}TO DISPLAY HELP MESSAGE TYPE: \${gre}\${script_path} -h\${whi}\"
	fi
	
	# Display exit message
	if ! [ \"\${display_exit}\" == 'no' 2>/dev/null ]; then # Exit message
		echo \"\${pur}EXITING SCRIPT:\${ora} \${script_path}\${whi}\"
	fi
	
	# Display script process time
	if [ \"\${show_time}\" == 'yes' 2>/dev/null ]; then # Script time message
		script_time_func 2>/dev/null
	fi
	
	printf \"\${formatreset}\\n\"
	exit \"\${exit_type}\"
} # exit_message

#---------------------------------- CODE -----------------------------------#
script_path=\$(mac_readlink \"\${script_path}\") # equivalent to 'readlink -f' in linux

for inputs; do # Reads through all inputs
	option_eval \"\${inputs}\"
done

if ! [ \"\${clear_screen}\" == 'no' 2>/dev/null ]; then
	clear     # Clears screen unless activation of input option: '-cs'
fi

color_formats # Activates or inhibits colorful output

# Display help message or open file
if [ \"\${activate_help}\" == 'yes' ]; then # '-h' or '--help'
	script_usage
elif [ \${open_script} == 'yes' ]; then   # '-o' or '--open'
	open_text_editor \"\${script_path}\" \${text_editors[@]}
	exit_message 0 -nm -nt
fi

# Exit script if invalid inputs found
if [ \"\${#bad_inputs[@]}\" -gt '0' ]; then
	re_enter_input_message \${bad_inputs[@]}
	exit_message 1
fi

exit_message 0"
} # create_script3

create_script4 () { # Includes time and exit message
echo "#!/bin/bash
#--------------------------------------------------------------------------------------#
# Created: ${todays_date} By: ${script_author} (${contact_info})
# Revised: ${todays_date} By: ${script_author}
#--------------------------------------------------------------------------------------#
#
#-------------------------------- VARIABLES --------------------------------#

#--------------------------- DEFAULT SETTINGS ------------------------------#
text_editors=('kwrite' 'gedit' 'open -a /Applications/TextWrangler.app' 'open' 'nano' 'emacs') # text editor commands in order of preference

#----------------------- GENERAL SCRIPT VARIABLES --------------------------#
script_start_time=\`date +%s\`           # Time in seconds.
script_start_date_time=\`date +%x' '%r\` # (e.g. 01/01/2015 12:00:00 AM)
script_path=\"\${BASH_SOURCE[0]}\"        # Script path (becomes absolute path later)
version_number='1.0' # Script version number

	###--- 'yes' or 'no' options (inputs do the opposite of default) ---###
activate_colors='yes' # 'yes': Display messages in color [INPUT: '-nc']
activate_help='no'    # 'no' : Display help message      [INPUT: '-h' or '--help']
clear_screen='yes'    # 'yes': Clear screen at start     [INPUT: '-cs']
display_exit='yes'    # 'yes': Display an exit message   [INPUT: '-nm']
open_script='no'      # 'no' : Open this script          [INPUT: '-o' or '--open']
show_time='yes'       # 'yes': Display process time      [INPUT: '-nt']
suggest_help='no'     # 'no' : Suggest help (within script option: '-nh')

#-------------------------------- FUNCTIONS --------------------------------#
option_eval () { # Evaluate inputs
	if [ \"\${1}\" == '-cs' 2>/dev/null ] || [ \"\${1}\" == '-h' 2>/dev/null ] || \\
	[ \"\${1}\" == '--help' 2>/dev/null ] || [ \"\${1}\" == '-nc' 2>/dev/null ] || \\
	[ \"\${1}\" == '-nt' 2>/dev/null ] || [ \"\${1}\" == '-nm' 2>/dev/null ] || \\
	[ \"\${1}\" == '-o' 2>/dev/null ] || [ \"\${1}\" == '--open' 2>/dev/null ]; then
		activate_options \"\${1}\"
	elif [ \"\${1:0:1}\" == '-' 2>/dev/null ]; then
		bad_inputs+=(\"\${1}\")
	else
		echo \"\${1}\"
		bad_inputs+=(\"\${1}\")
	fi
} # option_eval

activate_options () { # Activate input options
	if [ \"\${1}\" == '-cs' ]; then
		clear_screen='no'    # Do NOT clear screen at start
	elif [ \"\${1}\" == '-h' ] || [ \"\${1}\" == '--help' ]; then
		activate_help='yes'  # Display help message
	elif [ \"\${1}\" == '-nc' ]; then
		activate_colors='no' # Do NOT display messages in color
	elif [ \"\${1}\" == '-nm' ]; then
		display_exit='no'    # Do NOT display exit message
	elif [ \"\${1}\" == '-nt' ]; then
		show_time='no'       # Do NOT display script process time
	elif [ \"\${1}\" == '-o' ] || [ \"\${1}\" == '--open' ]; then
		open_script='yes'    # Open this script
	else # if option is not defined here (for debugging)
		bad_inputs+=(\"ERROR:activate_options:\${1}\")
	fi
} # activate_options

color_formats () { # Print colorful terminal text
	if [ \"\${activate_colors}\" == 'yes' 2>/dev/null ]; then
		whi=\`tput setab 0; tput setaf 7\` # Black background, white text
		red=\`tput setab 0; tput setaf 1\` # Black background, red text
		ora=\`tput setab 0; tput setaf 3\` # Black background, orange text
		gre=\`tput setab 0; tput setaf 2\` # Black background, green text
		blu=\`tput setab 0; tput setaf 4\` # Black background, blue text
		pur=\`tput setab 0; tput setaf 5\` # Black background, purple text
		formatreset=\`tput sgr0\`          # Reset to default terminal settings
	fi
} # color_formats

mac_readlink () { # Get absolute path of a file
	input_path=\"\${1}\"
	cwd=\"\$(pwd)\" # Current working directory path

	if [ -e \"\${input_path}\" ]; then # if file or directory exists
		cd \"\$(dirname \${input_path})\"
		abs_path=\"\$(pwd)/\$(basename \${input_path})\"
		cd \"\${cwd}\" # Change directory back to original directory
	fi

	if [ -e \"\${abs_path}\" ] && ! [ -z \"\${abs_path}\" ]; then
		echo \"\${abs_path}\"
	else # Invalid input or script error
		echo \"\${input_path}\" # echo original input
	fi
} # mac_readlink

open_text_editor () { # Opens input file
	file_to_open=\"\${1}\"
	valid_text_editor='no'
	
	if [ -f \"\${file_to_open}\" ]; then
		for i in \${!text_editors[@]}; do # Loop through indices
			\${text_editors[i]} \"\${file_to_open}\" 2>/dev/null &
			pid=\"\$!\" # Background process ID
			check_text_pid=(\`ps \"\${pid}\" |grep \"\${pid}\"\`) # Check if pid is running
			
			if [ \"\${#check_text_pid[@]}\" -gt '0' ] && [ \"\${check_text_pid[0]}\" == \"\${pid}\" 2>/dev/null ]; then
				valid_text_editor='yes'
				break
			fi
		done

		if [ \"\${valid_text_editor}\" == 'no' 2>/dev/null ]; then
			echo \"\${red}NO VALID TEXT EDITORS: \${ora}\${text_editors[@]}\${whi}\"
			exit_message 99 -nh -nm -nt
		fi
	else
		echo \"\${red}MISSING FILE: \${ora}\${file_to_open}\${whi}\"
	fi
} # open_text_editor

#-------------------------------- MESSAGES ---------------------------------#
script_usage () { # Script explanation
	echo \"\${red}HELP MESSAGE: \${gre}\${script_path}\${whi}
\${ora}DESCRIPTION\${whi}:
     
\${ora}ADVICE\${whi}: Create an alias inside your \${ora}\${HOME}/.bashrc\${whi} file
(e.g. \${gre}alias xx='\${script_path}'\${whi})
     
\${ora}USAGE\${whi}:
 [\${ora}1\${whi}] \${gre}\${script_path}\${whi}
     
\${ora}OPTIONS\${whi}: Can input multiple options in any order
 \${pur}-cs\${whi}  Prevent screen from clearing before script processes
 \${pur}-h\${whi} or \${pur}--help\${whi}  Display this message
 \${pur}-nc\${whi}  Prevent color printing in terminal
 \${pur}-nm\${whi}  Prevent exit message from displaying
 \${pur}-nt\${whi}  Prevent script process time from displaying
 \${pur}-o\${whi} or \${pur}--open\${whi} Open this script
     
\${ora}DEFAULT SETTINGS\${whi}:
 text editors: \${gre}\${text_editors[@]}\${whi}
     
\${ora}VERSION: \${gre}\${version_number}\${whi}
\${red}END OF HELP: \${gre}\${script_path}\${whi}\"
	exit_message 0 -nt -nm
} # script_usage

re_enter_input_message () { # Displays invalid input message
	clear
	echo \"\${red}INVALID INPUT: \${ora}\"
	printf '%s\\n' \${@}
	echo \"\${pur}PLEASE RE-ENTER INPUT\${whi}\"
} # re_enter_input_message

script_time_message () { # Script process time message
	echo \"STARTED : \${script_start_date_time}\"
	echo \"FINISHED: \`date +%x' '%r\`\"
} # script_time_message

script_time_func () { # Script process time calculation
	script_end_time=\`date +%s\`
	script_process_time=\$((\${script_end_time} - \${script_start_time}))
	days=\$((\${script_process_time} / 86400))
	hours=\$((\${script_process_time} % 86400 / 3600))
	mins=\$((\${script_process_time} % 3600 / 60))
	secs=\$((\${script_process_time} % 60))
	time_message=(\"PROCESS TIME: \")
	
	if [ \"\${days}\" -gt '0' ]; then 
		time_message+=(\"\${days} day(s) \${hours} hour(s) \${mins} minute(s) \${secs} second(s)\")
	elif [ \"\${hours}\" -gt '0' ]; then
		time_message+=(\"\${hours} hour(s) \${mins} minute(s) \${secs} second(s)\")
	elif [ \"\${mins}\" -gt '0' ]; then
		time_message+=(\"\${mins} minute(s) \${secs} second(s)\")
	else
		time_message+=(\"\${secs} second(s)\")
	fi
	
	script_time_message
	echo \${time_message[@]}
} # script_time_func

exit_message () { # Message before exiting script
	if [ -z \"\${1}\" 2>/dev/null ] || ! [ \"\${1}\" -eq \"\${1}\" 2>/dev/null ]; then
		exit_type='0'
	else
		exit_type=\"\${1}\"
	fi
	
	if [ \"\${exit_type}\" -ne '0' ]; then
		suggest_help='yes'
	fi
	
	for exit_inputs; do
		if [ \"\${exit_inputs}\" == '-nh' 2>/dev/null ]; then
			suggest_help='no'
		elif [ \"\${exit_inputs}\" == '-nt' 2>/dev/null ]; then
			show_time='no'
		elif [ \"\${exit_inputs}\" == '-nm' 2>/dev/null ]; then
			display_exit='no'
		fi
	done
	
	wait # Waits for background processes to finish before exiting

	# Suggest help message
	if [ \"\${suggest_help}\" == 'yes' 2>/dev/null ]; then
		echo \"\${ora}TO DISPLAY HELP MESSAGE TYPE: \${gre}\${script_path} -h\${whi}\"
	fi
	
	# Display exit message
	if ! [ \"\${display_exit}\" == 'no' 2>/dev/null ]; then # Exit message
		echo \"\${pur}EXITING SCRIPT:\${ora} \${script_path}\${whi}\"
	fi
	
	# Display script process time
	if [ \"\${show_time}\" == 'yes' 2>/dev/null ]; then # Script time message
		script_time_func 2>/dev/null
	fi
	
	printf \"\${formatreset}\\n\"
	exit \"\${exit_type}\"
} # exit_message

#---------------------------------- CODE -----------------------------------#
script_path=\$(mac_readlink \"\${script_path}\") # equivalent to 'readlink -f' in linux

for inputs; do # Reads through all inputs
	option_eval \"\${inputs}\"
done

if ! [ \"\${clear_screen}\" == 'no' 2>/dev/null ]; then
	clear     # Clears screen unless activation of input option: '-cs'
fi

color_formats # Activates or inhibits colorful output

# Display help message or open file
if [ \"\${activate_help}\" == 'yes' ]; then # '-h' or '--help'
	script_usage
elif [ \${open_script} == 'yes' ]; then   # '-o' or '--open'
	open_text_editor \"\${script_path}\" \${text_editors[@]}
	exit_message 0 -nm -nt
fi

# Exit script if invalid inputs found
if [ \"\${#bad_inputs[@]}\" -gt '0' ]; then
	re_enter_input_message \${bad_inputs[@]}
	exit_message 1
fi

exit_message 0"
} # create_script4

create_script5 () { # Includes exit message, bg functions, vital_command and vital_file
echo "#!/bin/bash
#--------------------------------------------------------------------------------------#
# Created: ${todays_date} By: ${script_author} (${contact_info})
# Revised: ${todays_date} By: ${script_author}
#--------------------------------------------------------------------------------------#
#
#-------------------------------- VARIABLES --------------------------------#

#--------------------------- DEFAULT SETTINGS ------------------------------#
max_bg_jobs='10' # '10': Max number of background processes
text_editors=('kwrite' 'gedit' 'open -a /Applications/TextWrangler.app' 'open' 'nano' 'emacs') # text editor commands in order of preference

#----------------------- GENERAL SCRIPT VARIABLES --------------------------#
script_start_date_time=\`date +%x' '%r\` # (e.g. 01/01/2015 12:00:00 AM)
script_path=\"\${BASH_SOURCE[0]}\"        # Script path (becomes absolute path later)
version_number='1.0' # Script version number

	###--- 'yes' or 'no' options (inputs do the opposite of default) ---###
activate_colors='yes' # 'yes': Display messages in color [INPUT: '-nc']
activate_help='no'    # 'no' : Display help message      [INPUT: '-h' or '--help']
clear_screen='yes'    # 'yes': Clear screen at start     [INPUT: '-cs']
display_exit='yes'    # 'yes': Display an exit message   [INPUT: '-nm']
open_script='no'      # 'no' : Open this script          [INPUT: '-o' or '--open']
suggest_help='no'     # 'no' : Suggest help (within script option: '-nh')

#-------------------------------- FUNCTIONS --------------------------------#
control_bg_jobs () { # Controls number of background processes
	job_count=\`jobs -p |wc -l\` # Get number of running jobs
	if [ \"\${job_count}\" -ge \"\${max_bg_jobs}\" ]; then
		sleep 0.25
		control_bg_jobs
	fi
} # control_bg_jobs

option_eval () { # Evaluate inputs
	if [ \"\${1}\" == '-cs' 2>/dev/null ] || [ \"\${1}\" == '-h' 2>/dev/null ] || \\
	[ \"\${1}\" == '--help' 2>/dev/null ] || [ \"\${1}\" == '-nc' 2>/dev/null ] || \\
	[ \"\${1}\" == '-nm' 2>/dev/null ] || [ \"\${1}\" == '-o' 2>/dev/null ] || \\
	[ \"\${1}\" == '--open' 2>/dev/null ]; then
		activate_options \"\${1}\"
	elif [ \"\${1:0:1}\" == '-' 2>/dev/null ]; then
		bad_inputs+=(\"\${1}\")
	else
		echo \"\${1}\"
		bad_inputs+=(\"\${1}\")
	fi
} # option_eval

activate_options () { # Activate input options
	if [ \"\${1}\" == '-cs' ]; then
		clear_screen='no'    # Do NOT clear screen at start
	elif [ \"\${1}\" == '-h' ] || [ \"\${1}\" == '--help' ]; then
		activate_help='yes'  # Display help message
	elif [ \"\${1}\" == '-nc' ]; then
		activate_colors='no' # Do NOT display messages in color
	elif [ \"\${1}\" == '-nm' ]; then
		display_exit='no'    # Do NOT display exit message
	elif [ \"\${1}\" == '-o' ] || [ \"\${1}\" == '--open' ]; then
		open_script='yes'    # Open this script
	else # if option is not defined here (for debugging)
		bad_inputs+=(\"ERROR:activate_options:\${1}\")
	fi
} # activate_options

color_formats () { # Print colorful terminal text
	if [ \"\${activate_colors}\" == 'yes' 2>/dev/null ]; then
		whi=\`tput setab 0; tput setaf 7\` # Black background, white text
		red=\`tput setab 0; tput setaf 1\` # Black background, red text
		ora=\`tput setab 0; tput setaf 3\` # Black background, orange text
		gre=\`tput setab 0; tput setaf 2\` # Black background, green text
		blu=\`tput setab 0; tput setaf 4\` # Black background, blue text
		pur=\`tput setab 0; tput setaf 5\` # Black background, purple text
		formatreset=\`tput sgr0\`          # Reset to default terminal settings
	fi
} # color_formats

mac_readlink () { # Get absolute path of a file
	input_path=\"\${1}\"
	cwd=\"\$(pwd)\" # Current working directory path

	if [ -e \"\${input_path}\" ]; then # if file or directory exists
		cd \"\$(dirname \${input_path})\"
		abs_path=\"\$(pwd)/\$(basename \${input_path})\"
		cd \"\${cwd}\" # Change directory back to original directory
	fi

	if [ -e \"\${abs_path}\" ] && ! [ -z \"\${abs_path}\" ]; then
		echo \"\${abs_path}\"
	else # Invalid input or script error
		echo \"\${input_path}\" # echo original input
	fi
} # mac_readlink

open_text_editor () { # Opens input file
	file_to_open=\"\${1}\"
	valid_text_editor='no'
	
	if [ -f \"\${file_to_open}\" ]; then
		for i in \${!text_editors[@]}; do # Loop through indices
			\${text_editors[i]} \"\${file_to_open}\" 2>/dev/null &
			pid=\"\$!\" # Background process ID
			check_text_pid=(\`ps \"\${pid}\" |grep \"\${pid}\"\`) # Check if pid is running
			
			if [ \"\${#check_text_pid[@]}\" -gt '0' ] && [ \"\${check_text_pid[0]}\" == \"\${pid}\" 2>/dev/null ]; then
				valid_text_editor='yes'
				break
			fi
		done

		if [ \"\${valid_text_editor}\" == 'no' 2>/dev/null ]; then
			echo \"\${red}NO VALID TEXT EDITORS: \${ora}\${text_editors[@]}\${whi}\"
			exit_message 99 -nh -nm
		fi
	else
		echo \"\${red}MISSING FILE: \${ora}\${file_to_open}\${whi}\"
	fi
} # open_text_editor

vital_command () { # exits script if an essential command fails
	command_status=\"\$?\"
	command_line_number=\"\${1}\" # Must input as: vital_command \${LINENO}
	
	if ! [ -z \"\${command_status}\" ] && [ \"\${command_status}\" -ne '0' ]; then
		echo \"\${red}INVALID COMMAND: LINE \${ora}\${command_line_number}\${whi}\"
		exit_message 98 -nh -nm
	fi
} # vital_command

vital_file () { # exits script if an essential file is missing
	for vitals; do
		if ! [ -e \"\${vitals}\" 2>/dev/null ]; then
			bad_files+=(\"\${vitals}\")
		fi
	done
	
	if [ \"\${#bad_files[@]}\" -gt '0' ]; then
		echo \"\${red}MISSING ESSENTIAL FILE(S):\${pur}\"
		printf '%s\\n' \${bad_files[@]}
		exit_message 97 -nh -nm
	fi
} # vital_file

#-------------------------------- MESSAGES ---------------------------------#
script_usage () { # Script explanation
	echo \"\${red}HELP MESSAGE: \${gre}\${script_path}\${whi}
\${ora}DESCRIPTION\${whi}:
     
\${ora}ADVICE\${whi}: Create an alias inside your \${ora}\${HOME}/.bashrc\${whi} file
(e.g. \${gre}alias xx='\${script_path}'\${whi})
     
\${ora}USAGE\${whi}:
 [\${ora}1\${whi}] \${gre}\${script_path}\${whi}
     
\${ora}OPTIONS\${whi}: Can input multiple options in any order
 \${pur}-cs\${whi}  Prevent screen from clearing before script processes
 \${pur}-h\${whi} or \${pur}--help\${whi}  Display this message
 \${pur}-nc\${whi}  Prevent color printing in terminal
 \${pur}-nm\${whi}  Prevent exit message from displaying
 \${pur}-o\${whi} or \${pur}--open\${whi} Open this script
     
\${ora}DEFAULT SETTINGS\${whi}:
 text editors: \${gre}\${text_editors[@]}\${whi}
     
\${ora}VERSION: \${gre}\${version_number}\${whi}
\${red}END OF HELP: \${gre}\${script_path}\${whi}\"
	exit_message 0 -nm
} # script_usage

re_enter_input_message () { # Displays invalid input message
	clear
	echo \"\${red}INVALID INPUT: \${ora}\"
	printf '%s\\n' \${@}
	echo \"\${pur}PLEASE RE-ENTER INPUT\${whi}\"
} # re_enter_input_message

exit_message () { # Message before exiting script
	if [ -z \"\${1}\" 2>/dev/null ] || ! [ \"\${1}\" -eq \"\${1}\" 2>/dev/null ]; then
		exit_type='0'
	else
		exit_type=\"\${1}\"
	fi
	
	if [ \"\${exit_type}\" -ne '0' ]; then
		suggest_help='yes'
	fi
	
	for exit_inputs; do
		if [ \"\${exit_inputs}\" == '-nh' 2>/dev/null ]; then
			suggest_help='no'
		elif [ \"\${exit_inputs}\" == '-nm' 2>/dev/null ]; then
			display_exit='no'
		fi
	done
	
	wait # Waits for background processes to finish before exiting

	# Suggest help message
	if [ \"\${suggest_help}\" == 'yes' 2>/dev/null ]; then
		echo \"\${ora}TO DISPLAY HELP MESSAGE TYPE: \${gre}\${script_path} -h\${whi}\"
	fi
	
	# Display exit message
	if ! [ \"\${display_exit}\" == 'no' 2>/dev/null ]; then # Exit message
		echo \"\${pur}EXITING SCRIPT:\${ora} \${script_path}\${whi}\"
	fi
	
	printf \"\${formatreset}\\n\"
	exit \"\${exit_type}\"
} # exit_message

#---------------------------------- CODE -----------------------------------#
script_path=\$(mac_readlink \"\${script_path}\") # equivalent to 'readlink -f' in linux

for inputs; do # Reads through all inputs
	option_eval \"\${inputs}\"
done

if ! [ \"\${clear_screen}\" == 'no' 2>/dev/null ]; then
	clear     # Clears screen unless activation of input option: '-cs'
fi

color_formats # Activates or inhibits colorful output

# Display help message or open file
if [ \"\${activate_help}\" == 'yes' ]; then # '-h' or '--help'
	script_usage
elif [ \${open_script} == 'yes' ]; then   # '-o' or '--open'
	open_text_editor \"\${script_path}\" \${text_editors[@]}
	exit_message 0 -nm
fi

# Exit script if invalid inputs found
if [ \"\${#bad_inputs[@]}\" -gt '0' ]; then
	re_enter_input_message \${bad_inputs[@]}
	exit_message 1
fi

exit_message 0"
} # create_script5

create_script6 () { # Includes exit message, vital_command and vital_file
echo "#!/bin/bash
#--------------------------------------------------------------------------------------#
# Created: ${todays_date} By: ${script_author} (${contact_info})
# Revised: ${todays_date} By: ${script_author}
#--------------------------------------------------------------------------------------#
#
#-------------------------------- VARIABLES --------------------------------#

#--------------------------- DEFAULT SETTINGS ------------------------------#
text_editors=('kwrite' 'gedit' 'open -a /Applications/TextWrangler.app' 'open' 'nano' 'emacs') # text editor commands in order of preference

#----------------------- GENERAL SCRIPT VARIABLES --------------------------#
script_start_date_time=\`date +%x' '%r\` # (e.g. 01/01/2015 12:00:00 AM)
script_path=\"\${BASH_SOURCE[0]}\"        # Script path (becomes absolute path later)
version_number='1.0' # Script version number

	###--- 'yes' or 'no' options (inputs do the opposite of default) ---###
activate_colors='yes' # 'yes': Display messages in color [INPUT: '-nc']
activate_help='no'    # 'no' : Display help message      [INPUT: '-h' or '--help']
clear_screen='yes'    # 'yes': Clear screen at start     [INPUT: '-cs']
display_exit='yes'    # 'yes': Display an exit message   [INPUT: '-nm']
open_script='no'      # 'no' : Open this script          [INPUT: '-o' or '--open']
suggest_help='no'     # 'no' : Suggest help (within script option: '-nh')

#-------------------------------- FUNCTIONS --------------------------------#
option_eval () { # Evaluate inputs
	if [ \"\${1}\" == '-cs' 2>/dev/null ] || [ \"\${1}\" == '-h' 2>/dev/null ] || \\
	[ \"\${1}\" == '--help' 2>/dev/null ] || [ \"\${1}\" == '-nc' 2>/dev/null ] || \\
	[ \"\${1}\" == '-nm' 2>/dev/null ] || [ \"\${1}\" == '-o' 2>/dev/null ] || \\
	[ \"\${1}\" == '--open' 2>/dev/null ]; then
		activate_options \"\${1}\"
	elif [ \"\${1:0:1}\" == '-' 2>/dev/null ]; then
		bad_inputs+=(\"\${1}\")
	else
		echo \"\${1}\"
		bad_inputs+=(\"\${1}\")
	fi
} # option_eval

activate_options () { # Activate input options
	if [ \"\${1}\" == '-cs' ]; then
		clear_screen='no'    # Do NOT clear screen at start
	elif [ \"\${1}\" == '-h' ] || [ \"\${1}\" == '--help' ]; then
		activate_help='yes'  # Display help message
	elif [ \"\${1}\" == '-nc' ]; then
		activate_colors='no' # Do NOT display messages in color
	elif [ \"\${1}\" == '-nm' ]; then
		display_exit='no'    # Do NOT display exit message
	elif [ \"\${1}\" == '-o' ] || [ \"\${1}\" == '--open' ]; then
		open_script='yes'    # Open this script
	else # if option is not defined here (for debugging)
		bad_inputs+=(\"ERROR:activate_options:\${1}\")
	fi
} # activate_options

color_formats () { # Print colorful terminal text
	if [ \"\${activate_colors}\" == 'yes' 2>/dev/null ]; then
		whi=\`tput setab 0; tput setaf 7\` # Black background, white text
		red=\`tput setab 0; tput setaf 1\` # Black background, red text
		ora=\`tput setab 0; tput setaf 3\` # Black background, orange text
		gre=\`tput setab 0; tput setaf 2\` # Black background, green text
		blu=\`tput setab 0; tput setaf 4\` # Black background, blue text
		pur=\`tput setab 0; tput setaf 5\` # Black background, purple text
		formatreset=\`tput sgr0\`          # Reset to default terminal settings
	fi
} # color_formats

mac_readlink () { # Get absolute path of a file
	input_path=\"\${1}\"
	cwd=\"\$(pwd)\" # Current working directory path

	if [ -e \"\${input_path}\" ]; then # if file or directory exists
		cd \"\$(dirname \${input_path})\"
		abs_path=\"\$(pwd)/\$(basename \${input_path})\"
		cd \"\${cwd}\" # Change directory back to original directory
	fi

	if [ -e \"\${abs_path}\" ] && ! [ -z \"\${abs_path}\" ]; then
		echo \"\${abs_path}\"
	else # Invalid input or script error
		echo \"\${input_path}\" # echo original input
	fi
} # mac_readlink

open_text_editor () { # Opens input file
	file_to_open=\"\${1}\"
	valid_text_editor='no'
	
	if [ -f \"\${file_to_open}\" ]; then
		for i in \${!text_editors[@]}; do # Loop through indices
			\${text_editors[i]} \"\${file_to_open}\" 2>/dev/null &
			pid=\"\$!\" # Background process ID
			check_text_pid=(\`ps \"\${pid}\" |grep \"\${pid}\"\`) # Check if pid is running
			
			if [ \"\${#check_text_pid[@]}\" -gt '0' ] && [ \"\${check_text_pid[0]}\" == \"\${pid}\" 2>/dev/null ]; then
				valid_text_editor='yes'
				break
			fi
		done

		if [ \"\${valid_text_editor}\" == 'no' 2>/dev/null ]; then
			echo \"\${red}NO VALID TEXT EDITORS: \${ora}\${text_editors[@]}\${whi}\"
			exit_message 99 -nh -nm
		fi
	else
		echo \"\${red}MISSING FILE: \${ora}\${file_to_open}\${whi}\"
	fi
} # open_text_editor

vital_command () { # exits script if an essential command fails
	command_status=\"\$?\"
	command_line_number=\"\${1}\" # Must input as: vital_command \${LINENO}
	
	if ! [ -z \"\${command_status}\" ] && [ \"\${command_status}\" -ne '0' ]; then
		echo \"\${red}INVALID COMMAND: LINE \${ora}\${command_line_number}\${whi}\"
		exit_message 98 -nh -nm
	fi
} # vital_command

vital_file () { # exits script if an essential file is missing
	for vitals; do
		if ! [ -e \"\${vitals}\" 2>/dev/null ]; then
			bad_files+=(\"\${vitals}\")
		fi
	done
	
	if [ \"\${#bad_files[@]}\" -gt '0' ]; then
		echo \"\${red}MISSING ESSENTIAL FILE(S):\${pur}\"
		printf '%s\\n' \${bad_files[@]}
		exit_message 97 -nh -nm
	fi
} # vital_file

#-------------------------------- MESSAGES ---------------------------------#
script_usage () { # Script explanation
	echo \"\${red}HELP MESSAGE: \${gre}\${script_path}\${whi}
\${ora}DESCRIPTION\${whi}:
     
\${ora}ADVICE\${whi}: Create an alias inside your \${ora}\${HOME}/.bashrc\${whi} file
(e.g. \${gre}alias xx='\${script_path}'\${whi})
     
\${ora}USAGE\${whi}:
 [\${ora}1\${whi}] \${gre}\${script_path}\${whi}
     
\${ora}OPTIONS\${whi}: Can input multiple options in any order
 \${pur}-cs\${whi}  Prevent screen from clearing before script processes
 \${pur}-h\${whi} or \${pur}--help\${whi}  Display this message
 \${pur}-nc\${whi}  Prevent color printing in terminal
 \${pur}-nm\${whi}  Prevent exit message from displaying
 \${pur}-o\${whi} or \${pur}--open\${whi} Open this script
     
\${ora}DEFAULT SETTINGS\${whi}:
 text editors: \${gre}\${text_editors[@]}\${whi}
     
\${ora}VERSION: \${gre}\${version_number}\${whi}
\${red}END OF HELP: \${gre}\${script_path}\${whi}\"
	exit_message 0 -nm
} # script_usage

re_enter_input_message () { # Displays invalid input message
	clear
	echo \"\${red}INVALID INPUT: \${ora}\"
	printf '%s\\n' \${@}
	echo \"\${pur}PLEASE RE-ENTER INPUT\${whi}\"
} # re_enter_input_message

exit_message () { # Message before exiting script
	if [ -z \"\${1}\" 2>/dev/null ] || ! [ \"\${1}\" -eq \"\${1}\" 2>/dev/null ]; then
		exit_type='0'
	else
		exit_type=\"\${1}\"
	fi
	
	if [ \"\${exit_type}\" -ne '0' ]; then
		suggest_help='yes'
	fi
	
	for exit_inputs; do
		if [ \"\${exit_inputs}\" == '-nh' 2>/dev/null ]; then
			suggest_help='no'
		elif [ \"\${exit_inputs}\" == '-nm' 2>/dev/null ]; then
			display_exit='no'
		fi
	done
	
	wait # Waits for background processes to finish before exiting

	# Suggest help message
	if [ \"\${suggest_help}\" == 'yes' 2>/dev/null ]; then
		echo \"\${ora}TO DISPLAY HELP MESSAGE TYPE: \${gre}\${script_path} -h\${whi}\"
	fi
	
	# Display exit message
	if ! [ \"\${display_exit}\" == 'no' 2>/dev/null ]; then # Exit message
		echo \"\${pur}EXITING SCRIPT:\${ora} \${script_path}\${whi}\"
	fi
	
	printf \"\${formatreset}\\n\"
	exit \"\${exit_type}\"
} # exit_message

#---------------------------------- CODE -----------------------------------#
script_path=\$(mac_readlink \"\${script_path}\") # equivalent to 'readlink -f' in linux

for inputs; do # Reads through all inputs
	option_eval \"\${inputs}\"
done

if ! [ \"\${clear_screen}\" == 'no' 2>/dev/null ]; then
	clear     # Clears screen unless activation of input option: '-cs'
fi

color_formats # Activates or inhibits colorful output

# Display help message or open file
if [ \"\${activate_help}\" == 'yes' ]; then # '-h' or '--help'
	script_usage
elif [ \${open_script} == 'yes' ]; then   # '-o' or '--open'
	open_text_editor \"\${script_path}\" \${text_editors[@]}
	exit_message 0 -nm
fi

# Exit script if invalid inputs found
if [ \"\${#bad_inputs[@]}\" -gt '0' ]; then
	re_enter_input_message \${bad_inputs[@]}
	exit_message 1
fi

exit_message 0"
} # create_script6

create_script7 () { # Includes exit message and bg functions
echo "#!/bin/bash
#--------------------------------------------------------------------------------------#
# Created: ${todays_date} By: ${script_author} (${contact_info})
# Revised: ${todays_date} By: ${script_author}
#--------------------------------------------------------------------------------------#
#
#-------------------------------- VARIABLES --------------------------------#

#--------------------------- DEFAULT SETTINGS ------------------------------#
max_bg_jobs='10' # '10': Max number of background processes
text_editors=('kwrite' 'gedit' 'open -a /Applications/TextWrangler.app' 'open' 'nano' 'emacs') # text editor commands in order of preference

#----------------------- GENERAL SCRIPT VARIABLES --------------------------#
script_start_date_time=\`date +%x' '%r\` # (e.g. 01/01/2015 12:00:00 AM)
script_path=\"\${BASH_SOURCE[0]}\"        # Script path (becomes absolute path later)
version_number='1.0' # Script version number

	###--- 'yes' or 'no' options (inputs do the opposite of default) ---###
activate_colors='yes' # 'yes': Display messages in color [INPUT: '-nc']
activate_help='no'    # 'no' : Display help message      [INPUT: '-h' or '--help']
clear_screen='yes'    # 'yes': Clear screen at start     [INPUT: '-cs']
display_exit='yes'    # 'yes': Display an exit message   [INPUT: '-nm']
open_script='no'      # 'no' : Open this script          [INPUT: '-o' or '--open']
suggest_help='no'     # 'no' : Suggest help (within script option: '-nh')

#-------------------------------- FUNCTIONS --------------------------------#
control_bg_jobs () { # Controls number of background processes
	job_count=\`jobs -p |wc -l\` # Get number of running jobs
	if [ \"\${job_count}\" -ge \"\${max_bg_jobs}\" ]; then
		sleep 0.25
		control_bg_jobs
	fi
} # control_bg_jobs

option_eval () { # Evaluate inputs
	if [ \"\${1}\" == '-cs' 2>/dev/null ] || [ \"\${1}\" == '-h' 2>/dev/null ] || \\
	[ \"\${1}\" == '--help' 2>/dev/null ] || [ \"\${1}\" == '-nc' 2>/dev/null ] || \\
	[ \"\${1}\" == '-nm' 2>/dev/null ] || [ \"\${1}\" == '-o' 2>/dev/null ] || \\
	[ \"\${1}\" == '--open' 2>/dev/null ]; then
		activate_options \"\${1}\"
	elif [ \"\${1:0:1}\" == '-' 2>/dev/null ]; then
		bad_inputs+=(\"\${1}\")
	else
		echo \"\${1}\"
		bad_inputs+=(\"\${1}\")
	fi
} # option_eval

activate_options () { # Activate input options
	if [ \"\${1}\" == '-cs' ]; then
		clear_screen='no'    # Do NOT clear screen at start
	elif [ \"\${1}\" == '-h' ] || [ \"\${1}\" == '--help' ]; then
		activate_help='yes'  # Display help message
	elif [ \"\${1}\" == '-nc' ]; then
		activate_colors='no' # Do NOT display messages in color
	elif [ \"\${1}\" == '-nm' ]; then
		display_exit='no'    # Do NOT display exit message
	elif [ \"\${1}\" == '-o' ] || [ \"\${1}\" == '--open' ]; then
		open_script='yes'    # Open this script
	else # if option is not defined here (for debugging)
		bad_inputs+=(\"ERROR:activate_options:\${1}\")
	fi
} # activate_options

color_formats () { # Print colorful terminal text
	if [ \"\${activate_colors}\" == 'yes' 2>/dev/null ]; then
		whi=\`tput setab 0; tput setaf 7\` # Black background, white text
		red=\`tput setab 0; tput setaf 1\` # Black background, red text
		ora=\`tput setab 0; tput setaf 3\` # Black background, orange text
		gre=\`tput setab 0; tput setaf 2\` # Black background, green text
		blu=\`tput setab 0; tput setaf 4\` # Black background, blue text
		pur=\`tput setab 0; tput setaf 5\` # Black background, purple text
		formatreset=\`tput sgr0\`          # Reset to default terminal settings
	fi
} # color_formats

mac_readlink () { # Get absolute path of a file
	input_path=\"\${1}\"
	cwd=\"\$(pwd)\" # Current working directory path

	if [ -e \"\${input_path}\" ]; then # if file or directory exists
		cd \"\$(dirname \${input_path})\"
		abs_path=\"\$(pwd)/\$(basename \${input_path})\"
		cd \"\${cwd}\" # Change directory back to original directory
	fi

	if [ -e \"\${abs_path}\" ] && ! [ -z \"\${abs_path}\" ]; then
		echo \"\${abs_path}\"
	else # Invalid input or script error
		echo \"\${input_path}\" # echo original input
	fi
} # mac_readlink

open_text_editor () { # Opens input file
	file_to_open=\"\${1}\"
	valid_text_editor='no'
	
	if [ -f \"\${file_to_open}\" ]; then
		for i in \${!text_editors[@]}; do # Loop through indices
			\${text_editors[i]} \"\${file_to_open}\" 2>/dev/null &
			pid=\"\$!\" # Background process ID
			check_text_pid=(\`ps \"\${pid}\" |grep \"\${pid}\"\`) # Check if pid is running
			
			if [ \"\${#check_text_pid[@]}\" -gt '0' ] && [ \"\${check_text_pid[0]}\" == \"\${pid}\" 2>/dev/null ]; then
				valid_text_editor='yes'
				break
			fi
		done

		if [ \"\${valid_text_editor}\" == 'no' 2>/dev/null ]; then
			echo \"\${red}NO VALID TEXT EDITORS: \${ora}\${text_editors[@]}\${whi}\"
			exit_message 99 -nh -nm
		fi
	else
		echo \"\${red}MISSING FILE: \${ora}\${file_to_open}\${whi}\"
	fi
} # open_text_editor

#-------------------------------- MESSAGES ---------------------------------#
script_usage () { # Script explanation
	echo \"\${red}HELP MESSAGE: \${gre}\${script_path}\${whi}
\${ora}DESCRIPTION\${whi}:
     
\${ora}ADVICE\${whi}: Create an alias inside your \${ora}\${HOME}/.bashrc\${whi} file
(e.g. \${gre}alias xx='\${script_path}'\${whi})
     
\${ora}USAGE\${whi}:
 [\${ora}1\${whi}] \${gre}\${script_path}\${whi}
     
\${ora}OPTIONS\${whi}: Can input multiple options in any order
 \${pur}-cs\${whi}  Prevent screen from clearing before script processes
 \${pur}-h\${whi} or \${pur}--help\${whi}  Display this message
 \${pur}-nc\${whi}  Prevent color printing in terminal
 \${pur}-nm\${whi}  Prevent exit message from displaying
 \${pur}-o\${whi} or \${pur}--open\${whi} Open this script
     
\${ora}DEFAULT SETTINGS\${whi}:
 text editors: \${gre}\${text_editors[@]}\${whi}
     
\${ora}VERSION: \${gre}\${version_number}\${whi}
\${red}END OF HELP: \${gre}\${script_path}\${whi}\"
	exit_message 0 -nm
} # script_usage

re_enter_input_message () { # Displays invalid input message
	clear
	echo \"\${red}INVALID INPUT: \${ora}\"
	printf '%s\\n' \${@}
	echo \"\${pur}PLEASE RE-ENTER INPUT\${whi}\"
} # re_enter_input_message

exit_message () { # Message before exiting script
	if [ -z \"\${1}\" 2>/dev/null ] || ! [ \"\${1}\" -eq \"\${1}\" 2>/dev/null ]; then
		exit_type='0'
	else
		exit_type=\"\${1}\"
	fi
	
	if [ \"\${exit_type}\" -ne '0' ]; then
		suggest_help='yes'
	fi
	
	for exit_inputs; do
		if [ \"\${exit_inputs}\" == '-nh' 2>/dev/null ]; then
			suggest_help='no'
		elif [ \"\${exit_inputs}\" == '-nm' 2>/dev/null ]; then
			display_exit='no'
		fi
	done
	
	wait # Waits for background processes to finish before exiting

	# Suggest help message
	if [ \"\${suggest_help}\" == 'yes' 2>/dev/null ]; then
		echo \"\${ora}TO DISPLAY HELP MESSAGE TYPE: \${gre}\${script_path} -h\${whi}\"
	fi
	
	# Display exit message
	if ! [ \"\${display_exit}\" == 'no' 2>/dev/null ]; then # Exit message
		echo \"\${pur}EXITING SCRIPT:\${ora} \${script_path}\${whi}\"
	fi
	
	printf \"\${formatreset}\\n\"
	exit \"\${exit_type}\"
} # exit_message

#---------------------------------- CODE -----------------------------------#
script_path=\$(mac_readlink \"\${script_path}\") # equivalent to 'readlink -f' in linux

for inputs; do # Reads through all inputs
	option_eval \"\${inputs}\"
done

if ! [ \"\${clear_screen}\" == 'no' 2>/dev/null ]; then
	clear     # Clears screen unless activation of input option: '-cs'
fi

color_formats # Activates or inhibits colorful output

# Display help message or open file
if [ \"\${activate_help}\" == 'yes' ]; then # '-h' or '--help'
	script_usage
elif [ \${open_script} == 'yes' ]; then   # '-o' or '--open'
	open_text_editor \"\${script_path}\" \${text_editors[@]}
	exit_message 0 -nm
fi

# Exit script if invalid inputs found
if [ \"\${#bad_inputs[@]}\" -gt '0' ]; then
	re_enter_input_message \${bad_inputs[@]}
	exit_message 1
fi

exit_message 0"
} # create_script7

create_script8 () { # Includes exit message
echo "#!/bin/bash
#--------------------------------------------------------------------------------------#
# Created: ${todays_date} By: ${script_author} (${contact_info})
# Revised: ${todays_date} By: ${script_author}
#--------------------------------------------------------------------------------------#
#
#-------------------------------- VARIABLES --------------------------------#

#--------------------------- DEFAULT SETTINGS ------------------------------#
text_editors=('kwrite' 'gedit' 'open -a /Applications/TextWrangler.app' 'open' 'nano' 'emacs') # text editor commands in order of preference

#----------------------- GENERAL SCRIPT VARIABLES --------------------------#
script_start_date_time=\`date +%x' '%r\` # (e.g. 01/01/2015 12:00:00 AM)
script_path=\"\${BASH_SOURCE[0]}\"        # Script path (becomes absolute path later)
version_number='1.0' # Script version number

	###--- 'yes' or 'no' options (inputs do the opposite of default) ---###
activate_colors='yes' # 'yes': Display messages in color [INPUT: '-nc']
activate_help='no'    # 'no' : Display help message      [INPUT: '-h' or '--help']
clear_screen='yes'    # 'yes': Clear screen at start     [INPUT: '-cs']
display_exit='yes'    # 'yes': Display an exit message   [INPUT: '-nm']
open_script='no'      # 'no' : Open this script          [INPUT: '-o' or '--open']
suggest_help='no'     # 'no' : Suggest help (within script option: '-nh')

#-------------------------------- FUNCTIONS --------------------------------#
option_eval () { # Evaluate inputs
	if [ \"\${1}\" == '-cs' 2>/dev/null ] || [ \"\${1}\" == '-h' 2>/dev/null ] || \\
	[ \"\${1}\" == '--help' 2>/dev/null ] || [ \"\${1}\" == '-nc' 2>/dev/null ] || \\
	[ \"\${1}\" == '-nm' 2>/dev/null ] || [ \"\${1}\" == '-o' 2>/dev/null ] || \\
	[ \"\${1}\" == '--open' 2>/dev/null ]; then
		activate_options \"\${1}\"
	elif [ \"\${1:0:1}\" == '-' 2>/dev/null ]; then
		bad_inputs+=(\"\${1}\")
	else
		echo \"\${1}\"
		bad_inputs+=(\"\${1}\")
	fi
} # option_eval

activate_options () { # Activate input options
	if [ \"\${1}\" == '-cs' ]; then
		clear_screen='no'    # Do NOT clear screen at start
	elif [ \"\${1}\" == '-h' ] || [ \"\${1}\" == '--help' ]; then
		activate_help='yes'  # Display help message
	elif [ \"\${1}\" == '-nc' ]; then
		activate_colors='no' # Do NOT display messages in color
	elif [ \"\${1}\" == '-nm' ]; then
		display_exit='no'    # Do NOT display exit message
	elif [ \"\${1}\" == '-o' ] || [ \"\${1}\" == '--open' ]; then
		open_script='yes'    # Open this script
	else # if option is not defined here (for debugging)
		bad_inputs+=(\"ERROR:activate_options:\${1}\")
	fi
} # activate_options

color_formats () { # Print colorful terminal text
	if [ \"\${activate_colors}\" == 'yes' 2>/dev/null ]; then
		whi=\`tput setab 0; tput setaf 7\` # Black background, white text
		red=\`tput setab 0; tput setaf 1\` # Black background, red text
		ora=\`tput setab 0; tput setaf 3\` # Black background, orange text
		gre=\`tput setab 0; tput setaf 2\` # Black background, green text
		blu=\`tput setab 0; tput setaf 4\` # Black background, blue text
		pur=\`tput setab 0; tput setaf 5\` # Black background, purple text
		formatreset=\`tput sgr0\`          # Reset to default terminal settings
	fi
} # color_formats

mac_readlink () { # Get absolute path of a file
	input_path=\"\${1}\"
	cwd=\"\$(pwd)\" # Current working directory path

	if [ -e \"\${input_path}\" ]; then # if file or directory exists
		cd \"\$(dirname \${input_path})\"
		abs_path=\"\$(pwd)/\$(basename \${input_path})\"
		cd \"\${cwd}\" # Change directory back to original directory
	fi

	if [ -e \"\${abs_path}\" ] && ! [ -z \"\${abs_path}\" ]; then
		echo \"\${abs_path}\"
	else # Invalid input or script error
		echo \"\${input_path}\" # echo original input
	fi
} # mac_readlink

open_text_editor () { # Opens input file
	file_to_open=\"\${1}\"
	valid_text_editor='no'
	
	if [ -f \"\${file_to_open}\" ]; then
		for i in \${!text_editors[@]}; do # Loop through indices
			\${text_editors[i]} \"\${file_to_open}\" 2>/dev/null &
			pid=\"\$!\" # Background process ID
			check_text_pid=(\`ps \"\${pid}\" |grep \"\${pid}\"\`) # Check if pid is running
			
			if [ \"\${#check_text_pid[@]}\" -gt '0' ] && [ \"\${check_text_pid[0]}\" == \"\${pid}\" 2>/dev/null ]; then
				valid_text_editor='yes'
				break
			fi
		done

		if [ \"\${valid_text_editor}\" == 'no' 2>/dev/null ]; then
			echo \"\${red}NO VALID TEXT EDITORS: \${ora}\${text_editors[@]}\${whi}\"
			exit_message 99 -nh -nm
		fi
	else
		echo \"\${red}MISSING FILE: \${ora}\${file_to_open}\${whi}\"
	fi
} # open_text_editor

#-------------------------------- MESSAGES ---------------------------------#
script_usage () { # Script explanation
	echo \"\${red}HELP MESSAGE: \${gre}\${script_path}\${whi}
\${ora}DESCRIPTION\${whi}:
     
\${ora}ADVICE\${whi}: Create an alias inside your \${ora}\${HOME}/.bashrc\${whi} file
(e.g. \${gre}alias xx='\${script_path}'\${whi})
     
\${ora}USAGE\${whi}:
 [\${ora}1\${whi}] \${gre}\${script_path}\${whi}
     
\${ora}OPTIONS\${whi}: Can input multiple options in any order
 \${pur}-cs\${whi}  Prevent screen from clearing before script processes
 \${pur}-h\${whi} or \${pur}--help\${whi}  Display this message
 \${pur}-nc\${whi}  Prevent color printing in terminal
 \${pur}-nm\${whi}  Prevent exit message from displaying
 \${pur}-o\${whi} or \${pur}--open\${whi} Open this script
     
\${ora}DEFAULT SETTINGS\${whi}:
 text editors: \${gre}\${text_editors[@]}\${whi}
     
\${ora}VERSION: \${gre}\${version_number}\${whi}
\${red}END OF HELP: \${gre}\${script_path}\${whi}\"
	exit_message 0 -nm
} # script_usage

re_enter_input_message () { # Displays invalid input message
	clear
	echo \"\${red}INVALID INPUT: \${ora}\"
	printf '%s\\n' \${@}
	echo \"\${pur}PLEASE RE-ENTER INPUT\${whi}\"
} # re_enter_input_message

exit_message () { # Message before exiting script
	if [ -z \"\${1}\" 2>/dev/null ] || ! [ \"\${1}\" -eq \"\${1}\" 2>/dev/null ]; then
		exit_type='0'
	else
		exit_type=\"\${1}\"
	fi
	
	if [ \"\${exit_type}\" -ne '0' ]; then
		suggest_help='yes'
	fi
	
	for exit_inputs; do
		if [ \"\${exit_inputs}\" == '-nh' 2>/dev/null ]; then
			suggest_help='no'
		elif [ \"\${exit_inputs}\" == '-nm' 2>/dev/null ]; then
			display_exit='no'
		fi
	done
	
	wait # Waits for background processes to finish before exiting

	# Suggest help message
	if [ \"\${suggest_help}\" == 'yes' 2>/dev/null ]; then
		echo \"\${ora}TO DISPLAY HELP MESSAGE TYPE: \${gre}\${script_path} -h\${whi}\"
	fi
	
	# Display exit message
	if ! [ \"\${display_exit}\" == 'no' 2>/dev/null ]; then # Exit message
		echo \"\${pur}EXITING SCRIPT:\${ora} \${script_path}\${whi}\"
	fi
	
	printf \"\${formatreset}\\n\"
	exit \"\${exit_type}\"
} # exit_message

#---------------------------------- CODE -----------------------------------#
script_path=\$(mac_readlink \"\${script_path}\") # equivalent to 'readlink -f' in linux

for inputs; do # Reads through all inputs
	option_eval \"\${inputs}\"
done

if ! [ \"\${clear_screen}\" == 'no' 2>/dev/null ]; then
	clear     # Clears screen unless activation of input option: '-cs'
fi

color_formats # Activates or inhibits colorful output

# Display help message or open file
if [ \"\${activate_help}\" == 'yes' ]; then # '-h' or '--help'
	script_usage
elif [ \${open_script} == 'yes' ]; then   # '-o' or '--open'
	open_text_editor \"\${script_path}\" \${text_editors[@]}
	exit_message 0 -nm
fi

# Exit script if invalid inputs found
if [ \"\${#bad_inputs[@]}\" -gt '0' ]; then
	re_enter_input_message \${bad_inputs[@]}
	exit_message 1
fi

exit_message 0"
} # create_script8

create_script9 () { # Basic functions
echo "#!/bin/bash
#--------------------------------------------------------------------------------------#
# Created: ${todays_date} By: ${script_author} (${contact_info})
# Revised: ${todays_date} By: ${script_author}
#--------------------------------------------------------------------------------------#
#
#-------------------------------- VARIABLES --------------------------------#

#--------------------------- DEFAULT SETTINGS ------------------------------#
text_editors=('kwrite' 'gedit' 'open -a /Applications/TextWrangler.app' 'open' 'nano' 'emacs') # text editor commands in order of preference

#----------------------- GENERAL SCRIPT VARIABLES --------------------------#
script_start_date_time=\`date +%x' '%r\` # (e.g. 01/01/2015 12:00:00 AM)
script_path=\"\${BASH_SOURCE[0]}\"        # Script path (becomes absolute path later)
version_number='1.0' # Script version number

	###--- 'yes' or 'no' options (inputs do the opposite of default) ---###
activate_colors='yes' # 'yes': Display messages in color [INPUT: '-nc']
activate_help='no'    # 'no' : Display help message      [INPUT: '-h' or '--help']
clear_screen='yes'    # 'yes': Clear screen at start     [INPUT: '-cs']
open_script='no'      # 'no' : Open this script          [INPUT: '-o' or '--open']
suggest_help='no'     # 'no' : Suggest help (within script option: '-nh')

#-------------------------------- FUNCTIONS --------------------------------#
option_eval () { # Evaluate inputs
	if [ \"\${1}\" == '-cs' 2>/dev/null ] || [ \"\${1}\" == '-h' 2>/dev/null ] || \\
	[ \"\${1}\" == '--help' 2>/dev/null ] || [ \"\${1}\" == '-nc' 2>/dev/null ] || \\
	[ \"\${1}\" == '-o' 2>/dev/null ] || [ \"\${1}\" == '--open' 2>/dev/null ]; then
		activate_options \"\${1}\"
	elif [ \"\${1:0:1}\" == '-' 2>/dev/null ]; then
		bad_inputs+=(\"\${1}\")
	else
		echo \"\${1}\"
		bad_inputs+=(\"\${1}\")
	fi
} # option_eval

activate_options () { # Activate input options
	if [ \"\${1}\" == '-cs' ]; then
		clear_screen='no'    # Do NOT clear screen at start
	elif [ \"\${1}\" == '-h' ] || [ \"\${1}\" == '--help' ]; then
		activate_help='yes'  # Display help message
	elif [ \"\${1}\" == '-nc' ]; then
		activate_colors='no' # Do NOT display messages in color
	elif [ \"\${1}\" == '-o' ] || [ \"\${1}\" == '--open' ]; then
		open_script='yes'    # Open this script
	else # if option is not defined here (for debugging)
		bad_inputs+=(\"ERROR:activate_options:\${1}\")
	fi
} # activate_options

color_formats () { # Print colorful terminal text
	if [ \"\${activate_colors}\" == 'yes' 2>/dev/null ]; then
		whi=\`tput setab 0; tput setaf 7\` # Black background, white text
		red=\`tput setab 0; tput setaf 1\` # Black background, red text
		ora=\`tput setab 0; tput setaf 3\` # Black background, orange text
		gre=\`tput setab 0; tput setaf 2\` # Black background, green text
		blu=\`tput setab 0; tput setaf 4\` # Black background, blue text
		pur=\`tput setab 0; tput setaf 5\` # Black background, purple text
		formatreset=\`tput sgr0\`          # Reset to default terminal settings
	fi
} # color_formats

mac_readlink () { # Get absolute path of a file
	input_path=\"\${1}\"
	cwd=\"\$(pwd)\" # Current working directory path

	if [ -e \"\${input_path}\" ]; then # if file or directory exists
		cd \"\$(dirname \${input_path})\"
		abs_path=\"\$(pwd)/\$(basename \${input_path})\"
		cd \"\${cwd}\" # Change directory back to original directory
	fi

	if [ -e \"\${abs_path}\" ] && ! [ -z \"\${abs_path}\" ]; then
		echo \"\${abs_path}\"
	else # Invalid input or script error
		echo \"\${input_path}\" # echo original input
	fi
} # mac_readlink

open_text_editor () { # Opens input file
	file_to_open=\"\${1}\"
	valid_text_editor='no'
	
	if [ -f \"\${file_to_open}\" ]; then
		for i in \${!text_editors[@]}; do # Loop through indices
			\${text_editors[i]} \"\${file_to_open}\" 2>/dev/null &
			pid=\"\$!\" # Background process ID
			check_text_pid=(\`ps \"\${pid}\" |grep \"\${pid}\"\`) # Check if pid is running
			
			if [ \"\${#check_text_pid[@]}\" -gt '0' ] && [ \"\${check_text_pid[0]}\" == \"\${pid}\" 2>/dev/null ]; then
				valid_text_editor='yes'
				break
			fi
		done

		if [ \"\${valid_text_editor}\" == 'no' 2>/dev/null ]; then
			echo \"\${red}NO VALID TEXT EDITORS: \${ora}\${text_editors[@]}\${whi}\"
			exit_message 99 -nh
		fi
	else
		echo \"\${red}MISSING FILE: \${ora}\${file_to_open}\${whi}\"
	fi
} # open_text_editor

#-------------------------------- MESSAGES ---------------------------------#
script_usage () { # Script explanation
	echo \"\${red}HELP MESSAGE: \${gre}\${script_path}\${whi}
\${ora}DESCRIPTION\${whi}:
     
\${ora}USAGE\${whi}:
 [\${ora}1\${whi}] \${gre}\${script_path}\${whi}
     
\${ora}OPTIONS\${whi}: Can input multiple options in any order
 \${pur}-cs\${whi}  Prevent screen from clearing before script processes
 \${pur}-h\${whi} or \${pur}--help\${whi}  Display this message
 \${pur}-nc\${whi}  Prevent color printing in terminal
 \${pur}-o\${whi} or \${pur}--open\${whi} Open this script
     
\${ora}DEFAULT SETTINGS\${whi}:
 text editors: \${gre}\${text_editors[@]}\${whi}
     
\${ora}VERSION: \${gre}\${version_number}\${whi}
\${red}END OF HELP: \${gre}\${script_path}\${whi}\"
	exit_message 0
} # script_usage

re_enter_input_message () { # Displays invalid input message
	clear
	echo \"\${red}INVALID INPUT: \${ora}\"
	printf '%s\\n' \${@}
	echo \"\${pur}PLEASE RE-ENTER INPUT\${whi}\"
} # re_enter_input_message

exit_message () { # Message before exiting script
	if [ -z \"\${1}\" 2>/dev/null ] || ! [ \"\${1}\" -eq \"\${1}\" 2>/dev/null ]; then
		exit_type='0'
	else
		exit_type=\"\${1}\"
	fi
	
	if [ \"\${exit_type}\" -ne '0' ]; then
		suggest_help='yes'
	fi
	
	for exit_inputs; do
		if [ \"\${exit_inputs}\" == '-nh' 2>/dev/null ]; then
			suggest_help='no'
		fi
	done

	# Suggest help message
	if [ \"\${suggest_help}\" == 'yes' 2>/dev/null ]; then
		echo \"\${ora}TO DISPLAY HELP MESSAGE TYPE: \${gre}\${script_path} -h\${whi}\"
	fi
	
	printf \"\${formatreset}\\n\"
	exit \"\${exit_type}\"
} # exit_message

#---------------------------------- CODE -----------------------------------#
script_path=\$(mac_readlink \"\${script_path}\") # equivalent to 'readlink -f' in linux

for inputs; do # Reads through all inputs
	option_eval \"\${inputs}\"
done

if ! [ \"\${clear_screen}\" == 'no' 2>/dev/null ]; then
	clear     # Clears screen unless activation of input option: '-cs'
fi

color_formats # Activates or inhibits colorful output

# Display help message or open file
if [ \"\${activate_help}\" == 'yes' ]; then # '-h' or '--help'
	script_usage
elif [ \${open_script} == 'yes' ]; then   # '-o' or '--open'
	open_text_editor \"\${script_path}\" \${text_editors[@]}
	exit_message 0
fi

# Exit script if invalid inputs found
if [ \"\${#bad_inputs[@]}\" -gt '0' ]; then
	re_enter_input_message \${bad_inputs[@]}
	exit_message 1
fi

exit_message 0"
} # create_script9

create_script10 () { # Header information only
echo "#!/bin/bash
#--------------------------------------------------------------------------------------#
# Created: ${todays_date} By: ${script_author} (${contact_info})
# Revised: ${todays_date} By: ${script_author}
#--------------------------------------------------------------------------------------#
#
#-------------------------------- VARIABLES --------------------------------#

#---------------------------------- CODE -----------------------------------#"
} # create_script10

option_eval () { # Evaluates command line options
	check_permission=($(echo "${1}" |grep '[0-7][0-7][0-7]'))
	
	if [ ${1} == '-h' 2>/dev/null ] || [ ${1} == '--help' 2>/dev/null ] || \
	[ ${1} == '-i' 2>/dev/null ] || [ ${1} == '-l' 2>/dev/null ] || \
	[ ${1} == '-n' 2>/dev/null ] || [ ${1} == '-nc' 2>/dev/null ] || \
	[ ${1} == '-nl' 2>/dev/null ] || [ ${1} == '-o' 2>/dev/null ] || \
	[ ${1} == '--open' 2>/dev/null ] || [ ${1} == '-p' 2>/dev/null ]; then
		activate_options "${1}"
	elif ! [ -z "${n_in}" 2>/dev/null ] && [ "${n_in}" == 'yes' 2>/dev/null ]; then
		if [ "${1}" -eq "${1}" 2>/dev/null ] && [ "${1}" -gt '0' 2>/dev/null ] \
		&& [ -z "${n_script}" 2>/dev/null ]; then
			n_script="${1}"
		else
			bad_inputs+=("-n:${1}")
		fi
		n_in='no'
	elif ! [ -z "${p_in}" 2>/dev/null ] && [ "${p_in}" == 'yes' 2>/dev/null ]; then
		if [ "${#check_permission[@]}" -eq '1' ] && [ "${#check_permission[0]}" -eq '3' ]; then
			permission_value="${1}"
		else
			bad_inputs+=("-p:${1}")
		fi
	elif [ "${1:0:1}" == '-' 2>/dev/null ]; then
		bad_inputs+=("${1}")
	else
		if ! [ "${filename_reader}" == 'off' 2>/dev/null ]; then
			filename="${1}"
			filename_reader='off'
		else
			bad_inputs+=("${1}")
		fi
	fi
} # option_eval

activate_options () { # Activate input options
	n_in='no'  # Do NOT read in 'n' numbers
	p_in='no'  # Do NOT read in new 'p' default
	
	if [ "${1}" == '-h' ] || [ "${1}" == '--help' ]; then
		activate_help='yes'   # Display help message
	elif [ "${1}" == '-i' ]; then
		open_file='no'        # List user settings
	elif [ "${1}" == '-l' ]; then
		list_settings='yes'   # List user settings
	elif [ "${1}" == '-n' ]; then
		n_in='yes'            # Which script number to create
	elif [ "${1}" == '-nc' ]; then
		activate_colors='no'  # Do not display in color
	elif [ "${1}" == '-nl' ]; then
		display_scripts='yes' # List script explanations
	elif [ "${1}" == '-o' ] || [ "${1}" == '--open' ]; then
		open_script='yes'     # Open this script
	elif [ "${1}" == '-p' ]; then
		p_in='yes'            # Input permission value
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

create_script () { # Creates, activates and opens new shell script
	${script_function} > "${filename}" || error_script_create "${filename}"
	chmod "${permission_value}" "${filename}" # Automatically activates script
	echo "${gre}CREATED: ${ora}${file_path}${whi}"
			
	if [ "${open_file}" == 'yes' 2>/dev/null ]; then
		open_text_editor "${filename}" # open new script
	fi
} # create_script

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

prompt_user_input () { # Prompt user to input filename
	printf "${ora}INPUT FILENAME (e.g. ${gre}example.sh${ora}):${whi}"
	read -r filename
	
	if [ "${#filename}" -eq '0' ]; then
		clear
		prompt_user_input
	fi
} # prompt_user_input

read_filename () { # Check if file exists
	file_path="$(pwd)/${filename}"
	
	if [ -f "${file_path}" ]; then # Checks if file already exists
		echo "${red}FILE EXISTS: ${gre}${file_path}${whi}"
		printf "${ora}OVERWRITE? [${red}y${ora}/${red}n${ora}]:${whi}"
		read -r overwrite_file # User input to overwrite existing file
		overwrite_file=$(echo ${overwrite_file} |tr '[:upper:]' '[:lower:]') # lowercase
		
		if [ "${overwrite_file}" == 'y' 2>/dev/null ] || [ "${overwrite_file}" == 'yes' 2>/dev/null ]; then
			create_script
		elif [ "${overwrite_file}" == 'n' 2>/dev/null ] || [ "${overwrite_file}" == 'no' 2>/dev/null ]; then
			prompt_user_input
			read_filename
		elif [ "${overwrite_file}" == 'q' 2>/dev/null ] || [ ${overwrite_file} == 'quit' 2>/dev/null ]; then
			exit_message 0
		else
			clear
			re_enter_input_message "${overwrite_file}"
			echo "${ora}QUIT [${red}q${ora}]${whi}"
			read_filename
		fi
	else
		create_script
	fi
} # read_filename

#-------------------------------- MESSAGES ---------------------------------#
script_usage () { # Script explanation
	echo "${red}HELP MESSAGE: ${gre}${script_path}${whi}
${ora}DESCRIPTION${whi}: Create script in working directory
     
${ora}ADVICE${whi}: Create an alias inside your ${ora}${HOME}/.bashrc${whi} file
(e.g. ${gre}alias cs='${script_path}'${whi})
     
${ora}USAGE${whi}: Input filename of new script
  [${ora}1${whi}] ${gre}cs${ora} examplefile1.sh${whi}
  
${ora}OPTIONS${whi}: Can input multiple options in any order
 ${pur}-h${whi} or ${pur}--help${whi}  Display this message
 ${pur}-i${whi}   Do ${red}NOT${whi} open script file after it is created
 ${pur}-l${whi}   List default settings
 ${pur}-n${whi}   Which '${gre}create_script${whi}' function to use (${ora}default: ${gre}${default_script_number}${whi})
  [${ora}2${whi}] ${gre}cs ${pur}-n ${ora}5${whi}
 ${pur}-nc${whi}  Prevent color printing in terminal
 ${pur}-nl${whi}  List comments for each '${gre}create_script${whi}' function
 ${pur}-o${whi} or  ${pur}--open${whi}  Open this script
 ${pur}-p${whi}   Input permission value (${ora}default: ${gre}${permission_value}${whi})
  [${ora}3${whi}] ${gre}cs ${pur}-p ${ora}744${whi}
     
${ora}DEFAULT SETTINGS${whi}:
 Script types: ${gre}`grep -c '^create_script[0-9]' ${script_path}`${whi}
 Text editors: ${gre}${text_editors[@]}${whi}
 Script file permission: ${gre}${permission_value}${whi}
${ora}VERSION: ${gre}${version_number}${whi}
${red}END OF HELP: ${gre}${script_path}${whi}"

exit_message 0
} # script_usage

error_script_create () { # Error message if script could not be created
echo "${red}COULD NOT CREATE: ${ora}${1}${whi}"
exit_message 98
} # error_script_create

list_user_settings () { # '-l' option
	echo "${pur}+---USER SETTINGS---+${ora}"
	echo "${gre}Permission value: ${ora}${permission_value}${whi}"
	echo "${gre}Text editors: ${ora}${text_editors[@]}${whi}"
	exit_message 0
} # list_user_settings

script_display () { # '-nl' option
	script_count=(`grep '^create_script[0-9]' "${script_path}" |grep '() {' |awk '{print $1}' |sed 's@create_script@@g'`)
	creation_scripts=(`grep '^create_script[0-9]' "${script_path}" |grep '() {' |sed 's@ @+-+@g' |awk -F '#' '{print $2}'`)
	
	for i_count in ${!script_count[@]}; do
		echo "${whi}[${ora}${script_count[${i_count}]}${whi}]${gre}$(echo ${creation_scripts[${i_count}]} |sed 's@+-+@ @g')${whi}"
	done
	exit_message 0
} # script_display

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
	
	# Suggest help message
	if [ "${exit_type}" -ne '0' 2>/dev/null ]; then
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

clear

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
fi

if [ -z "${n_script}" 2>/dev/null ]; then
	n_script="${default_script_number}" # Create default template
fi

if [ "${list_settings}" == 'yes' 2>/dev/null ]; then     # '-l'
	list_user_settings
elif [ "${display_scripts}" == 'yes' 2>/dev/null ]; then # '-nl'
	script_display
else # Check existence of 'create_script' function
	script_function="create_script${n_script}"
	check_create=(`type -t ${script_function}`)
	
	if ! [ "${check_create[0]}" == 'function' 2>/dev/null ]; then
		echo "${red}FUNCTION DOES NOT EXIST: ${ora}${script_function}${whi}"
		exit_message 2
	fi
fi

if [ -z "${filename}" ]; then
	prompt_user_input
	read_filename
else
	read_filename
fi

exit_message 0