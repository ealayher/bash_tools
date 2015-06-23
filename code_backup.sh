#!/bin/bash
#--------------------------------------------------------------------------------------#
# Created: 09/12/14 By: Evan Layher (ealayher@ucdavis.edu: UC Davis Medical Center)
# Revised: 06/02/15 By: Evan Layher
# Reference: github.com/ealayher
#--------------------------------------------------------------------------------------#
# Store and retrieve backup code files in a customized file structure
#--------------------------- DEFAULT SETTINGS ------------------------------#
initial_default_backup_dir="${HOME}/code_backup" # Default code backup directory
default_script_exts=('.bash' '.csh' '.ksh' '.m' '.py' '.sh' '.tcsh' '.zsh') # Default script extensions
default_max_files='10' # Default maximum number of backup files per file
default_text_editors=('kwrite' 'gedit' 'emacs' 'vim' 'leafpad') # default text editor commands in order of preference

#----------------------- GENERAL SCRIPT VARIABLES --------------------------#
script_path="$(readlink -f ${BASH_SOURCE[0]})"	# Full path of this script
version_number='1.2' 	# Script version number

activate_colors='yes'	# 'yes': Displays messages in color (color_formats) ['yes' or 'no'] [INPUT: '-nc']
activate_help='no'	# 'no': Displays help messeage (script_usage) ['yes' or 'no'] [INPUT: '-h' or '--help']
backup_all_dirs='no'	# 'no': Backup all saved directories ['yes' or 'no'] [INPUT: '-ad']
create_dir_tree='no'	# 'no': Create backup files for all nested directories ['yes' or 'no'] [INPUT: '-tree' ]
create_tree_structure='no'	# 'no': Created nested backup directory ['yes' or 'no'] [INPUT: '-trees' ]
force_files='no'	# 'no': Force saving and moving files without prompting ['yes' or 'no'] [INPUT: '-force' ]
get_all_files='no'	# 'no': Get all files, not just files with valid script endings ['yes' or 'no'] [INPUT: '-a']
list_settings='no'	# 'no': List user settings (list_user_settings) ['yes' or 'no'] [INPUT: '-l']
open_script='no'	# 'no': Opens this script ['yes' or 'no'] [INPUT: '-o' or '--open']
recycle_backups='no'	# 'no': Put obsolete backup files into recycle bin ['yes' or 'no'] [INPUT: '-rec']
reset_template='no'	# 'no': Reset template file (reset_option_file) ['yes' or 'no'] [INPUT: '-r']
restore_template='no'	# 'no': Restore old template files ['yes' or 'no'] [INPUT: '-restore']
retrieve_recycle_backups='no'	# 'no': List recycle bin and choose files to retrieve ['yes' or 'no'] [INPUT: '-grec']
suggest_help='no'	# 'no': Suggests help if script has a non-zero exit ['yes' or 'no']

bad_inputs=()		# (): Array of bad inputs
code_files=()		# (): Array of code files
dir_find=("$(pwd)")	# $(pwd): Directories to find files
directory_tree=()	# (): Array of directories to copy
exclude_files=()	# (): Array of files to exclude

#-------------------------------- FUNCTIONS --------------------------------#
option_eval () { # Evaluates command line options
if [ ${1} == '-a' 2>/dev/null ] || [ ${1} == '-ad' 2>/dev/null ] || [ ${1} == '-c' 2>/dev/null ] || \
[ ${1} == '-d' 2>/dev/null ] || [ ${1} == '-dr' 2>/dev/null ] || [ ${1} == '-e' 2>/dev/null ] || \
[ ${1} == '-er' 2>/dev/null ] || [ ${1} == '-force' 2>/dev/null ] || [ ${1} == '-g' 2>/dev/null ] || \
[ ${1} == '-gl' 2>/dev/null ] || [ ${1} == '-grec' 2>/dev/null ] || [ ${1} == '-h' 2>/dev/null ] || \
[ ${1} == '--help' 2>/dev/null ] || [ ${1} == '-l' 2>/dev/null ] || [ ${1} == '-m' 2>/dev/null ] || \
[ ${1} == '-nc' 2>/dev/null ] || [ ${1} == '-o' 2>/dev/null ] || [ ${1} == '--open' 2>/dev/null ] || \
[ ${1} == '-r' 2>/dev/null ] || [ ${1} == '-rec' 2>/dev/null ] || [ ${1} == '-restore' 2>/dev/null ] || \
[ ${1} == '-t' 2>/dev/null ] || [ ${1} == '-tr' 2>/dev/null ] || [ ${1} == '-tree' 2>/dev/null ] || \
[ ${1} == '-trees' 2>/dev/null ] || [ ${1} == '-v' 2>/dev/null ]; then
activate_options ${1}
elif [ ${v_in} == 'yes' 2>/dev/null ]; then # exclude specified files in code backup
	if [ -f ${1} ]; then
	exclude_files+=(`readlink -f ${1}`)
	fi
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
elif [ -d ${1} ]; then # -tree or -trees option (if activated)
directory_tree+=(`readlink -f ${1}`) # specify directories to include in tree
else
bad_inputs+=("${1}")
fi
} # option_eval

