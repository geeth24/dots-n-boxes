# Data segment
.data
array: .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
       .word 0,1,0,1,0,1,0,1,0,1,0,1,0,1,0
       .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
       .word 0,1,0,1,0,1,0,1,0,1,0,1,0,1,0
       .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
       .word 0,1,0,1,0,1,0,1,0,1,0,1,0,1,0
       .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
       .word 0,1,0,1,0,1,0,1,0,1,0,1,0,1,0
       .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
       .word 0,1,0,1,0,1,0,1,0,1,0,1,0,1,0
       .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
rows: .word 11            # number of rows
cols: .word 15            # number of columns

# Code segment
.text
.globl checkForBoxes
checkForBoxes:
    # Load the number of rows and columns into registers
    lw $t0, rows
    lw $t1, cols
    
    # Initialize the outer loop index (i) to 1
    li $t2, 1
    
    # Loop over the rows of the array
outer_loop:
    # Initialize the inner loop index (j) to 1
    li $t3, 1
    
    # Loop over the columns of the current row
inner_loop:
    
    li $t7, 0 # Counter
    j check_left
    
return_left: 
    
    j check_right

return_right:
    
    j check_up
    
return_up:

    j check_down
    
return_down:
    
    beq $t7, 3, success # If counter = 3, then a potential box has been found.
    
    # Increment the inner loop index (j) and check if we're done with this row
    addi $t3, $t3, 2   # increment j
    blt $t3, $t1, inner_loop # branch to inner_loop if j != cols
    
    # Increment the outer loop index (i) and check if we're done with the array
    addi $t2, $t2, 2   # increment i
    blt $t2, $t0, outer_loop # branch to outer_loop if i != rows
    j failure
    
success:
    move $a0, $t8 #Print row
    li $v0, 1
    syscall
    
    move $a0, $t9 #Print column
    syscall
 
failure:   
    # Exit the program
    li $v0, 10 # syscall code for exit
    syscall

check_left:
	move $t6, $t3
	subi $t6, $t6, 1
	
	# Calculate the offset into the array
    	mult $t2, $t1      # multiply i by the number of columns
    	mflo $t4           # store the result in $t4
    	add $t4, $t4, $t6  # add j to the offset
    	sll $t4, $t4, 2    # multiply the offset by 4 (since each word is 4 bytes)
    	la $t5, array      # load the base address of the array
    	add $t5, $t5, $t4  # add the offset to the base address to get the address of the current element
    	
    	lw $a0, ($t5)
    	beq $a0, 0, check_left_zero # checks if left line is empty.
    	j check_left_one
    	
check_left_zero:
	move $t8, $t2 # store row
	move $t9, $t6 # store column
	j return_left

check_left_one:
	addi $t7, $t7, 1 # increment counter by 1
    	j return_left
    	
    	
check_right:
	move $t6, $t3
	addi $t6, $t6, 1
	
	# Calculate the offset into the array
    	mult $t2, $t1      # multiply i by the number of columns
    	mflo $t4           # store the result in $t4
    	add $t4, $t4, $t6  # add j to the offset
    	sll $t4, $t4, 2    # multiply the offset by 4 (since each word is 4 bytes)
    	la $t5, array      # load the base address of the array
    	add $t5, $t5, $t4  # add the offset to the base address to get the address of the current element
    	
    	lw $a0, ($t5)
    	beq $a0, 0, check_right_zero # checks if right line is empty.
    	j check_right_one
    	
check_right_zero:
	move $t8, $t2 # store row
	move $t9, $t6 # store column
	j return_right

check_right_one:
	addi $t7, $t7, 1 # increment counter by 1
    	j return_right

    	
check_up:
       move $t6, $t2
       subi $t6, $t6, 1
       
       mult $t6, $t1      # multiply i by the number of columns
       mflo $t4           # store the result in $t4
       add $t4, $t4, $t3  # add j to the offset
       sll $t4, $t4, 2    # multiply the offset by 4 (since each word is 4 bytes)
       la $t5, array      # load the base address of the array
       add $t5, $t5, $t4  # add the offset to the base address to get the address of the current element

       lw $a0, ($t5)
       beq $a0, 0, check_up_zero # checks if top line is empty.
       j check_up_one
    	
check_up_zero:
        move $t8, $t6 # store row
	move $t9, $t3 # store column

	j return_up

check_up_one:
	addi $t7, $t7, 1 # increment counter by 1
    	j return_up
	
check_down:
       move $t6, $t2
       addi $t6, $t6, 1
       
       mult $t6, $t1      # multiply i by the number of columns
       mflo $t4           # store the result in $t4
       add $t4, $t4, $t3  # add j to the offset
       sll $t4, $t4, 2    # multiply the offset by 4 (since each word is 4 bytes)
       la $t5, array      # load the base address of the array
       add $t5, $t5, $t4  # add the offset to the base address to get the address of the current element

	lw $a0, ($t5)
        beq $a0, 0, check_down_zero # checks if bottom line is empty.
    	j check_down_one
    	
check_down_zero:
	move $t8, $t6 # store row
	move $t9, $t3 # store column
	j return_down

check_down_one:
	addi $t7, $t7, 1 # increment counter by 1
    	j return_down
    	
    # Calculate the offset into the array
    # mult $t2, $t1      # multiply i by the number of columns
    # mflo $t4           # store the result in $t4
    # add $t4, $t4, $t3  # add j to the offset
    # sll $t4, $t4, 2    # multiply the offset by 4 (since each word is 4 bytes)
    # la $t5, array      # load the base address of the array
    # add $t5, $t5, $t4  # add the offset to the base address to get the address of the current element
