#!/bin/bash
#--------------------------------------------------------------------------------------#
# Created: 06/22/15 By: Evan Layher (evan.layher@psych.ucsb.edu)
# Revised: 10/19/15 By: Evan Layher
# Revised: 02/12/16 By: Evan Layher # 'awk' error when input >100 characters
#--------------------------------------------------------------------------------------#
# Take the power of an array of numbers (floats or integers) in a shell script and echo result
# Source this function (or copy it into script of interest)

# EXAMPLE 1: Input values
# awk_power '5' '5'
# prints: 3125

# EXAMPLE 2: Input array(s)
# y=('3' '2')
# z=('3')
# awk_power ${y[@]} ${z[@]}
# prints: 6561
# Beware: above example does 3^(8)

# EXAMPLE 3: Store output in variable
# x=$(awk_power ${y[@]} ${z[@]})
#--------------------------------------------------------------------------------------#
decimal_places='2' # Maximum number of decimals in output
max_chars='95'     # 'awk' error when input >100 characters (uses loop if character count > ${max_chars})

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
