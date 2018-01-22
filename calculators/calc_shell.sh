#!/bin/bash
#--------------------------------------------------------------------------------------#
# Created: 10/22/2015 By: Evan Layher (1.0) (layher@psych.ucsb.edu)
# Revised: 01/21/2018 By: Evan Layher (1.1) Minor updates, more user friendly
#--------------------------------------------------------------------------------------#
# Calculations from shell command line
#-------------------------------- VARIABLES --------------------------------#
default_calc=('awk_sum') # which function(s) to calculate if no input

#--------------------------- DEFAULT SETTINGS ------------------------------#
text_editors=('kwrite' 'kate' 'gedit' 'open -a /Applications/BBEdit.app' 'open') # GUI text editor commands in preference order

decimal_places='2' # Maximum number of decimals in output
max_chars='95'     # 'awk' error when input >100 characters (uses loop if character count > ${max_chars})
nums_per_loop='20' # Default number of inputs per loop

IFS_old="${IFS}" # whitespace separator
IFS=$'\n' # newline separator (useful when paths have whitespace)
#------------------------- SCRIPT HELP MESSAGE -----------------------------#
usage () { # Help message: '-h' or '--help' option
	echo "${red}HELP MESSAGE: ${gre}${script_path}${whi}
${ora}DESCRIPTION${whi}: Bash calculator from command line
     
${ora}ADVICE${whi}: Create alias in ${ora}${HOME}/.bashrc${whi}
(e.g. ${gre}alias c='${script_path}'${whi})
     
${ora}USAGE${whi}: Input values and calculation type
 [${ora}1${whi}] ${gre}c ${ora}+ ${pur}6.5 -32.2 12${whi}
     
${ora}OPTIONS${whi}: Can input multiple options in any order
 ${pur}-cs${whi}  Prevent clearing screen at start
 ${pur}-d${whi}   Input decimal places (${pur}default${whi}: '${ora}${decimal_places}${whi}')
 ${pur}-h${whi} or ${pur}--help${whi}  Display this message
 ${pur}-nc${whi}  Prevent color printing in terminal
 ${pur}-nm${whi}  Prevent exit message from displaying
 ${pur}-o${whi} or ${pur}--open${whi} Open this script
 
${ora}CALCULATION INPUTS${whi}:
AVERAGE : ${pur}avg${whi},${pur} -avg${whi},${pur} average${whi},${pur} mean${whi}
MEDIAN  : ${pur}med${whi},${pur} -med${whi},${pur} median${whi},${pur} -median${whi}
POWER   : ${pur}pow${whi},${pur} -pow${whi},${pur} power${whi},${pur} -power${whi}
PRODUCT : ${pur}x${whi},${pur} prod${whi},${pur} product${whi},${pur} -product${whi}
QUOTIENT: ${pur}/${whi},${pur} div${whi},${pur} divide${whi},${pur} quotient${whi}
SUM     : ${pur}+${whi},${pur} add${whi},${pur} -add${whi},${pur} sum${whi}

${ora}DEFAULT CALCULATIONS${whi}:
DECIMAL PLACES: ${pur}${decimal_places}${whi}
$(display_values ${default_calc[@]}) 
${ora}VERSION: ${gre}${version}${whi}
${red}END OF HELP: ${gre}${script_path}${whi}"
	exit 0
} # usage

#----------------------- GENERAL SCRIPT VARIABLES --------------------------#
script_path="${BASH_SOURCE[0]}" # Script path (becomes absolute path later)
version='1.1' # Script version number

	###--- 'yes' or 'no' options (inputs do the opposite of default) ---###
activate_colors='yes' # 'yes': Display messages in color [INPUT: '-nc']
activate_help='no'    # 'no' : Display help message      [INPUT: '-h' or '--help']
clear_screen='yes'    # 'yes': Clear screen at start     [INPUT: '-cs']
display_exit='yes'    # 'yes': Display an exit message   [INPUT: '-nm']
open_script='no'      # 'no' : Open this script          [INPUT: '-o' or '--open']
suggest_help='no'     # 'no' : Suggest help (within script option: '-nh')

