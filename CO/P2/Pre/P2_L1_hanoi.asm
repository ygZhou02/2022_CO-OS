.data
	.asciiz		"move disk "
	.asciiz	 	" from "
	.asciiz		" to "
.text

.macro	moveprint(%id, %from, %to)
	li	$a0, 0
	li	$v0, 4			#print "move disk"
	syscall 
	move	$a0, %id		#print id
	li	$v0, 1
	syscall
	li	$a0, 11
	li	$v0, 4			#print "from"
	syscall 
	move	$a0, %from		#print char from
	li	$v0, 11
	syscall
	li	$a0, 18
	li	$v0, 4			#print "to"
	syscall 
	move	$a0, %to		#print to
	li	$v0, 11
	syscall
	addi 	$a0, $0, 0xA		#ascii code for LF, if you have any trouble try 0xD for CR.
       addi 	$v0, $0, 0xB		#syscall 11 prints the lower 8 bits of $a0 as an ascii character.
       syscall				#print \n
.end_macro 


main:	#li	$s0, 5
	#li	$s1, 65
	#li	$s2, 67
	#moveprint($s0, $s1, $s2)	# TEST RIGHT
	li	$v0, 5
	syscall
	move	$a0, $v0		# $a0 = base
	li	$a1, 65			# $a1 = 'A'
	li	$a2, 66			# $a2 = 'B'
	li	$a3, 67			# $a3 = 'C'
	jal	hanoi			# call hanoi function
	li	$v0, 10			#end project
	syscall
	
print:	moveprint($0, $t1, $t2)
	moveprint($0, $t2, $t3)
	j	exit
	
exit:	jr	$ra

	
hanoi:	move	$t0, $a0	# base
	move	$t1, $a1	# from	
	move	$t2, $a2	# via
	move	$t3, $a3	# to
	beq	$t0, $0, print
	addi	$t4, $t0, -1	# $t4 = base-1
	
	# hanoi(base - 1, from, via, to)
	# push stack
	addiu 	$sp, $sp, -24
	sw 	$t0, 0($sp)
	sw 	$t1, 4($sp)	
	sw	$t2, 8($sp)
	sw	$t3, 12($sp)
	sw	$t4, 16($sp)
	sw	$ra, 20($sp)	# protect registers
	move	$a0, $t4	#base-1
	move	$a1, $t1	#from
	move	$a2, $t2	#via
	move	$a3, $t3	#to
	jal	hanoi
	lw 	$t0, 0($sp)
	lw 	$t1, 4($sp)	
	lw	$t2, 8($sp)
	lw	$t3, 12($sp)
	lw 	$t4, 16($sp)
	lw 	$ra, 20($sp)
	addiu	$sp, $sp, 24	# reset $sp
	
	# move(base, from, via)
	moveprint($t0, $t1, $t2)
	
	# hanoi(base - 1, to, via, from)
	# push stack
	addiu 	$sp, $sp, -24
	sw 	$t0, 0($sp)
	sw 	$t1, 4($sp)	
	sw	$t2, 8($sp)
	sw	$t3, 12($sp)
	sw	$t4, 16($sp)
	sw	$ra, 20($sp)	# protect registers
	move	$a0, $t4	#base-1
	move	$a1, $t3	#to
	move	$a2, $t2	#via
	move	$a3, $t1	#from
	jal	hanoi
	lw 	$t0, 0($sp)
	lw 	$t1, 4($sp)	
	lw	$t2, 8($sp)
	lw	$t3, 12($sp)
	lw 	$t4, 16($sp)
	lw 	$ra, 20($sp)
	addiu	$sp, $sp, 24	# reset $sp
	
	# move(base, via, to)
	moveprint($t0, $t2, $t3)
	
	# hanoi(base - 1, from, via, to)
	# push stack
	addiu 	$sp, $sp, -24
	sw 	$t0, 0($sp)
	sw 	$t1, 4($sp)	
	sw	$t2, 8($sp)
	sw	$t3, 12($sp)
	sw	$t4, 16($sp)
	sw	$ra, 20($sp)	# protect registers
	move	$a0, $t4	#base-1
	move	$a1, $t1	#from
	move	$a2, $t2	#via
	move	$a3, $t3	#to
	jal	hanoi
	lw 	$t0, 0($sp)
	lw 	$t1, 4($sp)	
	lw	$t2, 8($sp)
	lw	$t3, 12($sp)
	lw 	$t4, 16($sp)
	lw 	$ra, 20($sp)
	addiu	$sp, $sp, 24	# reset $sp
	j	exit
	
		