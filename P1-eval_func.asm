################################################################################
# Title:	Polynomial Evaluator
# Filename:	eval_funct.asm
# Author:	Jefferson Phillips Retana
# Date:		March 25, 2020
# Description:	Evaluates a quadratic polynomialin the form: f(x) = a*x^2 + b*x + c
# Input:	Coefficients and x value (Integers).
# Output:	Result
################################################################################

##########  Data segment  ######################################################
.data
	fx: .asciiz "\n\tf(x) = a*x^2 + b*x + c\n\n"	#Initial string
	CoefA: .asciiz "\tEnter Coefficient [a]: "	#Get 1st coefficient
	CoefB: .asciiz "\tEnter Coefficient [b]: "	#Get 2st coefficient
	CoefC: .asciiz "\tEnter Coefficient [c]: "	#Get 3st coefficient
	InpX: .asciiz "\tEnter Input Value [x]: "	#Get 3st coefficient
	Coef_Array: .space 12				#3 coficients 

	new_line:.asciiz "\n"
	result_1: .asciiz "\n\tf(x) = "
	result_2: .asciiz "*x^2 + "
	result_3: .asciiz "*x + "
	result_4: .asciiz " = "

	extra_credit: .asciiz "\n\tWhen f(x) = 0\n"
	root1: .asciiz "\t\tRoot 1: "
	root2: .asciiz "\t\tRoot 2: "
	two: .word 2
	four: .word 4

##########  Code segment  ######################################################
.text

################################################################################
# Procedure:	Main
# Comments:	Controls the execution of the program.
################################################################################
.globl main
main:				# Program entry point
	
	li $v0, 4		# Load Immediate. System call code for print string.
	la $a0 fx		# Load Address. ASCII string f_x 
	syscall			# Output
	
	jal get_input		# Call procedure to get input values
	
	jal print_function	# Call Procedure to display the function with the input values
	
	jal Compute_n_print	# Call a function to process the values and print the result to the screen
 
	li $v0, 4		# Load Immediate. System call code for printing string 
	la $a0, new_line	# Load Address. Just a new line
	syscall			# Print the prompted message
	
	jal extra_cre		#Extra Credit

	li $v0, 4		# Load Immediate. System call code for printing string 
	la $a0, new_line	# Load Address. Just a new line
	syscall			# Print the prompted message
	
	li $v0, 10		# Exit program
	syscall
	
	
################################################################################
# Procedure:	get_input
# Comments:	Gets the values of the coefficients and x
# Input:	Coefficients and x, from the users
# Output:	Array
################################################################################
get_input:	
### Get A - Stored in Coef_Array(0).
	li $v0, 4		# Load Immediate. System call code for printing string 
	la $a0, CoefA		# Load Address. ASCII string Coef_B
	syscall			# Print the prompted message
	
	li $v0, 5		# Load Immediate. System call code to Read Integer and store value
	syscall			# Read the value of X into $v0
	addi $t0, $zero, 0	# Set index to zero	
	sb $v0, Coef_Array($t0)	#Store the value in the array

### Get B - Stored in Coef_Array(4).
	li $v0, 4		# Load Immediate. System call code for printing string 
	la $a0, CoefB		# Load Address. ASCII string Coef_B
	syscall			# Print the prompted message
	
	li $v0, 5		# Load Immediate. System call code to Read Integer and store value
	syscall			# Read the value of X into $v0
	addi $t0, $t0, 4	# Set index to 4	
	sb $v0, Coef_Array($t0)	#Store the value in the array

### Get C - Stored in Coef_Array(8).
	li $v0, 4		# Load Immediate. System call code for printing string 
	la $a0, CoefC		# Load Address. ASCII string Coef_B
	syscall			# Print the prompted message
	
	li $v0, 5		# Load Immediate. System call code to Read Integer and store value
	syscall			# Read the value of X into $v0
	addi $t0, $t0, 4	# Set index to 8
	sb $v0, Coef_Array($t0)	#Store the value in the array
	
### Get X - Stored in t4.
	li $v0, 4		# Load Immediate. System call code for printing string 
	la $a0, InpX		# Load Address. ASCII string Coef_B
	syscall			# Print the prompted message
	
	li $v0, 5		# Load Immediate. System call code to Read Integer and store value
	syscall			# Read the value of X into $v0
	move $t4, $v0		# Store value to $t4
	
	jr $ra			#End of Procedure
	
	
