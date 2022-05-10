	.data
num1:	.word	0 : 250		#storage for 250 nums
num2:	.word	0 : 250 	#storage for 250 nums
num3:	.word	0 : 600		#reverse store
	.text

main:	li	$v0, 5
	syscall
	move	$s0, $v0	#$s0 = n1
	move	$t0, $0		#cycle variable
	
loop1:	li	$v0, 5
	syscall
	move	$t1, $v0	#$t1 record input num1
	sub	$t2, $s0, $t0
	addi	$t2, $t2, -1	#reverse store, high number store at low pos
	sll	$t2, $t2, 2
	sw	$t1, num1($t2)	#store $t1 at num1+$t0
	addi	$t0, $t0, 1
	bne	$t0, $s0, loop1
	
	li	$v0, 5
	syscall
	move	$s1, $v0	#$s1 = n2
	move	$t0, $0		#cycle variable
	
loop2:	li	$v0, 5
	syscall
	move	$t1, $v0	#$t1 record input num1
	sub	$t2, $s1, $t0
	addi	$t2, $t2, -1	#reverse store, high number store at low pos
	sll	$t2, $t2, 2
	sw	$t1, num2($t2)	#store $t1 at num1+$t0
	addi	$t0, $t0, 1
	bne	$t0, $s1, loop2
	
	
	move	$t0, $0		#$t0 is i
	
loop3:	move	$t1, $0		#$t1 is j
loop4:	sll	$t2, $t0, 2
	sll	$t3, $t1, 2
	lw	$t5, num1($t2)	#a[i]
	lw	$t6, num2($t3)	#b[j]
	mult	$t5, $t6
	mflo	$t7
	add	$t4, $t1, $t0	#i+j
	sll	$t4, $t4, 2
	lw	$t3, num3($t4)	#c[i+j]
	add	$t3, $t3, $t7
	sw	$t3, num3($t4)	#store new c[i+j]

	addi	$t1, $t1, 1
	bne	$t1, $s1, loop4

	addi	$t0, $t0, 1
	bne	$t0, $s0, loop3
	
	
	
	
	
	
	add	$t0, $s0, $s1
	addi	$s2, $t0, -1		#n1+n2-1
	move	$t0, $0			#cycle variable k
loop5:	sll	$t1, $t0, 2
	lw	$t2, num3($t1)		#c[k]
	addi	$t1, $t1, 4		#address of k+1
	lw	$t3, num3($t1)		#c[k+1]
	li	$t4, 10
	div	$t2, $t4		#c[k]/10
	mflo	$t6			#quotient
	add	$t3, $t3, $t6		#c[k+1]+=c[k]/10
	sw	$t3, num3($t1)		#store c[k+1]
	mfhi	$t2
	addi	$t1, $t1, -4		#sub to k
	sw	$t2, num3($t1)		#store c[k]	

	addi	$t0, $t0, 1
	bne	$t0, $s2, loop5
	
	
	
	sll	$t0, $s2, 2
	lw	$t1, num3($t0)
	bgtz 	$t1, plus
	
	
back:	move	$t0, $s2
while:	addi	$t1, $t0, -1		#l-1
	sll	$t1, $t1, 2
	lw	$t2, num3($t1)		#c[l-1]
	addi	$t2, $t2, -10
	bltz	$t2, quitwhile
	addi	$t2, $t2, 10
	li	$t3, 10
	div	$t2, $t3
	mflo	$t3	# c[l-1]/10
	mfhi	$t4	# c[l-1]%10
	sw	$t4, num3($t1)
	addi	$t1, $t1, 4
	sw	$t3, num3($t1)
	addi	$t0, $t0, 1
	
quitwhile:	sll	$t1, $t0, 2
	lw	$t2, num3($t1)
	bne	$t2, $0, print
while2:beq	$t0, 0, print	
	addi	$t0, $t0, -1
	sll	$t1, $t0, 2
	lw	$t2, num3($t1)
	bne	$t2, $0, print
	j	while2
	
	
	
print:	sll	$t1, $t0, 2
	lw	$a0, num3($t1)
	li	$v0, 1
	syscall
	addi	$t0, $t0, -1
	bne	$t0, -1, print
	
	
	
	li	$v0, 10
	syscall
	

plus:	addi	$s2, $s2, 1
	j	back