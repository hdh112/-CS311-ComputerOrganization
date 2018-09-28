# PROGRAM: Merge Sort

	.data		# Data declaration section

	in_data: 
		.word 13, 43, 16, 23, 9, 2, 15, 19, 8, 28, 30, 4, 48, 24, 10, 18, 29, 35, 6, 35

	.text

main:	# Start of code section

functions: 

mergesort:	# function mergesort
	addi $sp, $sp, -16		# make room on stack for 4 registers
	sw $ra, 12($sp)			# save $ra on stack
	sw $s2, 8($sp)			# save $s2 on stack
	sw $s1, 4($sp)			# save $s1 on stack
	sw $s0, 0($sp)			# save $s0 on stack

	move $s0, $a1			# save $a1 into $s0 (left)
	move $s2, $a2			# save $a2 into $s2 (right)
							# $a0=A, $s0=left, $s1=mid, $s2=right

forsorttest:
	slt $t0, $s0, $s2		# $t0=0 if $s0>=$s2 (left>=right)
	beq $t0, $zero, exit	# go to exit if left>=right
	add $t1, $s0, $s2		# $t1 = left+right
	srl $s1, $t1, 1			# $s1 = (left+right)/2 = mid

	move $a1, $s0			# 2nd param of mergesort is left
	move $a2, $s1			# 3rd param of mergesort is mid
	j mergesort				# $a0=A, $a1=left, $a2=mid

	addi $t1, $s1, 1		# $t1 = mid+1
	move $a1, $t1			# 2nd param of mergesort is mid+1
	move $a2, $s2			# 3rd param of mergesort is right
	j mergesort				# $a0=A, $a1 = mid+1, $a2=right

	move $a1, $s0			# 2nd param of merge is left
	move $a2, $s1			# 3rd param of merge is mid
	move $a3, $s2			# 4th param of merge is right
	j merge

exit:
	lw $s0, 0($sp)			# restore $s0 from stack
	lw $s1, 4($sp)			# restore $s1 from stack
	lw $s2, 8($sp)			# restore $s2 from stack
	lw $ra, 12($sp)			# restore $ra from stack
	addi $sp, $sp, 16		# restore stack pointer
	jr $ra


finish:
	jr $ra


# BLANK LINE AT THE END TO KEEP SPIM HAPPY!
