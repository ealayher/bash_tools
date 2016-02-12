#!/bin/bash
#--------------------------------------------------------------------------------------#
# Created: 06/22/15 By: Evan Layher (evan.layher@psych.ucsb.edu)
# Revised: 10/19/15 By: Evan Layher
# Revised: 02/12/16 By: Evan Layher # 'awk' error when input >100 characters
#--------------------------------------------------------------------------------------#
# sum, average, multiply, divide or power in bash (floats and integers)
# source script and input following functions with values

# EXAMPLE 1: Input values
# awk_sum '1.765' '-2.321' '45' '3.4'
# prints: 47.844 (or 47.84 if decimal_places='2')

# EXAMPLE 2: Input array(s)
# y=('-1' '5.5' '10')
# z=('1.87' '6')
# awk_average ${y[@]} ${z[@]}
# prints: 4.474 (or 4.47 if decimal_places='2')

# EXAMPLE 3: Store output in variable
# x=$(awk_quotient ${y[@]} ${z[@]})
#--------------------------------------------------------------------------------------#
decimal_places='2' # Maximum number of decimals in output
max_chars='95'     # 'awk' error when input >100 characters (uses loop if character count > ${max_chars})
nums_per_loop='20' # Default number of inputs per loop

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