activate_options () { # read in valid user inputs
c_in='no'	# Change master code backup directory
d_in='no'	# Change/create code backup directory for specific code folders
e_in='no'	# Add script extensions to search for
er_in='no'	# Remove script extension(s) to search for
m_in='no'	# Change maximum number of backup files per script
t_in='no'	# Add text editor(s) to open files within script
tr_in='no'	# Remove text editor(s) to use within script
v_in='no'	# Exclude specified files from code backup
if [ ${1} == '-a' ]; then
get_all_files='yes'	# Include all files
elif [ ${1} == '-ad' ]; then
backup_all_dirs='yes'	# Backup all directories
elif [ ${1} == '-c' ]; then
change_master='yes'	# Change master default backup directory
c_in='yes'
elif [ ${1} == '-d' ]; then
d_in='yes'		# Create folder specific backup directory
elif [ ${1} == '-force' ]; then
force_files='yes'	# Force file saving and moving without prompts
elif [ ${1} == '-dr' ]; then
remove_dirs='yes'	# Remove folder specific backup directories
elif [ ${1} == '-e' ]; then
e_in='yes'		# Add script extension(s)
list_settings='yes'	# List user settings
elif [ ${1} == '-er' ]; then
er_in='yes'		# Remove script extension(s)
list_settings='yes'	# List user settings
elif [ ${1} == '-g' ]; then
get_latest_file='yes'	# Copy most recent backup file into working directory
elif [ ${1} == '-gl' ]; then
list_backup_files='yes'	# List backup files
get_latest_file='yes'	# Copy most recent backup file into working directory
elif [ ${1} == '-grec' ]; then
retrieve_recycle_backups='yes'   # View and retrieve files in recycle bin
elif [ ${1} == '-h' ] || [ ${1} == '--help' ]; then
activate_help='yes'	# Display help message
elif [ ${1} == '-l' ]; then
list_settings='yes'	# List user settings
elif [ ${1} == '-m' ]; then
m_in='yes'		# Change max_files
list_settings='yes'	# List user settings
elif [ ${1} == '-nc' ]; then
activate_colors='no'	# Do not display colored text in terminal
elif [ ${1} == '-o' ] || [ ${1} == '--open' ]; then
open_script='yes'	# Open this script
elif [ ${1} == '-r' ]; then
reset_template='yes'   # Reset option file
elif [ ${1} == '-rec' ]; then
recycle_backups='yes'   # Put obsolete backup files into recycle bin
elif [ ${1} == '-restore' ]; then
restore_template='yes'  # Restore old template files
elif [ ${1} == '-t' ]; then
t_in='yes'   		# Add text editor(s)
list_settings='yes'	# list user settings
elif [ ${1} == '-tr' ]; then
tr_in='yes'   		# Remove text editor(s)
list_settings='yes'	# list user settings
elif [ ${1} == '-tree' ]; then
create_dir_tree='yes'	# Create backup files recursively
elif [ ${1} == '-trees' ]; then
create_dir_tree='yes'	# Create backup files recursively
create_tree_structure='yes'	# Place backup files in same directory structure as actual files
elif [ ${1} == '-v' ]; then
v_in='yes'		# Exclude specified file(s)
else # If option is in 'option_eval' but not accounted for here
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
else # -nc option
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
	for i_text_editor in ${@:2}; do # All inputs except first
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

###--- MASTER CODE BACKUP FUNCTIONS (START) ---###
check_default_existence () { # Checks if original and new backup directories are the same
default1=${1}
default2=${2}
if [ ${default1} == ${default2} 2>/dev/null ]; then
echo "${formatred}DEFAULT DIRECTORY ALREADY IS ${formatblue}${default1}${format}"
exit_message 0
fi
} # check_default_existence

confirm_default_backup () { # User confirm default backup directory
echo "${formatorange}CONFIRM DEFAULT BACKUP DIRECTORY: ${formatgreen}${backup_dir}${format}"
printf "${formatorange}[${formatgreen}y${formatorange}/${formatgreen}n${formatorange}]${format}:"
read -r confirm_dir
if [ ${confirm_dir} = 'y' 2>/dev/null ] || [ ${confirm_dir} = 'Y' 2>/dev/null ]; then
old_default_backup_dir=(`grep '^default_backup_dir=' ${option_file}`)
new_default_backup_dir="default_backup_dir=${backup_dir}"
create_backup_dir # Create backup directory
sed -i "s@${old_default_backup_dir[0]}@${new_default_backup_dir}@g" ${option_file}
move_old_files
elif [ ${confirm_dir} = 'n' 2>/dev/null ] || [ ${confirm_dir} = 'N' 2>/dev/null ]; then
clear
input_default_backup
else
invalid_input_msg ${confirm_dir}
confirm_default_backup
fi
} # confirm_default_backup

default_code_backup () { # Backup directory if not specified
if [ -f ${option_file} ]; then
check_default_dir=(`grep '^default_backup_dir=' ${option_file} |awk -F '=' '{print $2}'`)
	if [ ${#check_default_dir[@]} -eq 0 ]; then
	input_default_backup
	else
	default_backup_dir=${check_default_dir[0]}
	fi
	
	if ! [ -d ${check_default_dir[0]} ]; then
	mkdir -p ${default_backup_dir} 2>/dev/null
	file_manager_check ${default_backup_dir} -mkdir -f ${LINENO}
	fi
fi
} # default_code_backup

input_default_backup () { # User input default backup directory
echo "${formatorange}PLEASE INPUT MASTER BACKUP DIRECTORY${format}"
printf "${formatblue}CREATE ${formatgreen}${initial_default_backup_dir}${formatblue}? INPUT [${formatgreen}y${formatblue}]${format}:"
read -r input_backup_dir
if [ ${input_backup_dir} == 'y' 2>/dev/null ] || [ ${input_backup_dir} == 'Y' 2>/dev/null ]; then
backup_dir=${initial_default_backup_dir}
default_backup_dir=${backup_dir}
check_default_existence ${original_backup_dir} ${backup_dir}
confirm_default_backup
elif [ ${input_backup_dir:0:1} == '/' 2>/dev/null ]; then
backup_dir=`echo ${input_backup_dir} |sed -e 's@/*$@@' -e 's@//*@/@g'` # Remove trailing and excess '/'
default_backup_dir=${backup_dir}
check_default_existence ${original_backup_dir} ${backup_dir}
confirm_default_backup
else
invalid_input_msg ${input_backup_dir}
input_default_backup
fi
} # input_default_backup
###--- MASTER CODE BACKUP FUNCTIONS (END) ---###

create_backup_dir () { # Create backup directory
if ! [ -d ${backup_dir} ]; then
mkdir -p ${backup_dir} 2>/dev/null
file_manager_check ${backup_dir} -mkdir -f ${LINENO}
fi
} # create_backup_dir

create_backup_file () { # Create backup file
file_value=${1}
if ! [ -z ${file_value} ] && [ ${file_value} -eq ${file_value} 2>/dev/null ]; then
create_backup_dir
outfile="${backup_dir}/`printf "%0${#max_files}d_" ${file_value}`${base_file}"
cp ${i_file} ${outfile}
	if [ ${reset_template} == 'yes' 2>/dev/null ]; then
	display_msg=''
	else
	display_msg='-c'
	fi
file_manager_check "${outfile}" -cr ${display_msg}
fi
} # create_backup_file

create_backups () { # Create backup files
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
} # create_backups

create_dir_specific_default () { # -d option: Create new backup directory for files in current directory

	add_new_default () { # Add new default to option file
	backup_dir=${1}
	create_backup_dir # Create backup directory
	
	if [ ${#check_for_default_dir[@]} -gt 0 ]; then
	sed -i "s@${check_for_default_dir[0]}@@g" ${option_file}
	fi
	
	dir_line=`grep -nF '[directories]' ${option_file} |awk -F ':' '{print $1}'`	
	if ! [ -z ${dir_line} ] && [ ${dir_line} -eq ${dir_line} 2>/dev/null ]; then
	all_custom_dirs=(`printf '%s\n' "${file_dir}=${backup_dir}" $(grep '^/' ${option_file}) |sort -u`)
	head -n${dir_line} ${option_file} > ${option_file}TEMP
	printf '%s\n' ${all_custom_dirs[@]} >> ${option_file}TEMP
	mv ${option_file}TEMP ${option_file}
	file_manager_check "${option_file}TEMP+to+${option_file}" -mv -f ${LINENO}
	completed_backup_dir+=("${file_dir}")
	else
	echo "${formatred}ERROR: ${formatorange}grep error line ${LINENO}${format}"
	fi
	
	recycle_dir_line=`grep -nF '[backup_directories]' ${recycle_bin_tracker} |awk -F ':' '{print $1}'`
	if ! [ -z ${recycle_dir_line} ] && [ ${recycle_dir_line} -eq ${recycle_dir_line} 2>/dev/null ]; then
	all_recycle_dirs=(`printf '%s\n' "${backup_dir}" $(grep '^/' ${recycle_bin_tracker}) |sort -u`)
	head -n${recycle_dir_line} ${recycle_bin_tracker} > ${recycle_bin_tracker}TEMP
	printf '%s\n' ${all_recycle_dirs[@]} >> ${recycle_bin_tracker}TEMP
	mv ${recycle_bin_tracker}TEMP ${recycle_bin_tracker}
	file_manager_check "${recycle_bin_tracker}TEMP+to+${recycle_bin_tracker}" -mv -f ${LINENO}
	else
	echo "${formatred}ERROR: ${formatorange}grep error line ${LINENO}${format}"
	fi
	} # add_new_default

	confirm_new_default () { # Confirm new specific default directory
	echo "${formatblue}SAVE FILES IN ${formatgreen}${file_dir}${formatblue} TO ${formatgreen}${check_backup_dir}${formatblue}?${format}"
	printf "${formatorange}[${formatgreen}y${formatorange}/${formatgreen}n${formatorange}]${format}:"
	read -r confirm_new
	if [ ${confirm_new} == 'y' 2>/dev/null ] || [ ${confirm_new} == 'Y' 2>/dev/null ]; then
	add_new_default ${check_backup_dir}
		if [ ${#check_for_default_dir[@]} -eq 0 ]; then
		original_backup_dir=${check_backup_dir} # No backup directory existed
		fi
	elif [ ${confirm_new} == 'n' 2>/dev/null ] || [ ${confirm_new} == 'N' 2>/dev/null ]; then
	echo "${formatred}FILES NOT BACKED UP: ${formatorange}${file_dir}${format}"
	skip_copy+=("${file_dir}")
	continue
	else
	invalid_input_msg ${confirm_new}
	confirm_new_default
	fi
	} # confirm_new_default
	
	force_file_saves () { # Prompt confirmation or not
	if [ ${force_files} == 'yes' 2>/dev/null ]; then # -force option
	add_new_default ${check_backup_dir}
		if [ ${#check_for_default_dir[@]} -eq 0 ]; then
		original_backup_dir=${check_backup_dir} # No backup directory existed
		fi
	else
	confirm_new_default
	fi
	} # force_file_saves
	
check_for_default_dir=(`grep "^${file_dir}=" ${option_file}`)
if [ ${#check_for_default_dir[@]} -gt 0 ]; then
outdir=(`echo ${check_for_default_dir[0]} |awk -F '=' '{ $1 = ""; print $0}' 2>/dev/null`)
original_backup_dir=${outdir[0]}
backup_dir=${outdir[0]}
else
original_backup_dir=${default_backup_dir}
backup_dir=${default_backup_dir}
fi

check_completed_backup_dir=(`printf '%s\n' ${completed_backup_dir[@]} |grep "^${file_dir}$"`)

if [ ${#check_completed_backup_dir[@]} -eq 0 ]; then
	if ! [ -z ${save_backup_dir} ]; then
	echo "${format}#---------------#"
		if [ ${save_backup_dir:0:1} == '/' 2>/dev/null ]; then
		check_backup_dir=`echo ${save_backup_dir} |sed -e 's@/*$@@' -e 's@//*@/@g'` # Remove trailing and excess '/'
		else
		check_backup_dir=`echo "${default_backup_dir}/${save_backup_dir}" |sed -e 's@/*$@@' -e 's@//*@/@g'` # Remove trailing and excess '/'
		fi
		if [ ${outdir[0]} == ${check_backup_dir} 2>/dev/null ]; then
		echo "${formatred}DEFAULT FOR ${formatblue}${file_dir}${formatred} ALREADY IS ${formatblue}${check_backup_dir}${format}"
		completed_backup_dir+=("${file_dir}")
		else
		force_file_saves
		fi
	else
		if [ ${#check_for_default_dir[@]} -eq 0 ]; then
		check_backup_dir=${backup_dir}
		force_file_saves
		fi
	fi
fi
} # create_dir_specific_default

create_option_file () { # Creates .ini files to store user settings
ealayher_code_dir="${HOME}/.ealayher_code" # Directory of option file
recycle_bin="${ealayher_code_dir}/.code_backup_recycle_bin" # Directory for obselete files [-rec]
recycle_bin_tracker="${ealayher_code_dir}/.`basename ${script_path%.*}`_recycle_bin.ini" # track backup directories
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

if ! [ -d ${recycle_bin} ]; then # Create recycle bin
mkdir ${recycle_bin}
fi

if ! [ -f ${recycle_bin_tracker} ]; then # Create recycle bin tracker file
echo "[backup_directories]" > ${recycle_bin_tracker}
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
} # create_option_file

move_old_files () { # -d option: Move backup files in previous directory to new directory

	move_files () { # move files to new backup directory
	original_files=(`printf "${original_backup_dir}/%s\n" ${original_files[@]}`)
	mv ${original_files[@]} ${backup_dir} 2>/dev/null
	file_manager_check "${original_backup_dir}+to+${backup_dir}" -mv -f ${LINENO} -c
	rmdir ${original_backup_dir} 2>/dev/null # Removes empty directory
	}
	
check_completed_move=(`printf '%s\n' ${completed_move[@]} |grep "^${file_dir}$"`)

if [ ${#check_completed_move[@]} -eq 0 ] && ! [ ${reset_template} == 'yes' 2>/dev/null ]; then
search_files=(`find ${file_dir} -maxdepth 1 -type f -exec basename {} \; 2>/dev/null`)
files_to_grep=$(printf '^[0-9]*_%s$\|' "${search_files[@]}" |sed 's%\\|$%%')
original_files=(`ls ${original_backup_dir} 2>/dev/null |grep "${files_to_grep}" 2>/dev/null`)
	if [ ${#original_files[@]} -gt 0 ]; then
		if [ ${force_files} == 'yes' 2>/dev/null ]; then
		move_files
		else
		echo "${formatblue}MOVE ${formatorange}${file_dir}${formatblue} BACKUP FILES${format}"
		echo "${formatgreen}${original_backup_dir}${formatblue} TO ${formatgreen}${backup_dir}${formatblue}?"
		printf "${formatorange}[${formatgreen}y${formatorange}/${formatgreen}n${formatorange}]${format}:"
		read -r to_move
			if [ ${to_move} == 'y' 2>/dev/null ] || [ ${to_move} == 'Y' 2>/dev/null ]; then
			move_files
			elif [ ${to_move} == 'n' 2>/dev/null ] || [ ${to_move} == 'N' 2>/dev/null ]; then
			echo "${formatred}NOT MOVING ${formatgreen}${original_backup_dir}${formatorange} FILES TO ${formatgreen}${backup_dir}${format}"
			else
			invalid_input_msg ${to_move}
			move_old_files
			fi
		fi
	completed_move+=("${file_dir}")
	fi
fi
} # move_old_files

recycle_backup_files () { # -rec: clean up backup directories and place lost files in recycle bin
recycle_dirs=(`grep '^/' ${recycle_bin_tracker}`) # Record of all created backup directories

if [ ${#recycle_dirs[@]} -gt 0 ]; then
active_dirs=(`grep '^/' ${option_file} |awk -F '=' '{print $1}'`)
	if [ ${#active_dirs[@]} -gt 0 ]; then
	active_files=(`find ${active_dirs[@]} -maxdepth 1 -type f -exec basename {} \; 2>/dev/null`)
	active_filter=`echo "${active_files[@]}$" |sed -e 's@ @$\\\|@g' -e 's@\.@\\\.@g'`
	recycle_files=(`find ${recycle_dirs[@]} -maxdepth 1 -type f 2>/dev/null |grep -v "${active_filter}"`)
	else
	recycle_files=(`find ${recycle_dirs[@]} -maxdepth 1 -type f 2>/dev/null`)
	fi
	
	if [ ${#recycle_files[@]} -gt 0 ]; then
	mv ${recycle_files[@]} ${recycle_bin} 2>/dev/null
	file_manager_check "${recycle_bin}" -mv -f ${LINENO}
	fi
rmdir ${recycle_dirs[@]} 2>/dev/null # Remove empty directories
echo "${formatorange}MOVED ${formatgreen}${#recycle_files[@]}${formatorange} BACKUP FILES TO RECYCLE BIN${format}"

	for i_recycle_dir in ${recycle_dirs[@]}; do # Remove non-existing directories from tracker file
		if ! [ -d ${i_recycle_dir} ]; then
		sed -i "s@^${i_recycle_dir}\$@@g" ${recycle_bin_tracker}
		fi
	done
fi
} # recycle_backup_files

remove_backup_dirs () { # -dr option: Remove specified backup directories
	read_in_indices () { # User input numbers corresponding to directories
	invalid_indices=()
	remove_indices=()
	printf "${formatorange}INPUT [${formatgreen}NUMBER(S)${formatorange}] TO REMOVE${format}:"
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
	if [ ${#invalid_indices[@]} -gt 0 ] || [ ${#remove_indices[@]} -eq 0 ]; then
	invalid_input_msg ${invalid_indices[@]}
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
} # remove_backup_dirs

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
file_manager_check ${remove_files[0]} -rm
fi

if [ ${#sort_backup_files[@]} -gt 0 ]; then # Needed if max_files='1'
	for j_backup_file in `eval echo {${#sort_backup_files[@]}..1}`; do
	temp_file="${backup_dir}/`printf "%0${#max_files}d_" ${j_backup_file}`${base_file}TEMP"
	mv ${sort_backup_files[${backup_count}]} ${temp_file} 2>/dev/null
	file_manager_check "${sort_backup_files[${backup_count}]}+to+${temp_file}" -mv -f ${LINENO}
	temp_files+=(${temp_file})
	backup_count=$((${backup_count} + 1))
	done # create temp files to reset order
	
	for j_temp_file in ${temp_files[@]}; do
	final_file=`echo ${j_temp_file} |sed 's@TEMP$@@g'`
	mv ${j_temp_file} ${final_file}
	file_manager_check "${j_temp_file}+to+${final_file}" -mv -f ${LINENO}
	done # Move temp files to regular backup files
fi

	if [ ${#check_diff[@]} -eq 0 ];  then
		if ! [ ${reset_template} == 'yes' 2>/dev/null ]; then
		echo "${formatorange}NO CHANGES DETECTED: ${formatgreen}${i_file}${format}"
		fi
	else
	create_backup_file ${new_count}
	fi
} # rename_backup_files

reset_option_file () { # -r: Reset user option file
printf "${formatorange}RESET OPTIONS FILE? [${formatgreen}y${formatorange}/${formatgreen}n${formatorange}]${format}:"
read -r reset_it
if [ ${reset_it} == 'y' 2>/dev/null ] || [ ${reset_it} == 'Y' 2>/dev/null ]; then
kill $! 2>/dev/null # Close file before removing
wait $! 2>/dev/null # Suppress kill message
backup_dir=`dirname ${option_file}`
base_file=`basename ${option_file}`
backup_files=(`ls ${backup_dir} 2>/dev/null |grep "^[0-9]*_${base_file}$" 2>/dev/null`)
i_file=${option_file}
check_completed_move=("${option_file}")
create_backups
rm ${option_file} 2>/dev/null
file_manager_check ${option_file} -rm -f ${LINENO}
create_option_file
elif [ ${reset_it} == 'n' 2>/dev/null ] || [ ${reset_it} == 'N' 2>/dev/null ]; then
kill $! 2>/dev/null # Close file before exit
wait $! 2>/dev/null # Suppress kill message
exit_message 0
else
invalid_input_msg ${reset_it}
reset_option_file
fi
} # reset_option_file

restore_backup_files () { # -gl, -grec or -restore option: View or copy files
choose_indices=()	# User selected files
bad_choose_inputs=()	# Invalid user inputs
copy_backup='no'	# Copy file(s) into working directory
remove_backup='no'	# Remove backup file(s)
remove_all_backup='no' # Remove all backup file(s)
skip_choose='no'	# Skip file
sort_list=(`ls -lt ${sort_backup_files[@]} |sed -e 's@ @,@g' -e "s@${backup_dir}/@@g"`)
list_count='1'		# List counter

for i_list_file in ${sort_list[@]}; do
echo "${formatorange}[${formatgreen}${list_count}${formatorange}] ${formatgreen}${i_list_file}${format}" |sed "s@,@ @g"
list_count=$((${list_count} + 1))
done

echo "${formatorange}INPUT [${formatgreen}NUMBER(S)${formatorange}] TO VIEW FILE(S)${format}"
echo "${formatorange}INPUT [${formatgreen}-c${formatorange}] AND [${formatgreen}NUMBER(S)${formatorange}] TO COPY SPECIFIED FILE(S)${format}"
echo "${formatorange}INPUT [${formatgreen}-r${formatorange}] AND [${formatgreen}NUMBER(S)${formatorange}] TO REMOVE SPECIFIED FILE(S)${format}"
echo "${formatorange}INPUT [${formatgreen}-removal${formatorange}] TO REMOVE ${formatred}ALL${formatorange} LISTED FILE(S)${format}"
printf "${formatorange}INPUT [${formatgreen}-s${formatorange}] TO SKIP${format}:"
read -r choose_input
for i_input in ${choose_input}; do # Read through user inputs
	if [ ${remove_all_backup} == 'yes' 2>/dev/null ]; then
	bad_choose_inputs+=("-removal:${i_input}")
	elif [ ${i_input} == '-c' 2>/dev/null ] || [ ${i_input} == '-C' 2>/dev/null ]; then
	copy_backup='yes'
	elif [ ${i_input} == '-r' 2>/dev/null ] || [ ${i_input} == '-R' 2>/dev/null ]; then
	remove_backup='yes'
	elif [ ${i_input} == '-removal' 2>/dev/null ]; then
	remove_backup='yes'
	remove_all_backup='yes'
	last_index=$((${#sort_list[@]} - 1))
	choose_indices=(`eval echo {0..${last_index}}`)
	elif [ ${i_input} == '-s' 2>/dev/null ] || [ ${i_input} == '-S' 2>/dev/null ]; then
	skip_choose='yes'
	elif [ ${i_input} -eq ${i_input} 2>/dev/null ] && [ ${i_input} -ge '1' 2>/dev/null ] && [ ${i_input} -lt ${list_count} 2>/dev/null ]; then
	choose_indices+=("$((${i_input} - 1))") # Subtract 1 for index
	else
	bad_choose_inputs+=("${i_input}")
	fi
done # i_input

if [ ${skip_choose} == 'yes' 2>/dev/null ]; then
clear
continue 2>/dev/null # suppress error message if not in loop
elif [ ${#bad_choose_inputs[@]} -gt 0 ] || [ ${#choose_indices[@]} -eq 0 ]; then
invalid_input_msg ${bad_choose_inputs[@]}
restore_backup_files
elif [ ${copy_backup} == 'yes' 2>/dev/null ]; then
clear
copy_backup='no'
	if [ ${restore_template} == 'yes' 2>/dev/null ]; then
		if [ ${#choose_indices[@]} -gt 1 ]; then
		echo "${formatred}CAN ONLY SELECT ONE USER SETTINGS FILE. SELECTED:${formatorange}${#choose_indices[@]}${format}"
		restore_backup_files
		else
		temp_option_file="${sort_backup_files[${i_choose_index}]}TEMPORARY"
		mv ${option_file} ${temp_option_file} 2>/dev/null
		file_manager_check "${option_file}+to+${temp_option_file}" -mv -f ${LINENO}
		mv ${sort_backup_files[${i_choose_index}]} ${option_file} 2>/dev/null
		file_manager_check "${sort_backup_files[${i_choose_index}]}+to+${option_file}" -mv -f ${LINENO}
		mv ${temp_option_file} ${sort_backup_files[${i_choose_index}]}
		file_manager_check "${temp_option_file}+to+${sort_backup_files[${i_choose_index}]}" -mv -f ${LINENO}
		echo "${formatgreen}RESTORED USER SETTINGS FILE${format}"
		fi
	else
		for i_choose_index in ${choose_indices[@]}; do
		cp ${sort_backup_files[${i_choose_index}]} ${file_dir} 2>/dev/null
		file_manager_check "`basename ${sort_backup_files[${i_choose_index}]}`+to+${file_dir}" -cp -c
		done
	fi
elif [ ${remove_backup} == 'yes' 2>/dev/null ]; then
echo "${formatred}REMOVE THE FOLLOWING FILE(S)?${format}"
	for i_choose_index in ${choose_indices[@]}; do
	echo ${formatblue}${sort_backup_files[${i_choose_index}]}${format}
	done
printf "${formatred}TO PERMANENTLY DELETE ${formatgreen}${#choose_indices[@]}${formatred} FILE(S) INPUT [${formatgreen}y${formatred}]${format}:"
read -r delete_backup_files
	if [ ${delete_backup_files} == 'y' 2>/dev/null ] || [ ${delete_backup_files} == 'Y' 2>/dev/null ]; then
		for i_choose_index in ${choose_indices[@]}; do
		rm ${sort_backup_files[${i_choose_index}]} 2>/dev/null
		file_manager_check "${sort_backup_files[${i_choose_index}]}" -rm -c
		done
	else
	echo "${formatred}NOT REMOVING FILES${format}"
	fi
else # Open files to view
clear
	for i_choose_index in ${choose_indices[@]}; do
	open_text_editor ${sort_backup_files[${i_choose_index}]} ${text_editors[@]}
	done
restore_backup_files
fi
} # restore_backup_files

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
 ${formatblue}-a${format}   Backup all file types
 ${formatblue}-ad${format}  Backup all directories saved in user settings
 ${formatblue}-c${format}   Change default backup directory
  [${formatorange}3${format}] ${formatgreen}${script_path} ${formatblue}-c ${formatorange}${HOME}/new_default_dir${format}
 ${formatblue}-d${format}   Create backup directory for scripts in working directory
  [${formatorange}4${format}] ${formatgreen}${script_path} ${formatblue}-d ${formatorange}${HOME}/new_backup_dir${format}
 ${formatblue}-dr${format}  Remove backup directories
 ${formatblue}-e${format}   Add extension(s) of files to backup
  [${formatorange}5${format}] ${formatgreen}${script_path} ${formatblue}-e ${formatorange}.sh .py${format}
 ${formatblue}-er${format}  Remove extension(s) of files to backup${format}
  [${formatorange}6${format}] ${formatgreen}${script_path} ${formatblue}-er ${formatorange}.sh .py${format}
 ${formatblue}-force${format} Force backup copy and move (suppress prompts)
 ${formatblue}-g${format}   Restore latest backup file
  [${formatorange}7${format}] ${formatgreen}${script_path} ${formatblue}-g ${formatorange}examplefile1.sh examplefile2.sh${format}
 ${formatblue}-gl${format}  List backup files to view, restore and/or remove
  [${formatorange}8${format}] ${formatgreen}${script_path} ${formatblue}-gl ${formatorange}examplefile1.sh examplefile2.sh${format}
 ${formatblue}-grec${format} List files in recycle bin to view, restore and/or remove
 ${formatblue}-h${format} or ${formatblue}--help${format} Display this message 
 ${formatblue}-l${format}   List all user settings
 ${formatblue}-m${format}   Input maximum number of backup copies per file
  [${formatorange}9${format}] ${formatgreen}${script_path} ${formatblue}-m ${formatorange}5${format}
 ${formatblue}-nc${format}  Prevent color printing in terminal
 ${formatblue}-o${format} or ${formatblue}--open${format} Open this script
 ${formatblue}-r${format}   Reset user settings
 ${formatblue}-rec${format} Move obsolete backup files to recycle bin
 ${formatblue}-restore${format} Restore previous user settings
 ${formatblue}-t${format}   Add text editor(s)
  [${formatorange}10${format}] ${formatgreen}${script_path} ${formatblue}-t ${formatorange}kwrite gedit${format}
 ${formatblue}-tr${format}  Remove text editor(s)
  [${formatorange}11${format}] ${formatgreen}${script_path} ${formatblue}-tr ${formatorange}kwrite gedit${format}
 ${formatblue}-tree${format} Backup files in all or specified directories in working directory
  [${formatorange}12${format}] ${formatgreen}${script_path} ${formatblue}-tree ${formatorange}dir1 dir2${format}
 ${formatblue}-trees${format} Mimic backup directory structure in working directory
  [${formatorange}13${format}] ${formatgreen}${script_path} ${formatblue}-trees ${formatorange}dir1 dir2${format}
 ${formatblue}-v${format}   Exclude specified files from being backed up
  [${formatorange}14${format}] ${formatgreen}${script_path} ${formatblue}-v ${formatorange}examplefile1.sh examplefile2.sh${format}

${formatorange}DEFAULT SETTINGS${format}:
 backup directory: ${formatgreen}`grep 'default_backup_dir=' ${option_file} |sed 's@default_backup_dir=@@g'`${format}
 max files: ${formatgreen}`grep 'max_files=' ${option_file} |sed 's@max_files=@@g'`${format}
 text editors: ${formatgreen}`grep 'text_editors=' ${option_file} |sed -e 's@text_editors=@@g' -e 's@(@@g' -e 's@)@@g'`${format}
    
${formatorange}VERSION: ${formatgreen}${version_number}${format}
${formatred}END OF HELP: ${formatgreen}${script_path}${format}"
exit_message 0
} # script_usage

file_manager_check () { # permission may prevent file adjustments
command_success="$?" # 0 = success
manipulated_file=`echo ${1} |sed "s@+to+@${formatblue} to ${formatorange}@g"`
display_created_message='no'
force_exit='no'
function_line_number='LINE-NUMBER-NOT-FOUND'
message_type='MISSING-COMMAND-NAME'
for file_manager_inputs; do
	if [ ${file_manager_inputs} -eq ${file_manager_inputs} 2>/dev/null ]; then
	function_line_number=${file_manager_inputs}
	elif [ ${file_manager_inputs} == '-c' 2>/dev/null ]; then
	display_created_message='yes'
	elif [ ${file_manager_inputs} == '-cp' 2>/dev/null ]; then
	message_type='COPY'
	elif [ ${file_manager_inputs} == '-f' 2>/dev/null ]; then
	force_exit='yes'
	elif [ ${file_manager_inputs} == '-mkdir' 2>/dev/null ] || [ ${file_manager_inputs} == '-cr' 2>/dev/null ]; then
	message_type='CREATION'
	elif [ ${file_manager_inputs} == '-mv' 2>/dev/null ]; then
	message_type='MOVE'
	elif [ ${file_manager_inputs} == '-rm' 2>/dev/null ]; then
	message_type='REMOVE'
	fi
done

if [ ${command_success} -eq 0 ]; then
	if [ ${display_created_message} == 'yes' 2>/dev/null ]; then
	echo "${formatgreen}SUCCESSFUL ${message_type}: ${formatorange}${manipulated_file}${format}"
	fi
else
echo "${formatred}FAILED ${message_type}: ${formatorange}${manipulated_file}${format}"
	if [ ${force_exit} == 'yes' 2>/dev/null ]; then
	echo "${formatred}FATAL ERROR: ${formatorange}LINE ${function_line_number}${format}"
	exit_message 98
	fi
fi
} # file_manager_check

invalid_input_msg () { # Displays message if input is invalid
if [ ${1} == '--valid--' 2>/dev/null ]; then
	if [ ${2} -eq 0 2>/dev/null ]; then
	echo "${formatred}NO VALID INPUT${format}"
	exit_message 97
	fi
else
clear
	if [ -z ${1} ]; then
	echo "${formatred}NO VALID INPUT${format}"
	else
	echo "${formatred}INVALID INPUT: '${formatorange}${@}${formatred}'${format}"
	fi
echo "${formatblue}PLEASE RE-ENTER INPUT${format}"
fi
} # invalid_input_msg

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
echo "${formatgreen}Extensions: ${formatorange}${script_exts[@]}${format}"
exit_message 0
} # list_user_settings

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
color_formats # -nc option: prevents colorful output

# Exit script if invalid inputs found
if [ ${#bad_inputs[@]} -gt 0 ]; then
suggest_help='yes'
invalid_input_msg ${bad_inputs[@]}
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
elif [ ${restore_template} == 'yes' 2>/dev/null ]; then
template_dir=`dirname ${option_file}`
template_file=`basename ${option_file}`
find_templates=(`find ${template_dir} -maxdepth 1 -type f 2>/dev/null |grep "/[0-9]*_${template_file}$"`)
	if [ ${#find_templates[@]} -eq 0 ]; then
	echo "${formatred}NO BACKUP OPTION FILES FOUND${format}"
	else
	backup_dir="${template_dir}"
	file_dir="${template_dir}"
	sort_backup_files=(`ls -t ${find_templates[@]}`)
	restore_backup_files
	fi
exit_message 0
elif [ ${backup_all_dirs} == 'yes' 2>/dev/null ]; then
dir_find=(`grep '^/' ${option_file} |awk -F '=' '{print $1}'`)
	if [ ${#dir_find[@]} -eq 0 ]; then
	echo "${formatred}NO DIRECTORIES FOUND IN USER SETTINGS${format}"
	exit_message 0
	fi
elif [ ${change_master} == 'yes' 2>/dev/null ]; then # -c option
original_backup_dir=`grep '^default_backup_dir=' ${option_file} |sed 's@default_backup_dir=@@g'`
file_dir=${original_backup_dir}
	if [ -z ${change_master_dir} ]; then
	input_default_backup
	else
	backup_dir=`echo ${change_master_dir} |sed -e 's@/*$@@' -e 's@//*@/@g'` # Remove trailing and excess '/'
	check_default_existence ${original_backup_dir} ${backup_dir}
	confirm_default_backup
	fi
list_user_settings
exit_message 0
elif [ ${remove_dirs} == 'yes' 2>/dev/null ]; then # -dr option
remove_backup_dirs
exit_message 0
elif [ ${recycle_backups} == 'yes' 2>/dev/null ]; then # -rec option
recycle_backup_files
exit_message 0
elif [ ${retrieve_recycle_backups} == 'yes' 2>/dev/null ]; then # -grec option
backup_dir="${recycle_bin}"
file_dir="$(pwd)"
recycle_find=(`find ${backup_dir} -maxdepth 1 -type f 2>/dev/null`)
	if [ ${#recycle_find[@]} -eq 0 ]; then
	echo "${formatred}NO FILES IN: ${formatorange}${recycle_bin}${format}"
	else
	sort_backup_files=(`ls -t ${recycle_find[@]}`)
	restore_backup_files
	fi
exit_message 0
elif [ ${reset_template} == 'yes' 2>/dev/null ]; then # -r option
open_text_editor ${option_file} ${text_editors[@]}
reset_option_file
input_default_backup
exit_message 0
elif [ ${create_dir_tree} == 'yes' 2>/dev/null ]; then # -tree or -trees option
	if [ ${#directory_tree[@]} -eq 0 ]; then
	code_dirs=(`find $(pwd) -type d 2>/dev/null |sort -u`) # no input directories
	else
	code_dirs=(`find ${directory_tree[@]} -type d 2>/dev/null |sort -u`) # user input directories
	fi
	invalid_input_msg '--valid--' ${#code_dirs[@]} # Check for directories
	hidden_dirs=(`printf '%s\n' ${code_dirs[@]} |grep '/\.'`)
	echo "${formatorange}FOUND: ${formatgreen}${#code_dirs[@]} ${formatorange}DIRECTORIES USING ${formatblue}-tree(s) ${formatorange}OPTION${format}"
	if ! [ ${force_files} == 'yes' 2>/dev/null ]; then
		until ! [ -z ${copy_tree} ]; do
			if [ ${#hidden_dirs[@]} -gt 0 ]; then
			echo "${formatgreen}${#hidden_dirs[@]}${formatorange}/${formatgreen}${#code_dirs[@]} ${formatorange}DIRECTORIES ARE HIDDEN${format}"
			echo "${formatorange}EXCLUDE HIDDEN DIRECTORIES? [${formatgreen}ex${formatorange}]${format}"
			echo "${formatorange}LIST HIDDEN DIRECTORIES? [${formatgreen}lh${formatorange}]${format}"
			fi
		echo "${formatorange}LIST ALL DIRECTORIES? [${formatgreen}ls${formatorange}]${format}"
		printf "${formatorange}CONTINUE COPY? [${formatgreen}y${formatorange}/${formatgreen}n${formatorange}]${format}:"
		read -r copy_tree
			if [ ${copy_tree} == 'y' 2>/dev/null ] || [ ${copy_tree} == 'Y' 2>/dev/null ]; then
			dir_find=("${code_dirs[@]}")
			elif [ ${copy_tree} == 'n' 2>/dev/null ] || [ ${copy_tree} == 'n' 2>/dev/null ]; then
			exit_message 0
			elif [ ${copy_tree} == 'ex' 2>/dev/null ] || [ ${copy_tree} == 'EX' 2>/dev/null ]; then
			exclude_dirs=$(echo "^${hidden_dirs[@]}$" |sed -e 's@ @$\\|^@g' -e 's@\.@\\\.@g')
			dir_find=(`printf '%s\n' ${code_dirs[@]} |grep -v ${exclude_dirs}`)
			invalid_input_msg '--valid--' ${#dir_find[@]}
			elif [ ${copy_tree} == 'l' 2>/dev/null ] || [ ${copy_tree} == 'ls' 2>/dev/null ] || \
			[ ${copy_tree} == 'L' 2>/dev/null ] || [ ${copy_tree} == 'LS' 2>/dev/null ] || \
			[ ${copy_tree} == 'lh' 2>/dev/null ] || [ ${copy_tree} == 'LH' 2>/dev/null ]; then
			     if [ ${copy_tree} == 'lh' 2>/dev/null ] || [ ${copy_tree} == 'LH' 2>/dev/null ]; then
			     code_dirs_of_interest=(${hidden_dirs[@]})
			     else
			     code_dirs_of_interest=(${code_dirs[@]})
			     fi
			clear
			dir_count='1'
				for i_dir in ${code_dirs_of_interest[@]}; do
				echo "${formatorange}[${formatgreen}${dir_count}${formatorange}] ${formatblue}${i_dir}${format}"
				dir_count=$((${dir_count} + 1))
				done
			copy_tree=''
			else
			invalid_input_msg ${copy_tree}
			copy_tree=''
			fi
		done
	else
	dir_find=("${code_dirs[@]}")
	fi
fi

if [ ${#code_files[@]} -eq 0 ]; then # If files not specified
code_search=(`find ${dir_find[@]} -maxdepth 1 -type f |tr '*' ' ' |tr '?' ' ' |tr '=' ' ' |sed "s@ @${formatred}+INVALID+${formatorange}@g"`)
code_exts=$(printf "\%s$\|" "${script_exts[@]}" |sed 's%\\|$%%g')
	if [ ${get_all_files} == 'no' ]; then # Get files with default extensions
	code_files=(`printf "%s\n" ${code_search[@]} |grep ${code_exts}`)
	else # -a option: get all files
	code_files=(`printf "%s\n" ${code_search[@]}`)
	fi
else # Remove invalid file characters
code_files=(`printf '%s\n' ${code_files[@]} |tr '*' ' ' |tr '?' ' ' |tr '=' ' ' |sed "s@ @${formatred}+INVALID+${formatorange}@g"`)
fi

invalid_input_msg '--valid--' ${#code_files[@]} # If no valid inputs, exit script
default_code_backup # get backup directory if not specified
create_backup_dir # Create backup directory

code_sort=(`printf '%s\n' ${code_files[@]} |sort -u`) # Alphabetize and sort files

if [ ${#exclude_files[@]} -gt 0 ]; then # -v option: Exclude specified files
exclude_filter=$(echo "^${exclude_files[@]}$" |sed 's@ @$\\|^@g')
code_sort=(`printf '%s\n' ${code_sort[@]} |grep -v "${exclude_filter}"`)
invalid_input_msg '--valid--' ${#code_sort[@]} # If no valid inputs, exit script
fi

skip_copy=()            # Do not copy files in directory
continue_with_copy=()   # Continue with copy if nested in backup directory
completed_backup_dir=() # Directory has backup
completed_move=()       # Directory has moved files
invalid_files=()	 # Files containing invalid characters

if [ ${create_tree_structure} == 'yes' 2>/dev/null ]; then # -trees option
	if [ -z ${save_backup_dir} ]; then
	tree_root=${default_backup_dir} # base backup directory is default
	else
	tree_root=${save_backup_dir} # base backup directory is user input
	fi
fi

for i_file in ${code_sort[@]}; do # loop through each code file
i_file="${i_file/\\/${formatred}+INVALID+${formatorange}}" # Change '\' characters
	  if ! [ -f ${i_file} 2>/dev/null ]; then # If file names contain special characters
	  invalid_files+=("${i_file}")
	  continue
	  fi
	  
file_dir=`dirname ${i_file}`

check_skip_copy=(`printf '%s\n' ${skip_copy[@]} |grep "^${file_dir}$"`)
check_continue_with_copy=(`printf '%s\n' ${continue_with_copy[@]} |grep "^${file_dir}$"`)

	if [ ${#check_skip_copy[@]} -gt 0 ]; then
	continue
	fi

	if [ ${create_tree_structure} == 'yes' 2>/dev/null ]; then
	end_dirname=${file_dir#"`dirname $(pwd)`/"}
	save_backup_dir="${tree_root}/${end_dirname}"
	fi

check_if_dir_backup=(`grep "^/" ${option_file} |awk -F '=' '{print $2}' 2>/dev/null |grep "^${file_dir}$" 2>/dev/null`)
	if [ ${#check_if_dir_backup[@]} -gt 0 ]; then # Prompt that directory already is a backup
	echo "${formatred}WARNING: ${formatorange}${file_dir}${formatred} IS A BACKUP DIRECTORY${format}"
	printf "${formatred}CONTINUE WITH BACKUP? [${formatgreen}y${formatred}/${formatgreen}n${formatred}]${format}:"
	read -r confirm_continue
		if ! [ ${confirm_continue} == 'y' 2>/dev/null ] || [ ${confirm_continue} == 'Y' 2>/dev/null ]; then
		skip_copy+=("${file_dir}")
		continue
		fi
	fi
	
create_dir_specific_default # -d option: Find backup directory or create new directory

	if [ ${backup_dir} == ${file_dir} 2>/dev/null ]; then # Prevent file copies in same directory
	echo "${formatred}WORKING DIRECTORY IS BACKUP DIRECTORY CANNOT COPY FILES${format}"
	skip_copy+=("${file_dir}")
	continue
	fi

	if [ ${#check_continue_with_copy[@]} -eq 0 ]; then
		if [ `printf '%s\n' ${file_dir} |grep -o "^${backup_dir}"` == ${backup_dir} 2>/dev/null ]; then # Check if inside backup directory
		clear
			until [ ${continue_copy} == 'y' 2>/dev/null ] || [ ${continue_copy} == 'Y' 2>/dev/null ] || \
			[ ${continue_copy} == 'n' 2>/dev/null ] || [ ${continue_copy} == 'N' 2>/dev/null ]; do
			echo "${formatred}YOU ARE INSIDE BACKUP DIRECTORY: ${formatorange}${backup_dir}${format}"
			printf "${formatorange}CONTINUE COPY? [${formatgreen}y${formatorange}/${formatgreen}n${formatorange}]${format}:"
			read -r continue_copy
				if [ ${continue_copy} == 'y' 2>/dev/null ] || [ ${continue_copy} == 'Y' 2>/dev/null ]; then
				continue_with_copy+=("${file_dir}")
				elif [ ${continue_copy} == 'n' 2>/dev/null ] || [ ${continue_copy} == 'N' 2>/dev/null ]; then
				skip_copy+=("${file_dir}")
				continue 2
				else
				clear
				invalid_input_msg ${continue_copy}
				fi
			done
		fi
	fi

backup_files=()
sort_backup_files=()
base_file=`basename ${i_file}`

	if [ ${original_backup_dir} != ${backup_dir} 2>/dev/null ]; then # -d option: create_dir_specific_default
	move_old_files
	fi

backup_files=(`ls ${backup_dir} 2>/dev/null |grep "^[0-9]*_${base_file}$" 2>/dev/null`)

	if [ ${get_latest_file} == 'yes' 2>/dev/null ]; then # -g or -gl option
		if [ ${#backup_files[@]} -gt 0 ]; then
		sort_backup_files=(`ls -t $(printf "${backup_dir}/%s\n" ${backup_files[@]})`)
			if [ ${list_backup_files} == 'yes' 2>/dev/null ]; then # -gl option
			restore_backup_files
			else # -g option (automatically copy latest backup file)
			cp ${sort_backup_files[0]} ${file_dir} 2>/dev/null
			file_manager_check "`basename ${sort_backup_files}`${formatblue}+to+${formatorange}${file_dir}" -cp -c
			fi
		else
		echo "${formatred}NO BACKUP FILES FOUND: ${formatorange}${i_file}${format}"
		fi
	continue
	fi
create_backups
done # i_file

if [ ${#invalid_files[@]} -gt 0 ]; then
echo "${formatred}FILE(S) CONTAINING INVALID CHARACTER(S): '\' ' ' '?' '*' '='${format}"
printf "${formatorange}%s${format}\n" ${invalid_files[@]}
fi
 
exit_message 0