#-------------------------------- FUNCTIONS --------------------------------#
option_eval () { # Evaluate user inputs
	if [ "${1}" == '-' 2>/dev/null ] || [ "${1}" == '-cs' 2>/dev/null ] || [ "${1}" == '-d' 2>/dev/null ] || \
	   [ "${1}" == '-h' 2>/dev/null ] || [ "${1}" == '--help' 2>/dev/null ] || \
	   [ "${1}" == '-nc' 2>/dev/null ] || [ "${1}" == '-nm' 2>/dev/null ] || \
	   [ "${1}" == '-o' 2>/dev/null ] || [ "${1}" == '--open' 2>/dev/null ]; then
		activate_options "${1}"
	elif [ "${1}" == '-avg' 2>/dev/null ] || [ "${1}" == 'avg' 2>/dev/null ] || \
	     [ "${1}" == 'mean' 2>/dev/null ] || [ "${1}" == 'average' 2>/dev/null ]; then
		calc_types+=("awk_average")
	elif [ "${1}" == '-med' 2>/dev/null ] || [ "${1}" == 'med' 2>/dev/null ] || \
	     [ "${1}" == '-median' 2>/dev/null ] || [ "${1}" == 'median' 2>/dev/null ]; then
		calc_types+=("awk_median")
	elif [ "${1}" == '-pow' 2>/dev/null ] || [ "${1}" == 'pow' 2>/dev/null ] || \
	     [ "${1}" == '-power' 2>/dev/null ] || [ "${1}" == 'power' 2>/dev/null ]; then
		calc_types+=("awk_power")
	elif [ "${1}" == 'x' 2>/dev/null ] || [ "${1}" == 'prod' 2>/dev/null ] || \
	     [ "${1}" == '-product' 2>/dev/null ] || [ "${1}" == 'product' 2>/dev/null ]; then
		calc_types+=("awk_product")
	elif [ "${1}" == '/' 2>/dev/null ] || [ "${1}" == 'div' 2>/dev/null ] || \
	     [ "${1}" == 'divide' 2>/dev/null ] || [ "${1}" == 'quotient' 2>/dev/null ]; then
		calc_types+=("awk_quotient")
	elif [ "${1}" == '+' 2>/dev/null ] || [ "${1}" == 'sum' 2>/dev/null ] || \
	     [ "${1}" == 'add' 2>/dev/null ] || [ "${1}" == '-add' 2>/dev/null ]; then
		calc_types+=("awk_sum")
	elif [ "${d_in}" == 'yes' 2>/dev/null ]; then
		if [ "${1}" -eq "${1}" 2>/dev/null ] && [ "${1}" -ge '0' 2>/dev/null ]; then
			decimal_places="${1}" # User specifies decimal places
		else # Not integer >= 0
			bad_inputs+=("MUST-BE-INTEGER_-d:${1}")
		fi
		
		d_in='no' # Read in 1 value only
	elif [ "${minus_in}" == 'yes' 2>/dev/null ]; then
		values+=("-${1}") # Create negative value
		minus_in='no' # Read in 1 value only
	else # Collect values (floats included)
		chk_add=($(echo "${1}" |grep '+')) # check for add values (without spaces)
		chk_div=($(echo "${1}" |grep '/')) # check for divide values (without spaces)
		chk_mul=($(echo "${1}" |grep 'x')) # check for multiply values (without spaces)
		chk_sub=($(echo "${1}" |grep '-')) # check for subtract values (without spaces)
		
		if [ "${#chk_add[@]}" -gt '0' ] || [ "${#chk_sub[@]}" -gt '0' ]; then
			calc_types+=("awk_sum")
		fi # Add values
		
		if [ "${#chk_div[@]}" -gt '0' ]; then
			calc_types+=("awk_quotient")
		fi # Divide values
		
		if [ "${#chk_mul[@]}" -gt '0' ]; then
			calc_types+=("awk_product")
		fi # Multiply values
		
		values+=($(echo "${1}" |tr '+' "${IFS}" |tr 'x' "${IFS}" |tr '/' "${IFS}"))
	fi
} # option_eval

activate_options () { # Activate input options
	d_in='no'     # Read in decimal value
	minus_in='no' # Subtract next value

	if [ "${1}" == '-' ]; then
		minus_in='yes'        # Subtract next value
	elif [ "${1}" == '-cs' ]; then
		clear_screen='no'     # Do NOT clear screen at start
	elif [ "${1}" == '-d' ]; then
		d_in='yes'            # Read in decimal value
	elif [ "${1}" == '-h' ] || [ "${1}" == '--help' ]; then
		activate_help='yes'   # Display help message
	elif [ "${1}" == '-nc' ]; then
		activate_colors='no'  # Do NOT display messages in color
	elif [ "${1}" == '-nm' ]; then
		display_exit='no'     # Do NOT display exit message
	elif [ "${1}" == '-o' ] || [ "${1}" == '--open' ]; then
		open_script='yes'     # Open this script
	else # if option is undefined (for debugging)
		bad_inputs+=("ERROR:activate_options:${1}")
	fi
} # activate_options

