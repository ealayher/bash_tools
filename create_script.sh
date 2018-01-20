#!/bin/bash
#--------------------------------------------------------------------------------------#
# Created: 04/22/2014 By: Evan Layher (layher@psych.ucsb.edu)
# Revised: 06/23/2015 By: Evan Layher
# Revised: 10/21/2015 By: Evan Layher # (3.0) Mac compatible (and other minor alterations)
# Revised: 11/06/2015 By: Evan Layher # (3.1) Update create_scriptX functions
# Revised: 11/11/2015 By: Evan Layher # (3.2) Update 'open_text_editor' functions
# Revised: 02/12/2016 By: Evan Layher # (3.3) Minor updates
# Revised: 03/16/2016 By: Evan Layher # (3.4) Changed IFS='\n' + minor updates
# Revised: 09/09/2016 By: Evan Layher # (3.5) Updated functions + minor updates
# Revised: 02/16/2017 By: Evan Layher # (3.6) Minor updates
# Revised: 12/13/2017 By: Evan Layher # (3.7) Minor updates
# Revised: 01/10/2018 By: Evan Layher # (3.8) Added display_values function + minor updates
# Reference: github.com/ealayher/bash_tools
#--------------------------------------------------------------------------------------#
# Create new scripts with customized information

## --- LICENSE INFORMATION --- ##
## create_script.sh is the proprietary property of The Regents of the University of California ("The Regents.")

## Copyright © 2014-18 The Regents of the University of California, Davis campus. All Rights Reserved.

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
text_editors=('kwrite' 'kate' 'gedit' 'open -a /Applications/BBEdit.app' 'open') # GUI text editor commands in preference order
perm='755'         # '755': Default file permission for new scripts
default_script='1' # '1'  : 'create_script' functions
script_author='Evan Layher' # Author of script
contact_info='layher@psych.ucsb.edu' # Author contact information

#------------------------- SCRIPT HELP MESSAGE -----------------------------#
usage () { # Help message: '-h' or '--help' option
	echo "${red}HELP MESSAGE: ${gre}${script_path}${whi}
${ora}DESCRIPTION${whi}: Create script in working directory
     
${ora}ADVICE${whi}: Create alias in ${ora}${HOME}/.bashrc${whi}
(e.g. ${gre}alias cs='${script_path}'${whi})
     
${ora}USAGE${whi}: Input filename of new script
  [${ora}1${whi}] ${gre}cs${ora} examplefile1.sh${whi}
  
${ora}OPTIONS${whi}: Can input multiple options in any order
 ${pur}-h${whi} or ${pur}--help${whi}  Display this message
 ${pur}-i${whi}   Do ${red}NOT${whi} open script file after it is created
 ${pur}-l${whi}   List comments for each '${gre}create_script${whi}' function
 ${pur}-n${whi}   Which '${gre}create_script${whi}' function to use (${ora}default: ${gre}${default_script}${whi})
  [${ora}2${whi}] ${gre}cs ${pur}-n ${ora}5${whi}
 ${pur}-nc${whi}  Prevent color printing in terminal 
 ${pur}-o${whi} or  ${pur}--open${whi}  Open this script
 ${pur}-p${whi}   Input permission value (${ora}default: ${gre}${perm}${whi})
  [${ora}3${whi}] ${gre}cs ${pur}-p ${ora}744${whi}
     
${ora}DEFAULT SETTINGS${whi}:
 Script types: ${gre}`grep -c '^create_script[0-9]' ${script_path}`${whi}
 Script file permission: ${gre}${perm}${whi}
${ora}VERSION: ${gre}${version}${whi}
${red}END OF HELP: ${gre}${script_path}${whi}"

exit_message 0
} # usage

#----------------------- GENERAL SCRIPT VARIABLES --------------------------#
todays_date=$(date +%x)         # Inputs date inside of script
script_path="${BASH_SOURCE[0]}" # Script path (becomes absolute path later)
version='3.8'            # Script version number

	###--- 'yes' or 'no' options (inputs do the opposite of default) ---###
activate_colors='yes'   # 'yes': Display messages in color [INPUT: '-nc']
activate_help='no'      # 'no' : Display help message      [INPUT: '-h' or '--help']
change_permission='no'  # 'no' : Change permission         [INPUT: '[0-7][0-7][0-7]']
display_scripts='no'    # 'no' : Display script types      [INPUT: '-l']
filename_reader='on'    # 'on' : Read in filename ('on' or 'off')
open_file='yes'         # 'yes': Open newly created script [INPUT: '-i']
open_script='no'        # 'no' : Open this script          [INPUT: '-o' or '--open']
p_in='no'               # 'no' : Read in permission level for output file

