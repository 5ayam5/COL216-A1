# 2019CS10399 Sayam Sethi
# 2019CS50440 Mallika Prabhakar

# ----------------------ASSIGNMENT 1---------------------------

	.text
	.globl main

# setting and loading initial values along with handling base case
main:
	l.s		$f11, max		# load the max permitted value of x, y
	l.s		$f10, min		# load the min permitted value of x, y

	li		$v0, 5			# load_int
	syscall

	move	$t0, $v0		# n: number of coordinates
	blt		$t0, 1, nLess1	# handle corner case (n<1)

	li		$t1, 1			# counter of points
	jal		input
	mov.s	$f1, $f0		# coordinate of x1
	jal		input
	mov.s	$f2, $f0		# coordinate of y1

	beq		$t0, 1, nIs1	# handle corner case

	l.s		$f6, zero		# the area
	l.s		$f5, point5		# load 0.5


# taking n coordinates as input and calculating area using a loop
loop:
	jal		checkBounds		# check the bounds
	addi	$t1, $t1, 1		# increment the counter
	jal		input
	mov.s	$f3, $f0		# coordinate of x2
	jal		input
	mov.s	$f4, $f0		# coordinate of y2

	jal		area			# compute area
	add.s	$f6, $f6, $f1	# increment area

	beq		$t1, $t0, print	# end loop

	mov.s	$f1, $f3		# update x1
	mov.s	$f2, $f4		# update x2
	j		loop			# jump to loop


# area function
area:
	sub.s	$f1, $f3, $f1	# compute x2-x1
	add.s	$f2, $f4, $f2	# compute y1+y2
	mul.s	$f2, $f2, $f5	# compute (y1+y2)/2
	mul.s	$f1, $f1, $f2	# compute area of trapezium

	jr		$ra


# function to take a float input
input:
	li		$v0, 6			# read_float
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
	c.lt.s	$f11, $f1
	bc1t	outOfBounds
	c.lt.s	$f1, $f10
	bc1t	outOfBounds
	# y coordinate out of bounds
	c.lt.s	$f11, $f2
	bc1t	outOfBounds
	c.lt.s	$f2, $f10
	bc1t	outOfBounds
	# all okay, go back
	jr		$ra

# outOfBounds error handling
outOfBounds:
	la		$a0, ooB		# load ooB message
	jal		output
	j		exit

# only one point has area zero
nIs1:
	li		$v0, 2			# print 0 as $f12 is initialised to 0
	l.s		$f12, zero		# load 0 just to be sure
	syscall
	j		exit

# n is less than 1
nLess1:
	la		$a0, errN		# load error message
	jal		output
	j		exit

# function to print float value
print:
	mov.s	$f12, $f6		# the value
	li		$v0, 2			# print_float
	syscall
	la		$a0, lf
	jal		output
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
	.float	1023.0		# @TODO: find the actual upper bound

# lower limit
min:
	.float	-1024.0		# @TODO: find the actual lower bound

# zero float
zero:
	.float	0.0

# 0.5 float
point5:
	.float	0.5