awk_average () { # Average all inputs
	input_numbers=($(printf '%s\n' ${@} |grep '[0-9]')) # Only include values with digit(s)

	if [ "${#input_numbers[@]}" -eq '0' ]; then # If no valid inputs, return '0'
		awk_final_value='0' # if no valid inputs, then return 0
	else
		input_char_check=$(echo ${input_numbers[@]} |sed 's@ @+@g') # check if input characters > ${max_chars}
		if [ "${#input_char_check}" -gt "${max_chars}" ]; then # Use loop for large input
			index_count='0' # begin with first index
			until [ -z "${input_numbers[${index_count}]}" ]; do # Add values until array index is empty
				input_char_check=$(echo "${awk_final_sum}+${input_numbers[@]:${index_count}:${nums_per_loop}}" |sed 's@ @+@g') # check if input characters > ${max_chars}
				if [ "${#input_char_check}" -gt "${max_chars}" ]; then
					if [ "${nums_per_loop}" -gt '1' ]; then # Reduce number of inputs to avoid error
						nums_per_loop=$((${nums_per_loop} - 1))
					else # Single input too large for calculation
						awk_final_value='ERROR' # Return 'ERROR'
						break # break out of loop
					fi
				else # Add values to ${awk_final_value}
					awk_final_sum=$(eval "echo |awk '{print $(echo ${awk_final_sum} ${input_numbers[@]:${index_count}:${nums_per_loop}} |sed 's@ @+@g')}' OFMT='%0.${decimal_places}f'")
					index_count=$((${index_count} + ${nums_per_loop}))
				fi
			done
		else # Put all values into 'awk'
			awk_final_sum=$(eval "echo |awk '{print $(echo ${input_numbers[@]} |sed 's@ @+@g')}' OFMT='%0.${decimal_places}f'")
			# e.g.: echo |awk '{print 3.2+-9.8+9.23}' OFMT='%0.2f' # change decimal places
		fi
		
		if [ -z "${awk_final_value}" ]; then
			input_char_check="${awk_final_sum}/${#input_numbers[@]}"
			if [ "${#input_char_check}" -gt "${max_chars}" ]; then
				awk_final_value='ERROR'
			else 
				awk_final_value=$(eval "echo |awk '{print ${awk_final_sum}/${#input_numbers[@]}}' OFMT='%0.${decimal_places}f'")
				# e.g.: echo |awk '{print -54.6/12}' OFMT='%0.2f' # change decimal places
			fi
		fi
	fi
	
	echo "${awk_final_value}"
} # awk_average

