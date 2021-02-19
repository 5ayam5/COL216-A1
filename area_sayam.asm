
	.text
	.globl main

main:
	lw		$s7, max		# load the max permitted value of x, y
	jal		input			# calls input function
	move	$t0, $v0		# store input in s0 - n
	beq		$t0, 1, nIs1	# handle corner case
	li		$t1, 1			# counter of points
	jal		input
	move	$t2, $v0		# coordinate of x1
	jal		input
	move	$t3, $v0		# coordinate of y1
	move	$s0, $zero		# the area (integer part)
	move	$s1, $zero		# the area (fractional part) : only 0 or 1

loop:
	addi	$t1, $t1, 1		# increment the counter
	jal input
	move	$t4, $v0		# coordinate of x2
	jal input
	move	$t5, $v0		# coordinate of y2
	beq		$t1, $t0, exit	# end loop
	j		loop			# jump to loop

input:
	li		$v0, 5		# read_int
	syscall				# takes input and stores in v0
	jr		$ra			# returns function and jumps to address stored in $ra

nIs1:
	li		$v0, 4		# print_string
	la		$a0, errN	# load error message
	syscall
	li		$v0, 10		# exit
	syscall

exit:
	li		$v0, 10
	syscall

	.data
errN:
	.asciiz	"input n must be greater than 1\n"
max:
	.word	1000		# @TODO: find the actual upper bound