#-------------------------------- FUNCTIONS --------------------------------#
### SCRIPT TYPES: Must have naming convenction of 'create_script*[0-9] () {' [ e.g. create_script10 () { # Comments ]
create_script1 () { # Time, exit message, bg functions, vital_command/file
echo "#!/bin/bash
#--------------------------------------------------------------------------------------#
# Created: ${todays_date} By: ${script_author} (1.0) (${contact_info})
# Revised: ${todays_date} By: ${script_author}
#--------------------------------------------------------------------------------------#
#
#-------------------------------- VARIABLES --------------------------------#

#--------------------------- DEFAULT SETTINGS ------------------------------#
max_bg_jobs='5' # Maximum background processes (1-10)
text_editors=('kwrite' 'kate' 'gedit' 'open -a /Applications/BBEdit.app' 'open') # GUI text editor commands in preference order

IFS_old=\"\${IFS}\" # whitespace separator
IFS=\$'\\n' # newline separator (useful when paths have whitespace)
#------------------------- SCRIPT HELP MESSAGE -----------------------------#
usage () { # Help message: '-h' or '--help' option
	echo \"\${red}HELP MESSAGE: \${gre}\${script_path}\${whi}
\${ora}DESCRIPTION\${whi}:
     
\${ora}ADVICE\${whi}: Create alias in \${ora}\${HOME}/.bashrc\${whi}
(e.g. \${gre}alias xx='\${script_path}'\${whi})
     
\${ora}USAGE\${whi}: Run script
 [\${ora}1\${whi}] \${gre}\${script_path}\${whi}
     
\${ora}OPTIONS\${whi}: Can input multiple options in any order
 \${pur}-cs\${whi}  Prevent clearing screen at start
 \${pur}-f\${whi}   Overwrite existing files
 \${pur}-h\${whi} or \${pur}--help\${whi}  Display this message
 \${pur}-nc\${whi}  Prevent color printing in terminal
 \${pur}-nm\${whi}  Prevent exit message from displaying
 \${pur}-nt\${whi}  Prevent script process time from displaying
 \${pur}-o\${whi} or \${pur}--open\${whi} Open this script
     
\${ora}VERSION: \${gre}\${version}\${whi}
\${red}END OF HELP: \${gre}\${script_path}\${whi}\"
	exit_message 0 -nm -nt
} # usage

#----------------------- GENERAL SCRIPT VARIABLES --------------------------#
start_time=\$(date +%s) # Time in seconds
script_path=\"\${BASH_SOURCE[0]}\" # Script path (becomes absolute path later)
version='1.0' # Script version number

	###--- 'yes' or 'no' options (inputs do the opposite of default) ---###
activate_colors='yes' # 'yes': Display messages in color [INPUT: '-nc']
activate_help='no'    # 'no' : Display help message      [INPUT: '-h' or '--help']
clear_screen='yes'    # 'yes': Clear screen at start     [INPUT: '-cs']
display_exit='yes'    # 'yes': Display an exit message   [INPUT: '-nm']
force_overwrite='no'  # 'no' : Overwrite output file(s)  [INPUT: '-f']
open_script='no'      # 'no' : Open this script          [INPUT: '-o' or '--open']
show_time='yes'       # 'yes': Display process time      [INPUT: '-nt']
suggest_help='no'     # 'no' : Suggest help (within script option: '-nh')

#-------------------------------- FUNCTIONS --------------------------------#
option_eval () { # Evaluate user inputs
	if [ \"\${1}\" == '-cs' 2>/dev/null ] || [ \"\${1}\" == '-f' 2>/dev/null ] || \\
	   [ \"\${1}\" == '-h' 2>/dev/null ] || [ \"\${1}\" == '--help' 2>/dev/null ] || \\
	   [ \"\${1}\" == '-nc' 2>/dev/null ] || [ \"\${1}\" == '-nm' 2>/dev/null ] || \\
	   [ \"\${1}\" == '-nt' 2>/dev/null ] || [ \"\${1}\" == '-o' 2>/dev/null ] || \\
	   [ \"\${1}\" == '--open' 2>/dev/null ]; then
		activate_options \"\${1}\"
	elif [ \"\${1:0:1}\" == '-' 2>/dev/null ]; then
		bad_inputs+=(\"INVALID-OPTION:\${1}\")
	fi
} # option_eval

activate_options () { # Activate input options
	if [ \"\${1}\" == '-cs' ]; then
		clear_screen='no'     # Do NOT clear screen at start
	elif [ \"\${1}\" == '-f' ]; then
		force_overwrite='yes' # Overwrite files
	elif [ \"\${1}\" == '-h' ] || [ \"\${1}\" == '--help' ]; then
		activate_help='yes'   # Display help message
	elif [ \"\${1}\" == '-nc' ]; then
		activate_colors='no'  # Do NOT display messages in color
	elif [ \"\${1}\" == '-nm' ]; then
		display_exit='no'     # Do NOT display exit message
	elif [ \"\${1}\" == '-nt' ]; then
		show_time='no'        # Do NOT display script process time
	elif [ \"\${1}\" == '-o' ] || [ \"\${1}\" == '--open' ]; then
		open_script='yes'     # Open this script
	else # if option is undefined (for debugging)
		bad_inputs+=(\"ERROR:activate_options:\${1}\")
	fi
} # activate_options

color_formats () { # Print colorful terminal text
	if [ \"\${activate_colors}\" == 'yes' 2>/dev/null ]; then
		whi=\$(tput setab 0; tput setaf 7) # Black background, white text
		red=\$(tput setab 0; tput setaf 1) # Black background, red text
		ora=\$(tput setab 0; tput setaf 3) # Black background, orange text
		gre=\$(tput setab 0; tput setaf 2) # Black background, green text
		blu=\$(tput setab 0; tput setaf 4) # Black background, blue text
		pur=\$(tput setab 0; tput setaf 5) # Black background, purple text
		formatreset=\$(tput sgr0)          # Reset to default terminal settings
	fi
} # color_formats

control_bg_jobs () { # Controls number of background processes
	if [ \"\${max_bg_jobs}\" -eq '1' 2>/dev/null ]; then
		wait # Proceed after all background processes are finished
	else
		if [ \"\${max_bg_jobs}\" -gt '1' 2>/dev/null ] && [ \"\${max_bg_jobs}\" -le '10' 2>/dev/null ]; then 
			true # Make sure variable is defined and valid number
		elif [ \"\${max_bg_jobs}\" -gt '10' 2>/dev/null ]; then
			echo \"\${red}RESTRICTING BACKGROUND PROCESSES TO 10\${whi}\"
			max_bg_jobs='10' # Background jobs should not exceed '10' (Lowers risk of crashing)
		else # If 'max_bg_jobs' not defined as integer
			echo \"\${red}INVALID VALUE: \${ora}max_bg_jobs='\${gre}\${max_bg_jobs}\${ora}'\${whi}\"
			max_bg_jobs='1'
		fi
	
		job_count=(\$(jobs -p)) # Place job IDs into array
		if ! [ \"\$?\" -eq '0' ]; then # If 'jobs -p' command fails
			echo \"\${red}ERROR (\${ora}control_bg_jobs\${red}): \${ora}RESTRICTING BACKGROUND PROCESSES\${whi}\"
			max_bg_jobs='1'
			wait
		else
			if [ \"\${#job_count[@]}\" -ge \"\${max_bg_jobs}\" ]; then
				sleep 0.2 # Wait 0.2 seconds to prevent overflow errors
				control_bg_jobs # Check job count
			fi
		fi # if ! [ \"\$?\" -eq '0' ]
	fi # if [ \"\${max_bg_jobs}\" -eq '1' 2>/dev/null ]
} # control_bg_jobs

display_values () { # Display output with numbers
	if [ \"\${#@}\" -gt '0' ]; then
		val_count=(\$(seq 1 1 \${#@}))
		vals_and_count=(\$(paste -d \"\${IFS}\" <(printf \"%s\${IFS}\" \${val_count[@]}) <(printf \"%s\${IFS}\" \${@})))
		printf \"\${pur}[\${ora}%s\${pur}] \${gre}%s\${IFS}\${whi}\" \${vals_and_count[@]}
	fi
} # display_values

mac_readlink () { # Get absolute path of a file (mac and linux compatible)
	dir_mac=\$(dirname \"\${1}\")   # Directory path
	file_mac=\$(basename \"\${1}\") # Filename
	wd_mac=\$(pwd) # Working directory path

	if [ -d \"\${dir_mac}\" ]; then
		cd \"\${dir_mac}\"
		echo \"\$(pwd)/\${file_mac}\" # Print full path
		cd \"\${wd_mac}\" # Change back to original directory
	else
		echo \"\${1}\" # Print input
	fi
} # mac_readlink

open_text_editor () { # Opens input file in background (GUI text editors only)
	open_file=\"\${1}\"  # Input file
	valid_editor='no' # Remains 'no' until command is valid
	
	if [ -f \"\${open_file}\" ]; then # If input file exists
		for i in \${!text_editors[@]}; do # Loop through indices
			eval \"\${text_editors[\${i}]} \${open_file} 2>/dev/null &\" # eval for complex commands
			pid=\"\$!\" # Background process ID
			check_pid=(\$(ps \"\${pid}\" |grep \"\${pid}\")) # Check if pid is running
			
			if [ \"\${#check_pid[@]}\" -gt '0' ]; then
				valid_editor='yes'
				break
			fi # Break loop when valid command is found
		done

		if [ \"\${valid_editor}\" == 'no' 2>/dev/null ]; then
			echo \"\${red}NO VALID TEXT EDITOR COMMANDS IN \${ora}text_editors \${red}ARRAY:\${whi}\"
			printf \"\${ora}%s\${IFS}\${whi}\" \${text_editors[@]}
			exit_message 99 -nh -nm -nt
		fi
	else # Missing input file
		echo \"\${red}MISSING FILE: \${ora}\${open_file}\${whi}\"
	fi # if [ -f \"\${open_file}\" ]; then
} # open_text_editor

vital_command () { # Exit script if command fails
	command_status=\"\$?\"
	command_line_number=\"\${1}\" # Must input as: vital_command \${LINENO}
	
	if ! [ -z \"\${command_status}\" ] && [ \"\${command_status}\" -ne '0' ]; then
		echo \"\${red}INVALID COMMAND: LINE \${ora}\${command_line_number}\${whi}\"
		exit_message 98 -nh -nm -nt
	fi
} # vital_command

vital_file () { # Exit script if missing file
	for vitals; do
		if ! [ -e \"\${vitals}\" 2>/dev/null ]; then
			bad_files+=(\"\${vitals}\")
		fi
	done
	
	if [ \"\${#bad_files[@]}\" -gt '0' ]; then
		echo \"\${red}MISSING ESSENTIAL FILE(S):\${whi}\"
		printf \"\${pur}%s\${IFS}\${whi}\" \${bad_files[@]}
		exit_message 97 -nh -nm -nt
	fi
} # vital_file

#-------------------------------- MESSAGES ---------------------------------#
control_c () { # Function activates after 'ctrl + c'
	echo \"\${red}FINISHING CURRENT BACKGROUND PROCESSES BEFORE CRASHING\${whi}\"
	exit_message 96 -nh -nt
} # control_c

exit_message () { # Script exit message
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
	
	wait # Wait for background processes to finish

	# Suggest help message
	if [ \"\${suggest_help}\" == 'yes' 2>/dev/null ]; then
		echo \"\${ora}FOR HELP: \${gre}\${script_path} -h\${whi}\"
	fi
	
	# Display exit message
	if ! [ \"\${display_exit}\" == 'no' 2>/dev/null ]; then # Exit message
		echo \"\${pur}EXITING: \${ora}\${script_path}\${whi}\"
	fi
	
	# Display script process time
	if [ \"\${show_time}\" == 'yes' 2>/dev/null ]; then # Script time message
		time_func 2>/dev/null
	fi
	
	printf \"\${formatreset}\\n\"
	IFS=\"\${IFS_old}\" # Reset IFS
	exit \"\${exit_type}\"
} # exit_message

time_func () { # Script process time calculation
	func_end_time=\$(date +%s) # Time in seconds
	input_time=\"\${1}\"
	valid_time='yes'
	
	if ! [ -z \"\${input_time}\" ] && [ \"\${input_time}\" -eq \"\${input_time}\" 2>/dev/null ]; then
		func_start_time=\"\${input_time}\"
	elif ! [ -z \"\${start_time}\" ] && [ \"\${start_time}\" -eq \"\${start_time}\" 2>/dev/null ]; then
		func_start_time=\"\${start_time}\"
	else # If no integer input or 'start_time' undefined
		valid_time='no'
	fi
	
	if [ \"\${valid_time}\" == 'yes' ]; then
		process_time=\$((\${func_end_time} - \${func_start_time}))
		days=\$((\${process_time} / 86400))
		hours=\$((\${process_time} % 86400 / 3600))
		mins=\$((\${process_time} % 3600 / 60))
		secs=\$((\${process_time} % 60))
	
		if [ \"\${days}\" -gt '0' ]; then 
			echo \"PROCESS TIME: \${days} day(s) \${hours} hour(s) \${mins} minute(s) \${secs} second(s)\"
		elif [ \"\${hours}\" -gt '0' ]; then
			echo \"PROCESS TIME: \${hours} hour(s) \${mins} minute(s) \${secs} second(s)\"
		elif [ \"\${mins}\" -gt '0' ]; then
			echo \"PROCESS TIME: \${mins} minute(s) \${secs} second(s)\"
		else
			echo \"PROCESS TIME: \${secs} second(s)\"
		fi
	else # Unknown start time
		echo \"UNKNOWN PROCESS TIME\"
	fi # if [ \"\${valid_time}\" == 'yes' ]
} # time_func

#---------------------------------- CODE -----------------------------------#
trap control_c SIGINT 2>/dev/null # Finishes background processes before crashing
script_path=\$(mac_readlink \"\${script_path}\") # similar to 'readlink -f' in linux

for inputs; do # Read through all inputs
	option_eval \"\${inputs}\"
done

if ! [ \"\${clear_screen}\" == 'no' 2>/dev/null ]; then
	clear     # Clears screen unless input option: '-cs'
fi

color_formats # Activate or prevent colorful output

# Display help message or open script
if [ \"\${activate_help}\" == 'yes' 2>/dev/null ]; then # '-h' or '--help'
	usage # Display help message
elif [ \"\${open_script}\" == 'yes' 2>/dev/null ]; then # '-o' or '--open'
	open_text_editor \"\${script_path}\" # Open script
	exit_message 0 -nm -nt
fi

# Exit script if invalid inputs
if [ \"\${#bad_inputs[@]}\" -gt '0' ]; then
	clear
	echo \"\${red}INVALID INPUT:\${whi}\"
	display_values \${bad_inputs[@]}
	exit_message 1 -nt
fi

exit_message 0"
} # create_script1

create_script2 () { # Time, exit message, vital_command/file
echo "#!/bin/bash
#--------------------------------------------------------------------------------------#
# Created: ${todays_date} By: ${script_author} (1.0) (${contact_info})
# Revised: ${todays_date} By: ${script_author}
#--------------------------------------------------------------------------------------#
#
#-------------------------------- VARIABLES --------------------------------#

#--------------------------- DEFAULT SETTINGS ------------------------------#
text_editors=('kwrite' 'kate' 'gedit' 'open -a /Applications/BBEdit.app' 'open') # GUI text editor commands in preference order

IFS_old=\"\${IFS}\" # whitespace separator
IFS=\$'\\n' # newline separator (useful when paths have whitespace)
#------------------------- SCRIPT HELP MESSAGE -----------------------------#
usage () { # Help message: '-h' or '--help' option
	echo \"\${red}HELP MESSAGE: \${gre}\${script_path}\${whi}
\${ora}DESCRIPTION\${whi}:
     
\${ora}ADVICE\${whi}: Create alias in \${ora}\${HOME}/.bashrc\${whi}
(e.g. \${gre}alias xx='\${script_path}'\${whi})
     
\${ora}USAGE\${whi}: Run script
 [\${ora}1\${whi}] \${gre}\${script_path}\${whi}
     
\${ora}OPTIONS\${whi}: Can input multiple options in any order
 \${pur}-cs\${whi}  Prevent clearing screen at start
 \${pur}-f\${whi}   Overwrite existing files
 \${pur}-h\${whi} or \${pur}--help\${whi}  Display this message
 \${pur}-nc\${whi}  Prevent color printing in terminal
 \${pur}-nm\${whi}  Prevent exit message from displaying
 \${pur}-nt\${whi}  Prevent script process time from displaying
 \${pur}-o\${whi} or \${pur}--open\${whi} Open this script
     
\${ora}VERSION: \${gre}\${version}\${whi}
\${red}END OF HELP: \${gre}\${script_path}\${whi}\"
	exit_message 0 -nm -nt
} # usage

#----------------------- GENERAL SCRIPT VARIABLES --------------------------#
start_time=\$(date +%s) # Time in seconds
script_path=\"\${BASH_SOURCE[0]}\" # Script path (becomes absolute path later)
version='1.0' # Script version number

	###--- 'yes' or 'no' options (inputs do the opposite of default) ---###
activate_colors='yes' # 'yes': Display messages in color [INPUT: '-nc']
activate_help='no'    # 'no' : Display help message      [INPUT: '-h' or '--help']
clear_screen='yes'    # 'yes': Clear screen at start     [INPUT: '-cs']
display_exit='yes'    # 'yes': Display an exit message   [INPUT: '-nm']
force_overwrite='no'  # 'no' : Overwrite output file(s)  [INPUT: '-f']
open_script='no'      # 'no' : Open this script          [INPUT: '-o' or '--open']
show_time='yes'       # 'yes': Display process time      [INPUT: '-nt']
suggest_help='no'     # 'no' : Suggest help (within script option: '-nh')

#-------------------------------- FUNCTIONS --------------------------------#
option_eval () { # Evaluate user inputs
	if [ \"\${1}\" == '-cs' 2>/dev/null ] || [ \"\${1}\" == '-f' 2>/dev/null ] || \\
	   [ \"\${1}\" == '-h' 2>/dev/null ] || [ \"\${1}\" == '--help' 2>/dev/null ] || \\
	   [ \"\${1}\" == '-nc' 2>/dev/null ] || [ \"\${1}\" == '-nm' 2>/dev/null ] || \\
	   [ \"\${1}\" == '-nt' 2>/dev/null ] || [ \"\${1}\" == '-o' 2>/dev/null ] || \\
	   [ \"\${1}\" == '--open' 2>/dev/null ]; then
		activate_options \"\${1}\"
	elif [ \"\${1:0:1}\" == '-' 2>/dev/null ]; then
		bad_inputs+=(\"INVALID-OPTION:\${1}\")
	fi
} # option_eval

activate_options () { # Activate input options
	if [ \"\${1}\" == '-cs' ]; then
		clear_screen='no'     # Do NOT clear screen at start
	elif [ \"\${1}\" == '-f' ]; then
		force_overwrite='yes' # Overwrite files
	elif [ \"\${1}\" == '-h' ] || [ \"\${1}\" == '--help' ]; then
		activate_help='yes'   # Display help message
	elif [ \"\${1}\" == '-nc' ]; then
		activate_colors='no'  # Do NOT display messages in color
	elif [ \"\${1}\" == '-nm' ]; then
		display_exit='no'     # Do NOT display exit message
	elif [ \"\${1}\" == '-nt' ]; then
		show_time='no'        # Do NOT display script process time
	elif [ \"\${1}\" == '-o' ] || [ \"\${1}\" == '--open' ]; then
		open_script='yes'     # Open this script
	else # if option is undefined (for debugging)
		bad_inputs+=(\"ERROR:activate_options:\${1}\")
	fi
} # activate_options

color_formats () { # Print colorful terminal text
	if [ \"\${activate_colors}\" == 'yes' 2>/dev/null ]; then
		whi=\$(tput setab 0; tput setaf 7) # Black background, white text
		red=\$(tput setab 0; tput setaf 1) # Black background, red text
		ora=\$(tput setab 0; tput setaf 3) # Black background, orange text
		gre=\$(tput setab 0; tput setaf 2) # Black background, green text
		blu=\$(tput setab 0; tput setaf 4) # Black background, blue text
		pur=\$(tput setab 0; tput setaf 5) # Black background, purple text
		formatreset=\$(tput sgr0)          # Reset to default terminal settings
	fi
} # color_formats

display_values () { # Display output with numbers
	if [ \"\${#@}\" -gt '0' ]; then
		val_count=(\$(seq 1 1 \${#@}))
		vals_and_count=(\$(paste -d \"\${IFS}\" <(printf \"%s\${IFS}\" \${val_count[@]}) <(printf \"%s\${IFS}\" \${@})))
		printf \"\${pur}[\${ora}%s\${pur}] \${gre}%s\${IFS}\${whi}\" \${vals_and_count[@]}
	fi
} # display_values

mac_readlink () { # Get absolute path of a file (mac and linux compatible)
	dir_mac=\$(dirname \"\${1}\")   # Directory path
	file_mac=\$(basename \"\${1}\") # Filename
	wd_mac=\$(pwd) # Working directory path

	if [ -d \"\${dir_mac}\" ]; then
		cd \"\${dir_mac}\"
		echo \"\$(pwd)/\${file_mac}\" # Print full path
		cd \"\${wd_mac}\" # Change back to original directory
	else
		echo \"\${1}\" # Print input
	fi
} # mac_readlink

open_text_editor () { # Opens input file in background (GUI text editors only)
	open_file=\"\${1}\"  # Input file
	valid_editor='no' # Remains 'no' until command is valid
	
	if [ -f \"\${open_file}\" ]; then # If input file exists
		for i in \${!text_editors[@]}; do # Loop through indices
			eval \"\${text_editors[\${i}]} \${open_file} 2>/dev/null &\" # eval for complex commands
			pid=\"\$!\" # Background process ID
			check_pid=(\$(ps \"\${pid}\" |grep \"\${pid}\")) # Check if pid is running
			
			if [ \"\${#check_pid[@]}\" -gt '0' ]; then
				valid_editor='yes'
				break
			fi # Break loop when valid command is found
		done

		if [ \"\${valid_editor}\" == 'no' 2>/dev/null ]; then
			echo \"\${red}NO VALID TEXT EDITOR COMMANDS IN \${ora}text_editors \${red}ARRAY:\${whi}\"
			printf \"\${ora}%s\${IFS}\${whi}\" \${text_editors[@]}
			exit_message 99 -nh -nm -nt
		fi
	else # Missing input file
		echo \"\${red}MISSING FILE: \${ora}\${open_file}\${whi}\"
	fi # if [ -f \"\${open_file}\" ]; then
} # open_text_editor

vital_command () { # Exit script if command fails
	command_status=\"\$?\"
	command_line_number=\"\${1}\" # Must input as: vital_command \${LINENO}
	
	if ! [ -z \"\${command_status}\" ] && [ \"\${command_status}\" -ne '0' ]; then
		echo \"\${red}INVALID COMMAND: LINE \${ora}\${command_line_number}\${whi}\"
		exit_message 98 -nh -nm -nt
	fi
} # vital_command

vital_file () { # Exit script if missing file
	for vitals; do
		if ! [ -e \"\${vitals}\" 2>/dev/null ]; then
			bad_files+=(\"\${vitals}\")
		fi
	done
	
	if [ \"\${#bad_files[@]}\" -gt '0' ]; then
		echo \"\${red}MISSING ESSENTIAL FILE(S):\${whi}\"
		printf \"\${pur}%s\${IFS}\${whi}\" \${bad_files[@]}
		exit_message 97 -nh -nm -nt
	fi
} # vital_file

#-------------------------------- MESSAGES ---------------------------------#
exit_message () { # Script exit message
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
	
	wait # Wait for background processes to finish

	# Suggest help message
	if [ \"\${suggest_help}\" == 'yes' 2>/dev/null ]; then
		echo \"\${ora}FOR HELP: \${gre}\${script_path} -h\${whi}\"
	fi
	
	# Display exit message
	if ! [ \"\${display_exit}\" == 'no' 2>/dev/null ]; then # Exit message
		echo \"\${pur}EXITING: \${ora}\${script_path}\${whi}\"
	fi
	
	# Display script process time
	if [ \"\${show_time}\" == 'yes' 2>/dev/null ]; then # Script time message
		time_func 2>/dev/null
	fi
	
	printf \"\${formatreset}\\n\"
	IFS=\"\${IFS_old}\" # Reset IFS
	exit \"\${exit_type}\"
} # exit_message

time_func () { # Script process time calculation
	func_end_time=\$(date +%s) # Time in seconds
	input_time=\"\${1}\"
	valid_time='yes'
	
	if ! [ -z \"\${input_time}\" ] && [ \"\${input_time}\" -eq \"\${input_time}\" 2>/dev/null ]; then
		func_start_time=\"\${input_time}\"
	elif ! [ -z \"\${start_time}\" ] && [ \"\${start_time}\" -eq \"\${start_time}\" 2>/dev/null ]; then
		func_start_time=\"\${start_time}\"
	else # If no integer input or 'start_time' undefined
		valid_time='no'
	fi
	
	if [ \"\${valid_time}\" == 'yes' ]; then
		process_time=\$((\${func_end_time} - \${func_start_time}))
		days=\$((\${process_time} / 86400))
		hours=\$((\${process_time} % 86400 / 3600))
		mins=\$((\${process_time} % 3600 / 60))
		secs=\$((\${process_time} % 60))
	
		if [ \"\${days}\" -gt '0' ]; then 
			echo \"PROCESS TIME: \${days} day(s) \${hours} hour(s) \${mins} minute(s) \${secs} second(s)\"
		elif [ \"\${hours}\" -gt '0' ]; then
			echo \"PROCESS TIME: \${hours} hour(s) \${mins} minute(s) \${secs} second(s)\"
		elif [ \"\${mins}\" -gt '0' ]; then
			echo \"PROCESS TIME: \${mins} minute(s) \${secs} second(s)\"
		else
			echo \"PROCESS TIME: \${secs} second(s)\"
		fi
	else # Unknown start time
		echo \"UNKNOWN PROCESS TIME\"
	fi # if [ \"\${valid_time}\" == 'yes' ]
} # time_func

#---------------------------------- CODE -----------------------------------#
script_path=\$(mac_readlink \"\${script_path}\") # similar to 'readlink -f' in linux

for inputs; do # Read through all inputs
	option_eval \"\${inputs}\"
done

if ! [ \"\${clear_screen}\" == 'no' 2>/dev/null ]; then
	clear     # Clears screen unless input option: '-cs'
fi

color_formats # Activate or prevent colorful output

# Display help message or open script
if [ \"\${activate_help}\" == 'yes' 2>/dev/null ]; then # '-h' or '--help'
	usage # Display help message
elif [ \"\${open_script}\" == 'yes' 2>/dev/null ]; then # '-o' or '--open'
	open_text_editor \"\${script_path}\" # Open script
	exit_message 0 -nm -nt
fi

# Exit script if invalid inputs
if [ \"\${#bad_inputs[@]}\" -gt '0' ]; then
	clear
	echo \"\${red}INVALID INPUT:\${whi}\"
	display_values \${bad_inputs[@]}
	exit_message 1 -nt
fi

exit_message 0"
} # create_script2

create_script3 () { # Time, exit message, bg functions
echo "#!/bin/bash
#--------------------------------------------------------------------------------------#
# Created: ${todays_date} By: ${script_author} (1.0) (${contact_info})
# Revised: ${todays_date} By: ${script_author}
#--------------------------------------------------------------------------------------#
#
#-------------------------------- VARIABLES --------------------------------#

#--------------------------- DEFAULT SETTINGS ------------------------------#
max_bg_jobs='5' # Maximum background processes (1-10)
text_editors=('kwrite' 'kate' 'gedit' 'open -a /Applications/BBEdit.app' 'open') # GUI text editor commands in preference order

IFS_old=\"\${IFS}\" # whitespace separator
IFS=\$'\\n' # newline separator (useful when paths have whitespace)
#------------------------- SCRIPT HELP MESSAGE -----------------------------#
usage () { # Help message: '-h' or '--help' option
	echo \"\${red}HELP MESSAGE: \${gre}\${script_path}\${whi}
\${ora}DESCRIPTION\${whi}:
     
\${ora}ADVICE\${whi}: Create alias in \${ora}\${HOME}/.bashrc\${whi}
(e.g. \${gre}alias xx='\${script_path}'\${whi})
     
\${ora}USAGE\${whi}: Run script
 [\${ora}1\${whi}] \${gre}\${script_path}\${whi}
     
\${ora}OPTIONS\${whi}: Can input multiple options in any order
 \${pur}-cs\${whi}  Prevent clearing screen at start
 \${pur}-f\${whi}   Overwrite existing files
 \${pur}-h\${whi} or \${pur}--help\${whi}  Display this message
 \${pur}-nc\${whi}  Prevent color printing in terminal
 \${pur}-nm\${whi}  Prevent exit message from displaying
 \${pur}-nt\${whi}  Prevent script process time from displaying
 \${pur}-o\${whi} or \${pur}--open\${whi} Open this script
     
\${ora}VERSION: \${gre}\${version}\${whi}
\${red}END OF HELP: \${gre}\${script_path}\${whi}\"
	exit_message 0 -nm -nt
} # usage

#----------------------- GENERAL SCRIPT VARIABLES --------------------------#
start_time=\$(date +%s) # Time in seconds
script_path=\"\${BASH_SOURCE[0]}\" # Script path (becomes absolute path later)
version='1.0' # Script version number

	###--- 'yes' or 'no' options (inputs do the opposite of default) ---###
activate_colors='yes' # 'yes': Display messages in color [INPUT: '-nc']
activate_help='no'    # 'no' : Display help message      [INPUT: '-h' or '--help']
clear_screen='yes'    # 'yes': Clear screen at start     [INPUT: '-cs']
display_exit='yes'    # 'yes': Display an exit message   [INPUT: '-nm']
force_overwrite='no'  # 'no' : Overwrite output file(s)  [INPUT: '-f']
open_script='no'      # 'no' : Open this script          [INPUT: '-o' or '--open']
show_time='yes'       # 'yes': Display process time      [INPUT: '-nt']
suggest_help='no'     # 'no' : Suggest help (within script option: '-nh')

#-------------------------------- FUNCTIONS --------------------------------#
option_eval () { # Evaluate user inputs
	if [ \"\${1}\" == '-cs' 2>/dev/null ] || [ \"\${1}\" == '-f' 2>/dev/null ] || \\
	   [ \"\${1}\" == '-h' 2>/dev/null ] || [ \"\${1}\" == '--help' 2>/dev/null ] || \\
	   [ \"\${1}\" == '-nc' 2>/dev/null ] || [ \"\${1}\" == '-nm' 2>/dev/null ] || \\
	   [ \"\${1}\" == '-nt' 2>/dev/null ] || [ \"\${1}\" == '-o' 2>/dev/null ] || \\
	   [ \"\${1}\" == '--open' 2>/dev/null ]; then
		activate_options \"\${1}\"
	elif [ \"\${1:0:1}\" == '-' 2>/dev/null ]; then
		bad_inputs+=(\"INVALID-OPTION:\${1}\")
	fi
} # option_eval

activate_options () { # Activate input options
	if [ \"\${1}\" == '-cs' ]; then
		clear_screen='no'     # Do NOT clear screen at start
	elif [ \"\${1}\" == '-f' ]; then
		force_overwrite='yes' # Overwrite files
	elif [ \"\${1}\" == '-h' ] || [ \"\${1}\" == '--help' ]; then
		activate_help='yes'   # Display help message
	elif [ \"\${1}\" == '-nc' ]; then
		activate_colors='no'  # Do NOT display messages in color
	elif [ \"\${1}\" == '-nm' ]; then
		display_exit='no'     # Do NOT display exit message
	elif [ \"\${1}\" == '-nt' ]; then
		show_time='no'        # Do NOT display script process time
	elif [ \"\${1}\" == '-o' ] || [ \"\${1}\" == '--open' ]; then
		open_script='yes'     # Open this script
	else # if option is undefined (for debugging)
		bad_inputs+=(\"ERROR:activate_options:\${1}\")
	fi
} # activate_options

color_formats () { # Print colorful terminal text
	if [ \"\${activate_colors}\" == 'yes' 2>/dev/null ]; then
		whi=\$(tput setab 0; tput setaf 7) # Black background, white text
		red=\$(tput setab 0; tput setaf 1) # Black background, red text
		ora=\$(tput setab 0; tput setaf 3) # Black background, orange text
		gre=\$(tput setab 0; tput setaf 2) # Black background, green text
		blu=\$(tput setab 0; tput setaf 4) # Black background, blue text
		pur=\$(tput setab 0; tput setaf 5) # Black background, purple text
		formatreset=\$(tput sgr0)          # Reset to default terminal settings
	fi
} # color_formats

control_bg_jobs () { # Controls number of background processes
	if [ \"\${max_bg_jobs}\" -eq '1' 2>/dev/null ]; then
		wait # Proceed after all background processes are finished
	else
		if [ \"\${max_bg_jobs}\" -gt '1' 2>/dev/null ] && [ \"\${max_bg_jobs}\" -le '10' 2>/dev/null ]; then 
			true # Make sure variable is defined and valid number
		elif [ \"\${max_bg_jobs}\" -gt '10' 2>/dev/null ]; then
			echo \"\${red}RESTRICTING BACKGROUND PROCESSES TO 10\${whi}\"
			max_bg_jobs='10' # Background jobs should not exceed '10' (Lowers risk of crashing)
		else # If 'max_bg_jobs' not defined as integer
			echo \"\${red}INVALID VALUE: \${ora}max_bg_jobs='\${gre}\${max_bg_jobs}\${ora}'\${whi}\"
			max_bg_jobs='1'
		fi
	
		job_count=(\$(jobs -p)) # Place job IDs into array
		if ! [ \"\$?\" -eq '0' ]; then # If 'jobs -p' command fails
			echo \"\${red}ERROR (\${ora}control_bg_jobs\${red}): \${ora}RESTRICTING BACKGROUND PROCESSES\${whi}\"
			max_bg_jobs='1'
			wait
		else
			if [ \"\${#job_count[@]}\" -ge \"\${max_bg_jobs}\" ]; then
				sleep 0.2 # Wait 0.2 seconds to prevent overflow errors
				control_bg_jobs # Check job count
			fi
		fi # if ! [ \"\$?\" -eq '0' ]
	fi # if [ \"\${max_bg_jobs}\" -eq '1' 2>/dev/null ]
} # control_bg_jobs

display_values () { # Display output with numbers
	if [ \"\${#@}\" -gt '0' ]; then
		val_count=(\$(seq 1 1 \${#@}))
		vals_and_count=(\$(paste -d \"\${IFS}\" <(printf \"%s\${IFS}\" \${val_count[@]}) <(printf \"%s\${IFS}\" \${@})))
		printf \"\${pur}[\${ora}%s\${pur}] \${gre}%s\${IFS}\${whi}\" \${vals_and_count[@]}
	fi
} # display_values

mac_readlink () { # Get absolute path of a file (mac and linux compatible)
	dir_mac=\$(dirname \"\${1}\")   # Directory path
	file_mac=\$(basename \"\${1}\") # Filename
	wd_mac=\$(pwd) # Working directory path

	if [ -d \"\${dir_mac}\" ]; then
		cd \"\${dir_mac}\"
		echo \"\$(pwd)/\${file_mac}\" # Print full path
		cd \"\${wd_mac}\" # Change back to original directory
	else
		echo \"\${1}\" # Print input
	fi
} # mac_readlink

open_text_editor () { # Opens input file in background (GUI text editors only)
	open_file=\"\${1}\"  # Input file
	valid_editor='no' # Remains 'no' until command is valid
	
	if [ -f \"\${open_file}\" ]; then # If input file exists
		for i in \${!text_editors[@]}; do # Loop through indices
			eval \"\${text_editors[\${i}]} \${open_file} 2>/dev/null &\" # eval for complex commands
			pid=\"\$!\" # Background process ID
			check_pid=(\$(ps \"\${pid}\" |grep \"\${pid}\")) # Check if pid is running
			
			if [ \"\${#check_pid[@]}\" -gt '0' ]; then
				valid_editor='yes'
				break
			fi # Break loop when valid command is found
		done

		if [ \"\${valid_editor}\" == 'no' 2>/dev/null ]; then
			echo \"\${red}NO VALID TEXT EDITOR COMMANDS IN \${ora}text_editors \${red}ARRAY:\${whi}\"
			printf \"\${ora}%s\${IFS}\${whi}\" \${text_editors[@]}
			exit_message 99 -nh -nm -nt
		fi
	else # Missing input file
		echo \"\${red}MISSING FILE: \${ora}\${open_file}\${whi}\"
	fi # if [ -f \"\${open_file}\" ]; then
} # open_text_editor

#-------------------------------- MESSAGES ---------------------------------#
control_c () { # Function activates after 'ctrl + c'
	echo \"\${red}FINISHING CURRENT BACKGROUND PROCESSES BEFORE CRASHING\${whi}\"
	exit_message 98 -nh -nt
} # control_c

exit_message () { # Script exit message
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
	
	wait # Wait for background processes to finish

	# Suggest help message
	if [ \"\${suggest_help}\" == 'yes' 2>/dev/null ]; then
		echo \"\${ora}FOR HELP: \${gre}\${script_path} -h\${whi}\"
	fi
	
	# Display exit message
	if ! [ \"\${display_exit}\" == 'no' 2>/dev/null ]; then # Exit message
		echo \"\${pur}EXITING: \${ora}\${script_path}\${whi}\"
	fi
	
	# Display script process time
	if [ \"\${show_time}\" == 'yes' 2>/dev/null ]; then # Script time message
		time_func 2>/dev/null
	fi
	
	printf \"\${formatreset}\\n\"
	IFS=\"\${IFS_old}\" # Reset IFS
	exit \"\${exit_type}\"
} # exit_message

time_func () { # Script process time calculation
	func_end_time=\$(date +%s) # Time in seconds
	input_time=\"\${1}\"
	valid_time='yes'
	
	if ! [ -z \"\${input_time}\" ] && [ \"\${input_time}\" -eq \"\${input_time}\" 2>/dev/null ]; then
		func_start_time=\"\${input_time}\"
	elif ! [ -z \"\${start_time}\" ] && [ \"\${start_time}\" -eq \"\${start_time}\" 2>/dev/null ]; then
		func_start_time=\"\${start_time}\"
	else # If no integer input or 'start_time' undefined
		valid_time='no'
	fi
	
	if [ \"\${valid_time}\" == 'yes' ]; then
		process_time=\$((\${func_end_time} - \${func_start_time}))
		days=\$((\${process_time} / 86400))
		hours=\$((\${process_time} % 86400 / 3600))
		mins=\$((\${process_time} % 3600 / 60))
		secs=\$((\${process_time} % 60))
	
		if [ \"\${days}\" -gt '0' ]; then 
			echo \"PROCESS TIME: \${days} day(s) \${hours} hour(s) \${mins} minute(s) \${secs} second(s)\"
		elif [ \"\${hours}\" -gt '0' ]; then
			echo \"PROCESS TIME: \${hours} hour(s) \${mins} minute(s) \${secs} second(s)\"
		elif [ \"\${mins}\" -gt '0' ]; then
			echo \"PROCESS TIME: \${mins} minute(s) \${secs} second(s)\"
		else
			echo \"PROCESS TIME: \${secs} second(s)\"
		fi
	else # Unknown start time
		echo \"UNKNOWN PROCESS TIME\"
	fi # if [ \"\${valid_time}\" == 'yes' ]
} # time_func

#---------------------------------- CODE -----------------------------------#
trap control_c SIGINT 2>/dev/null # Finishes background processes before crashing
script_path=\$(mac_readlink \"\${script_path}\") # similar to 'readlink -f' in linux

for inputs; do # Read through all inputs
	option_eval \"\${inputs}\"
done

if ! [ \"\${clear_screen}\" == 'no' 2>/dev/null ]; then
	clear     # Clears screen unless input option: '-cs'
fi

color_formats # Activate or prevent colorful output

# Display help message or open script
if [ \"\${activate_help}\" == 'yes' 2>/dev/null ]; then # '-h' or '--help'
	usage # Display help message
elif [ \"\${open_script}\" == 'yes' 2>/dev/null ]; then # '-o' or '--open'
	open_text_editor \"\${script_path}\" # Open script
	exit_message 0 -nm -nt
fi

# Exit script if invalid inputs
if [ \"\${#bad_inputs[@]}\" -gt '0' ]; then
	clear
	echo \"\${red}INVALID INPUT:\${whi}\"
	display_values \${bad_inputs[@]}
	exit_message 1 -nt
fi

exit_message 0"
} # create_script3

create_script4 () { # Time, exit message
echo "#!/bin/bash
#--------------------------------------------------------------------------------------#
# Created: ${todays_date} By: ${script_author} (1.0) (${contact_info})
# Revised: ${todays_date} By: ${script_author}
#--------------------------------------------------------------------------------------#
#
#-------------------------------- VARIABLES --------------------------------#

#--------------------------- DEFAULT SETTINGS ------------------------------#
text_editors=('kwrite' 'kate' 'gedit' 'open -a /Applications/BBEdit.app' 'open') # GUI text editor commands in preference order

IFS_old=\"\${IFS}\" # whitespace separator
IFS=\$'\\n' # newline separator (useful when paths have whitespace)
#------------------------- SCRIPT HELP MESSAGE -----------------------------#
usage () { # Help message: '-h' or '--help' option
	echo \"\${red}HELP MESSAGE: \${gre}\${script_path}\${whi}
\${ora}DESCRIPTION\${whi}:
     
\${ora}ADVICE\${whi}: Create alias in \${ora}\${HOME}/.bashrc\${whi}
(e.g. \${gre}alias xx='\${script_path}'\${whi})
     
\${ora}USAGE\${whi}: Run script
 [\${ora}1\${whi}] \${gre}\${script_path}\${whi}
     
\${ora}OPTIONS\${whi}: Can input multiple options in any order
 \${pur}-cs\${whi}  Prevent clearing screen at start
 \${pur}-f\${whi}   Overwrite existing files
 \${pur}-h\${whi} or \${pur}--help\${whi}  Display this message
 \${pur}-nc\${whi}  Prevent color printing in terminal
 \${pur}-nm\${whi}  Prevent exit message from displaying
 \${pur}-nt\${whi}  Prevent script process time from displaying
 \${pur}-o\${whi} or \${pur}--open\${whi} Open this script
     
\${ora}VERSION: \${gre}\${version}\${whi}
\${red}END OF HELP: \${gre}\${script_path}\${whi}\"
	exit_message 0 -nm -nt
} # usage

#----------------------- GENERAL SCRIPT VARIABLES --------------------------#
start_time=\$(date +%s) # Time in seconds
script_path=\"\${BASH_SOURCE[0]}\" # Script path (becomes absolute path later)
version='1.0' # Script version number

	###--- 'yes' or 'no' options (inputs do the opposite of default) ---###
activate_colors='yes' # 'yes': Display messages in color [INPUT: '-nc']
activate_help='no'    # 'no' : Display help message      [INPUT: '-h' or '--help']
clear_screen='yes'    # 'yes': Clear screen at start     [INPUT: '-cs']
display_exit='yes'    # 'yes': Display an exit message   [INPUT: '-nm']
force_overwrite='no'  # 'no' : Overwrite output file(s)  [INPUT: '-f']
open_script='no'      # 'no' : Open this script          [INPUT: '-o' or '--open']
show_time='yes'       # 'yes': Display process time      [INPUT: '-nt']
suggest_help='no'     # 'no' : Suggest help (within script option: '-nh')

#-------------------------------- FUNCTIONS --------------------------------#
option_eval () { # Evaluate user inputs
	if [ \"\${1}\" == '-cs' 2>/dev/null ] || [ \"\${1}\" == '-f' 2>/dev/null ] || \\
	   [ \"\${1}\" == '-h' 2>/dev/null ] || [ \"\${1}\" == '--help' 2>/dev/null ] || \\
	   [ \"\${1}\" == '-nc' 2>/dev/null ] || [ \"\${1}\" == '-nm' 2>/dev/null ] || \\
	   [ \"\${1}\" == '-nt' 2>/dev/null ] || [ \"\${1}\" == '-o' 2>/dev/null ] || \\
	   [ \"\${1}\" == '--open' 2>/dev/null ]; then
		activate_options \"\${1}\"
	elif [ \"\${1:0:1}\" == '-' 2>/dev/null ]; then
		bad_inputs+=(\"INVALID-OPTION:\${1}\")
	fi
} # option_eval

activate_options () { # Activate input options
	if [ \"\${1}\" == '-cs' ]; then
		clear_screen='no'     # Do NOT clear screen at start
	elif [ \"\${1}\" == '-f' ]; then
		force_overwrite='yes' # Overwrite files
	elif [ \"\${1}\" == '-h' ] || [ \"\${1}\" == '--help' ]; then
		activate_help='yes'   # Display help message
	elif [ \"\${1}\" == '-nc' ]; then
		activate_colors='no'  # Do NOT display messages in color
	elif [ \"\${1}\" == '-nm' ]; then
		display_exit='no'     # Do NOT display exit message
	elif [ \"\${1}\" == '-nt' ]; then
		show_time='no'        # Do NOT display script process time
	elif [ \"\${1}\" == '-o' ] || [ \"\${1}\" == '--open' ]; then
		open_script='yes'     # Open this script
	else # if option is undefined (for debugging)
		bad_inputs+=(\"ERROR:activate_options:\${1}\")
	fi
} # activate_options

color_formats () { # Print colorful terminal text
	if [ \"\${activate_colors}\" == 'yes' 2>/dev/null ]; then
		whi=\$(tput setab 0; tput setaf 7) # Black background, white text
		red=\$(tput setab 0; tput setaf 1) # Black background, red text
		ora=\$(tput setab 0; tput setaf 3) # Black background, orange text
		gre=\$(tput setab 0; tput setaf 2) # Black background, green text
		blu=\$(tput setab 0; tput setaf 4) # Black background, blue text
		pur=\$(tput setab 0; tput setaf 5) # Black background, purple text
		formatreset=\$(tput sgr0)          # Reset to default terminal settings
	fi
} # color_formats

display_values () { # Display output with numbers
	if [ \"\${#@}\" -gt '0' ]; then
		val_count=(\$(seq 1 1 \${#@}))
		vals_and_count=(\$(paste -d \"\${IFS}\" <(printf \"%s\${IFS}\" \${val_count[@]}) <(printf \"%s\${IFS}\" \${@})))
		printf \"\${pur}[\${ora}%s\${pur}] \${gre}%s\${IFS}\${whi}\" \${vals_and_count[@]}
	fi
} # display_values

mac_readlink () { # Get absolute path of a file (mac and linux compatible)
	dir_mac=\$(dirname \"\${1}\")   # Directory path
	file_mac=\$(basename \"\${1}\") # Filename
	wd_mac=\$(pwd) # Working directory path

	if [ -d \"\${dir_mac}\" ]; then
		cd \"\${dir_mac}\"
		echo \"\$(pwd)/\${file_mac}\" # Print full path
		cd \"\${wd_mac}\" # Change back to original directory
	else
		echo \"\${1}\" # Print input
	fi
} # mac_readlink

open_text_editor () { # Opens input file in background (GUI text editors only)
	open_file=\"\${1}\"  # Input file
	valid_editor='no' # Remains 'no' until command is valid
	
	if [ -f \"\${open_file}\" ]; then # If input file exists
		for i in \${!text_editors[@]}; do # Loop through indices
			eval \"\${text_editors[\${i}]} \${open_file} 2>/dev/null &\" # eval for complex commands
			pid=\"\$!\" # Background process ID
			check_pid=(\$(ps \"\${pid}\" |grep \"\${pid}\")) # Check if pid is running
			
			if [ \"\${#check_pid[@]}\" -gt '0' ]; then
				valid_editor='yes'
				break
			fi # Break loop when valid command is found
		done

		if [ \"\${valid_editor}\" == 'no' 2>/dev/null ]; then
			echo \"\${red}NO VALID TEXT EDITOR COMMANDS IN \${ora}text_editors \${red}ARRAY:\${whi}\"
			printf \"\${ora}%s\${IFS}\${whi}\" \${text_editors[@]}
			exit_message 99 -nh -nm -nt
		fi
	else # Missing input file
		echo \"\${red}MISSING FILE: \${ora}\${open_file}\${whi}\"
	fi # if [ -f \"\${open_file}\" ]; then
} # open_text_editor

#-------------------------------- MESSAGES ---------------------------------#
exit_message () { # Script exit message
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
	
	wait # Wait for background processes to finish

	# Suggest help message
	if [ \"\${suggest_help}\" == 'yes' 2>/dev/null ]; then
		echo \"\${ora}FOR HELP: \${gre}\${script_path} -h\${whi}\"
	fi
	
	# Display exit message
	if ! [ \"\${display_exit}\" == 'no' 2>/dev/null ]; then # Exit message
		echo \"\${pur}EXITING: \${ora}\${script_path}\${whi}\"
	fi
	
	# Display script process time
	if [ \"\${show_time}\" == 'yes' 2>/dev/null ]; then # Script time message
		time_func 2>/dev/null
	fi
	
	printf \"\${formatreset}\\n\"
	IFS=\"\${IFS_old}\" # Reset IFS
	exit \"\${exit_type}\"
} # exit_message

time_func () { # Script process time calculation
	func_end_time=\$(date +%s) # Time in seconds
	input_time=\"\${1}\"
	valid_time='yes'
	
	if ! [ -z \"\${input_time}\" ] && [ \"\${input_time}\" -eq \"\${input_time}\" 2>/dev/null ]; then
		func_start_time=\"\${input_time}\"
	elif ! [ -z \"\${start_time}\" ] && [ \"\${start_time}\" -eq \"\${start_time}\" 2>/dev/null ]; then
		func_start_time=\"\${start_time}\"
	else # If no integer input or 'start_time' undefined
		valid_time='no'
	fi
	
	if [ \"\${valid_time}\" == 'yes' ]; then
		process_time=\$((\${func_end_time} - \${func_start_time}))
		days=\$((\${process_time} / 86400))
		hours=\$((\${process_time} % 86400 / 3600))
		mins=\$((\${process_time} % 3600 / 60))
		secs=\$((\${process_time} % 60))
	
		if [ \"\${days}\" -gt '0' ]; then 
			echo \"PROCESS TIME: \${days} day(s) \${hours} hour(s) \${mins} minute(s) \${secs} second(s)\"
		elif [ \"\${hours}\" -gt '0' ]; then
			echo \"PROCESS TIME: \${hours} hour(s) \${mins} minute(s) \${secs} second(s)\"
		elif [ \"\${mins}\" -gt '0' ]; then
			echo \"PROCESS TIME: \${mins} minute(s) \${secs} second(s)\"
		else
			echo \"PROCESS TIME: \${secs} second(s)\"
		fi
	else # Unknown start time
		echo \"UNKNOWN PROCESS TIME\"
	fi # if [ \"\${valid_time}\" == 'yes' ]
} # time_func

#---------------------------------- CODE -----------------------------------#
script_path=\$(mac_readlink \"\${script_path}\") # similar to 'readlink -f' in linux

for inputs; do # Read through all inputs
	option_eval \"\${inputs}\"
done

if ! [ \"\${clear_screen}\" == 'no' 2>/dev/null ]; then
	clear     # Clears screen unless input option: '-cs'
fi

color_formats # Activate or prevent colorful output

# Display help message or open script
if [ \"\${activate_help}\" == 'yes' 2>/dev/null ]; then # '-h' or '--help'
	usage # Display help message
elif [ \"\${open_script}\" == 'yes' 2>/dev/null ]; then # '-o' or '--open'
	open_text_editor \"\${script_path}\" # Open script
	exit_message 0 -nm -nt
fi

# Exit script if invalid inputs
if [ \"\${#bad_inputs[@]}\" -gt '0' ]; then
	clear
	echo \"\${red}INVALID INPUT:\${whi}\"
	display_values \${bad_inputs[@]}
	exit_message 1 -nt
fi

exit_message 0"
} # create_script4

create_script5 () { # Exit message, bg functions, vital_command/file
echo "#!/bin/bash
#--------------------------------------------------------------------------------------#
# Created: ${todays_date} By: ${script_author} (1.0) (${contact_info})
# Revised: ${todays_date} By: ${script_author}
#--------------------------------------------------------------------------------------#
#
#-------------------------------- VARIABLES --------------------------------#

#--------------------------- DEFAULT SETTINGS ------------------------------#
max_bg_jobs='5' # Maximum background processes (1-10)
text_editors=('kwrite' 'kate' 'gedit' 'open -a /Applications/BBEdit.app' 'open') # GUI text editor commands in preference order

IFS_old=\"\${IFS}\" # whitespace separator
IFS=\$'\\n' # newline separator (useful when paths have whitespace)
#------------------------- SCRIPT HELP MESSAGE -----------------------------#
usage () { # Help message: '-h' or '--help' option
	echo \"\${red}HELP MESSAGE: \${gre}\${script_path}\${whi}
\${ora}DESCRIPTION\${whi}:
     
\${ora}ADVICE\${whi}: Create alias in \${ora}\${HOME}/.bashrc\${whi}
(e.g. \${gre}alias xx='\${script_path}'\${whi})
     
\${ora}USAGE\${whi}: Run script
 [\${ora}1\${whi}] \${gre}\${script_path}\${whi}
     
\${ora}OPTIONS\${whi}: Can input multiple options in any order
 \${pur}-cs\${whi}  Prevent clearing screen at start
 \${pur}-f\${whi}   Overwrite existing files
 \${pur}-h\${whi} or \${pur}--help\${whi}  Display this message
 \${pur}-nc\${whi}  Prevent color printing in terminal
 \${pur}-nm\${whi}  Prevent exit message from displaying
 \${pur}-o\${whi} or \${pur}--open\${whi} Open this script
     
\${ora}VERSION: \${gre}\${version}\${whi}
\${red}END OF HELP: \${gre}\${script_path}\${whi}\"
	exit_message 0 -nm
} # usage

#----------------------- GENERAL SCRIPT VARIABLES --------------------------#
script_path=\"\${BASH_SOURCE[0]}\" # Script path (becomes absolute path later)
version='1.0' # Script version number

	###--- 'yes' or 'no' options (inputs do the opposite of default) ---###
activate_colors='yes' # 'yes': Display messages in color [INPUT: '-nc']
activate_help='no'    # 'no' : Display help message      [INPUT: '-h' or '--help']
clear_screen='yes'    # 'yes': Clear screen at start     [INPUT: '-cs']
display_exit='yes'    # 'yes': Display an exit message   [INPUT: '-nm']
force_overwrite='no'  # 'no' : Overwrite output file(s)  [INPUT: '-f']
open_script='no'      # 'no' : Open this script          [INPUT: '-o' or '--open']
suggest_help='no'     # 'no' : Suggest help (within script option: '-nh')

#-------------------------------- FUNCTIONS --------------------------------#
option_eval () { # Evaluate user inputs
	if [ \"\${1}\" == '-cs' 2>/dev/null ] || [ \"\${1}\" == '-f' 2>/dev/null ] || \\
	   [ \"\${1}\" == '-h' 2>/dev/null ] || [ \"\${1}\" == '--help' 2>/dev/null ] || \\
	   [ \"\${1}\" == '-nc' 2>/dev/null ] || [ \"\${1}\" == '-nm' 2>/dev/null ] || \\
	   [ \"\${1}\" == '-o' 2>/dev/null ] || [ \"\${1}\" == '--open' 2>/dev/null ]; then
		activate_options \"\${1}\"
	elif [ \"\${1:0:1}\" == '-' 2>/dev/null ]; then
		bad_inputs+=(\"INVALID-OPTION:\${1}\")
	fi
} # option_eval

activate_options () { # Activate input options
	if [ \"\${1}\" == '-cs' ]; then
		clear_screen='no'     # Do NOT clear screen at start
	elif [ \"\${1}\" == '-f' ]; then
		force_overwrite='yes' # Overwrite files
	elif [ \"\${1}\" == '-h' ] || [ \"\${1}\" == '--help' ]; then
		activate_help='yes'   # Display help message
	elif [ \"\${1}\" == '-nc' ]; then
		activate_colors='no'  # Do NOT display messages in color
	elif [ \"\${1}\" == '-nm' ]; then
		display_exit='no'     # Do NOT display exit message
	elif [ \"\${1}\" == '-o' ] || [ \"\${1}\" == '--open' ]; then
		open_script='yes'     # Open this script
	else # if option is undefined (for debugging)
		bad_inputs+=(\"ERROR:activate_options:\${1}\")
	fi
} # activate_options

color_formats () { # Print colorful terminal text
	if [ \"\${activate_colors}\" == 'yes' 2>/dev/null ]; then
		whi=\$(tput setab 0; tput setaf 7) # Black background, white text
		red=\$(tput setab 0; tput setaf 1) # Black background, red text
		ora=\$(tput setab 0; tput setaf 3) # Black background, orange text
		gre=\$(tput setab 0; tput setaf 2) # Black background, green text
		blu=\$(tput setab 0; tput setaf 4) # Black background, blue text
		pur=\$(tput setab 0; tput setaf 5) # Black background, purple text
		formatreset=\$(tput sgr0)          # Reset to default terminal settings
	fi
} # color_formats

control_bg_jobs () { # Controls number of background processes
	if [ \"\${max_bg_jobs}\" -eq '1' 2>/dev/null ]; then
		wait # Proceed after all background processes are finished
	else
		if [ \"\${max_bg_jobs}\" -gt '1' 2>/dev/null ] && [ \"\${max_bg_jobs}\" -le '10' 2>/dev/null ]; then 
			true # Make sure variable is defined and valid number
		elif [ \"\${max_bg_jobs}\" -gt '10' 2>/dev/null ]; then
			echo \"\${red}RESTRICTING BACKGROUND PROCESSES TO 10\${whi}\"
			max_bg_jobs='10' # Background jobs should not exceed '10' (Lowers risk of crashing)
		else # If 'max_bg_jobs' not defined as integer
			echo \"\${red}INVALID VALUE: \${ora}max_bg_jobs='\${gre}\${max_bg_jobs}\${ora}'\${whi}\"
			max_bg_jobs='1'
		fi
	
		job_count=(\$(jobs -p)) # Place job IDs into array
		if ! [ \"\$?\" -eq '0' ]; then # If 'jobs -p' command fails
			echo \"\${red}ERROR (\${ora}control_bg_jobs\${red}): \${ora}RESTRICTING BACKGROUND PROCESSES\${whi}\"
			max_bg_jobs='1'
			wait
		else
			if [ \"\${#job_count[@]}\" -ge \"\${max_bg_jobs}\" ]; then
				sleep 0.2 # Wait 0.2 seconds to prevent overflow errors
				control_bg_jobs # Check job count
			fi
		fi # if ! [ \"\$?\" -eq '0' ]
	fi # if [ \"\${max_bg_jobs}\" -eq '1' 2>/dev/null ]
} # control_bg_jobs

display_values () { # Display output with numbers
	if [ \"\${#@}\" -gt '0' ]; then
		val_count=(\$(seq 1 1 \${#@}))
		vals_and_count=(\$(paste -d \"\${IFS}\" <(printf \"%s\${IFS}\" \${val_count[@]}) <(printf \"%s\${IFS}\" \${@})))
		printf \"\${pur}[\${ora}%s\${pur}] \${gre}%s\${IFS}\${whi}\" \${vals_and_count[@]}
	fi
} # display_values

mac_readlink () { # Get absolute path of a file (mac and linux compatible)
	dir_mac=\$(dirname \"\${1}\")   # Directory path
	file_mac=\$(basename \"\${1}\") # Filename
	wd_mac=\$(pwd) # Working directory path

	if [ -d \"\${dir_mac}\" ]; then
		cd \"\${dir_mac}\"
		echo \"\$(pwd)/\${file_mac}\" # Print full path
		cd \"\${wd_mac}\" # Change back to original directory
	else
		echo \"\${1}\" # Print input
	fi
} # mac_readlink

open_text_editor () { # Opens input file in background (GUI text editors only)
	open_file=\"\${1}\"  # Input file
	valid_editor='no' # Remains 'no' until command is valid
	
	if [ -f \"\${open_file}\" ]; then # If input file exists
		for i in \${!text_editors[@]}; do # Loop through indices
			eval \"\${text_editors[\${i}]} \${open_file} 2>/dev/null &\" # eval for complex commands
			pid=\"\$!\" # Background process ID
			check_pid=(\$(ps \"\${pid}\" |grep \"\${pid}\")) # Check if pid is running
			
			if [ \"\${#check_pid[@]}\" -gt '0' ]; then
				valid_editor='yes'
				break
			fi # Break loop when valid command is found
		done

		if [ \"\${valid_editor}\" == 'no' 2>/dev/null ]; then
			echo \"\${red}NO VALID TEXT EDITOR COMMANDS IN \${ora}text_editors \${red}ARRAY:\${whi}\"
			printf \"\${ora}%s\${IFS}\${whi}\" \${text_editors[@]}
			exit_message 99 -nh -nm
		fi
	else # Missing input file
		echo \"\${red}MISSING FILE: \${ora}\${open_file}\${whi}\"
	fi # if [ -f \"\${open_file}\" ]; then
} # open_text_editor

vital_command () { # Exit script if command fails
	command_status=\"\$?\"
	command_line_number=\"\${1}\" # Must input as: vital_command \${LINENO}
	
	if ! [ -z \"\${command_status}\" ] && [ \"\${command_status}\" -ne '0' ]; then
		echo \"\${red}INVALID COMMAND: LINE \${ora}\${command_line_number}\${whi}\"
		exit_message 98 -nh -nm
	fi
} # vital_command

vital_file () { # Exit script if missing file
	for vitals; do
		if ! [ -e \"\${vitals}\" 2>/dev/null ]; then
			bad_files+=(\"\${vitals}\")
		fi
	done
	
	if [ \"\${#bad_files[@]}\" -gt '0' ]; then
		echo \"\${red}MISSING ESSENTIAL FILE(S):\${whi}\"
		printf \"\${pur}%s\${IFS}\${whi}\" \${bad_files[@]}
		exit_message 97 -nh -nm
	fi
} # vital_file

#-------------------------------- MESSAGES ---------------------------------#
control_c () { # Function activates after 'ctrl + c'
	echo \"\${red}FINISHING CURRENT BACKGROUND PROCESSES BEFORE CRASHING\${whi}\"
	exit_message 96 -nh
} # control_c

exit_message () { # Script exit message
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
	
	wait # Wait for background processes to finish

	# Suggest help message
	if [ \"\${suggest_help}\" == 'yes' 2>/dev/null ]; then
		echo \"\${ora}FOR HELP: \${gre}\${script_path} -h\${whi}\"
	fi
	
	# Display exit message
	if ! [ \"\${display_exit}\" == 'no' 2>/dev/null ]; then # Exit message
		echo \"\${pur}EXITING: \${ora}\${script_path}\${whi}\"
	fi
	
	printf \"\${formatreset}\\n\"
	IFS=\"\${IFS_old}\" # Reset IFS
	exit \"\${exit_type}\"
} # exit_message

#---------------------------------- CODE -----------------------------------#
trap control_c SIGINT 2>/dev/null # Finishes background processes before crashing
script_path=\$(mac_readlink \"\${script_path}\") # similar to 'readlink -f' in linux

for inputs; do # Read through all inputs
	option_eval \"\${inputs}\"
done

if ! [ \"\${clear_screen}\" == 'no' 2>/dev/null ]; then
	clear     # Clears screen unless input option: '-cs'
fi

color_formats # Activate or prevent colorful output

# Display help message or open script
if [ \"\${activate_help}\" == 'yes' 2>/dev/null ]; then # '-h' or '--help'
	usage # Display help message
elif [ \"\${open_script}\" == 'yes' 2>/dev/null ]; then # '-o' or '--open'
	open_text_editor \"\${script_path}\" # Open script
	exit_message 0 -nm
fi

# Exit script if invalid inputs
if [ \"\${#bad_inputs[@]}\" -gt '0' ]; then
	clear
	echo \"\${red}INVALID INPUT:\${whi}\"
	display_values \${bad_inputs[@]}
	exit_message 1
fi

exit_message 0"
} # create_script5

create_script6 () { # Exit message, vital_command/file
echo "#!/bin/bash
#--------------------------------------------------------------------------------------#
# Created: ${todays_date} By: ${script_author} (1.0) (${contact_info})
# Revised: ${todays_date} By: ${script_author}
#--------------------------------------------------------------------------------------#
#
#-------------------------------- VARIABLES --------------------------------#

#--------------------------- DEFAULT SETTINGS ------------------------------#
text_editors=('kwrite' 'kate' 'gedit' 'open -a /Applications/BBEdit.app' 'open') # GUI text editor commands in preference order

IFS_old=\"\${IFS}\" # whitespace separator
IFS=\$'\\n' # newline separator (useful when paths have whitespace)
#------------------------- SCRIPT HELP MESSAGE -----------------------------#
usage () { # Help message: '-h' or '--help' option
	echo \"\${red}HELP MESSAGE: \${gre}\${script_path}\${whi}
\${ora}DESCRIPTION\${whi}:
     
\${ora}ADVICE\${whi}: Create alias in \${ora}\${HOME}/.bashrc\${whi}
(e.g. \${gre}alias xx='\${script_path}'\${whi})
     
\${ora}USAGE\${whi}: Run script
 [\${ora}1\${whi}] \${gre}\${script_path}\${whi}
     
\${ora}OPTIONS\${whi}: Can input multiple options in any order
 \${pur}-cs\${whi}  Prevent clearing screen at start
 \${pur}-f\${whi}   Overwrite existing files
 \${pur}-h\${whi} or \${pur}--help\${whi}  Display this message
 \${pur}-nc\${whi}  Prevent color printing in terminal
 \${pur}-nm\${whi}  Prevent exit message from displaying
 \${pur}-o\${whi} or \${pur}--open\${whi} Open this script
     
\${ora}VERSION: \${gre}\${version}\${whi}
\${red}END OF HELP: \${gre}\${script_path}\${whi}\"
	exit_message 0 -nm
} # usage

#----------------------- GENERAL SCRIPT VARIABLES --------------------------#
script_path=\"\${BASH_SOURCE[0]}\" # Script path (becomes absolute path later)
version='1.0' # Script version number

	###--- 'yes' or 'no' options (inputs do the opposite of default) ---###
activate_colors='yes' # 'yes': Display messages in color [INPUT: '-nc']
activate_help='no'    # 'no' : Display help message      [INPUT: '-h' or '--help']
clear_screen='yes'    # 'yes': Clear screen at start     [INPUT: '-cs']
display_exit='yes'    # 'yes': Display an exit message   [INPUT: '-nm']
force_overwrite='no'  # 'no' : Overwrite output file(s)  [INPUT: '-f']
open_script='no'      # 'no' : Open this script          [INPUT: '-o' or '--open']
suggest_help='no'     # 'no' : Suggest help (within script option: '-nh')

#-------------------------------- FUNCTIONS --------------------------------#
option_eval () { # Evaluate user inputs
	if [ \"\${1}\" == '-cs' 2>/dev/null ] || [ \"\${1}\" == '-f' 2>/dev/null ] || \\
	   [ \"\${1}\" == '-h' 2>/dev/null ] || [ \"\${1}\" == '--help' 2>/dev/null ] || \\
	   [ \"\${1}\" == '-nc' 2>/dev/null ] || [ \"\${1}\" == '-nm' 2>/dev/null ] || \\
	   [ \"\${1}\" == '-o' 2>/dev/null ] || [ \"\${1}\" == '--open' 2>/dev/null ]; then
		activate_options \"\${1}\"
	elif [ \"\${1:0:1}\" == '-' 2>/dev/null ]; then
		bad_inputs+=(\"INVALID-OPTION:\${1}\")
	fi
} # option_eval

activate_options () { # Activate input options
	if [ \"\${1}\" == '-cs' ]; then
		clear_screen='no'     # Do NOT clear screen at start
	elif [ \"\${1}\" == '-f' ]; then
		force_overwrite='yes' # Overwrite files
	elif [ \"\${1}\" == '-h' ] || [ \"\${1}\" == '--help' ]; then
		activate_help='yes'   # Display help message
	elif [ \"\${1}\" == '-nc' ]; then
		activate_colors='no'  # Do NOT display messages in color
	elif [ \"\${1}\" == '-nm' ]; then
		display_exit='no'     # Do NOT display exit message
	elif [ \"\${1}\" == '-o' ] || [ \"\${1}\" == '--open' ]; then
		open_script='yes'     # Open this script
	else # if option is undefined (for debugging)
		bad_inputs+=(\"ERROR:activate_options:\${1}\")
	fi
} # activate_options

color_formats () { # Print colorful terminal text
	if [ \"\${activate_colors}\" == 'yes' 2>/dev/null ]; then
		whi=\$(tput setab 0; tput setaf 7) # Black background, white text
		red=\$(tput setab 0; tput setaf 1) # Black background, red text
		ora=\$(tput setab 0; tput setaf 3) # Black background, orange text
		gre=\$(tput setab 0; tput setaf 2) # Black background, green text
		blu=\$(tput setab 0; tput setaf 4) # Black background, blue text
		pur=\$(tput setab 0; tput setaf 5) # Black background, purple text
		formatreset=\$(tput sgr0)          # Reset to default terminal settings
	fi
} # color_formats

display_values () { # Display output with numbers
	if [ \"\${#@}\" -gt '0' ]; then
		val_count=(\$(seq 1 1 \${#@}))
		vals_and_count=(\$(paste -d \"\${IFS}\" <(printf \"%s\${IFS}\" \${val_count[@]}) <(printf \"%s\${IFS}\" \${@})))
		printf \"\${pur}[\${ora}%s\${pur}] \${gre}%s\${IFS}\${whi}\" \${vals_and_count[@]}
	fi
} # display_values

mac_readlink () { # Get absolute path of a file (mac and linux compatible)
	dir_mac=\$(dirname \"\${1}\")   # Directory path
	file_mac=\$(basename \"\${1}\") # Filename
	wd_mac=\$(pwd) # Working directory path

	if [ -d \"\${dir_mac}\" ]; then
		cd \"\${dir_mac}\"
		echo \"\$(pwd)/\${file_mac}\" # Print full path
		cd \"\${wd_mac}\" # Change back to original directory
	else
		echo \"\${1}\" # Print input
	fi
} # mac_readlink

open_text_editor () { # Opens input file in background (GUI text editors only)
	open_file=\"\${1}\"  # Input file
	valid_editor='no' # Remains 'no' until command is valid
	
	if [ -f \"\${open_file}\" ]; then # If input file exists
		for i in \${!text_editors[@]}; do # Loop through indices
			eval \"\${text_editors[\${i}]} \${open_file} 2>/dev/null &\" # eval for complex commands
			pid=\"\$!\" # Background process ID
			check_pid=(\$(ps \"\${pid}\" |grep \"\${pid}\")) # Check if pid is running
			
			if [ \"\${#check_pid[@]}\" -gt '0' ]; then
				valid_editor='yes'
				break
			fi # Break loop when valid command is found
		done

		if [ \"\${valid_editor}\" == 'no' 2>/dev/null ]; then
			echo \"\${red}NO VALID TEXT EDITOR COMMANDS IN \${ora}text_editors \${red}ARRAY:\${whi}\"
			printf \"\${ora}%s\${IFS}\${whi}\" \${text_editors[@]}
			exit_message 99 -nh -nm
		fi
	else # Missing input file
		echo \"\${red}MISSING FILE: \${ora}\${open_file}\${whi}\"
	fi # if [ -f \"\${open_file}\" ]; then
} # open_text_editor

vital_command () { # Exit script if command fails
	command_status=\"\$?\"
	command_line_number=\"\${1}\" # Must input as: vital_command \${LINENO}
	
	if ! [ -z \"\${command_status}\" ] && [ \"\${command_status}\" -ne '0' ]; then
		echo \"\${red}INVALID COMMAND: LINE \${ora}\${command_line_number}\${whi}\"
		exit_message 98 -nh -nm
	fi
} # vital_command

vital_file () { # Exit script if missing file
	for vitals; do
		if ! [ -e \"\${vitals}\" 2>/dev/null ]; then
			bad_files+=(\"\${vitals}\")
		fi
	done
	
	if [ \"\${#bad_files[@]}\" -gt '0' ]; then
		echo \"\${red}MISSING ESSENTIAL FILE(S):\${whi}\"
		printf \"\${pur}%s\${IFS}\${whi}\" \${bad_files[@]}
		exit_message 97 -nh -nm
	fi
} # vital_file

#-------------------------------- MESSAGES ---------------------------------#
exit_message () { # Script exit message
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
	
	wait # Wait for background processes to finish

	# Suggest help message
	if [ \"\${suggest_help}\" == 'yes' 2>/dev/null ]; then
		echo \"\${ora}FOR HELP: \${gre}\${script_path} -h\${whi}\"
	fi
	
	# Display exit message
	if ! [ \"\${display_exit}\" == 'no' 2>/dev/null ]; then # Exit message
		echo \"\${pur}EXITING: \${ora}\${script_path}\${whi}\"
	fi
	
	printf \"\${formatreset}\\n\"
	IFS=\"\${IFS_old}\" # Reset IFS
	exit \"\${exit_type}\"
} # exit_message

#---------------------------------- CODE -----------------------------------#
script_path=\$(mac_readlink \"\${script_path}\") # similar to 'readlink -f' in linux

for inputs; do # Read through all inputs
	option_eval \"\${inputs}\"
done

if ! [ \"\${clear_screen}\" == 'no' 2>/dev/null ]; then
	clear     # Clears screen unless input option: '-cs'
fi

color_formats # Activate or prevent colorful output

# Display help message or open script
if [ \"\${activate_help}\" == 'yes' 2>/dev/null ]; then # '-h' or '--help'
	usage # Display help message
elif [ \"\${open_script}\" == 'yes' 2>/dev/null ]; then # '-o' or '--open'
	open_text_editor \"\${script_path}\" # Open script
	exit_message 0 -nm
fi

# Exit script if invalid inputs
if [ \"\${#bad_inputs[@]}\" -gt '0' ]; then
	clear
	echo \"\${red}INVALID INPUT:\${whi}\"
	display_values \${bad_inputs[@]}
	exit_message 1
fi

exit_message 0"
} # create_script6

create_script7 () { # Exit message, bg functions
echo "#!/bin/bash
#--------------------------------------------------------------------------------------#
# Created: ${todays_date} By: ${script_author} (1.0) (${contact_info})
# Revised: ${todays_date} By: ${script_author}
#--------------------------------------------------------------------------------------#
#
#-------------------------------- VARIABLES --------------------------------#

#--------------------------- DEFAULT SETTINGS ------------------------------#
max_bg_jobs='5' # Maximum background processes (1-10)
text_editors=('kwrite' 'kate' 'gedit' 'open -a /Applications/BBEdit.app' 'open') # GUI text editor commands in preference order

IFS_old=\"\${IFS}\" # whitespace separator
IFS=\$'\\n' # newline separator (useful when paths have whitespace)
#------------------------- SCRIPT HELP MESSAGE -----------------------------#
usage () { # Help message: '-h' or '--help' option
	echo \"\${red}HELP MESSAGE: \${gre}\${script_path}\${whi}
\${ora}DESCRIPTION\${whi}:
     
\${ora}ADVICE\${whi}: Create alias in \${ora}\${HOME}/.bashrc\${whi}
(e.g. \${gre}alias xx='\${script_path}'\${whi})
     
\${ora}USAGE\${whi}: Run script
 [\${ora}1\${whi}] \${gre}\${script_path}\${whi}
     
\${ora}OPTIONS\${whi}: Can input multiple options in any order
 \${pur}-cs\${whi}  Prevent clearing screen at start
 \${pur}-f\${whi}   Overwrite existing files
 \${pur}-h\${whi} or \${pur}--help\${whi}  Display this message
 \${pur}-nc\${whi}  Prevent color printing in terminal
 \${pur}-nm\${whi}  Prevent exit message from displaying
 \${pur}-o\${whi} or \${pur}--open\${whi} Open this script
     
\${ora}VERSION: \${gre}\${version}\${whi}
\${red}END OF HELP: \${gre}\${script_path}\${whi}\"
	exit_message 0 -nm
} # usage

#----------------------- GENERAL SCRIPT VARIABLES --------------------------#
script_path=\"\${BASH_SOURCE[0]}\" # Script path (becomes absolute path later)
version='1.0' # Script version number

	###--- 'yes' or 'no' options (inputs do the opposite of default) ---###
activate_colors='yes' # 'yes': Display messages in color [INPUT: '-nc']
activate_help='no'    # 'no' : Display help message      [INPUT: '-h' or '--help']
clear_screen='yes'    # 'yes': Clear screen at start     [INPUT: '-cs']
display_exit='yes'    # 'yes': Display an exit message   [INPUT: '-nm']
force_overwrite='no'  # 'no' : Overwrite output file(s)  [INPUT: '-f']
open_script='no'      # 'no' : Open this script          [INPUT: '-o' or '--open']
suggest_help='no'     # 'no' : Suggest help (within script option: '-nh')

#-------------------------------- FUNCTIONS --------------------------------#
option_eval () { # Evaluate user inputs
	if [ \"\${1}\" == '-cs' 2>/dev/null ] || [ \"\${1}\" == '-f' 2>/dev/null ] || \\
	   [ \"\${1}\" == '-h' 2>/dev/null ] || [ \"\${1}\" == '--help' 2>/dev/null ] || \\
	   [ \"\${1}\" == '-nc' 2>/dev/null ] || [ \"\${1}\" == '-nm' 2>/dev/null ] || \\
	   [ \"\${1}\" == '-o' 2>/dev/null ] || [ \"\${1}\" == '--open' 2>/dev/null ]; then
		activate_options \"\${1}\"
	elif [ \"\${1:0:1}\" == '-' 2>/dev/null ]; then
		bad_inputs+=(\"INVALID-OPTION:\${1}\")
	fi
} # option_eval

activate_options () { # Activate input options
	if [ \"\${1}\" == '-cs' ]; then
		clear_screen='no'     # Do NOT clear screen at start
	elif [ \"\${1}\" == '-f' ]; then
		force_overwrite='yes' # Overwrite files
	elif [ \"\${1}\" == '-h' ] || [ \"\${1}\" == '--help' ]; then
		activate_help='yes'   # Display help message
	elif [ \"\${1}\" == '-nc' ]; then
		activate_colors='no'  # Do NOT display messages in color
	elif [ \"\${1}\" == '-nm' ]; then
		display_exit='no'     # Do NOT display exit message
	elif [ \"\${1}\" == '-o' ] || [ \"\${1}\" == '--open' ]; then
		open_script='yes'     # Open this script
	else # if option is undefined (for debugging)
		bad_inputs+=(\"ERROR:activate_options:\${1}\")
	fi
} # activate_options

color_formats () { # Print colorful terminal text
	if [ \"\${activate_colors}\" == 'yes' 2>/dev/null ]; then
		whi=\$(tput setab 0; tput setaf 7) # Black background, white text
		red=\$(tput setab 0; tput setaf 1) # Black background, red text
		ora=\$(tput setab 0; tput setaf 3) # Black background, orange text
		gre=\$(tput setab 0; tput setaf 2) # Black background, green text
		blu=\$(tput setab 0; tput setaf 4) # Black background, blue text
		pur=\$(tput setab 0; tput setaf 5) # Black background, purple text
		formatreset=\$(tput sgr0)          # Reset to default terminal settings
	fi
} # color_formats

control_bg_jobs () { # Controls number of background processes
	if [ \"\${max_bg_jobs}\" -eq '1' 2>/dev/null ]; then
		wait # Proceed after all background processes are finished
	else
		if [ \"\${max_bg_jobs}\" -gt '1' 2>/dev/null ] && [ \"\${max_bg_jobs}\" -le '10' 2>/dev/null ]; then 
			true # Make sure variable is defined and valid number
		elif [ \"\${max_bg_jobs}\" -gt '10' 2>/dev/null ]; then
			echo \"\${red}RESTRICTING BACKGROUND PROCESSES TO 10\${whi}\"
			max_bg_jobs='10' # Background jobs should not exceed '10' (Lowers risk of crashing)
		else # If 'max_bg_jobs' not defined as integer
			echo \"\${red}INVALID VALUE: \${ora}max_bg_jobs='\${gre}\${max_bg_jobs}\${ora}'\${whi}\"
			max_bg_jobs='1'
		fi
	
		job_count=(\$(jobs -p)) # Place job IDs into array
		if ! [ \"\$?\" -eq '0' ]; then # If 'jobs -p' command fails
			echo \"\${red}ERROR (\${ora}control_bg_jobs\${red}): \${ora}RESTRICTING BACKGROUND PROCESSES\${whi}\"
			max_bg_jobs='1'
			wait
		else
			if [ \"\${#job_count[@]}\" -ge \"\${max_bg_jobs}\" ]; then
				sleep 0.2 # Wait 0.2 seconds to prevent overflow errors
				control_bg_jobs # Check job count
			fi
		fi # if ! [ \"\$?\" -eq '0' ]
	fi # if [ \"\${max_bg_jobs}\" -eq '1' 2>/dev/null ]
} # control_bg_jobs

display_values () { # Display output with numbers
	if [ \"\${#@}\" -gt '0' ]; then
		val_count=(\$(seq 1 1 \${#@}))
		vals_and_count=(\$(paste -d \"\${IFS}\" <(printf \"%s\${IFS}\" \${val_count[@]}) <(printf \"%s\${IFS}\" \${@})))
		printf \"\${pur}[\${ora}%s\${pur}] \${gre}%s\${IFS}\${whi}\" \${vals_and_count[@]}
	fi
} # display_values

mac_readlink () { # Get absolute path of a file (mac and linux compatible)
	dir_mac=\$(dirname \"\${1}\")   # Directory path
	file_mac=\$(basename \"\${1}\") # Filename
	wd_mac=\$(pwd) # Working directory path

	if [ -d \"\${dir_mac}\" ]; then
		cd \"\${dir_mac}\"
		echo \"\$(pwd)/\${file_mac}\" # Print full path
		cd \"\${wd_mac}\" # Change back to original directory
	else
		echo \"\${1}\" # Print input
	fi
} # mac_readlink

open_text_editor () { # Opens input file in background (GUI text editors only)
	open_file=\"\${1}\"  # Input file
	valid_editor='no' # Remains 'no' until command is valid
	
	if [ -f \"\${open_file}\" ]; then # If input file exists
		for i in \${!text_editors[@]}; do # Loop through indices
			eval \"\${text_editors[\${i}]} \${open_file} 2>/dev/null &\" # eval for complex commands
			pid=\"\$!\" # Background process ID
			check_pid=(\$(ps \"\${pid}\" |grep \"\${pid}\")) # Check if pid is running
			
			if [ \"\${#check_pid[@]}\" -gt '0' ]; then
				valid_editor='yes'
				break
			fi # Break loop when valid command is found
		done

		if [ \"\${valid_editor}\" == 'no' 2>/dev/null ]; then
			echo \"\${red}NO VALID TEXT EDITOR COMMANDS IN \${ora}text_editors \${red}ARRAY:\${whi}\"
			printf \"\${ora}%s\${IFS}\${whi}\" \${text_editors[@]}
			exit_message 99 -nh -nm
		fi
	else # Missing input file
		echo \"\${red}MISSING FILE: \${ora}\${open_file}\${whi}\"
	fi # if [ -f \"\${open_file}\" ]; then
} # open_text_editor

#-------------------------------- MESSAGES ---------------------------------#
control_c () { # Function activates after 'ctrl + c'
	echo \"\${red}FINISHING CURRENT BACKGROUND PROCESSES BEFORE CRASHING\${whi}\"
	exit_message 98 -nh
} # control_c

exit_message () { # Script exit message
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
	
	wait # Wait for background processes to finish

	# Suggest help message
	if [ \"\${suggest_help}\" == 'yes' 2>/dev/null ]; then
		echo \"\${ora}FOR HELP: \${gre}\${script_path} -h\${whi}\"
	fi
	
	# Display exit message
	if ! [ \"\${display_exit}\" == 'no' 2>/dev/null ]; then # Exit message
		echo \"\${pur}EXITING: \${ora}\${script_path}\${whi}\"
	fi
	
	printf \"\${formatreset}\\n\"
	IFS=\"\${IFS_old}\" # Reset IFS
	exit \"\${exit_type}\"
} # exit_message

#---------------------------------- CODE -----------------------------------#
trap control_c SIGINT 2>/dev/null # Finishes background processes before crashing
script_path=\$(mac_readlink \"\${script_path}\") # similar to 'readlink -f' in linux

for inputs; do # Read through all inputs
	option_eval \"\${inputs}\"
done

if ! [ \"\${clear_screen}\" == 'no' 2>/dev/null ]; then
	clear     # Clears screen unless input option: '-cs'
fi

color_formats # Activate or prevent colorful output

# Display help message or open script
if [ \"\${activate_help}\" == 'yes' 2>/dev/null ]; then # '-h' or '--help'
	usage # Display help message
elif [ \"\${open_script}\" == 'yes' 2>/dev/null ]; then # '-o' or '--open'
	open_text_editor \"\${script_path}\" # Open script
	exit_message 0 -nm
fi

# Exit script if invalid inputs
if [ \"\${#bad_inputs[@]}\" -gt '0' ]; then
	clear
	echo \"\${red}INVALID INPUT:\${whi}\"
	display_values \${bad_inputs[@]}
	exit_message 1
fi

exit_message 0"
} # create_script7

create_script8 () { # Exit message
echo "#!/bin/bash
#--------------------------------------------------------------------------------------#
# Created: ${todays_date} By: ${script_author} (1.0) (${contact_info})
# Revised: ${todays_date} By: ${script_author}
#--------------------------------------------------------------------------------------#
#
#-------------------------------- VARIABLES --------------------------------#

#--------------------------- DEFAULT SETTINGS ------------------------------#
text_editors=('kwrite' 'kate' 'gedit' 'open -a /Applications/BBEdit.app' 'open') # GUI text editor commands in preference order

IFS_old=\"\${IFS}\" # whitespace separator
IFS=\$'\\n' # newline separator (useful when paths have whitespace)
#------------------------- SCRIPT HELP MESSAGE -----------------------------#
usage () { # Help message: '-h' or '--help' option
	echo \"\${red}HELP MESSAGE: \${gre}\${script_path}\${whi}
\${ora}DESCRIPTION\${whi}:
     
\${ora}ADVICE\${whi}: Create alias in \${ora}\${HOME}/.bashrc\${whi}
(e.g. \${gre}alias xx='\${script_path}'\${whi})
     
\${ora}USAGE\${whi}: Run script
 [\${ora}1\${whi}] \${gre}\${script_path}\${whi}
     
\${ora}OPTIONS\${whi}: Can input multiple options in any order
 \${pur}-cs\${whi}  Prevent clearing screen at start
 \${pur}-f\${whi}   Overwrite existing files
 \${pur}-h\${whi} or \${pur}--help\${whi}  Display this message
 \${pur}-nc\${whi}  Prevent color printing in terminal
 \${pur}-nm\${whi}  Prevent exit message from displaying
 \${pur}-o\${whi} or \${pur}--open\${whi} Open this script
     
\${ora}VERSION: \${gre}\${version}\${whi}
\${red}END OF HELP: \${gre}\${script_path}\${whi}\"
	exit_message 0 -nm
} # usage

#----------------------- GENERAL SCRIPT VARIABLES --------------------------#
script_path=\"\${BASH_SOURCE[0]}\" # Script path (becomes absolute path later)
version='1.0' # Script version number

	###--- 'yes' or 'no' options (inputs do the opposite of default) ---###
activate_colors='yes' # 'yes': Display messages in color [INPUT: '-nc']
activate_help='no'    # 'no' : Display help message      [INPUT: '-h' or '--help']
clear_screen='yes'    # 'yes': Clear screen at start     [INPUT: '-cs']
display_exit='yes'    # 'yes': Display an exit message   [INPUT: '-nm']
force_overwrite='no'  # 'no' : Overwrite output file(s)  [INPUT: '-f']
open_script='no'      # 'no' : Open this script          [INPUT: '-o' or '--open']
suggest_help='no'     # 'no' : Suggest help (within script option: '-nh')

#-------------------------------- FUNCTIONS --------------------------------#
option_eval () { # Evaluate user inputs
	if [ \"\${1}\" == '-cs' 2>/dev/null ] || [ \"\${1}\" == '-f' 2>/dev/null ] || \\
	   [ \"\${1}\" == '-h' 2>/dev/null ] || [ \"\${1}\" == '--help' 2>/dev/null ] || \\
	   [ \"\${1}\" == '-nc' 2>/dev/null ] || [ \"\${1}\" == '-nm' 2>/dev/null ] || \\
	   [ \"\${1}\" == '-o' 2>/dev/null ] || [ \"\${1}\" == '--open' 2>/dev/null ]; then
		activate_options \"\${1}\"
	elif [ \"\${1:0:1}\" == '-' 2>/dev/null ]; then
		bad_inputs+=(\"INVALID-OPTION:\${1}\")
	fi
} # option_eval

activate_options () { # Activate input options
	if [ \"\${1}\" == '-cs' ]; then
		clear_screen='no'     # Do NOT clear screen at start
	elif [ \"\${1}\" == '-f' ]; then
		force_overwrite='yes' # Overwrite files
	elif [ \"\${1}\" == '-h' ] || [ \"\${1}\" == '--help' ]; then
		activate_help='yes'   # Display help message
	elif [ \"\${1}\" == '-nc' ]; then
		activate_colors='no'  # Do NOT display messages in color
	elif [ \"\${1}\" == '-nm' ]; then
		display_exit='no'     # Do NOT display exit message
	elif [ \"\${1}\" == '-o' ] || [ \"\${1}\" == '--open' ]; then
		open_script='yes'     # Open this script
	else # if option is undefined (for debugging)
		bad_inputs+=(\"ERROR:activate_options:\${1}\")
	fi
} # activate_options

color_formats () { # Print colorful terminal text
	if [ \"\${activate_colors}\" == 'yes' 2>/dev/null ]; then
		whi=\$(tput setab 0; tput setaf 7) # Black background, white text
		red=\$(tput setab 0; tput setaf 1) # Black background, red text
		ora=\$(tput setab 0; tput setaf 3) # Black background, orange text
		gre=\$(tput setab 0; tput setaf 2) # Black background, green text
		blu=\$(tput setab 0; tput setaf 4) # Black background, blue text
		pur=\$(tput setab 0; tput setaf 5) # Black background, purple text
		formatreset=\$(tput sgr0)          # Reset to default terminal settings
	fi
} # color_formats

display_values () { # Display output with numbers
	if [ \"\${#@}\" -gt '0' ]; then
		val_count=(\$(seq 1 1 \${#@}))
		vals_and_count=(\$(paste -d \"\${IFS}\" <(printf \"%s\${IFS}\" \${val_count[@]}) <(printf \"%s\${IFS}\" \${@})))
		printf \"\${pur}[\${ora}%s\${pur}] \${gre}%s\${IFS}\${whi}\" \${vals_and_count[@]}
	fi
} # display_values

mac_readlink () { # Get absolute path of a file (mac and linux compatible)
	dir_mac=\$(dirname \"\${1}\")   # Directory path
	file_mac=\$(basename \"\${1}\") # Filename
	wd_mac=\$(pwd) # Working directory path

	if [ -d \"\${dir_mac}\" ]; then
		cd \"\${dir_mac}\"
		echo \"\$(pwd)/\${file_mac}\" # Print full path
		cd \"\${wd_mac}\" # Change back to original directory
	else
		echo \"\${1}\" # Print input
	fi
} # mac_readlink

open_text_editor () { # Opens input file in background (GUI text editors only)
	open_file=\"\${1}\"  # Input file
	valid_editor='no' # Remains 'no' until command is valid
	
	if [ -f \"\${open_file}\" ]; then # If input file exists
		for i in \${!text_editors[@]}; do # Loop through indices
			eval \"\${text_editors[\${i}]} \${open_file} 2>/dev/null &\" # eval for complex commands
			pid=\"\$!\" # Background process ID
			check_pid=(\$(ps \"\${pid}\" |grep \"\${pid}\")) # Check if pid is running
			
			if [ \"\${#check_pid[@]}\" -gt '0' ]; then
				valid_editor='yes'
				break
			fi # Break loop when valid command is found
		done

		if [ \"\${valid_editor}\" == 'no' 2>/dev/null ]; then
			echo \"\${red}NO VALID TEXT EDITOR COMMANDS IN \${ora}text_editors \${red}ARRAY:\${whi}\"
			printf \"\${ora}%s\${IFS}\${whi}\" \${text_editors[@]}
			exit_message 99 -nh -nm
		fi
	else # Missing input file
		echo \"\${red}MISSING FILE: \${ora}\${open_file}\${whi}\"
	fi # if [ -f \"\${open_file}\" ]; then
} # open_text_editor

#-------------------------------- MESSAGES ---------------------------------#
exit_message () { # Script exit message
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
	
	wait # Wait for background processes to finish

	# Suggest help message
	if [ \"\${suggest_help}\" == 'yes' 2>/dev/null ]; then
		echo \"\${ora}FOR HELP: \${gre}\${script_path} -h\${whi}\"
	fi
	
	# Display exit message
	if ! [ \"\${display_exit}\" == 'no' 2>/dev/null ]; then # Exit message
		echo \"\${pur}EXITING: \${ora}\${script_path}\${whi}\"
	fi
	
	printf \"\${formatreset}\\n\"
	IFS=\"\${IFS_old}\" # Reset IFS
	exit \"\${exit_type}\"
} # exit_message

#---------------------------------- CODE -----------------------------------#
script_path=\$(mac_readlink \"\${script_path}\") # similar to 'readlink -f' in linux

for inputs; do # Read through all inputs
	option_eval \"\${inputs}\"
done

if ! [ \"\${clear_screen}\" == 'no' 2>/dev/null ]; then
	clear     # Clears screen unless input option: '-cs'
fi

color_formats # Activate or prevent colorful output

# Display help message or open script
if [ \"\${activate_help}\" == 'yes' 2>/dev/null ]; then # '-h' or '--help'
	usage # Display help message
elif [ \"\${open_script}\" == 'yes' 2>/dev/null ]; then # '-o' or '--open'
	open_text_editor \"\${script_path}\" # Open script
	exit_message 0 -nm
fi

# Exit script if invalid inputs
if [ \"\${#bad_inputs[@]}\" -gt '0' ]; then
	clear
	echo \"\${red}INVALID INPUT:\${whi}\"
	display_values \${bad_inputs[@]}
	exit_message 1
fi

exit_message 0"
} # create_script8

create_script9 () { # Basic functions
echo "#!/bin/bash
#--------------------------------------------------------------------------------------#
# Created: ${todays_date} By: ${script_author} (1.0) (${contact_info})
# Revised: ${todays_date} By: ${script_author}
#--------------------------------------------------------------------------------------#
#
#-------------------------------- VARIABLES --------------------------------#

#--------------------------- DEFAULT SETTINGS ------------------------------#
text_editors=('kwrite' 'kate' 'gedit' 'open -a /Applications/BBEdit.app' 'open') # GUI text editor commands in preference order

IFS_old=\"\${IFS}\" # whitespace separator
IFS=\$'\\n' # newline separator (useful when paths have whitespace)
#------------------------- SCRIPT HELP MESSAGE -----------------------------#
usage () { # Help message: '-h' or '--help' option
	echo \"\${red}HELP MESSAGE: \${gre}\${script_path}\${whi}
\${ora}DESCRIPTION\${whi}:
     
\${ora}ADVICE\${whi}: Create alias in \${ora}\${HOME}/.bashrc\${whi}
(e.g. \${gre}alias xx='\${script_path}'\${whi})
     
\${ora}USAGE\${whi}: Run script
 [\${ora}1\${whi}] \${gre}\${script_path}\${whi}
     
\${ora}OPTIONS\${whi}: Can input multiple options in any order
 \${pur}-cs\${whi}  Prevent clearing screen at start
 \${pur}-f\${whi}   Overwrite existing files
 \${pur}-h\${whi} or \${pur}--help\${whi}  Display this message
 \${pur}-nc\${whi}  Prevent color printing in terminal
 \${pur}-o\${whi} or \${pur}--open\${whi} Open this script
     
\${ora}VERSION: \${gre}\${version}\${whi}
\${red}END OF HELP: \${gre}\${script_path}\${whi}\"
	exit 0
} # usage

#----------------------- GENERAL SCRIPT VARIABLES --------------------------#
script_path=\"\${BASH_SOURCE[0]}\" # Script path (becomes absolute path later)
version='1.0' # Script version number

	###--- 'yes' or 'no' options (inputs do the opposite of default) ---###
activate_colors='yes' # 'yes': Display messages in color [INPUT: '-nc']
activate_help='no'    # 'no' : Display help message      [INPUT: '-h' or '--help']
clear_screen='yes'    # 'yes': Clear screen at start     [INPUT: '-cs']
force_overwrite='no'  # 'no' : Overwrite output file(s)  [INPUT: '-f']
open_script='no'      # 'no' : Open this script          [INPUT: '-o' or '--open']
suggest_help='no'     # 'no' : Suggest help (within script option: '-nh')

#-------------------------------- FUNCTIONS --------------------------------#
option_eval () { # Evaluate user inputs
	if [ \"\${1}\" == '-cs' 2>/dev/null ] || [ \"\${1}\" == '-f' 2>/dev/null ] || \\
	   [ \"\${1}\" == '-h' 2>/dev/null ] || [ \"\${1}\" == '--help' 2>/dev/null ] || \\
	   [ \"\${1}\" == '-nc' 2>/dev/null ] || [ \"\${1}\" == '-o' 2>/dev/null ] || \\
	   [ \"\${1}\" == '--open' 2>/dev/null ]; then
		activate_options \"\${1}\"
	elif [ \"\${1:0:1}\" == '-' 2>/dev/null ]; then
		bad_inputs+=(\"INVALID-OPTION:\${1}\")
	fi
} # option_eval

activate_options () { # Activate input options
	if [ \"\${1}\" == '-cs' ]; then
		clear_screen='no'     # Do NOT clear screen at start
	elif [ \"\${1}\" == '-f' ]; then
		force_overwrite='yes' # Overwrite files
	elif [ \"\${1}\" == '-h' ] || [ \"\${1}\" == '--help' ]; then
		activate_help='yes'   # Display help message
	elif [ \"\${1}\" == '-nc' ]; then
		activate_colors='no'  # Do NOT display messages in color
	elif [ \"\${1}\" == '-o' ] || [ \"\${1}\" == '--open' ]; then
		open_script='yes'     # Open this script
	else # if option is undefined (for debugging)
		bad_inputs+=(\"ERROR:activate_options:\${1}\")
	fi
} # activate_options

color_formats () { # Print colorful terminal text
	if [ \"\${activate_colors}\" == 'yes' 2>/dev/null ]; then
		whi=\$(tput setab 0; tput setaf 7) # Black background, white text
		red=\$(tput setab 0; tput setaf 1) # Black background, red text
		ora=\$(tput setab 0; tput setaf 3) # Black background, orange text
		gre=\$(tput setab 0; tput setaf 2) # Black background, green text
		blu=\$(tput setab 0; tput setaf 4) # Black background, blue text
		pur=\$(tput setab 0; tput setaf 5) # Black background, purple text
		formatreset=\$(tput sgr0)          # Reset to default terminal settings
	fi
} # color_formats

display_values () { # Display output with numbers
	if [ \"\${#@}\" -gt '0' ]; then
		val_count=(\$(seq 1 1 \${#@}))
		vals_and_count=(\$(paste -d \"\${IFS}\" <(printf \"%s\${IFS}\" \${val_count[@]}) <(printf \"%s\${IFS}\" \${@})))
		printf \"\${pur}[\${ora}%s\${pur}] \${gre}%s\${IFS}\${whi}\" \${vals_and_count[@]}
	fi
} # display_values

mac_readlink () { # Get absolute path of a file (mac and linux compatible)
	dir_mac=\$(dirname \"\${1}\")   # Directory path
	file_mac=\$(basename \"\${1}\") # Filename
	wd_mac=\$(pwd) # Working directory path

	if [ -d \"\${dir_mac}\" ]; then
		cd \"\${dir_mac}\"
		echo \"\$(pwd)/\${file_mac}\" # Print full path
		cd \"\${wd_mac}\" # Change back to original directory
	else
		echo \"\${1}\" # Print input
	fi
} # mac_readlink

open_text_editor () { # Opens input file in background (GUI text editors only)
	open_file=\"\${1}\"  # Input file
	valid_editor='no' # Remains 'no' until command is valid
	
	if [ -f \"\${open_file}\" ]; then # If input file exists
		for i in \${!text_editors[@]}; do # Loop through indices
			eval \"\${text_editors[\${i}]} \${open_file} 2>/dev/null &\" # eval for complex commands
			pid=\"\$!\" # Background process ID
			check_pid=(\$(ps \"\${pid}\" |grep \"\${pid}\")) # Check if pid is running
			
			if [ \"\${#check_pid[@]}\" -gt '0' ]; then
				valid_editor='yes'
				break
			fi # Break loop when valid command is found
		done

		if [ \"\${valid_editor}\" == 'no' 2>/dev/null ]; then
			echo \"\${red}NO VALID TEXT EDITOR COMMANDS IN \${ora}text_editors \${red}ARRAY:\${whi}\"
			printf \"\${ora}%s\${IFS}\${whi}\" \${text_editors[@]}
			exit 99
		fi
	else # Missing input file
		echo \"\${red}MISSING FILE: \${ora}\${open_file}\${whi}\"
	fi # if [ -f \"\${open_file}\" ]; then
} # open_text_editor

#---------------------------------- CODE -----------------------------------#
script_path=\$(mac_readlink \"\${script_path}\") # similar to 'readlink -f' in linux

for inputs; do # Read through all inputs
	option_eval \"\${inputs}\"
done

if ! [ \"\${clear_screen}\" == 'no' 2>/dev/null ]; then
	clear     # Clears screen unless input option: '-cs'
fi

color_formats # Activate or prevent colorful output

# Display help message or open script
if [ \"\${activate_help}\" == 'yes' 2>/dev/null ]; then # '-h' or '--help'
	usage # Display help message
elif [ \"\${open_script}\" == 'yes' 2>/dev/null ]; then # '-o' or '--open'
	open_text_editor \"\${script_path}\" # Open script
	exit 0
fi

# Exit script if invalid inputs
if [ \"\${#bad_inputs[@]}\" -gt '0' ]; then
	clear
	echo \"\${red}INVALID INPUT:\${whi}\"
	display_values \${bad_inputs[@]}
	exit 1
fi

exit 0"
} # create_script9

create_script10 () { # Header information only
echo "#!/bin/bash
#--------------------------------------------------------------------------------------#
# Created: ${todays_date} By: ${script_author} (${contact_info})
# Revised: ${todays_date} By: ${script_author}
#--------------------------------------------------------------------------------------#
#
#-------------------------------- VARIABLES --------------------------------#
IFS_old=\"\${IFS}\" # whitespace separator
IFS=\$'\\n' # newline separator (needed when paths have whitespace)
#---------------------------------- CODE -----------------------------------#

IFS=\"\${IFS_old}\"
exit 0"
} # create_script10

option_eval () { # Evaluates command line options

	check_n () { # check integer value for n
		if [ "${1}" -eq "${1}" 2>/dev/null ] && [ "${1}" -gt '0' 2>/dev/null ] && \
		   [ -z "${n_script}" 2>/dev/null ]; then
			n_script="${1}"
		else
			bad_inputs+=("-n:${1}")
		fi
	} # check_n
	
	check_p () { # check integer value for p
		if [ "${#check_permission[@]}" -eq '1' ] && [ "${#check_permission[0]}" -eq '3' ]; then
			perm="${1}"
		else
			bad_inputs+=("-p:${1}")
		fi
	} # check_p
	
	check_permission=($(echo "${1}" |grep '[0-7][0-7][0-7]' |sed 's@^-p@@g'))
	
	if [ "${1}" == '-h' 2>/dev/null ] || [ "${1}" == '--help' 2>/dev/null ] || \
	   [ "${1}" == '-i' 2>/dev/null ] || [ "${1}" == '-l' 2>/dev/null ] || \
	   [ "${1}" == '-n' 2>/dev/null ] || [ "${1}" == '-nc' 2>/dev/null ] || \
	   [ "${1}" == '-o' 2>/dev/null ] || [ "${1}" == '--open' 2>/dev/null ] || \
	   [ "${1}" == '-p' 2>/dev/null ]; then
		activate_options "${1}"
	elif [ "${1:0:2}" == '-n' 2>/dev/null ]; then # If no space between '-n' and number
		check_n "${1:2}" # Check value after '-n'
	elif [ "${1:0:2}" == '-p' 2>/dev/null ]; then # If no space between '-p' and number
		check_p "${1:2}" # Check value after '-p'
	elif ! [ -z "${n_in}" 2>/dev/null ] && [ "${n_in}" == 'yes' 2>/dev/null ]; then
		check_n "${1}"
		n_in='no'
	elif ! [ -z "${p_in}" 2>/dev/null ] && [ "${p_in}" == 'yes' 2>/dev/null ]; then
		check_p "${1}"
		p_in='no'
	elif [ "${1:0:1}" == '-' 2>/dev/null ]; then
		bad_inputs+=("${1}")
	else
		if ! [ "${filename_reader}" == 'off' 2>/dev/null ]; then
			filename="${1}"
			filename_reader='off'
		else # Alert user of multiple filename inputs
			check_filenames=($(printf '%s\n' ${bad_inputs[@]} |grep "^MULTIPLE_FILENAME_INPUTS:${filename}$"))
			if [ "${#check_filenames[@]}" -eq '0' ]; then
				bad_inputs+=("MULTIPLE_FILENAME_INPUTS:${filename}" "MULTIPLE_FILENAME_INPUTS:${1}")
			else
				bad_inputs+=("MULTIPLE_FILENAME_INPUTS:${1}")
			fi
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
		display_scripts='yes' # List script explanations
	elif [ "${1}" == '-n' ]; then
		n_in='yes'            # Which script number to create
	elif [ "${1}" == '-nc' ]; then
		activate_colors='no'  # Do not display in color	
	elif [ "${1}" == '-o' ] || [ "${1}" == '--open' ]; then
		open_script='yes'     # Open this script
	elif [ "${1}" == '-p' ]; then
		p_in='yes'            # Input permission value
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

create_script () { # Creates, activates and opens new shell script
	"${script_function}" > "${filename}" || error_script_create "${filename}"
	chmod "${perm}" "${filename}" # Automatically activates script
	echo "${gre}CREATED (${pur}${n_script}${gre}): ${ora}${file_path}${whi}"
			
	if [ "${open_file}" == 'yes' 2>/dev/null ]; then
		open_text_editor "${filename}" # open new script
	fi
} # create_script

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
			invalid_msg "${overwrite_file}"
			echo "${ora}QUIT [${red}q${ora}]${whi}"
			read_filename
		fi
	else
		create_script
	fi
} # read_filename

#-------------------------------- MESSAGES ---------------------------------#
error_script_create () { # Error message if script could not be created
	echo "${red}COULD NOT CREATE: ${ora}${1}${whi}"
	exit_message 98
} # error_script_create

exit_message () { # Message before exiting script
	if [ -z "${1}" 2>/dev/null ] || ! [ "${1}" -eq "${1}" 2>/dev/null ]; then
		exit_type='0'
	else
		exit_type="${1}"
	fi
	
	# Suggest help message
	if [ "${exit_type}" -ne '0' 2>/dev/null ]; then
		echo "${ora}FOR HELP: ${gre}${script_path} -h${whi}"
	fi
	
	printf "${formatreset}\n"
	exit "${exit_type}"
} # exit_message

script_display () { # '-l' option
	script_count=(`grep '^create_script[0-9]' "${script_path}" |grep '() {' |awk '{print $1}' |sed 's@create_script@@g'`)
	creation_scripts=(`grep '^create_script[0-9]' "${script_path}" |grep '() {' |sed 's@ @+-+@g' |awk -F '#' '{print $2}'`)
	
	for i_count in ${!script_count[@]}; do
		echo "${whi}[${ora}${script_count[${i_count}]}${whi}]${gre}$(echo ${creation_scripts[${i_count}]} |sed 's@+-+@ @g')${whi}"
	done
	exit_message 0
} # script_display

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

clear

color_formats # Activates or prevent colorful output

# Display help message or open script
if [ "${activate_help}" == 'yes' 2>/dev/null ]; then # '-h' or '--help'
	usage # Display help message
elif [ "${open_script}" == 'yes' 2>/dev/null ]; then # '-o' or '--open'
	open_text_editor "${script_path}"
	exit_message 0
fi

# Exit script if invalid inputs found
if [ "${#bad_inputs[@]}" -gt '0' ]; then
	invalid_msg ${bad_inputs[@]}
	exit_message 1
fi

if [ -z "${n_script}" 2>/dev/null ]; then
	n_script="${default_script}" # Create default template
fi

if [ "${display_scripts}" == 'yes' 2>/dev/null ]; then # '-l'
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