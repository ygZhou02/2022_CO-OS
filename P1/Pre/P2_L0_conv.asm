	.data
data1:	.word	0 : 256
data2:	.word	0 : 256
newline: .asciiz "\n"

	.text
	
	li	$v0, 5
	syscall
	move	$s0, $v0	# read m1 row
	sw	$s0, 2040($0)
	li	$v0, 5
	syscall
	move	$s1, $v0	# read n1 column
	sw	$s1, 2044($0)
	li	$v0, 5
	syscall
	move	$s2, $v0	# read m2 row
	sw	$s2, 2048($0)
	li	$v0, 5
	syscall
	move	$s3, $v0	# read n2 column
	sw	$s3, 2052($0)
	
.macro	matrix_read(%t0, %t1, %t2, %row, %col, %tmp, %data, %tqp)
	move	%t0, $0			#%t0 = row counter
	move	%t1, $0			#%t1 = column counter
	#move	%t2, $0			#%t2 = value to be stored
	
loop1:	mult	%t0, %col		#%tmp = row * cols
	mflo	%tmp			#move mult result to %tmp; the result won't be more than 16 bit
	add	%tmp, %tmp, %t1	#%tmp += column counter
	sll	%tmp, %tmp, 2		#%tmp << 2, for byte offset
	li	$v0, 5
	syscall
	move	%t2, $v0		# read element
	add	%tqp, %data, %tmp
	sw	%t2, 0(%tqp)		#store value in matrix element
	addi	%t1, %t1, 1		#increase column counter
	bne	%col, %t1, loop1	#if not at end of row, go back
					
					#if at the end of row, check column
	move	%t1, $0			#reset column counter
	addi	%t0, %t0, 1		#increase row counter
	bne	%row, %t0, loop1	#if not at end of column, go back
					#if end of column, we finish traverse
.end_macro

.macro	conv(%startrow, %startcol, %endrow, %endcol)
	move	$t0, %startrow		# matrix 1 row counter
	move	$t1, %startcol		# matrix 1 column counter
	move	$t2, $0			# matrix 2 row counter
	move	$t3, $0			# matrix 2 column counter
	move 	$s7, $0			# result
	
loop2:	
	lw	$t4, 2044($0)
	mult	$t0, $t4
	mflo	$t4		# matrix 1 pos
	add	$t4, $t4, $t1
	sll	$t4, $t4, 2	#$t4 << 2, for byte offset
	lw	$t5, 2052($0)
	mult	$t2, $t5
	mflo	$t5		# matrix 2 pos
	add	$t5, $t5, $t3
	sll	$t5, $t5, 2	#$t5 << 2, for byte offset
	lw	$t6, 0($t4)	# mult value 1
	lw	$t7, 1024($t5)	# mult value 2
	mult	$t6, $t7
	mflo	$t4
	add	$s7, $s7, $t4	# add result
	
	
	
	
	addi	$t1, $t1, 1		#increase matrix 1 column counter
	addi	$t3, $t3, 1		#increase matrix 2 column counter
	bne	%endcol, $t1, loop2	#if not at end of row, go back
					
					#if at the end of row, check column
	move	$t1, %startcol		#reset matrix 1 column counter
	move	$t3, $0			#reset matrix 2 column counter
	addi	$t0, $t0, 1		#increase matrix 1 row counter
	addi	$t2, $t2, 1		#increase matrix 2 row counter
	bne	%endrow, $t0, loop2	#if not at end of column, go back
					#if end of column, we finish traverse
	
	move	$a0, $s7		# mult result
	li	$v0, 1
	syscall			# print result
	
.end_macro
	

	
	li	$t3, 0			# $t3 is where data stores
	matrix_read($t0, $t1, $t2, $s0, $s1, $s4, $t3, $t4)	# read matrix 1
	li	$t3, 1024
	matrix_read($t0, $t1, $t2, $s2, $s3, $s4, $t3, $t4)
	
	# move	$s5, $0
	# move	$s6, $0
	# conv($s5, $s6, $s2, $s3)
	# TEST SUCCESS!!! TWO MACROS WORKS WELL, JUST NEED TO FILL UP THE WHOLE MATRIX!
	
	
	sub	$t0, $s0, $s2
	addi	$t0, $t0, 1		# $t0 = matrix_row - kernel_row + 1 
	sub	$t1, $s1, $s3
	addi	$t1, $t1, 1		# $t1 = matrix_column - kernel_column + 1 
	move	$s2, $t0
	move	$s3, $t1		# s2, s3 store the range of traverse
	move	$s0, $0
	move	$s1, $0			# s0, s1 is traverse row and column
loop3:	lw	$t0, 2048($0)
	lw	$t1, 2052($0)		# load the size of kernel matrix
	add	$s4, $s0, $t0
	add	$s5, $s1, $t1		# end row, end column
	conv($s0, $s1, $s4, $s5)
	li	$a0, 32
	li	$v0, 11
	syscall				# print a space
	
	addi	$s1, $s1, 1		#increase column counter
	bne	$s1, $s3, loop3	#if not at end of row, go back
					
					#if at the end of row, check column
	addi 	$a0, $0, 0xA		#ascii code for LF, if you have any trouble try 0xD for CR.
       addi 	$v0, $0, 0xB		#syscall 11 prints the lower 8 bits of $a0 as an ascii character.
       syscall
	move	$s1, $0			#reset column counter
	addi	$s0, $s0, 1		#increase row counter
	bne	$s0, $s2, loop3	#if not at end of column, go back
					#if end of column, we finish traverse
	
	
	li	$v0, 10			#system service 10 is exit
	syscall
	