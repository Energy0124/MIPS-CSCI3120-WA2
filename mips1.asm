addi $sp, $sp, -4     # Follow the convention of the lecture note
                      # for the stack machine where $sp points
                      # to the next location in the stack.
		 
addi $sp, $sp, -12	# Reserve space to for foo, A, and B 
li   $a0, 100		# foo is at $sp+12 
sw   $a0, 12($sp)
sw   $0, 8($sp)		# A (address of A) is at $sp+8
sw   $0, 4($sp)       # B (address of B) is at $sp+4


# To allocate space for A[]
li $a0, 44		# 10 elements, 4 bytes each, plus 4 bytes for length
li $v0, 9		# syscall with service 9 = allocate space on heap
syscall

# address of the allocated space is now in $v0
sw $v0, 8($sp)	# store address of A

# TODO: Insert code to initialize all elements of A to zeroes and set
# its length to 10.
li $v0, 10	# size of array A
lw $a0, 8($sp)	# read address of A
sw $v0, 0($a0)	# set the size of A

sw   $t0, 0($sp)   	#store $t0 to stack
addi $sp, $sp, -4 	#push
sw   $ra, 0($sp)   	#store $ra to stack
addi $sp, $sp, -4 	#push

jal initialize

lw $ra, 4($sp)		#restore $t0
addi $sp, $sp, 4 	#pop
lw $t0, 4($sp)		#restore $t0
addi $sp, $sp, 4 	#pop

# TODO: Insert code here to allocate space for B[], assign the
# address of the allocated space to B, initialize all of its 
# elements to zeroes, and set its length to the value of "foo".
# To allocate space for A[]
lw $a0, 12($sp)
sll $a0, $a0, 2		# multi by 4 by bit shift left by 2 bit
addi $a0, $a0, 4	# 100 elements, 4 bytes each, plus 4 bytes for length
li $v0, 9		# syscall with service 9 = allocate space on heap
syscall

# address of the allocated space is now in $v0
sw $v0, 4($sp)	# store address of B

lw $v0, 12($sp)		# size of array B
#sll $v0, $v0, 2		# multi by 4 by bit shift left by 2 bit
#addi $v0, $v0, 4	# 100 elements, 4 bytes each, plus 4 bytes for length
lw $a0, 4($sp)	# read address of B
sw $v0, 0($a0)	# set the size of B

sw   $t0, 0($sp)   	#store $t0 to stack
addi $sp, $sp, -4 	#push
sw   $ra, 0($sp)   	#store $ra to stack
addi $sp, $sp, -4 	#push


jal initialize

lw $ra, 4($sp)		#restore $t0
addi $sp, $sp, 4 	#pop
lw $t0, 4($sp)		#restore $t0
addi $sp, $sp, 4 	#pop

j end


initialize:
	li $t0, 1	# set the start index of for-loop
	
ini_loop:
	bgt $t0, $v0, exit	# go to branch exit if $t0 > $t1
	
	addi $a0, $a0, 4	# go to the address of the current element
	sw $zero, 0($a0)	# set the element to be 0
	
	addi $t0, $t0, 1	# increase the index
	j ini_loop	# jump to the beginning of the loop
	
exit:
	jr $ra
	
end:
	li $v0, 10	# termination of the program
	syscall
