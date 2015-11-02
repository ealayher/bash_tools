#!/bin/bash
#--------------------------------------------------------------------------------------#
# Created: 09/12/2014 By: Evan Layher (evan.layher@psych.ucsb.edu)
# Revised: 06/02/2015 By: Evan Layher
# Revised: 11/01/2015 By: Evan Layher (2.0) Mac compatible and accepts files with spaces
#--------------------------------------------------------------------------------------#
# Save backup copies of scripts and easily retrieve them when needed
#-------------------------------- VARIABLES --------------------------------#
backup_dir="${HOME}/.ealayher/code_backup"
option_file="${backup_dir}/code_backup_options.ini"
recycle_bin="${backup_dir}/.code_backup_recycle_bin"
time_file="${backup_dir}/.code_backup_times"

#--------------------------- DEFAULT SETTINGS ------------------------------#
default_text_editors=('kwrite' 'gedit' 'open -a /Applications/TextWrangler.app' 'open' 'nano' 'emacs') # text editor commands in order of preference
default_max_files='10' # Default maximum number of backup files per file
default_script_exts=('.bash' '.csh' '.ksh' '.m' '.py' '.sh' '.tcsh' '.zsh') # Default script extensions

IFS_original="${IFS}" # whitespace separator
IFS=$'\n' # newline separator (needed when paths have whitespace)
#----------------------- GENERAL SCRIPT VARIABLES --------------------------#
script_path="${BASH_SOURCE[0]}" # Script path (becomes absolute path later)
version_number='2.0' # Script version number

	###--- 'yes' or 'no' options (inputs do the opposite of default) ---###
activate_colors='yes' # 'yes': Display messages in color [INPUT: '-nc']
activate_help='no'    # 'no' : Display help message      [INPUT: '-h' or '--help']
clear_screen='yes'    # 'yes': Clear screen at start     [INPUT: '-cs']
empty_rec_bin='no'    # 'no' : Empty recycle bin         [INPUT: '-empty']
get_all='no'          # 'no' : Get all backups           [INPUT: '-all']
get_sub_dirs='no'     # 'no' : Get all sub-directories   [INPUT: '-sub']
list_settings='no'    # 'no' : List user settings        [INPUT: '-l']
open_script='no'      # 'no' : Open this script          [INPUT: '-o' or '--open']
retrieve='no'         # 'no' : Retrieve backup file(s)   [INPUT: '-r']
remove_backup='no'    # 'no' : Remove obsolete backup(s) [INPUT: '-rem']
suggest_help='no'     # 'no' : Suggest help (within script option: '-nh')

