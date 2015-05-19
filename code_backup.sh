#!/bin/bash
#--------------------------------------------------------------------------------------#
# Created: 09/12/14 By: Evan Layher (ealayher@ucdavis.edu: UC Davis Medical Center)
# Revised: 05/18/15 By: Evan Layher
# Reference: github.com/ealayher
#--------------------------------------------------------------------------------------#
# Store and retrieve backup code files in a customized file structure
#--------------------------- DEFAULT SETTINGS ------------------------------#
initial_default_backup_dir="${HOME}/code_backup" # Default code backup directory
default_script_exts=('.bash' '.csh' '.ksh' '.m' '.py' '.sh' '.tcsh') # Default script extensions
default_max_files='10' # Default maximum number of backup files per file
default_text_editors=('kwrite' 'gedit' 'emacs' 'vim' 'leafpad') # default text editor commands in order of preference

#----------------------- GENERAL SCRIPT VARIABLES --------------------------#
script_path="$(readlink -f ${BASH_SOURCE[0]})"	# Full path of this script
version_number='1.0' 	# Script version number

activate_colors='yes'	# 'yes': Displays messages in color (color_formats) ['yes' or 'no'] [INPUT: '-nc']
activate_help='no'	# 'no': Displays help messeage (script_usage) ['yes' or 'no'] [INPUT: '-h' or '--help']
list_settings='no'	# 'no': List user settings (list_user_settings) ['yes' or 'no'] [INPUT: '-l']
open_script='no'	# 'no': Opens this script ['yes' or 'no'] [INPUT: '-o' or '--open']
reset_template='no'	# 'no': Reset template file (reset_option_file) ['yes' or 'no'] [INPUT: '-r']
suggest_help='no'	# 'no': Suggests help if needed ['yes' or 'no']

bad_inputs=()		# (): Array of bad inputs
code_files=()		# (): Array of code files

#-------------------------------- FUNCTIONS --------------------------------#
option_eval () { # Evaluates command line options
if [ ${1} == '-c' 2>/dev/null ] || [ ${1} == '-d' 2>/dev/null ] || [ ${1} == '-dr' 2>/dev/null ] || \
[ ${1} == '-e' 2>/dev/null ] || [ ${1} == '-er' 2>/dev/null ] || [ ${1} == '-g' 2>/dev/null ] || \
[ ${1} == '-gl' 2>/dev/null ] || [ ${1} == '-h' 2>/dev/null ] || [ ${1} == '--help' 2>/dev/null ] || \
[ ${1} == '-l' 2>/dev/null ] || [ ${1} == '-m' 2>/dev/null ] || [ ${1} == '-nc' 2>/dev/null ] || \
[ ${1} == '-o' 2>/dev/null ] || [ ${1} == '--open' 2>/dev/null ] || [ ${1} == '-r' 2>/dev/null ] || \
[ ${1} == '-t' 2>/dev/null ] || [ ${1} == '-tr' 2>/dev/null ]; then
activate_options ${1}
elif [ -f ${1} ]; then # Files to backup
code_files+=(`readlink -f ${1}`)
elif ! [ -z ${m_in} 2>/dev/null ] && [ ${m_in} == 'yes' 2>/dev/null ]; then # Change max number of backup copies (only one input allowed)
	if ! [ -z ${1} ] && [ ${1} -eq ${1} 2>/dev/null ] && [ ${1} -gt '0' ] && [ -z ${old_m_val} 2>/dev/null ]; then
	create_option_file
	old_m_val=`grep '^max_files=' ${option_file}`
	sed -i "s@${old_m_val}@max_files=${1}@g" ${option_file}
	else
	bad_inputs+=("-m:${1}")
	fi
elif [ ${c_in} == 'yes' 2>/dev/null ]; then # Create backup directory (only one input allowed)
	if [ ${1:0:1} == '/' 2>/dev/null ] && [ -z ${change_master_dir} 2>/dev/null ]; then
	change_master_dir="${1}"
	else
	bad_inputs+=("-c:${1}")
	fi
elif [ ${d_in} == 'yes' 2>/dev/null ]; then # Create backup directory (only one input allowed)
	if [ -z ${save_backup_dir} ]; then
	save_backup_dir="${1}"
	else
	bad_inputs+=("-d:${1}")
	fi
elif ! [ -z ${e_in} 2>/dev/null ] && [ ${e_in} == 'yes' 2>/dev/null ]; then # Add code file extensions
add_exts+=("${1}")
elif ! [ -z ${er_in} 2>/dev/null ] && [ ${er_in} == 'yes' 2>/dev/null ]; then # Remove code file extensions
rem_exts+=("${1}")
elif ! [ -z ${t_in} 2>/dev/null ] && [ ${t_in} == 'yes' 2>/dev/null ]; then # Add text editor
add_editors=("${1} ${add_editors[@]}") # Maintain order of editor inputs
elif ! [ -z ${tr_in} 2>/dev/null ] && [ ${tr_in} == 'yes' 2>/dev/null ]; then # Remove text editor
rem_editors+=("${1}")
else
bad_inputs+=("${1}")
fi
}

