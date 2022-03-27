	.data
tempM:		.word	0 : 256
resultM:	.word	0 : 256

	.text
	
.macro	matrix_read( %row, %col)
	move	$t0, $0			#$t0 = row counter
	move	$t1, $0			#$t1 = column counter
	la	$t3, tempM		#$t3 = base address
	
loop1:	mult	$t0, %col		#$s4 = row * cols
	mflo	$s4			#move mult result to $s4; the result won't be more than 16 bit
	add	$s4, $s4, $t1		#$s4 += column counter
	sll	$s4, $s4, 2		#$s4 << 2, for byte offset
	li	$v0, 5
	syscall
	move	$t2, $v0		# read element
	add	$t4, $t3, $s4		# bias add with base address
	sw	$t2, 0($t4)		#store value in matrix element
	addi	$t1, $t1, 1		#increase column counter
	bne	%col, $t1, loop1	#if not at end of row, go back
					
					#if at the end of row, check column
	move	$t1, $0			#reset column counter
	addi	$t0, $t0, 1		#increase row counter
	bne	%row, $t0, loop1	#if not at end of column, go back
					#if end of column, we finish traverse
.end_macro

.macro	multline(%row, %col)	#row is i, col is j
	li	$t3, 0	#k
	li	$t4, 0	#resultMatrix[i][j]
loopk:	beq	$t3, $s1, loopkend
	mult	%row, $s1
	mflo	$t5
	add	$t5, $t5, $t3
	sll	$t5, $t5, 2
	lw	$t5, tempM($t5)	# get temp[i][k]
	
	mult	$t3, $s1
	mflo	$t6
	add	$t6, $t6, %col
	sll	$t6, $t6, 2
	lw	$t6, tempM($t6)	# get temp[k][j]
	
	mult	$t5, $t6		# multiply temp[i][k] and temp[k][j]
	mflo	$t7			# $t7 is the mult result
	addu	$t4, $t4, $t7		# resultMatrix[i][j] += tempMatrix[i][k] * tempMatrix[k][j]

	addi	$t3, $t3, 1
	j	loopk
	
loopkend:	mult	%row, $s1
	mflo	$t5
	add	$t5, $t5, %col
	sll	$t5, $t5, 2
	sw	$t4, resultM($t5)	# store resultMatrix[i][j]
	
.end_macro


.macro	replace()
	li	$t3, 0	#i
loopr:	li	$t4, 0	#j
loops:	mult	$t3, $s1
	mflo	$t5
	add	$t5, $t5, $t4	# count matrix position, i*m+j
	sll	$t5, $t5, 2
	lw	$t6, resultM($t5)	# get num in result matrix
	sw	$t6, tempM($t5)	# store it in temp matrix

	addi	$t4, $t4, 1
	bne	$t4, $s1, loops	# if j=m, leave;else, continue cycle
	
	addi	$t3, $t3, 1
	bne	$t3, $s1, loopr	# if i=m, leave;else, continue cycle
.end_macro

main:	li	$v0, 5
	syscall
	move	$s0, $v0	# read n
	li	$v0, 5
	syscall
	move	$s1, $v0	# read m

	matrix_read($s1, $s1)		# read matrix 1
	
	# powerTempMatrix()
	li	$t2, 0	#i:1-n, in powerTempMatrix
loop0:	beq	$t2, $s0, loop0end
	li	$t0, 0	#i:1-m, in sqrtTempMatrix
	# sqrtTempMatrix()
loop1:	beq	$t0, $s1, loop1end
	li	$t1, 0	#j	
loop2:	beq	$t1, $s1, loop2end
	multline($t0, $t1)	
	addi	$t1, $t1, 1
	j	loop2
loop2end:	addi	$t0, $t0, 1
	j	loop1
	#end sqrtTempMatrix()
	#replaceTempMatrix()
loop1end:	replace()
	#end replaceTempMatrix()
	addi	$t2, $t2, 1
	j	loop0
	# end sqrtTempMatrix()
loop0end:	nop
	
	
	li	$t3, 0	#i
loopt:	li	$t4, 0	#j
loopq:	mult	$t3, $s1		
	mflo	$t5
	add	$t5, $t5, $t4		# get matrix position: i*m + j
	sll	$t5, $t5, 2
	lw	$t6, tempM($t5)	# get matrix number in $t6
	move	$a0, $t6
	li	$v0, 1
	syscall			# print matrix number
	li	$a0, 32
	li	$v0, 11
	syscall			# print a space
	addi	$t4, $t4, 1
	bne	$t4, $s1, loopq
	addi 	$a0, $0, 0xA		
       addi 	$v0, $0, 0xB		
       syscall			# print a '\n'
	addi	$t3, $t3, 1
	bne	$t3, $s1, loopt
	
	
	
	li	$v0, 10			#system service 10 is exit
	syscall
	
