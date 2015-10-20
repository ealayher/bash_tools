#!/bin/bash
#--------------------------------------------------------------------------------------#
# Created: 06/22/15 By: Evan Layher (evan.layher@psych.ucsb.edu)
# Revised: 10/19/15 By: Evan Layher
#--------------------------------------------------------------------------------------#
# Sum an array of numbers (floats or integers) in a shell script and echo result
# Source this function (or copy it into script of interest)

# EXAMPLE 1: Input values
# awk_sum '1.765' '-2.321' '45' '3.4'
# prints: 47.844 (or 47.84 if decimal_places='2')

# EXAMPLE 2: Input array(s)
# y=('-1.32' '12.32' '1234.23')
# z=('1.87' '-87.6')
# awk_sum ${y[@]} ${z[@]}
# prints: 1159.5

# EXAMPLE 3: Store output in variable
# x=$(awk_sum ${y[@]} ${z[@]})
#--------------------------------------------------------------------------------------#
decimal_places='2' # Maximum number of decimals in output

awk_sum () { # Add all inputs together
	input_numbers=($(printf '%s\n' ${@} |grep '[0-9]')) # Only include values with digit(s)
	
	if [ ${#input_numbers[@]} -eq '0' ]; then # If no valid inputs, return '0'
		awk_final_value='0' # if no inputs, then return 0
	else
		awk_final_value=$(eval "echo |awk '{print $(echo ${input_numbers[@]} |sed 's@ @+@g')}' OFMT='%0.${decimal_places}f'")
		# e.g.: echo |awk '{print 3.2+-9.8+9.23}' OFMT='%0.2f' # change decimal places
	fi
	
	echo "${awk_final_value}"
} # awk_sum