activate_options () {
c_in='no'
d_in='no'
e_in='no'
er_in='no'
m_in='no'
t_in='no'
tr_in='no'
if [ ${1} == '-c' ]; then
change_master='yes'	# Change master default backup directory
c_in='yes'
elif [ ${1} == '-d' ]; then
d_in='yes'		# Create new backup directories
elif [ ${1} == '-dr' ]; then
remove_dirs='yes'	# Remove backup directories
elif [ ${1} == '-e' ]; then
e_in='yes'		# Add extensions
list_settings='yes'	# List user settings
elif [ ${1} == '-er' ]; then
er_in='yes'		# Add extensions
list_settings='yes'	# List user settings
elif [ ${1} == '-g' ]; then
get_latest_file='yes'	# Copy latest file
elif [ ${1} == '-gl' ]; then
list_backup_files='yes'	# List backup files
get_latest_file='yes'	# Copy latest file
elif [ ${1} == '-h' ] || [ ${1} == '--help' ]; then
activate_help='yes'	# Display help message
elif [ ${1} == '-l' ]; then
list_settings='yes'	# List user settings
elif [ ${1} == '-m' ]; then
m_in='yes'		# Change max_files
list_settings='yes'
elif [ ${1} == '-nc' ]; then
activate_colors='no'	# Do not display in color
elif [ ${1} == '-o' ] || [ ${1} == '--open' ]; then
open_script='yes'	# Open this script
elif [ ${1} == '-r' ]; then
reset_template='yes'   # Reset option file
elif [ ${1} == '-t' ]; then
t_in='yes'   		# Add text editor
list_settings='yes'	# list user settings
elif [ ${1} == '-tr' ]; then
tr_in='yes'   		# Remove text editor
list_settings='yes'	# list user settings
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
else # -nc option
format=''	# No formatting
formatblue=''	# No formatting
formatgreen=''	# No formatting
formatorange=''	# No formatting
formatred=''	# No formatting
fi
}


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
}

