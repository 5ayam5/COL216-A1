# 2019CS10399 Sayam Sethi
# 2019CS50440 Mallika Prabhakar

# ----------------------ASSIGNMENT 1---------------------------

	.text
	.globl main

# setting and loading initial values along with handling base case
main:
	lw		$s7, max		# load the max permitted value of x, y
	lw		$s6, min		# load the min permitted value of x, y

	jal		input
	move	$t0, $v0		# n: number of coordinates
	blt		$t0, 1, nLess1	# handle corner case (n<1)

	li		$t1, 1			# counter of points
	jal		input
	move	$t2, $v0		# coordinate of x1
	jal		input
	move	$t3, $v0		# coordinate of y1

	beq		$t0, 1, nIs1	# handle corner case

	li		$s0, 0			# the area
	li		$s5, 2			# load 2
	l.s		$f5, point5		# load 0.5


# taking n coordinates as input and calculating area using a loop
loop:
	jal		checkBounds		# check the bounds
	addi	$t1, $t1, 1		# increment the counter
	jal		input
	move	$t4, $v0		# coordinate of x2
	jal		input
	move	$t5, $v0		# coordinate of y2

    jal		area			# compute area
	add		$s0, $s0, $t2	# increment area

	beq		$t1, $t0, print	# end loop

	move	$t2, $t4		# update x1
	move	$t3, $t5		# update x2
	j		loop			# jump to loop


# area function
area:
	sub		$t2, $t4, $t2	# compute x2-x1
	add		$t3, $t3, $t5	# compute y1+y2
	mul		$t2, $t2, $t3	# compute product

	jr $ra


# function to take a float input
input:
	li		$v0, 5			# read_int
	syscall					# takes input and stores in v0
	jr		$ra				# returns function and jumps to address stored in $ra

# function to print a string
output:
	li		$v0, 4			# print_string
	syscall
	jr		$ra

# function to check if the input value is in range
checkBounds:
	# x coordinate out of bounds
	bgt		$t2, $s7, outOfBounds
	blt		$t2, $s6, outOfBounds
	# y coordinate out of bounds
	bgt		$t3, $s7, outOfBounds
	blt		$t3, $s6, outOfBounds
	# all okay, go back
	jr		$ra

# outOfBounds error handling
outOfBounds:
	la		$a0, ooB		# load ooB message
	jal		output
	jal		exit

# only one point has area zero
nIs1:
	li		$v0, 2			# print 0 as $f12 is initialised to 0
	l.s		$f12, zero		# load 0 just to be sure
	syscall
	jal		exit

# n is less than 1
nLess1:
	la		$a0, errN		# load error message
	jal		output
	jal		exit

# function to print float value
print:
	div		$s0, $s5		# divide by 2 to get area
	mfhi	$t1				# the remainder
	mtc1	$t1, $f11
	cvt.s.w	$f11, $f11
	mul.s	$f11, $f11, $f5
	mflo	$t2				# quotient
	mtc1	$t2, $f12
	cvt.s.w	$f12, $f12
	add.s	$f12, $f12, $f11
	li		$v0, 2			# print_float
	syscall
	la		$a0, lf
	j		exit

# function to exit
exit:
	li		$v0, 10
	syscall

	.data

# n<1 error message
errN:
	.asciiz	"Input n must be greater than or equal to 1\nTerminating...\n"

# outOfBounds error message
ooB:
	.asciiz	"The value of coordinate is out of range\nTerminating...\n"

# new line character
lf:
	.asciiz "\n"

# upper limit
max:
	.word	1023		# @TODO: find the actual upper bound

# lower limit
min:
	.word	-1024		# @TODO: find the actual lower bound

# 0.5 float
point5:
	.float	0.5
