#!/bin/bash
#--------------------------------------------------------------------------------------#
# Created: 06/22/15 By: Evan Layher (evan.layher@psych.ucsb.edu)
# Revised: 10/19/15 By: Evan Layher
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

awk_power () { # Power all inputs: NOTE takes power from right to left (e.g. 3^3^3 becomes 3^27)
	input_numbers=($(printf '%s\n' ${@} |grep '[0-9]')) # Only include values with digit(s)

	if [ ${#input_numbers[@]} -eq '0' ]; then # If no inputs, return '0'
		awk_final_value='0' # if no valid inputs, then return 0
	else
		awk_final_value=$(eval "echo |awk '{print $(echo ${input_numbers[@]} |sed 's@ @^@g')}' OFMT='%0.${decimal_places}f'")
		# e.g.: echo |awk '{print 3.2^-9.8^9.23}' OFMT='%0.2f' # change decimal places
	fi
	
	echo "${awk_final_value}"
} # awk_power
