#!/bin/bash
#--------------------------------------------------------------------------------------#
# Created: 06/22/15 By: Evan Layher (evan.layher@psych.ucsb.edu)
# Revised: 10/19/15 By: Evan Layher
# Revised: 02/12/15 By: Evan Layher # 'awk' error when input >100 characters (use loop)
#--------------------------------------------------------------------------------------#
# Multiply an array of numbers (floats or integers) in a shell script and echo result
# Source this function (or copy it into script of interest)

# EXAMPLE 1: Input values
# awk_product '3.5' '-5'
# prints: -17.5

# EXAMPLE 2: Input array(s)
# y=('-1' '5.5' '10')
# z=('1.87' '6')
# awk_product ${y[@]} ${z[@]}
# prints: -617.1

# EXAMPLE 3: Store output in variable
# x=$(awk_product ${y[@]} ${z[@]})
#--------------------------------------------------------------------------------------#
decimal_places='2' # Maximum number of decimals in output
max_chars='95'     # 'awk' error when input >100 characters (uses loop if character count > ${max_chars})
nums_per_loop='20' # Default number of inputs per loop

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