#-------------------------------- FUNCTIONS --------------------------------#
option_eval () { # Evaluate inputs
	if [ "${1}" == '-all' 2>/dev/null ] || [ "${1}" == '-cs' 2>/dev/null ] || \
	[ "${1}" == '-e' 2>/dev/null ] || [ "${1}" == '-empty' 2>/dev/null ] || \
	[ "${1}" == '-er' 2>/dev/null ] || [ "${1}" == '-h' 2>/dev/null ] || \
	[ "${1}" == '--help' 2>/dev/null ] || [ "${1}" == '-l' 2>/dev/null ] || \
	[ "${1}" == '-m' 2>/dev/null ] || [ "${1}" == '-nc' 2>/dev/null ] || \
	[ "${1}" == '-o' 2>/dev/null ] || [ "${1}" == '--open' 2>/dev/null ] || \
	[ "${1}" == '-r' 2>/dev/null ] || [ "${1}" == '-rem' 2>/dev/null ] || \
	[ "${1}" == '-sub' 2>/dev/null ] || [ "${1}" == '-t' 2>/dev/null ] || \
	[ "${1}" == '-tr' 2>/dev/null ]; then
		activate_options "${1}"
	elif [ -e "${1}" ]; then
		full_file_path=$(mac_readlink "${1}") # variable needed for paths containing whitespace
		backup_files+=("${full_file_path}")
	elif [ "${e_in}" == 'yes' 2>/dev/null ]; then
		add_exts+=("${1}") # Add default script extensions
	elif [ "${er_in}" == 'yes' 2>/dev/null ]; then
		rem_exts+=("${1}") # Remove default script extensions
	elif [ "${m_in}" == 'yes' 2>/dev/null ]; then
	m_in='no'
		if [ "${1}" -ge '2' ] && [ "${1}" -le '99' ]; then
			create_option_file
			list_settings='yes' # list user settings
			old_m_val=$(grep '^max_files=' "${option_file}")
			new_m_val="max_files=${1}"
			sed -i '' -e "s@${old_m_val}@${new_m_val}@g" "${option_file}" 2>/dev/null  # '' -e for mac
		else # Value must be from 2 to 99
			bad_inputs+=("-m<2-99>:${1}")
		fi
	elif [ "${t_in}" == 'yes' 2>/dev/null ]; then
		add_editors+=("${1}") # Add text editors
	elif [ "${tr_in}" == 'yes' 2>/dev/null ]; then
		rem_editors+=("${1}") # Remove text editors
	else # Check if backup file exists (when actual file is missing)
		check_backup_file=$(mac_readlink "${1}") # Get input full path
		check_backup="${backup_dir}${check_backup_file}" # Check if backup exists when file does not
			if [ -d "${check_backup}" ]; then
				get_files+=("${check_backup}")
			else
				check_for_dir=$(dirname "${check_backup}")
				if [ -d "${check_for_dir}" ]; then
					check_for_file=$(basename "${check_backup}")
					check_for_backups=($(find "${check_for_dir}" -maxdepth 1 -type f -name "${check_for_file}_[0-9][0-9]"))
				fi
				
				if [ ${#check_for_backups[@]} -eq '0' ]; then
					bad_inputs+=("${1}")
				else
					get_files+=("${check_backup}")
				fi
				check_for_backups=() # Reset array
			fi
	fi
} # option_eval

activate_options () { # Activate input options
	e_in='no'  # Add file extension
	er_in='no' # Remove file extension
	m_in='no'  # Change maximum number of backup files
	t_in='no'  # Add text editor
	tr_in='no' # Remove text editor
	
	if [ "${1}" == '-all' ]; then
		get_all='yes'        # Get all backups
	elif [ "${1}" == '-cs' ]; then
		clear_screen='no'    # Do NOT clear screen at start
	elif [ "${1}" == '-e' ]; then
		e_in='yes'           # Add file extension
	elif [ "${1}" == '-empty' ]; then
		empty_rec_bin='yes'  # Empty recycle bin
		remove_backup='yes'  # Remove backup file(s)
	elif [ "${1}" == '-er' ]; then
		er_in='yes'          # Remove file extension
	elif [ "${1}" == '-h' ] || [ "${1}" == '--help' ]; then
		activate_help='yes'  # Display help message
	elif [ "${1}" == '-l' ]; then
		list_settings='yes'  # List user settings
	elif [ "${1}" == '-m' ]; then
		m_in='yes'           # Change maximum number of backup files
	elif [ "${1}" == '-r' ]; then
		retrieve='yes'       # Retrieve backup file(s)
	elif [ "${1}" == '-rem' ]; then
		remove_backup='yes'  # Remove backup file(s)
	elif [ "${1}" == '-nc' ]; then
		activate_colors='no' # Do NOT display messages in color
	elif [ "${1}" == '-o' ] || [ "${1}" == '--open' ]; then
		open_script='yes'    # Open this script
	elif [ "${1}" == '-sub' ]; then
		get_sub_dirs='yes'   # Get all sub-directories
	elif [ "${1}" == '-t' ]; then
		t_in='yes'           # Add text editor
	elif [ "${1}" == '-tr' ]; then
		tr_in='yes'          # Remove text editor
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

create_option_file () { # Creates .ini files to store user settings
if ! [ -d "${backup_dir}" ]; then  # Create backup directory
	mkdir -p "${backup_dir}"
fi

if ! [ -d "${recycle_bin}" ]; then # Create recycle bin
	mkdir -p "${recycle_bin}"
fi

if ! [ -f "${option_file}" ]; then # Create option file
	echo "[options]
max_files=${default_max_files}
script_exts=($(printf "'%s' " ${default_script_exts[@]}))
text_editors=($(printf "'%s' " ${default_text_editors[@]}))" > "${option_file}"
fi

if ! [ -f "${time_file}" ]; then # Keep track of when files were backed up
	printf '\n' > "${time_file}"
fi

eval $(grep '^max_files' "${option_file}")
eval $(grep '^script_exts' "${option_file}")
eval $(grep '^text_editors' "${option_file}")

if [ "${#add_exts[@]}" -gt '0' ] || [ "${#rem_exts[@]}" -gt '0' ]; then # Change user extensions
	list_settings='yes' # list user settings
	new_exts=($(printf '%s\n' ${script_exts[@]} ${add_exts[@]} |sort -u)) # Alphabetize unique extensions
	
	for i_rm_x in ${!rem_exts[@]}; do #
		new_exts=($(printf '%s\n' ${new_exts[@]} |sed "s,^${rem_exts[${i_rm_x}]}$,,g"))
	done
	
	old_ext_vals="$(grep '^script_exts' ${option_file})"
	new_ext_vals="script_exts=($(printf "'%s' " ${new_exts[@]}))"
	sed -i '' -e "s@${old_ext_vals}@${new_ext_vals}@g" "${option_file}" 2>/dev/null # '' -e for mac
	eval $(grep '^script_exts' "${option_file}")
fi

if [ "${#add_editors[@]}" -gt '0' ] || [ "${#rem_editors[@]}" -gt '0' ]; then # Change text editors
	list_settings='yes' # list user settings
	old_editor_vals="$(grep '^text_editors=' ${option_file})"
	editor_edit=(${rem_editors[@]} ${add_editors[@]})
	
	for i_ed in ${!editor_edit[@]}; do # Removes duplicate inputs
		text_editors=($(printf '%s\n' ${text_editors[@]} |sed "s,^${editor_edit[${i_ed}]}$,,g"))
	done
	
	text_editors=(${add_editors[@]} ${text_editors[@]}) # Put newest editor(s) in front
	
	new_editor_vals="text_editors=($(printf "'%s' " ${text_editors[@]}))"
	sed -i '' -e "s@${old_editor_vals}@${new_editor_vals}@g" "${option_file}" 2>/dev/null # '' -e for mac
	eval $(grep '^text_editors' "${option_file}")
fi
} # create_option_file

create_backup_file () { # Create backup file
	input_file="${1}"
	backup_file_check="${backup_dir}${input_file}"
	backup_filename=$(basename "${input_file}")
	backup_dir_check=$(dirname "${backup_file_check}")

	if ! [ -d "${backup_dir_check}" ]; then
		mkdir -p "${backup_dir_check}"
	fi

	check_backups=($(find "${backup_dir_check}" -maxdepth 1 -type f -name "${backup_filename}_[0-9][0-9]" |sort))
	
	if [ "${#check_backups[@]}" -gt '0' ]; then
		latest_index=$((${#check_backups[@]} - 1))
		check_diff=(`diff ${check_backups[${latest_index}]} ${input_file}`)
			if [ "${#check_diff[@]}" -eq '0' ]; then
				echo "${ora}NO CHANGES: [${whi}$(printf '%02d' ${#check_backups[@]})${ora}] ${gre}${input_file}${whi}"
				continue
			fi
	fi
	
	new_backup_count=$((${#check_backups[@]} + 1))
	backup_ext=$(printf "_%02d" "${new_backup_count}")
	max_ext=$(printf "_%02d" "${max_files}")
	
	if [ "${new_backup_count}" -le "${max_files}" ]; then
		backup_output="${backup_file_check}${backup_ext}"
		base_backup_output=$(basename "${backup_output}")
		cp "${input_file}" "${backup_output}"
		vital_command "${base_backup_output}"
		echo "${backup_output}//$(date +%Y-%m-%d_%H:%M)" >> "${time_file}"
	else
		rename_backup_files
	fi
} # create_backup_file

mac_readlink () { # Get absolute path of a file
	dir_mac=$(dirname "${1}")   # Directory path
	file_mac=$(basename "${1}") # Filename
	wd_mac="$(pwd)" # Working directory path

	if [ -d "${dir_mac}" ]; then
		cd "${dir_mac}"
		echo "$(pwd)/${file_mac}" # Print full path
		cd "${wd_mac}" # Change directory back to original directory
	else
		echo "${1}" # Print input
	fi
} # mac_readlink

open_text_editor () { # Opens input file
	file_to_open="${1}"
	valid_text_editor='no'
	
	if [ -f "${file_to_open}" ]; then
		for i in ${!text_editors[@]}; do # Loop through indices
			${text_editors[i]} "${file_to_open}" 2>/dev/null &
			pid="$!" # Background process ID
			check_text_pid=($(ps "${pid}" |grep "${pid}" |awk '{print $1}')) # Check if pid is running

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

rename_backup_files () { # Rename backup files in order of creation
	base_backup=$(echo "${check_backups[0]}" |sed 's#_[0-9][0-9]$##g')
	remove_count=$((${#check_backups[@]} - ${max_files} + 1))
	remove_files=($(printf '%s\n' ${check_backups[@]} |head -n${remove_count}))

	for i_rm in ${!remove_files[@]}; do
		file_to_rm="${remove_files[${i_rm}]}"
		rm "${file_to_rm}"
		
		if ! [ -f "${file_to_rm}" ]; then
			old_time_rec=$(grep "^${file_to_rm}//" "${time_file}")
			sed -i '' -e "s@${old_time_rec}@@g" "${time_file}" 2>/dev/null # '' -e for mac
		fi
	done
	
	all_file_times=($(grep "^${base_backup}_[0-9][0-9]//" "${time_file}"))
	backup_count='0'
	all_index='0'
	for i_back in ${!check_backups[@]}; do
		backfile="${check_backups[${i_back}]}"
		if [ -f "${backfile}" ]; then
			backup_count=$((${backup_count} + 1))
			backup_ext=$(printf "_%02d" "${backup_count}")
			new_backfile=$(echo "${backfile}" |sed "s@_[0-9][0-9]@${backup_ext}@g")
			mv "${backfile}" "${new_backfile}"
			vital_command "${new_backfile}" 'NO-MESSAGE'
			old_time_rec="${all_file_times[${all_index}]}"
			all_index=$((${all_index} + 1))
			new_time_rec=$(echo "${old_time_rec}" |sed "s@_[0-9][0-9]//@${backup_ext}//@g")
				if [ -z "${new_time_rec}" ]; then
					echo "${new_backfile}//UNKNOWN" >> "${time_file}"
				else
					sed -i '' -e "s@${old_time_rec}@${new_time_rec}@g" "${time_file}" 2>/dev/null  # '' -e for mac
				fi
		fi
	done
	
	final_ext=$(printf "_%02d" "${max_files}")
	final_backup_output="${base_backup}${final_ext}"
	cp "${input_file}" "${final_backup_output}"
	vital_command "${final_backup_output}"
	echo "${final_backup_output}//$(date +%Y-%m-%d_%H:%M)" >> "${time_file}"
} # rename_backup_files

vital_command () { # Check if file is created then display message
	command_status="$?"
	vital_file="${1}"
	display_msg="${2}"
	vital_num="${vital_file:(-2)}"
	
	if ! [ -z "${command_status}" ] && [ "${command_status}" -ne '0' ]; then
		echo "${red}COULD NOT CREATE: [${whi}${vital_num}${gre}] ${ora}$(echo ${vital_file} |sed 's@_[0-9][0-9]@@g')${whi}"
	else
		if [ -z "${display_msg}" ]; then
			echo "${gre}BACKED UP : [${whi}${vital_num}${gre}] ${ora}$(echo ${vital_file} |sed 's@_[0-9][0-9]@@g')${whi}"
		fi
	fi
} # vital_command

#-------------------------------- MESSAGES ---------------------------------#
script_usage () { # Script explanation
	echo "${red}HELP MESSAGE: ${gre}${script_path}${whi}
${ora}DESCRIPTION${whi}: Create and retrieve backup code files
    
${ora}ADVICE${whi}: Create an alias inside your ${ora}${HOME}/.bashrc${whi} file
(e.g. ${gre}alias cb='${script_path}'${whi})
     
${ora}USAGE${whi}: Input files or directories to backup or retrieve
 [${ora}1${whi}] ${gre}cb${whi} # Default: backup all code files in working directory
 [${ora}2${whi}] ${gre}cb${whi} ${ora}test_file1.sh ${whi}# Backup test_file1.sh
     
${ora}OPTIONS${whi}: Can input multiple options in any order
 ${pur}-all${whi} Retrieve, recycle or backup ${red}ALL${whi} backup files
 ${pur}-cs${whi}  Prevent screen from clearing before script processes
 ${pur}-e${whi}   Add default script extension(s)
 [${ora}3${whi}] ${gre}cb${whi} ${pur}-e ${ora}.m .py${whi}
 ${pur}-empty${whi} Empty recycle bin
 ${pur}-er${whi}  Remove default script extension
 [${ora}4${whi}] ${gre}cb${whi} ${pur}-er ${ora}.m .py${whi}
 ${pur}-h${whi} or ${pur}--help${whi}  Display this message
 ${pur}-m${whi}   Change maximum number of backup files ${gre}2${whi}-${gre}99${whi}
 [${ora}5${whi}] ${gre}cb${whi} ${pur}-m ${ora}10${whi}
 ${pur}-nc${whi}  Prevent color printing in terminal
 ${pur}-o${whi} or ${pur}--open${whi} Open this script
 ${pur}-r${whi}   Retrieve backup file(s)
 ${pur}-rem${whi} Move obsolete backup file(s) to recycle bin
 ${pur}-sub${whi} Retrieve, recycle or backup sub-directories
 ${pur}-t${whi}   Add default text editor command(s) (${red}spaces must be 'quoted'${whi})
 [${ora}6${whi}] ${gre}cb${whi} ${pur}-t ${ora}'open -a /Applications/TextWrangler.app'${whi}
 ${pur}-tr${whi}  Remove default text editor command(s)
 [${ora}7${whi}] ${gre}cb${whi} ${pur}-tr ${ora}kwrite${whi}    
  
${ora}DEFAULT SETTINGS${whi}:
${red}MAXIMUM BACKUP FILES
${gre}${max_files}${whi}
${red}SCRIPT EXTENSIONS${whi} 
${gre}${script_exts[@]}${whi}
${red}TEXT EDITORS${whi} 
${gre}${text_editors[@]}${whi}
     
${ora}VERSION: ${gre}${version_number}${whi}
${red}END OF HELP: ${gre}${script_path}${whi}"
	exit_message 0
} # script_usage

display_input_instructions () { # Remove or retrieve instructions
	proceed='no'
	until [ "${proceed}" == 'yes' 2>/dev/null ]; do
		display_values ${@}
		v_option='no'    # Reset '-v' option input
		input_indices=() # Reset array
		invalid_input=() # Reset array
		if [ "${retrieve}" == 'yes' 2>/dev/null ]; then
			echo "${ora}INPUT ${blu}[${whi}VALUE(S)${blu}] ${ora}OF BACKUP FILES TO ${gre}RETRIEVE${whi}"
		else
			echo "${ora}INPUT ${blu}[${whi}VALUE(S)${blu}] ${ora}OF BACKUP FILES TO ${red}REMOVE${whi}"
		fi 
			
		echo "${ora}INPUT '${whi}-a${ora}' FOR ALL VALUES${whi}"
		echo "${ora}INPUT '${whi}-v${ora}' FOR ALL VALUES ${red}EXCEPT${ora} INPUT ${whi}VALUE(S)"
		printf "${ora}INPUT: ${whi}"
		read -r input_values
		check_inputs=($(echo ${input_values} |tr ' ' '\n')) # Put input into array
		
		for i_input in ${check_inputs[@]}; do
			if [ "${i_input}" == '-a' 2>/dev/null ]; then # get all files
				input_indices=($(seq 1 1 ${#@}))
				proceed='yes'
				break
			elif [ "${i_input}" == '-v' 2>/dev/null ]; then # get all except input files
				v_option='yes'
			elif [ "${i_input}" -ge '1' 2>/dev/null ] && [ "${i_input}" -le "${#@}" 2>/dev/null ]; then
				input_indices+=("${i_input}")
			else
				invalid_input+=("${i_input}")
			fi
		done
			
		if [ "${v_option}" == 'yes' 2>/dev/null ]; then # Get all except inputs
			input_indices=($(seq 1 1 ${#@} |grep -E -v "$(echo ${input_indices[@]} |sed 's@ @|@g')"))
		fi
		
		if [ "${#invalid_input[@]}" -gt '0' ] || [ "${#input_indices[@]}" -eq '0' ]; then
			re_enter_input_message ${invalid_input[@]}
		else
			input_indices=($(printf '%s\n' ${input_indices[@]} |sort -n -u)) # sort unique values
			proceed='yes'
		fi
	done # until [ "${proceed}" == 'yes' 2>/dev/null ]
} # display_input_instructions

display_values () { # Display output with numbers
	if [ "${#@}" -gt '0' ]; then
		val_count=($(seq 1 1 ${#@}))
		vals_and_count=($(paste -d '\n' <(printf '%s\n' ${val_count[@]}) <(printf '%s\n' ${@})))
		printf "${blu}[${whi}%s${blu}] ${gre}%s\n${whi}" ${vals_and_count[@]}
	fi
} # display values

list_user_settings () { # -l option
	echo "${red}---USER SETTINGS---${whi}"
	echo "${ora}maximum backups  : ${gre}${max_files}${whi}"
	echo "${ora}script extensions:" # ${gre}${script_exts[@]}${whi}"
	display_values ${script_exts[@]}
	echo "${ora}text editors:${whi}"
	display_values ${text_editors[@]}
	exit_message 0
} # list_user_settings

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

create_option_file

if ! [ "${clear_screen}" == 'no' 2>/dev/null ]; then
	clear     # Clears screen unless activation of input option: '-cs'
fi

color_formats # Activates or inhibits colorful output

# Display help message or open file
if [ "${activate_help}" == 'yes' ]; then # '-h' or '--help'
	script_usage
elif [ "${open_script}" == 'yes' ]; then   # '-o' or '--open'
	open_text_editor "${script_path}" ${text_editors[@]}
	exit_message 0
fi

# Exit script if invalid inputs found
if [ "${#bad_inputs[@]}" -gt '0' ]; then
	re_enter_input_message ${bad_inputs[@]}
	exit_message 1
fi

if [ "${list_settings}" == 'yes' ]; then
	list_user_settings # Lists settings and exits
fi

# Empty recycle bin
if [ "${empty_rec_bin}" == 'yes' 2>/dev/null ]; then
	get_rec=($(find "${recycle_bin}" -maxdepth 1 -type f |sort))
	if [ "${#get_rec[@]}" -eq '0' ]; then
		echo "${ora}RECYCLE BIN IS EMPTY${whi}"
	else
		if [ "${#get_rec[@]}" -eq '2' ]; then # When array is '2' basename only gives 1 value?
			display_input_instructions ${get_rec[@]} # temporary work around
		else
			display_input_instructions $(basename ${get_rec[@]})
		fi
		
		for i_index in ${input_indices[@]}; do # display_input_instructions
			remove_files+=("${get_rec[$((${i_index} - 1))]}") # -1 for index
		done
		
		if [ "${#remove_files[@]}" -gt '0' ]; then
			proceed='no'
			until [ "${proceed}" == 'yes' 2>/dev/null ]; do
				echo "${red}PERMANENTALY DELETE ${ora}${#remove_files[@]} ${red}FILE(S) ${blu}[${gre}y${blu}/${gre}n${blu}]?${whi}"
				printf "${ora}LIST FILES ${blu}[${gre}ls${blu}]${ora}:${whi}"
				read -r del_option
				if [ "${del_option}" == 'y' 2>/dev/null ] || [ "${del_option}" == 'yes' 2>/dev/null ]; then
					for i_rm in ${!remove_files[@]}; do # Use for loop in case there are a lot of files
						rm ${remove_files[${i_rm}]}
					done
					echo "${gre}RECYCLYE BIN EMPTY${whi}"
					proceed='yes'
				elif [ "${del_option}" == 'n' 2>/dev/null ] || [ "${del_option}" == 'no' 2>/dev/null ]; then
					echo "${red}NOT REMOVING FILE(S)${whi}"
					proceed='yes'
				elif [ "${del_option}" == 'l' 2>/dev/null ] || [ "${del_option}" == 'ls' 2>/dev/null ]; then
					clear
					if [ "${#remove_files[@]}" -eq '2' ]; then # When array is '2' basename only gives 1 value?
						display_values ${remove_files[@]} # temporary work around
					else
						display_values $(basename ${remove_files[@]})
					fi
				else # invalid input
					clear
					re_enter_input_message "${del_option}"
				fi
			done # until [ "${proceed}" == 'yes' ]
		fi # [ "${#remove_files[@]}" -gt '0' ]
	fi # [ "${#get_rec[@]}" -eq '0' ]
exit_message 0
fi # [ "${empty_rec_bin}" == 'yes' ]


check_valid_dir=($(echo "$(pwd)" |grep "^${backup_dir}"))
if [ "${#check_valid_dir[@]}" -gt '0' ]; then # Do not copy files when inside backup directory
	echo "${red}CANNOT BACKUP FILES WHILE INSIDE: ${ora}${backup_dir}${whi}"
	exit_message 0
else
	echo "${ora}SEARCHING FOR FILES...${whi}" # Alert user
fi

# Retrieve or recycle files
if [ "${retrieve}" == 'yes' 2>/dev/null ] || [ "${remove_backup}" == 'yes' 2>/dev/null ]; then
	if [ "${get_all}" == 'yes' 2>/dev/null ]; then # Get all backup files
		get_dir=($(find "${backup_dir}" -maxdepth 1 -type d |grep -E -v "^${backup_dir}$|^${recycle_bin}$")) # omit backup_dir and recycle bin
		for i_dir in ${!get_dir[@]}; do
			final_get_backups+=($(find "${get_dir[${i_dir}]}" -type f)) # find all files
		done
	elif [ "${get_sub_dirs}" == 'yes' 2>/dev/null ]; then # get all files within sub-directories
		final_get_backups=($(find "${backup_dir}$(pwd)" -type f)) 
	elif [ "${#backup_files[@]}" -eq '0' ] && [ "${#get_files[@]}" -eq '0' ]; then
		get_files=("${backup_dir}$(pwd)")
	elif [ "${#backup_files[@]}" -gt '0' ]; then
		get_files+=($(printf "${backup_dir}%s\n" ${backup_files[@]}))
	fi
	
	if ! [ "${get_all}" == 'yes' 2>/dev/null ]; then
		for i_get in ${!get_files[@]}; do
			get_backups=() # Reset array
			get_file="${get_files[${i_get}]}" # file or directory
			
			if [ -d "${get_file}" ]; then # Get all files within directory
				get_backups=($(find "${get_file}" -maxdepth 1 -type f))
			else # Get all backup file versions
				get_file_dir=$(dirname "${get_file}")
				get_filename=$(basename "${get_file}")
				if [ -d "${get_file_dir}" ]; then
					get_backups=($(find "${get_file_dir}" -maxdepth 1 -type f -name "${get_filename}_[0-9][0-9]"))
				fi
			fi
			
			final_get_backups+=(${get_backups[@]})
		done
	fi
		
	if [ "${#final_get_backups[@]}" -eq '0' ]; then
		echo "${red}NO BACKUP FILES FOUND${whi}"
		exit_message 0
	fi
	
	final_display_backups=($(printf '%s\n' ${final_get_backups[@]} |sed 's,_[0-9][0-9]$,,g' |sed "s@^${backup_dir}@@g" |sort -u))
	
	if [ "${retrieve}" == 'yes' 2>/dev/null ]; then # retrieve files
		display_input_instructions ${final_display_backups[@]}
		
		for i_index in ${input_indices[@]}; do # display_input_instructions
			desired_files+=("${final_display_backups[$((${i_index} - 1))]}") # -1 for index
		done
		
		for i_desired in ${!desired_files[@]}; do
			clear
			backup_find="${backup_dir}${desired_files[${i_desired}]}"
			backup_search=($(printf '%s\n' ${final_get_backups[@]} |grep "${backup_find}_[0-9][0-9]"))
			backup_search_times=() # Reset array
			for j_search in ${!backup_search[@]}; do
				search_file="${backup_search[${j_search}]}"
				check_time=($(grep "^${search_file}//" "${time_file}"))
				if [ "${#check_time[@]}" -gt '0' ]; then # Display when files were backed up
					backup_search_times+=("${gre}$(basename ${search_file}) ${ora}$(basename ${check_time[0]})${whi}")
				else
					backup_search_times+=("${gre}$(basename ${search_file}) ${red}UNKNOWN${whi}")
				fi
			done
			display_input_instructions ${backup_search_times[@]}
			for j_index in ${input_indices[@]}; do # display_input_instructions
				retrieve_files+=("${backup_search[$((${j_index} - 1))]}") # -1 for index
			done
		done
		
		clear
		for i_file in ${!retrieve_files[@]}; do
			copy_file="${retrieve_files[${i_file}]}"
			cp "${copy_file}" "$(pwd)"
			if [ "$?" -eq '0' ]; then
				echo "${gre}COPIED: ${ora}$(basename ${copy_file})${whi}"
			else
				echo "${red}NOT COPIED: ${ora}$(basename ${copy_file}$){whi}"
			fi
		done
	else # recycle files
		for i_file in ${!final_display_backups[@]}; do
			exist_file="${final_display_backups[${i_file}]}"
			if ! [ -f "${exist_file}" ]; then 
				recycle_files+=("${exist_file}")
			fi # Only recycle backup files when main file is missing
		done
		
		if [ "${#recycle_files[@]}" -eq '0' ]; then
			echo "${red}NO FILES TO RECYCLE${whi}"
		else
			display_input_instructions ${recycle_files[@]}
			for i_index in ${input_indices[@]}; do # display_input_instructions
				rec_path="${backup_dir}${recycle_files[$((${i_index} - 1))]}"
				rec_dir=$(dirname "${rec_path}")
				rec_file=$(basename "${rec_path}")
				rec_bin=($(find "${rec_dir}" -maxdepth 1 -type f -name "${rec_file}_[0-9][0-9]")) # -1 for index
				if [ "${#rec_bin[@]}" -gt '0' ]; then
				mv ${rec_bin[@]} "${recycle_bin}"
					if [ "$?" -eq '0' ]; then
						edit_time_file=($(grep "${rec_file}_[0-9][0-9]//" "${time_file}"))
						for j_edit in ${!edit_time_file[@]}; do # Remove backups from time file
							sed -i '' -e "s@${edit_time_file[${j_edit}]}@@g" "${time_file}" 2>/dev/null  # '' -e for mac
						done
						echo "${gre}MOVED TO RECYCLE BIN: ${ora}${rec_file}${whi}"
					else
						echo "${red}COULD NOT MOVE TO RECYLCE BIN: ${ora}${rec_file}${whi}"
					fi
				fi
			done
		fi # [ "${#recycle_files[@]}" -eq '0' ]
	fi # [ "${retrieve}" == 'yes' ]
exit_message 0
fi # [ "${retrieve}" == 'yes' ] || [ "${remove_backup}" == 'yes' ]

# Backup files
if [ "${get_all}" == 'yes' 2>/dev/null ]; then # Re-backup all backup files
	backup_files=($(find "${backup_dir}" -type d |grep -E -v "^${backup_dir}$|^${recycle_bin}$" |sed "s@^${backup_dir}@@g"))
elif [ "${get_sub_dirs}" == 'yes' 2>/dev/null ]; then
	backup_files=($(find "$(pwd)" -type d)) # Backup code files in sub-directories
elif [ "${#backup_files[@]}" -eq '0' ]; then
	backup_files=("$(pwd)") # Get all files in working directory
fi

for i in ${!backup_files[@]}; do
	check_file="${backup_files[${i}]}"
	if [ -f "${check_file}" ]; then # if file
		final_backup+=("${check_file}")
	else # if directory or link
		final_backup+=($(find "${check_file}" -maxdepth 1 -type f |grep -E "$(echo ${script_exts[@]} |sed -e 's@\.@\\\.@g' -e 's@ @$|@g' -e 's@$@$@g')"))
		final_backup+=($(find "${check_file}" -maxdepth 1 -type l |grep -E "$(echo ${script_exts[@]} |sed -e 's@\.@\\\.@g' -e 's@ @$|@g' -e 's@$@$@g')"))
		check_backup_dir="${backup_dir}${check_file}"
		if [ -d "${check_backup_dir}" ]; then # Check backup directory for extra files that do NOT have a default extension
			extra_backup_files=($(find "${check_backup_dir}" -maxdepth 1 -type f |sed 's#_[0-9][0-9]$##g' |grep -E -v "$(echo ${script_exts[@]} |sed -e 's@\.@\\\.@g' -e 's@ @$|@g' -e 's@$@$@g')"))
			if [ "${#extra_backup_files[@]}" -gt '0' ]; then # Add these extra file(s) to backup
				check_final_backup=($(printf '%s\n' ${extra_backup_files[@]} |sed "s@^${backup_dir}@@g"))
				for j_check in ${!check_final_backup[@]}; do # Check if regular file exists
					check_reg_file="${check_final_backup[${j_check}]}"
					if [ -f "${check_reg_file}" ]; then # Only include files that exist
						final_backup+=("${check_reg_file}")
					fi
				done
			fi
		fi
	fi
done

if [ "${#final_backup[@]}" -eq '0' ]; then
	echo "${red}NO CODE FILES FOUND${whi}"
	exit_message 0
else # sort and get unique files
	final_backup=($(printf '%s\n' ${final_backup[@]} |sort -u))
fi

for i_backup in ${final_backup[@]}; do
	create_backup_file "${i_backup}"
done

# reorganize time file
all_times=($(grep '^/' "${time_file}" |sort))
rm "${time_file}"
printf '%s\n' ${all_times[@]} > "${time_file}"

IFS="${IFS_original}"

exit_message 0
