.data
.text
main:	li	$v0, 5
	syscall
	sw	$v0, 2048($0)	# 2048 store n
	addiu 	$sp, $sp, -20
	sw 	$0, 0($sp) 	
	jal	FA
	li	$v0, 10
	syscall
	
	
	
	
	
	
	
	
FA:	
	lw 	$s0, 0($sp) 	# $s0 = index
	
	lw	$t0, 2048($0)	# $t0 = n
	li	$t1, 0		# $t1 = for i
	beq	$s0, $t0, print
	
reFA:	beq	$t1, $t0, exit	# if i==n, break
	sll	$t2, $t1, 2
	lw	$t3, 0($t2)	# 0 store mark[i]	
	bne	$t3, $0, re
	addi	$s7, $t1, 1	# $s7 = i+1
	sll	$t2, $s0, 2	# $t2 = 4*index
	sw	$s7, 1024($t2)	# store array[index]
	li	$s6, 1
	sll	$t2, $t1, 2
	sw	$s6, 0($t2)	# mark[i] = 1
	addiu 	$sp, $sp, -20
	addi	$s5, $s0, 1
	sw 	$s5, 0($sp)
	sw 	$ra, 4($sp)	# store $ra
	sw	$t1, 8($sp)
	sw	$s0, 12($sp)
	sw	$t2, 16($sp)
	jal	FA
	lw 	$t2, 16($sp)
	sw	$0, 0($t2)	# mark[i] = 0
	lw 	$s5, 0($sp)
	lw 	$ra, 4($sp)	# load $ra
	lw	$t1, 8($sp)
	lw	$s0, 12($sp)
	addiu	$sp, $sp, 20	# reset $sp
	j	re
	
re:	addi	$t1, $t1, 1
	j	reFA	
	
exit:	# lw	$ra, 4($sp)	# $ra = $ra
	jr	$ra
	
exitn:	addi 	$a0, $0, 0xA		#ascii code for LF, if you have any trouble try 0xD for CR.
       addi 	$v0, $0, 0xB		#syscall 11 prints the lower 8 bits of $a0 as an ascii character.
       syscall				#print \n
	# lw	$ra, 4($sp)	# $s4 = $ra
	jr	$ra
	
print:	beq	$t1, $t0, exitn	# if i==n, break
	li	$v0, 1		# gonna print
	sll	$t2, $t1, 2
	lw	$a0, 1024($t2)	#1024 store array[]
	syscall
	li	$a0, 32
	li	$v0, 11		# print a space
	syscall
	addi	$t1, $t1, 1
	j	print		# continue circle
	
	