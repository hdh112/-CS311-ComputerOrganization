# PROGRAM: Merge Sort

	.data		# Data declaration section

	in_data: 
		.word 13, 43, 16, 23, 9, 2, 15, 19, 8, 28, 30, 4, 48, 24, 10, 18, 29, 35, 6, 35
	buf:
		.word 0:20	# reserve a block of 20 words
	size:
		.word 20

	.text		# Start of code section

main:
	la $a0, in_data		# $a0 = in_data
	li $a1, 0			# $a1 = 0
	li $a2, 19			# $a2 = 19
	jal mergesort

	la $s0, buf			# $s0 = buf
	lw $t0, size		# $t0 = size
	sw $t1, 0($t0)		# $t1 = 20
	sll $t0, $t1, 2		# $t0 = 20*4
	add $s1, $s0, $t0	# $s1 = &buf[20]

printbuf:
	slt $t0, $s0, $s1	# $t0=1 when &buf[i]<&buf[20]
	beqz $t0, finish		# go to finish when &buf[i]>=&buf[20]
	lw $a0, 0($s0)		# $a0 = buf[i]
	li $v0, 1			# load syscall(print integer) into syscall register
	syscall				# print element
	addi $s0, $s0, 4	# $s0 = &buf[i++]
	b printbuf

finish:
	li $v0, 10			# load syscall(exit program) into syscall register
	syscall



functions: 

merge:			# function merge
	addi $sp, $sp, -8		# make room on stack for 2 registers
	sw $ra, 4($sp)			# save $ra on stack
	sw $s0, 0($sp)			# save $s0 on stack
	la $s0, buf				# $s0 = buf
	
	sll $t0, $a1, 2			# $t0 = left*4 (i*4)
	add $t1, $s0, $t0		# $t1 = &buf[left]
	add $t2, $a0, $t0		# $t2 = &A[left]
	sll $t3, $a3, 2			# $t3 = right*4
	add $t3, $s0, $t3		# $t3 = &buf[right]

bufcopy:
	lw $t4, 0($t2)			# $t4 = A[i]
	sw $t4, 0($t1)			# buf[i] = A[i]
	addi $t1, $t1, 4		# &buf[i+1]
	addi $t2, $t2, 4		# &A[i+1]
	slt $t4, $t3, $t1		# $t4=0 if &buf[right]>=&buf[left]
	beqz $t4, bufcopy		# go to bufcopy if &buf[right]>=&buf[left]

	sll $t0, $a1, 2			# $t0 = left*4 (i*4)
	add $t0, $a0, $t0		# $t0 = &A[i]
	sll $t1, $a1, 2			# $t1 = left*4 (left_i*4)
	add $t1, $s0, $t1		# $t1 = &buf[left_i]
	addi $t2, $a2, 1		# $t2 = mid+1
	sll $t2, $t2, 2			# $t2 = right_i*4
	add $t2, $s0, $t2		# $t2 = &buf[right_i]
	sll $t4, $a2, 2			# $t4 = mid*4
	add $t4, $s0, $t4		# $t4 = &buf[mid]
							# $t3 = &buf[right] (unchanged)

copylr:
	slt $t5, $t4, $t1		# $t5=0 when &buf[mid]>=&buf[left_i]
	bnez $t5, copyremainl	# go(exit) to copyremainl if &buf[mid]<&buf[left_i]
	slt $t5, $t3, $t2		# $t5=0 when &buf[right]>=&buf[right_i]
	bnez $t5, copyremainl	# go(exit) to copyremainl if &buf[right]<&buf[right_i]
	lw $t6, 0($t1)			# $t6 = buf[left_i]
	lw $t7, 0($t2)			# $t7 = buf[right_i]
	slt $t5, $t6, $t7		# $t5=1 when buf[left_i]<buf[right_i]
	beqz $t5, righti		# go to righti if buf[left_i]>=buf[right_i], and copy buf[right_i++]

lefti:
	sw $t6, 0($t0)			# A[i] = buf[left_i]
	addi $t0, $t0, 4		# &A[i++]
	addi $t1, $t1, 4		# &buf[left_i++]
	b copylr

righti:
	sw $t7, 0($t0)			# A[i] = buf[right_i]
	addi $t0, $t0, 4		# &A[i++]
	addi $t2, $t2, 4		# &buf[right_i++]
	b copylr

copyremainl:
	slt $t5, $t4, $t1		# $t5=0 when &buf[mid]>=&buf[left_i]
	bnez $t5, copyremainr	# go(exit) to copyremainr if &buf[mid]<&buf[left_i]
	lw $t6, 0($t1)			# $t6 = buf[left_i]
	sw $t6, 0($t0)			# A[i] = buf[left_i]
	addi $t0, $t0, 4		# &A[i++]
	addi $t1, $t1, 4		# &buf[left_i++]
	b copyremainl

copyremainr:
	slt $t5, $t3, $t2		# $t5=0 when &buf[right]>=&buf[right_i]
	bnez $t5, mergeexit		# go to mergeexit if &buf[right]<&buf[right_i]
	lw $t6, 0($t2)			# $t6 = buf[right_i]
	sw $t6, 0($t0)			# A[i] = buf[right_i]
	addi $t0, $t0, 4		# &A[i++]
	addi $t2, $t2, 4		# &buf[right_i++]
	b copyremainr

mergeexit:
	lw $s0, 0($sp)		# restore $s0 from stack
	lw $ra, 4($sp)		# restore $ra from stack
	addi $sp, $sp, 8	# restore stack pointer
	jr $ra



mergesort:			# function mergesort
	addi $sp, $sp, -16	# make room on stack for 4 registers
	sw $ra, 12($sp)		# save $ra on stack
	sw $s2, 8($sp)		# save $s2 on stack
	sw $s1, 4($sp)		# save $s1 on stack
	sw $s0, 0($sp)		# save $s0 on stack

	move $s0, $a1		# save $a1 into $s0 (left)
	move $s2, $a2		# save $a2 into $s2 (right)
						# $a0=A, $s0=left, $s1=mid, $s2=right

forsorttest:
	slt $t0, $s0, $s2	# $t0=0 if $s0>=$s2 (left>=right)
	beqz $t0, sortexit	# go to sortexit if left>=right
	add $t1, $s0, $s2	# $t1 = left+right
	srl $s1, $t1, 1		# $s1 = (left+right)/2 = mid

	move $a1, $s0		# 2nd param of mergesort is left
	move $a2, $s1		# 3rd param of mergesort is mid
	jal mergesort		# $a0=A, $a1=left, $a2=mid

	addi $t1, $s1, 1	# $t1 = mid+1
	move $a1, $t1		# 2nd param of mergesort is mid+1
	move $a2, $s2		# 3rd param of mergesort is right
	jal mergesort		# $a0=A, $a1 = mid+1, $a2=right

	move $a1, $s0		# 2nd param of merge is left
	move $a2, $s1		# 3rd param of merge is mid
	move $a3, $s2		# 4th param of merge is right
	jal merge

sortexit:
	lw $s0, 0($sp)		# restore $s0 from stack
	lw $s1, 4($sp)		# restore $s1 from stack
	lw $s2, 8($sp)		# restore $s2 from stack
	lw $ra, 12($sp)		# restore $ra from stack
	addi $sp, $sp, 16	# restore stack pointer
	jr $ra


# BLANK LINE AT THE END TO KEEP SPIM HAPPY!