create_option_file () { # Creates .ini file to store user preferences
ealayher_code_dir="${HOME}/.ealayher_code" # Directory of preference file
option_file="${ealayher_code_dir}/`basename ${script_path%.*}`.ini" # .ini file path

if ! [ -d ${ealayher_code_dir} ]; then # Create directory for option file
mkdir ${ealayher_code_dir}
fi

if ! [ -f ${option_file} ]; then # Create option file
echo "[options]
default_backup_dir=
script_exts=(${default_script_exts[@]})
max_files=${default_max_files}
text_editors=(${default_text_editors[@]})

[directories]" > ${option_file}
fi

max_files=`awk -F '=' '/max_files=/ {print $2}' ${option_file}`
script_exts=(`awk -F '=' '/script_exts=/ {print $2}' ${option_file} |sed -e 's@(@@g' -e 's@)@@g'`)
text_editors=(`awk -F '=' '/text_editors=/ {print $2}' ${option_file} |sed -e 's@(@@g' -e 's@)@@g'`)

if [ ${#add_exts[@]} -gt 0 ] || [ ${#rem_exts[@]} -gt 0 ]; then # Change user extensions
new_exts=(`printf '%s\n' ${script_exts[@]} ${add_exts[@]} |sort -u`) # Alphabetize unique extensions
	for i_rem_ext in ${rem_exts[@]}; do
	new_exts=(`printf ' %s ' ${new_exts[@]} |sed "s@ ${i_rem_ext} @ @g"`)
	done
	old_ext_vals="script_exts=(${script_exts[@]})"
	new_ext_vals="script_exts=(${new_exts[@]})"
sed -i "s@${old_ext_vals}@${new_ext_vals}@g" ${option_file}
script_exts=(`awk -F '=' '/script_exts=/ {print $2}' ${option_file} |sed -e 's@(@@g' -e 's@)@@g'`)
fi

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
}

###--- MASTER CODE BACKUP FUNCTIONS (START) ---###
default_code_backup () { # Backup directory if not specified
if [ -f ${option_file} ]; then
check_default_dir=(`grep '^default_backup_dir=' ${option_file} |awk -F '=' '{print $2}'`)
	if [ ${#check_default_dir[@]} -eq 0 ]; then
	input_default_backup
	elif ! [ -d ${check_default_dir[0]} ]; then
	echo "${formatred}MISSING DEFAULT DIRECTORY: ${formatorange}${check_default_dir[0]}${format}"
	input_default_backup
	else
	default_backup_dir=${check_default_dir[0]}
	fi
fi
}

input_default_backup () { # User input default backup directory
echo "${formatorange}PLEASE INPUT MASTER BACKUP DIRECTORY${format}"
printf "${formatorange}CREATE ${formatgreen}${initial_default_backup_dir}${formatorange}? INPUT [${formatgreen}y${formatorange}]:${format}"
read -r input_backup_dir
if [ ${input_backup_dir} == 'y' 2>/dev/null ] || [ ${input_backup_dir} == 'Y' 2>/dev/null ]; then
default_backup_dir=${initial_default_backup_dir}
check_default_existence ${original_default} ${default_backup_dir}
clear
confirm_default_backup
elif [ ${input_backup_dir:0:1} == '/' 2>/dev/null ]; then
default_backup_dir=`echo ${input_backup_dir} |sed 's@/$@@'`
check_default_existence ${original_default} ${default_backup_dir}
clear
confirm_default_backup
else
re_enter_input_message ${input_backup_dir}
input_default_backup
fi
}

confirm_default_backup () { # User confirm default backup directory
echo "${formatorange}CONFIRM BACKUP DIRECTORY: ${formatgreen}${default_backup_dir}${format}"
printf "${formatorange}[${formatgreen}y${formatorange}/${formatgreen}n${formatorange}]:${format}"
read -r confirm_dir
if [ ${confirm_dir} = 'y' 2>/dev/null ] || [ ${confirm_dir} = 'Y' 2>/dev/null ]; then
old_default_backup_dir=(`grep '^default_backup_dir=' ${option_file}`)
new_default_backup_dir="default_backup_dir=${default_backup_dir}"
mkdir -p ${default_backup_dir} 2>/dev/null
	if [ $? -eq 0 ]; then
	sed -i "s@${old_default_backup_dir[0]}@${new_default_backup_dir}@g" ${option_file}
	else
	clear
	echo "${formatred}COULD NOT CREATE DIRECTORY: ${formatorange}${default_backup_dir}${format}"
	input_default_backup
	fi
	if ! [ -z ${confirm_move_default_backup_files} 2>/dev/null ] && [ ${confirm_move_default_backup_files} == 'yes' 2>/dev/null ]; then
	move_default_backup_files
	fi
elif [ ${confirm_dir} = 'n' 2>/dev/null ] || [ ${confirm_dir} = 'N' 2>/dev/null ]; then
clear
input_default_backup
else
re_enter_input_message ${confirm_dir}
confirm_default_backup
fi
}

confirm_change_master_backup () { # -c option: confirm change default code backup directory
confirm_move_default_backup_files='no'
original_default=`grep 'default_backup_dir=' ${option_file} |sed 's@default_backup_dir=@@g'`
if [ -d ${original_default} ]; then
original_default_files=(`find ${original_default} -maxdepth 1 -type f 2>/dev/null`)
	if [ ${#original_default_files[@]} -gt 0 ]; then
	confirm_move_default_backup_files='yes'
	fi
fi
if [ -z ${change_master_dir} ]; then
input_default_backup
else
default_backup_dir=`echo ${change_master_dir} |sed 's@/$@@'`
check_default_existence ${original_default} ${default_backup_dir}
confirm_default_backup
fi
}

move_default_backup_files () { # Move backup files to new default backup directory
echo "${formatorange}MOVE DEFAULT BACKUP FILES FROM: ${formatgreen}${original_default} ${formatorange}TO ${formatgreen}${default_backup_dir}${formatorange}?${format}"
printf "${formatorange}[${formatgreen}y${formatorange}/${formatgreen}n${formatorange}]:${format}"
read -r move_defaults
if [ ${move_defaults} == 'y' 2>/dev/null ] || [ ${move_defaults} = 'Y' 2>/dev/null ]; then
mv ${original_default_files[@]} ${default_backup_dir} 2>/dev/null
	if [ $? -eq 0 ]; then
	rmdir ${original_default} 2>/dev/null # Removes empty directory
	sed -i "s%=${original_default}$%=${default_backup_dir}%g" ${option_file}
	else
	echo "${formatred}COULD NOT MOVE FILES TO: ${formatgreen}${default_backup_dir}${format}"
	fi
elif [ ${move_defaults} == 'n' 2>/dev/null ] || [ ${move_defaults} = 'N' 2>/dev/null ]; then
echo "${formatorange}NOT MOVING FILES${format}"
else
re_enter_input_message ${move_defaults}
move_default_backup_files
fi
}

check_default_existence () { # Checks if original and new backup directories are the same
default1=${1}
default2=${2}
if [ ${default1} == ${default2} 2>/dev/null ]; then
echo "${formatorange}DEFAULT DIRECTORY ALREADY IS: ${formatgreen}${default1}${format}"
exit_message 0
fi
}
###--- MASTER CODE BACKUP FUNCTIONS (END) ---###

create_dir_specific_default () { # -d option: Create new backup directory for files in current directory

	confirm_new_default () { # Confirm new specific default directory
	echo "${formatorange}SAVE FILES IN ${formatgreen}$(pwd)${formatorange} TO ${formatgreen}${check_backup_dir}${formatorange}?${format}"
	printf "${formatorange}[${formatgreen}y${formatorange}/${formatgreen}n${formatorange}]${format}:"
	read -r confirm_new
	if [ ${confirm_new} == 'y' 2>/dev/null ] || [ ${confirm_new} == 'Y' 2>/dev/null ]; then
	add_new_default ${check_backup_dir}
		if [ ${#check_for_default_dir[@]} -eq 0 ]; then
		original_backup_dir=${check_backup_dir} # No backup directory existed
		fi
	elif [ ${confirm_new} == 'n' 2>/dev/null ] || [ ${confirm_new} == 'N' 2>/dev/null ]; then
	save_backup_dir=''
		until ! [ -z ${save_backup_dir} ]; do
		clear
		printf "${formatorange}INPUT NEW BACKUP DIRECTORY:${format}"
		read -r save_backup_dir
		done
	create_dir_specific_default
	else
	re_enter_input_message ${confirm_new}
	confirm_new_default
	fi
	}
	
	add_new_default () { # Add new default to option file
	backup_dir=${1}
	if [ ${#check_for_default_dir[@]} -gt 0 ]; then
	sed -i "s@${check_for_default_dir[0]}@@g" ${option_file}
	fi
	dir_line=`grep -nF '[directories]' ${option_file} |awk -F ':' '{print $1}'`
		if ! [ -z ${dir_line} ] && [ ${dir_line} -eq ${dir_line} ]; then
		all_custom_dirs=(`printf '%s\n' "$(pwd)=${backup_dir}" $(grep '^/' ${option_file}) |sort -u`)
		head -n${dir_line} ${option_file} > ${option_file}TEMP
		printf '%s\n' ${all_custom_dirs[@]} >> ${option_file}TEMP
		mv ${option_file}TEMP ${option_file}
		else
		echo "${formatred}ERROR: ${formatorange}grep error line $?${format}"
		fi
	}
	
check_for_default_dir=(`grep "^$(pwd)=" ${option_file}`)
if [ ${#check_for_default_dir[@]} -gt 0 ]; then
outdir=(`echo ${check_for_default_dir[0]} |awk -F '=' '{ $1 = ""; print $0}' 2>/dev/null`)
original_backup_dir=${outdir[0]}
backup_dir=${outdir[0]}
else
original_backup_dir=${default_backup_dir}
backup_dir=${default_backup_dir}
fi

if ! [ -z ${save_backup_dir} ]; then
	if [ ${save_backup_dir:0:1} == '/' 2>/dev/null ]; then
	check_backup_dir=`echo ${save_backup_dir} |sed 's@/$@@'` # Remove trailing '/'
	else
	check_backup_dir=`echo "${default_backup_dir}/${save_backup_dir}" |sed 's@/$@@'` # Remove trailing '/'
	fi
	if [ ${outdir[0]} == ${check_backup_dir} 2>/dev/null ]; then
	echo "${formatorange}DEFAULT DIRECTORY ALREADY IS: ${formatgreen}${check_backup_dir}${format}"
	else
	confirm_new_default
	fi
else
	if [ ${#check_for_default_dir[@]} -eq 0 ]; then
	add_new_default ${backup_dir}
	fi
fi
}

move_old_files () { # -d option: Move backup files in previous directory to new directory
original_files=(`ls ${original_backup_dir} 2>/dev/null |grep "^${file_name}_[0-9]*${file_ext}$" 2>/dev/null`)

if [ ${#original_files[@]} -gt 0 ]; then
	if [ -z ${move_old} 2>/dev/null ]; then
	echo "${formatorange}MOVE ${formatgreen}${original_backup_dir}${formatorange} FILES TO ${formatgreen}${backup_dir}${formatorange}?"
	printf "${formatorange}[${formatgreen}y${formatorange}/${formatgreen}n${formatorange}]:${format}"
	read -r to_move
		if [ ${to_move} == 'y' 2>/dev/null ] || [ ${to_move} == 'Y' 2>/dev/null ]; then
		move_old='yes'
		elif [ ${to_move} == 'n' 2>/dev/null ] || [ ${to_move} == 'N' 2>/dev/null ]; then
		move_old='no'
		else
		re_enter_input_message ${to_move}
		move_old_files
		fi
	fi
	
	if [ ${move_old} == 'yes' 2>/dev/null ]; then
	original_files=(`printf "${original_backup_dir}/%s\n" ${original_files[@]}`)
	mv ${original_files[@]} ${backup_dir} 2>/dev/null
		if [ $? -eq 0 ]; then
		rmdir ${original_backup_dir} 2>/dev/null # Removes empty directory
		else
		echo "${formatred}COULD NOT MOVE FILES FROM: ${formatorange}${original_backup_dir}${format}"
		fi
	fi
fi
}

restore_backup_files () { # -gl option: View or copy files
choose_indices=()	# User selected files
bad_choose_inputs=()	# Invalid user inputs
skip_choose='no'	# Skip file
copy_backup='no'	# Copy file(s) into working directory
sort_list=(`ls -lt ${sort_backup_files[@]} |sed 's@ @,@g'`)
list_count='1'		# List counter

for i_list_file in ${sort_list[@]}; do
echo "${formatorange}[${formatgreen}${list_count}${formatorange}] ${formatgreen}${i_list_file}${format}" |sed "s@,@ @g"
list_count=$((${list_count} + 1))
done

echo "${formatorange}ENTER ${formatgreen}NUMBER(S)${formatorange} TO VIEW FILE(S)${format}"
echo "${formatorange}INPUT [${formatgreen}-s${formatorange}] TO SKIP FILE.${format}"
printf "${formatorange}INPUT [${formatgreen}-c${formatorange}] AND ${formatgreen}NUMBER(S)${formatorange} TO COPY SPECIFIED FILES:${format}"
read -r choose_input
for i_input in ${choose_input}; do
	if [ ${i_input} == '-s' 2>/dev/null ] || [ ${i_input} == '-S' 2>/dev/null ]; then
	skip_choose='yes'
	elif [ ${i_input} == '-c' 2>/dev/null ] || [ ${i_input} == '-C' 2>/dev/null ]; then
	copy_backup='yes'
	elif [ ${i_input} -eq ${i_input} 2>/dev/null ] && [ ${i_input} -ge '1' 2>/dev/null ] && [ ${i_input} -lt ${list_count} 2>/dev/null ]; then
	choose_indices+=("$((${i_input} - 1))") # Subtract 1 for index
	else
	bad_choose_inputs+=("${i_input}")
	fi
done

if [ ${#bad_choose_inputs[@]} -gt 0 ]; then
re_enter_input_message ${bad_choose_inputs[@]}
restore_backup_files
elif [ ${skip_choose} == 'yes' 2>/dev/null ]; then
clear
continue
elif [ ${#choose_indices[@]} -eq 0 ]; then
clear
echo "${formatred}NO VALID INPUTS${format}"
restore_backup_files
elif [ ${copy_backup} == 'yes' 2>/dev/null ]; then
clear
copy_backup='no'
	for i_choose_index in ${choose_indices[@]}; do
	copy_file_name="$(pwd)/`basename ${sort_backup_files[${i_choose_index}]}`"
	cp ${sort_backup_files[${i_choose_index}]} $(pwd) 2>/dev/null
		if [ $? -eq 0 ]; then
		echo "${formatgreen}CREATED: ${formatorange}${copy_file_name}${format}"
		else
		echo "${formatred}COULD NOT CREATE: ${formatorange}${copy_file_name}${format}"
		fi
	done
else # Open files to view
clear
	for i_choose_index in ${choose_indices[@]}; do
	open_text_editor ${sort_backup_files[${i_choose_index}]} ${text_editors[@]}
	done
fi
}

remove_backup_dirs () { # -dr option: Remove specified backup directories
	read_in_indices () { # User input numbers corresponding to directories
	invalid_indices=()
	remove_indices=()
	printf "${formatorange}INPUT NUMBER(S) TO REMOVE:${format}"
	read -r dir_ind
	all_indices=(${dir_ind})
	for i_index in ${all_indices[@]}; do
		if [ ${i_index} -eq ${i_index} 2>/dev/null ] && \
		[ ${i_index} -gt '0' 2>/dev/null ] && \
		[ ${i_index} -lt ${count_dir} 2>/dev/null ]; then
		remove_indices+=("$((${i_index} - 1))")
		else
		invalid_indices+=("${i_index}")
		fi
	done
	if [ ${#invalid_indices[@]} -gt 0 ]; then
	re_enter_input_message ${invalid_indices[@]}
	remove_backup_dirs
	fi
	if [ ${#remove_indices[@]} -eq 0 ]; then
	echo "${formatred}NO VALID INDICES${format}"
	remove_backup_dirs
	else
		for i_rm_index in ${remove_indices[@]}; do
		sed -i "s@${option_dirs[${i_rm_index}]}@@g" ${option_file}
		done
	fi
	}
	
option_dirs=(`grep '^/' ${option_file}`) # Directories in options file
if [ ${#option_dirs[@]} -eq 0 ]; then
echo "${formatorange}NO DIRECTORIES FOUND: ${formatgreen}${option_file}${format}"
exit_message 0
fi

count_dir='1'
for i_opt_dir in ${option_dirs[@]}; do
echo "${formatorange}[${formatgreen}${count_dir}${formatorange}] ${i_opt_dir}${format}" |sed -e "s@=@:${formatgreen} @g" -e "s@^@${formatorange}@g"
count_dir=$((${count_dir} + 1))
done
read_in_indices
}

create_backup_file () { # Create backup file
file_value=${1}
if ! [ -z ${file_value} ] && [ ${file_value} -eq ${file_value} 2>/dev/null ]; then
outfile="${backup_dir}/${file_name}`printf "_%0${#max_files}d" ${file_value}`${file_ext}"
cp ${i_file} ${outfile}
	if [ $? -eq 0 ]; then
	echo "${formatgreen}CREATED: ${formatorange}${outfile}${format}"
	else
	echo "${formatred}COULD NOT CREATE: ${formatorange}${outfile}${format}"
	fi
fi
}

rename_backup_files () { # Rename backup files in order of creation
if [ ${max_files} -eq 1 ]; then
check_diff=(`diff ${remove_files[0]} ${i_file}`) # Checks if latest copy changed for max_files='1'
remove_files=(`echo ${remove_files[@]} |sed "s@${remove_files[0]}@@"`) # Will not remove latest copy
else
check_diff=(`diff ${sort_backup_files[0]} ${i_file}`) # Checks if latest copy changed
fi

backup_count='0'
temp_files=()
new_count=$((${#sort_backup_files[@]} + 1))
if [ ${#remove_files[@]} -gt 0 ]; then
rm ${remove_files[@]} 2>/dev/null
	if [ $? -ne 0 ]; then
	echo "${formatred}COULD NOT REMOVE OBSOLETE FILES: ${formatorange}${remove_files[@]}${format}"
	fi
fi

if [ ${#sort_backup_files[@]} -gt 0 ]; then # Needed if max_files='1'
	for j_backup_file in `eval echo {${#sort_backup_files[@]}..1}`; do
	temp_file="${backup_dir}/${file_name}`printf "_%0${#max_files}d" ${j_backup_file}`${file_ext}TEMP"
	mv ${sort_backup_files[${backup_count}]} ${temp_file} 2>/dev/null
	temp_files+=(${temp_file})
	backup_count=$((${backup_count} + 1))
	done
	
	for j_temp_file in ${temp_files[@]}; do
	final_file=`echo ${j_temp_file} |sed 's@TEMP$@@g'`
	mv ${j_temp_file} ${final_file}
	done
fi
	
if [ ${#check_diff[@]} -eq 0 ]; then
echo "${formatorange}NO CHANGES DETECTED: ${formatgreen}${i_file}"
else
create_backup_file ${new_count}
fi
}

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
}

#-------------------------------- MESSAGES ---------------------------------#
script_usage () { # -h or --help option: Script explanation
echo "${formatred}HELP MESSAGE: ${formatgreen}${script_path}${format}
${formatorange}DESCRIPTION${format}: Backup scripts to customized file structure
     
${formatorange}ADVICE${format}: Create an alias inside your ${formatorange}${HOME}/.bashrc${format} file
(e.g. ${formatgreen}alias cb='${script_path}'${format})
     
${formatorange}USAGE${format}: Input file(s) or backup all scripts in working directory
 ${format}Copy all scripts in working directory (run script)
  [${formatorange}1${format}] ${formatgreen}${script_path}${format}
 ${format}Copy specific file(s) (run script with input file(s))
  [${formatorange}2${format}] ${formatgreen}${script_path}${formatorange} examplefile1.sh examplefile2.sh${format}
     
${formatorange}OPTIONS${format}: Can input multiple options in any order
 ${formatblue}-c${format}   Change default backup directory
  [${formatorange}3${format}] ${formatgreen}${script_path} ${formatblue}-c ${formatorange}${HOME}/new_default_dir${format}
 ${formatblue}-d${format}   Create backup directory for scripts in working directory
  [${formatorange}4${format}] ${formatgreen}${script_path} ${formatblue}-d ${formatorange}${HOME}/new_backup_dir${format}
 ${formatblue}-dr${format}  Remove backup directories
 ${formatblue}-e${format}   Add extension(s) of files to backup
  [${formatorange}5${format}] ${formatgreen}${script_path} ${formatblue}-e ${formatorange}.sh .py${format}
 ${formatblue}-er${format}  Remove extension(s) of files to backup${format}
  [${formatorange}6${format}] ${formatgreen}${script_path} ${formatblue}-er ${formatorange}.sh .py${format}
 ${formatblue}-g${format}   Restore latest backup file
  [${formatorange}7${format}] ${formatgreen}${script_path} ${formatblue}-g ${formatorange}examplefile1.sh examplefile2.sh${format}
 ${formatblue}-gl${format}  List all backup files to view and/or restore
  [${formatorange}8${format}] ${formatgreen}${script_path} ${formatblue}-gl ${formatorange}examplefile1.sh examplefile2.sh${format}
 ${formatblue}-h${format} or ${formatblue}--help${format}  Display this message 
 ${formatblue}-l${format}   List default settings
 ${formatblue}-m${format}   Input maximum number of backup files
  [${formatorange}9${format}] ${formatgreen}${script_path} ${formatblue}-m ${formatorange}5${format}
 ${formatblue}-nc${format}  Prevent color printing in terminal
 ${formatblue}-o${format} or ${formatblue}--open${format}  Open this script
 ${formatblue}-r${format}   Reset option file
 ${formatblue}-t${format}   Add text editor(s)
  [${formatorange}10${format}] ${formatgreen}${script_path} ${formatblue}-t ${formatorange}kwrite gedit${format}
 ${formatblue}-tr${format}  Remove text editor(s)
  [${formatorange}11${format}] ${formatgreen}${script_path} ${formatblue}-tr ${formatorange}kwrite gedit${format}
     
${formatorange}DEFAULT SETTINGS${format}:
 backup directory: ${formatgreen}`grep 'default_backup_dir=' ${option_file} |sed 's@default_backup_dir=@@g'`${format}
 max files: ${formatgreen}`grep 'max_files=' ${option_file} |sed 's@max_files=@@g'`${format}
 text editors: ${formatgreen}`grep 'text_editors=' ${option_file} |sed -e 's@text_editors=@@g' -e 's@(@@g' -e 's@)@@g'`${format}
    
${formatorange}VERSION: ${formatgreen}${version_number}${format}
${formatred}END OF HELP: ${formatgreen}${script_path}${format}"
exit_message 0
}

list_user_settings () { # -l option
create_option_file
default_code_backup
if [ ${#add_exts[@]} -eq 0 ] && [ ${#rem_exts[@]} -eq 0 ] && [ ${#add_editors[@]} -eq 0 ] && \
[ ${#rem_editors[@]} -eq 0 ] && [ -z ${old_m_val} 2>/dev/null ]; then
other_default_dirs=(`grep '^/' ${option_file} | sed -e "s@=@:${formatgreen} @g" -e "s@^@${formatorange}@g"`)
	if [ ${#other_default_dirs[@]} -gt 0 ]; then
	echo "${formatblue}+---DEFAULT DIRECTORIES---+${formatorange}"
	printf '%s %s\n' ${other_default_dirs[@]}
	fi
fi
echo "${formatblue}+---USER SETTINGS---+${formatorange}"
echo "${formatgreen}Default backup directory: ${formatorange}${default_backup_dir}${format}"
echo "${formatgreen}Text editors: ${formatorange}${text_editors[@]}${format}"
echo "${formatgreen}Max files: ${formatorange}${max_files}${format}"
printf "${formatgreen}Extensions: ${formatorange}"
printf '%s ' ${script_exts[@]}
exit_message 0
}

re_enter_input_message () { # Displays invalid input message
clear
echo "${formatred}INVALID INPUT: ${formatorange}${@}${format}"
echo "${formatblue}PLEASE RE-ENTER INPUT${format}"
}

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
}

#---------------------------------- CODE -----------------------------------#
for inputs; do # Reads through all inputs
option_eval ${inputs}
done

clear
color_formats # -nc option: prevents colorful output

# Exit script if invalid inputs found
if [ ${#bad_inputs[@]} -gt 0 ]; then
suggest_help='yes'
re_enter_input_message ${bad_inputs[@]}
exit_message 1
fi

create_option_file # create .ini file

if [ ${activate_help} == 'yes' ]; then # -h or --help option
script_usage
elif [ ${open_script} == 'yes' ]; then # -o or --open option
echo "${formatorange}SCRIPT: ${formatgreen}${script_path}${format}"
open_text_editor ${script_path} ${text_editors[@]}
exit_message 0
elif [ ${list_settings} == 'yes' 2>/dev/null ]; then # -l option
list_user_settings
elif [ ${change_master} == 'yes' 2>/dev/null ]; then # -c option
confirm_change_master_backup
exit_message 0
elif [ ${remove_dirs} == 'yes' 2>/dev/null ]; then # -dr option
remove_backup_dirs
exit_message 0
elif [ ${reset_template} == 'yes' 2>/dev/null ]; then # -r option
open_text_editor ${option_file} ${text_editors[@]}
reset_option_file
input_default_backup
exit_message 0
elif [ ${#bad_inputs[@]} -eq 0 ] && [ ${#code_files[@]} -eq 0 ]; then # Get files with default extensions
code_files=(`find $(pwd) -maxdepth 1 -type f |grep $(echo ${script_exts[@]} |sed -e 's@\.@\\\.@g' -e 's@ @$\\\|@g' -e 's@$@$@g')`)
fi

if [ ${#code_files[@]} -eq 0 ]; then
echo "${formatred}NO VALID INPUTS${format}"
exit_message 2
fi

default_code_backup # get backup directory if not specified
create_dir_specific_default # Find backup directory or create new directory (-d option)

if ! [ -d ${backup_dir} ]; then # Create backup directory
mkdir -p ${backup_dir} 2>/dev/null
	if [ $? -ne 0 ]; then
	echo "${formatred}CANNOT CREATE DIRECTORY: ${formatorange}${backup_dir}${format}"
	exit_message 3
	fi
fi

if [ ${backup_dir} == $(pwd) 2>/dev/null ]; then # Prevent file copies in same directory
echo "${formatred}WORKING DIRECTORY IS BACKUP DIRECTORY CANNOT COPY FILES${format}"
exit_message 4
fi

if [ `echo $(pwd) |grep -o "^${backup_dir}"` == ${backup_dir} 2>/dev/null ]; then # Check if inside backup directory
clear
	until [ ${continue_copy} == 'y' 2>/dev/null ] || [ ${continue_copy} == 'Y' 2>/dev/null ] || \
	[ ${continue_copy} == 'n' 2>/dev/null ] || [ ${continue_copy} == 'N' 2>/dev/null ]; do
	echo "${formatred}YOU ARE INSIDE DEFAULT DIRECTORY: ${formatorange}${backup_dir}${format}"
	printf "${formatorange}CONTINUE WITH COPY? [${formatgreen}y${formatorange}/${formatgreen}n${formatorange}]:${format}"
	read -r continue_copy
		if [ ${continue_copy} == 'y' 2>/dev/null ] || [ ${continue_copy} == 'Y' 2>/dev/null ]; then
		true
		elif [ ${continue_copy} == 'n' 2>/dev/null ] || [ ${continue_copy} == 'N' 2>/dev/null ]; then
		exit_message 5
		else
		clear
		re_enter_input_message ${continue_copy}
		fi
	done
fi

code_sort=(`printf '%s\n' ${code_files[@]} |sort -u`) # Alphabetize and sort files

for i_file in ${code_sort[@]}; do
backup_files=()
sort_backup_files=()
base_file=`basename ${i_file}`
file_name=${base_file%.*}
file_ext=".${base_file##*.}"

	if [ ${file_ext} == ".${base_file}" 2>/dev/null ]; then # Check for '.' extension
	file_ext=''
	fi
	if [ ${original_backup_dir} != ${backup_dir} 2>/dev/null ]; then # -d option: create_dir_specific_default
	move_old_files
	fi
	
backup_files=(`ls ${backup_dir} 2>/dev/null |grep "^${file_name}_[0-9]*${file_ext}$" 2>/dev/null`)

	if [ ${get_latest_file} == 'yes' 2>/dev/null ]; then # -g or -gl option
		if [ ${#backup_files[@]} -gt 0 ]; then
		sort_backup_files=(`ls -t $(printf "${backup_dir}/%s\n" ${backup_files[@]})`)
			if [ ${list_backup_files} == 'yes' 2>/dev/null ]; then # -gl option
			restore_backup_files
			else # -g option (automatically copy latest backup file)
			cp ${sort_backup_files[0]} $(pwd) 2>/dev/null 
				if [ $? -eq 0 ]; then
				echo "${formatgreen}CREATED: ${formatorange}`basename ${sort_backup_files[0]}`${format}"
				else
				echo "${formatred}COULD NOT COPY FILE: ${formatorange}${sort_backup_files[0]}${format}"
				fi 
			fi
		else
		echo "${formatred}NO BACKUP FILES FOUND: ${formatorange}${i_file}${format}"
		fi
	continue
	fi
	
	if [ ${#backup_files[@]} -eq 0 ]; then
	create_backup_file 1
	elif [ ${#backup_files[@]} -lt ${max_files} ]; then 
	sort_backup_files=(`ls -t $(printf "${backup_dir}/%s\n" ${backup_files[@]})`)
	remove_files=()
	rename_backup_files
	else
	n_files=$((${max_files} - 1))
	sort_backup_files=(`ls -t $(printf "${backup_dir}/%s\n" ${backup_files[@]}) |head -n${n_files}`)
	remove_files=(`ls -t $(printf "${backup_dir}/%s\n" ${backup_files[@]}) |tail -n+${max_files}`)
	rename_backup_files
	fi
 done
 
exit_message 0