awk_median () { # Add all inputs together
	input_numbers=($(printf '%s\n' ${@} |grep '[0-9]' |sort -n)) # Only include values with digit(s)
	odd_or_even=$((${#input_numbers[@]} % 2)) # 0 = even, 1 = odd
	
	if [ "${#input_numbers[@]}" -eq '0' ]; then # If no valid inputs, return '0'
		awk_final_value='0' # if no inputs, then return 0
	else
		if [ "${odd_or_even}" -eq '0' ]; then # Even
			high_index=$((${#input_numbers[@]} / 2))
			low_index=$((${high_index} - 1))
			input_sum=("${input_numbers[${high_index}]}" "${input_numbers[${low_index}]}")
			if [ $((${#input_numbers[${high_index}]} + ${#input_numbers[${low_index}]} + 1)) -gt "${max_chars}" ]; then
				awk_final_value='ERROR' # Return 'ERROR'
			else
				awk_final_sum=$(eval "echo |awk '{print $(echo ${input_sum[@]} |sed 's@ @+@g')}' OFMT='%0.${decimal_places}f'")
				awk_final_value=$(eval "echo |awk '{print ${awk_final_sum}/${#input_sum[@]}}' OFMT='%0.${decimal_places}f'")
			fi
		else # Odd
			mid_index=$(($((${#input_numbers[@]} - 1)) / 2))
			awk_final_value="${input_numbers[${mid_index}]}"
		fi
	fi
	
	echo "${awk_final_value}"
} # awk_median

awk_power () { # Power all inputs: NOTE takes power from right to left (e.g. 3^3^3 becomes 3^27)
	input_numbers=($(printf '%s\n' ${@} |grep '[0-9]')) # Only include values with digit(s)

	if [ "${#input_numbers[@]}" -eq '0' ]; then # If no inputs, return '0'
		awk_final_value='0' # if no valid inputs, then return 0
	else
		input_char_check=$(echo ${input_numbers[@]} |sed 's@ @^@g') # check if input characters > ${max_chars}
		if [ "${#input_char_check}" -gt "${max_chars}" ]; then # Input too large for 'awk'
			awk_final_value='ERROR' # Return 'ERROR'
		else
			awk_final_value=$(eval "echo |awk '{print $(echo ${input_numbers[@]} |sed 's@ @^@g')}' OFMT='%0.${decimal_places}f'")
			# e.g.: echo |awk '{print 3.2^-9.8^9.23}' OFMT='%0.2f' # change decimal places
		fi
	fi
	
	echo "${awk_final_value}"
} # awk_power

awk_product () { # Multiply all inputs
	input_numbers=($(printf '%s\n' ${@} |grep '[0-9]')) # Only include values with digit(s)
	
	if [ "${#input_numbers[@]}" -eq '0' ]; then # If no inputs, return '0'
		awk_final_value='0' # if no valid inputs, then return 0
	else # add inputs together
		input_char_check=$(echo ${input_numbers[@]} |sed 's@ @+@g') # check if input characters > ${max_chars}
		if [ "${#input_char_check}" -gt "${max_chars}" ]; then # Use loop for large input
			index_count='0' # begin with first index
			until [ -z "${input_numbers[${index_count}]}" ]; do # Add values until array index is empty
				input_char_check=$(echo "${awk_final_value}*${input_numbers[@]:${index_count}:${nums_per_loop}}" |sed 's@ @+@g') # check if input characters > ${max_chars}
				if [ "${#input_char_check}" -gt "${max_chars}" ]; then
					if [ "${nums_per_loop}" -gt '1' ]; then # Reduce number of inputs to avoid error
						nums_per_loop=$((${nums_per_loop} - 1))
					else # Single input too large for calculation
						awk_final_value='ERROR' # Return 'ERROR'
						break # break out of loop
					fi
				else # Add values to ${awk_final_value}
					awk_final_value=$(eval "echo |awk '{print $(echo ${awk_final_value} ${input_numbers[@]:${index_count}:${nums_per_loop}} |sed 's@ @*@g')}' OFMT='%0.${decimal_places}f'")
					index_count=$((${index_count} + ${nums_per_loop}))
				fi
			done
		else
			awk_final_value=$(eval "echo |awk '{print $(echo ${input_numbers[@]} |sed 's@ @*@g')}' OFMT='%0.${decimal_places}f'")
			# e.g.: echo |awk '{print 3.2*-9.8*9.23}' OFMT='%0.2f' # change decimal places
		fi
	fi
	
	echo "${awk_final_value}"
} # awk_product

awk_quotient () { # Divide all inputs
	input_numbers=($(printf '%s\n' ${@} |grep '[0-9]')) # Only include values with digit(s)
	
	if [ "${#input_numbers[@]}" -eq '0' ]; then # If no inputs, return '0'
		awk_final_value='0' # if no valid inputs, then return 0
	else # add inputs together
		input_char_check=$(echo ${input_numbers[@]} |sed 's@ @+@g') # check if input characters > ${max_chars}
		if [ "${#input_char_check}" -gt "${max_chars}" ]; then # Use loop for large input
			index_count='0' # begin with first index
			until [ -z "${input_numbers[${index_count}]}" ]; do # Add values until array index is empty
				input_char_check=$(echo "${awk_final_value}/${input_numbers[@]:${index_count}:${nums_per_loop}}" |sed 's@ @+@g') # check if input characters > ${max_chars}
				if [ "${#input_char_check}" -gt "${max_chars}" ]; then
					if [ "${nums_per_loop}" -gt '1' ]; then # Reduce number of inputs to avoid error
						nums_per_loop=$((${nums_per_loop} - 1))
					else # Single input too large for calculation
						awk_final_value='ERROR' # Return 'ERROR'
						break # break out of loop
					fi
				else # Add values to ${awk_final_value}
					awk_final_value=$(eval "echo |awk '{print $(echo ${awk_final_value} ${input_numbers[@]:${index_count}:${nums_per_loop}} |sed 's@ @/@g')}' OFMT='%0.${decimal_places}f'")
					index_count=$((${index_count} + ${nums_per_loop}))
				fi
			done
		else
			awk_final_value=$(eval "echo |awk '{print $(echo ${input_numbers[@]} |sed 's@ @/@g')}' OFMT='%0.${decimal_places}f'")
			# e.g.: echo |awk '{print 3.2/-9.8/9.23}' OFMT='%0.2f' # change decimal places
		fi
	fi
	
	echo "${awk_final_value}"
} # awk_quotient

awk_sum () { # Add all inputs
	input_numbers=($(printf '%s\n' ${@} |grep '[0-9]')) # Only include values with digit(s)
	
	if [ "${#input_numbers[@]}" -eq '0' ]; then # If no valid inputs, return '0'
		awk_final_value='0' # if no inputs, then return 0
	else # add inputs together
		input_char_check=$(echo ${input_numbers[@]} |sed 's@ @+@g') # check if input characters > ${max_chars}
		if [ "${#input_char_check}" -gt "${max_chars}" ]; then # Use loop for large input
			index_count='0' # begin with first index
			until [ -z "${input_numbers[${index_count}]}" ]; do # Add values until array index is empty
				input_char_check=$(echo "${awk_final_value}+${input_numbers[@]:${index_count}:${nums_per_loop}}" |sed 's@ @+@g') # check if input characters > ${max_chars}
				if [ "${#input_char_check}" -gt "${max_chars}" ]; then
					if [ "${nums_per_loop}" -gt '1' ]; then # Reduce number of inputs to avoid error
						nums_per_loop=$((${nums_per_loop} - 1))
					else # Single input too large for calculation
						awk_final_value='ERROR' # Return 'ERROR'
						break # break out of loop
					fi
				else # Add values to ${awk_final_value}
					awk_final_value=$(eval "echo |awk '{print $(echo ${awk_final_value} ${input_numbers[@]:${index_count}:${nums_per_loop}} |sed 's@ @+@g')}' OFMT='%0.${decimal_places}f'")
					index_count=$((${index_count} + ${nums_per_loop}))
				fi
			done
		else # Put all values into 'awk'
			awk_final_value=$(eval "echo |awk '{print $(echo ${input_numbers[@]} |sed 's@ @+@g')}' OFMT='%0.${decimal_places}f'")
			# e.g.: echo |awk '{print 3.2+-9.8+9.23}' OFMT='%0.2f' # change decimal places
		fi
	fi
	
	echo "${awk_final_value}"
} # awk_sum

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

display_values () { # Display output with numbers
	if [ "${#@}" -gt '0' ]; then
		val_count=($(seq 1 1 ${#@}))
		vals_and_count=($(paste -d "${IFS}" <(printf "%s${IFS}" ${val_count[@]}) <(printf "%s${IFS}" ${@})))
		printf "${pur}[${ora}%s${pur}] ${gre}%s${IFS}${whi}" ${vals_and_count[@]}
	fi
} # display_values

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
			exit 99
		fi
	else # Missing input file
		echo "${red}MISSING FILE: ${ora}${open_file}${whi}"
	fi # if [ -f "${open_file}" ]; then
} # open_text_editor

#---------------------------------- CODE -----------------------------------#
script_path=$(mac_readlink "${script_path}") # similar to 'readlink -f' in linux

for inputs; do # Read through all inputs
	option_eval "${inputs}"
done

if ! [ "${clear_screen}" == 'no' 2>/dev/null ]; then
	clear     # Clears screen unless input option: '-cs'
fi

color_formats # Activate or prevent colorful output

# Display help message or open script
if [ "${activate_help}" == 'yes' 2>/dev/null ]; then # '-h' or '--help'
	usage # Display help message
elif [ "${open_script}" == 'yes' 2>/dev/null ]; then # '-o' or '--open'
	open_text_editor "${script_path}" # Open script
	exit 0
fi

# Exit script if invalid inputs
if [ "${#bad_inputs[@]}" -gt '0' ]; then
	clear
	echo "${red}INVALID INPUT:${whi}"
	display_values ${bad_inputs[@]}
	exit 1
elif [ "${#values[@]}" -eq '0' ]; then
	echo "${red}NO VALUES SPECIFIED${whi}"
	exit 2
fi

if [ "${#calc_types[@]}" -eq '0' ]; then
	if [ "${#default_calc[@]}" -gt '0' ]; then
		calc_types=($(printf "%s${IFS}" ${default_calc[@]})) # Use printf to avoid $IFS errors
	else # 
		echo "${red}NO CALCULATION DEFAULT VALUES SET: '${ora}default_calc${red}'${whi}"
		exit 3
	fi
fi

calc_types=($(printf "%s${IFS}" ${calc_types[@]} |sort -u)) # sort unique values

echo "${pur}VALUES: ${gre}"$(printf '%s ' ${values[@]} |sed -e 's,-, -,g' -e 's,- ,,g' -e 's, $,,' -e 's,  , ,g')"${whi}"
for i in ${!calc_types[@]}; do
	calc_type="${calc_types[${i}]}"
	answer=$(eval "${calc_type} "$(printf '%s ' ${values[@]} |sed -e 's,-, -,g' -e 's,- ,,g' -e 's, $,,' -e 's,  , ,g'))
	echo "${ora}${calc_type}: ${gre}${answer}${whi}" |sed 's@awk_@@g'
done

exit 0