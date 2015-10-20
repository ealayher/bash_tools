#!/bin/bash
#--------------------------------------------------------------------------------------#
# Created: 10/19/15 By: Evan Layher (evan.layher@psych.ucsb.edu)
# Revised: 10/19/15 By: Evan Layher
#--------------------------------------------------------------------------------------#
# Get median of an array of numbers (floats or integers) in a shell script and echo result
# Source this function (or copy it into script of interest)

#--------------------------------------------------------------------------------------#
decimal_places='2' # Maximum number of decimals in output

awk_median () { # Add all inputs together
	input_numbers=($(printf '%s\n' ${@} |grep '[0-9]' |sort -n)) # Only include values with digit(s)
	odd_or_even=$((${#input_numbers[@]} % 2)) # 0 = even, 1 = odd
	
	if [ ${#input_numbers[@]} -eq '0' ]; then # If no valid inputs, return '0'
		awk_final_value='0' # if no inputs, then return 0
	else
		if [ ${odd_or_even} -eq '0' ]; then # Even
			high_index=$((${#input_numbers[@]} / 2))
			low_index=$((${high_index} - 1))
			input_sum=("${input_numbers[${high_index}]}" "${input_numbers[${low_index}]}")
			awk_final_sum=$(eval "echo |awk '{print $(echo ${input_sum[@]} |sed 's@ @+@g')}' OFMT='%0.${decimal_places}f'")
			awk_final_value=$(eval "echo |awk '{print ${awk_final_sum}/${#input_sum[@]}}' OFMT='%0.${decimal_places}f'")
		else # Odd
			mid_index=$(($((${#input_numbers[@]} - 1)) / 2))
			awk_final_value="${input_numbers[${mid_index}]}"
		fi
	fi
	
	echo "${awk_final_value}"
} # awk_median