################################################################################
# Procedure:	get_input
# Comments:	Print the function with the input coeficients
# Input:	Array
# Output:	Function printed to screen
################################################################################
print_function:

	li $v0, 4		# Load Immediate. System call code for printing string 
	la $a0, result_1	# Load Address. ASCII string result_1
	syscall			# Print the prompted message
	
	addi $t0, $zero, 0	# Set index to zero	
	lb $t2, Coef_Array($t0)	# Get value A back from the array, store it in $t2 
	li $v0, 1		# System call code for printing integer
	move $a0, $t2		# Move printed value to $a0
	syscall			# Print

	li $v0, 4		# Load Immediate. System call code for printing string 
	la $a0, result_2	# Load Address. ASCII string result_2
	syscall			# Print the prompted message
	
	addi $t0, $t0, 4	# Set index to zero	
	lb $t2, Coef_Array($t0)	# Get value A back from the array, store it in $t2 
	li $v0, 1		# System call code for printing integer
	move $a0, $t2		# Move printed value to $a0
	syscall			# Print
	
	li $v0, 4		# Load Immediate. System call code for printing string 
	la $a0, result_3	# Load Address. ASCII string result_3
	syscall			# Print the prompted message
	
	addi $t0, $t0, 4	# Set index to zero	
	lb $t2, Coef_Array($t0)	# Get value A back from the array, store it in $t2 
	li $v0, 1		# System call code for printing integer
	move $a0, $t2		# Move printed value to $a0
	syscall			# Print
	
	li $v0, 4		# Load Immediate. System call code for printing string 
	la $a0, result_4	# Load Address. ASCII string result_4
	syscall			# Print the prompted message
	
	jr $ra			#End of Procedure
	
	
################################################################################
# Procedure:	Compute_n_print
# Comments:	Calculates and prints the output
# Input:	Coefficients and x
# Output:	Result
################################################################################
Compute_n_print:

	addi $t0, $zero, 0 	# Set index to zero	
	lb $t1, Coef_Array($t0)	# Get value A back from the array, store it in $t1
	
	addi $t0, $t0, 4 	# Set index to 4	
	lb $t2, Coef_Array($t0)	# Get value B back from the array, store it in $t2 
		
	addi $t0, $t0, 4 	# Set index to 8	
	lb $t3, Coef_Array($t0)	# Get value C back from the array, store it in $t3
	
	mul $t1, $t1, $t4		# A * x
	mul $t1, $t1, $t4		# A * x * x
	
	mul $t2, $t2, $t4		# B * x 
	
	add $t0, $t1, $t2		# A * x * x + B * x 
	add $t0, $t0, $t3		# A * x * x + B * x + C
	
	li $v0, 1		# System call code for printing integer
	move $a0, $t0		# Move printed value to $a0
	syscall			# Print
	
	jr $ra			#End of Procedure

################################################################################
# Procedure:	extra_cre
# Comments:	Calculates the value of x when f(x) = 0
# Input:	Coefficients in array 
# Output:	Result
################################################################################
extra_cre:
	addi $t0, $zero, 0 	# Set index to zero
	addi $t1, $t0, 4	# Set index to 4
	addi $t2, $t0, 8 	# Set index to 8

	lb $t0, Coef_Array($t0)	# A -> $f0
	lb $t1, Coef_Array($t1)	# B -> $f1
	lb $t2, Coef_Array($t2)	# C -> $f2
	
	mtc1 $t0, $f0		# Convert it to a single precision float  
	cvt.s.w $f0, $f0	
	
	mtc1 $t1, $f1		# Convert it to a single precision float 
	cvt.s.w $f1, $f1	
	
	mtc1 $t2, $f2		# Convert it to a single precision float 
	cvt.s.w $f2, $f2	

### Compute:

	mul.s $f8, $f1, $f1 	# $f8 = B^2
	mul.s $f9, $f0, $f2	# $f9 = A*C
	l.s $f5, four
	cvt.s.w $f5, $f5 	# $f5 = 4.0
	mul.s $f9, $f9, $f5	# $f9 = 4*A*C
	
	neg.s $f9, $f9 		# $f9 = -4*A*C
	add.s $f9, $f8, $f9	# $f9 = B^2 - 4*A*C
	sqrt.s $f9, $f9 	# $f9 = sqrt(B^2 - 4*A*C)
	mov.s $f7, $f1
	neg.s $f7, $f7		# $f7 = -B
	l.s $f5, two
	
	cvt.s.w $f5, $f5
	mul.s $f8, $f5, $f0 	# $f8 = 2*A
	add.s $f10, $f7, $f9
	div.s $f10, $f10, $f8 	# $f10 = one root
	neg.s $f9, $f9
	add.s $f11, $f7, $f9
	div.s $f11, $f11, $f8 	# $f11 = other root

#Print Roots

	li $v0, 4		# Load Immediate. System call code for print string.
	la $a0 extra_credit	# Load Address. ASCII string f_x 
	syscall			# Output

	li $v0, 4		# Load Immediate. System call code for print string.
	la $a0 root1		# Load Address. ASCII string f_x 
	syscall			# Output	

	li $v0, 2		# Print f10 here 
	mov.s $f12, $f10
	syscall

	li $v0, 4		# Load Immediate. System call code for printing string 
	la $a0, new_line	# Load Address. Just a new line
	syscall			# Print the prompted message

	li $v0, 4		# Load Immediate. System call code for print string.
	la $a0 root2		# Load Address. ASCII string f_x 
	syscall			# Output
	
	li $v0, 2		# Print f11 here 
	mov.s $f12, $f11
	syscall

	jr $ra			#End of Procedure
	
