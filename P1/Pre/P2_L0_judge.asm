	.data
data:	.space	30
	.text

main:	li	$v0, 5
	syscall
	move	$s0, $v0	# read the num of chars to $s0
	addi	$s1, $0, 0	# add from 1 to num, read chars
	move	$s2, $0
							
loop:	addi	$s1, $s1, 1	# add loop counter
	li	$v0, 12
	syscall			# read char
	move	$t0, $v0	# load char to $t0
	sb	$t0, data($s2)		#store value
	addi	$s2, $s2, 1	# add address
	bne	$s1, $s0, loop
	# end of input
	
	move	$s1, $0		# calculate address
	subi	$s0, $s0, 1	# transform char to int
loop2:	beq	$s1, $s0, exits	# success result, return 1	
	lb	$s2, data($s1)	# load former char
	sub	$t0, $s0, $s1	# calculate address
	lb	$s3, data($t0)	# load latter char
	addi	$s1, $s1, 1	# add address
	beq	$s2, $s3, loop2	# if equal, then continue, else return 0
	
	li	$a0, 0
	li	$v0, 1
	syscall
	li	$v0, 10
	syscall
	
	


exits:	li	$a0, 1
	li	$v0, 1
	syscall
	li	$v0, 10
	syscall