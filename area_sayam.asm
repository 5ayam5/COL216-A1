	.text
	.globl main

main:
	lw		$s7, max		# load the max permitted value of x, y
	lw		$s6, min		# load the min permitted value of x, y
	li		$v0, 5			# load_int
	syscall
	move	$t0, $v0		# n: number of coordinates
	beq		$t0, 1, nIs1	# handle corner case
	li		$t1, 1			# counter of points
	jal		input
	mov.s	$f1, $f0		# coordinate of x1
	jal		input
	mov.s	$f2, $f0		# coordinate of y1
	l.s		$f6, zero		# the area
	l.s		$f5, point5		# load 0.5

loop:
	jal		checkBounds		# check the bounds
	addi	$t1, $t1, 1		# increment the counter
	jal		input
	mov.s	$f3, $f0		# coordinate of x2
	jal		input
	mov.s	$f4, $f0		# coordinate of y2

	# compute the area
	sub.s	$f1, $f3, $f1	# compute x2-x1
	add.s	$f2, $f4, $f2	# compute y1+y2
	mul.s	$f2, $f2, $f5	# compute (y1+y2)/2
	mul.s	$f1, $f1, $f2	# compute area of trapezium
	add.s	$f6, $f6, $f1	# increment area

	beq		$t1, $t0, print	# end loop
	mov.s	$f1, $f3		# update x1
	mov.s	$f2, $f4		# update x2
	j		loop			# jump to loop

input:
	li		$v0, 6			# read_float
	syscall					# takes input and stores in v0
	jr		$ra				# returns function and jumps to address stored in $ra

output:
	li		$v0, 4			# print_string
	syscall
	jr		$ra

checkBounds:
	# x coordinate out of bounds
	bgt		$t2, $s7, outOfBounds
	blt		$t2, $s6, outOfBounds
	# y coordinate out of bounds
	bgt		$t3, $s7, outOfBounds
	blt		$t4, $s6, outOfBounds
	# all okay, go back
	jr		$ra

outOfBounds:
	la		$a0, ooB	# load ooB message
	jal		exit

nIs1:
	la		$a0, errN	# load error message
	jal		output
	jal		exit

print:
	mov.s	$f12, $f6	# the value
	li		$v0, 2		# print_float
	syscall
	j		exit

exit:
	li		$v0, 10
	syscall

	.data
errN:
	.asciiz	"Input n must be greater than 1\nTerminating...\n"
ooB:
	.asciiz	"The value of coordinate is out of range\nTerminating...\n"
max:
	.word	1000		# @TODO: find the actual upper bound
min:
	.word	-1000		# @TODO: find the actual lower bound
zero:
	.float	0.0
point5:
	.float	0.5