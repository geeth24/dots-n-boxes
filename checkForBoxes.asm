# Data segment
.data

test: .asciiz "this runs"
input: .asciiz "input: "
reward: .asciiz "point awarded"
space: .asciiz " "

# Code segment
.text # add number variable to determine if line is horizontal or vertical. If number even, then it is vertical. Otherwise, it is horizontal.
.globl checkForBoxes
checkForBoxes:

addi $t0, $s0, 0 # load the base address of the board into $t0
li $t1, 0  # initialize the iterator to 0
addi $t0, $t0, 1 # increment $t0 to point to the first top line in the fist box
addi $t1, $t1, 1 # increment the overall iterator to 1
li $t2, 0  # initialize row to 0
li $t3, 0  # initialize column to 0

find_box_of_input:
li $v0, 4
la $a0, input
syscall

li $v0, 5
syscall

move $t4, $v0

outer_loop:
    
   addi $t2, $t2, 1
   bge $t2, 6, failure 

inner_loop: 

    beq $t4, $t1, check_found_box # Check top line of box
    addi $t5, $t1, 14

    beq $t4, $t5, check_found_box # Check left line of box
    addi $t5, $t1, 16

    beq $t4, $t5, check_found_box # Check right line of box
    addi $t5, $t1, 30
    
    beq $t4, $t5, check_found_box # check bottom line of box
    
    addi $t3, $t3, 1 # Increment column by 1
    addi $t0, $t0, 2 # increment $t0 to point to the next top line in the next box
    addi $t1, $t1, 2 # increment the overall iterator to 2
    blt $t3, 7, inner_loop
    li $t3, 1  # initialize column to 0
    addi $t0, $t0, 18 # increment $t0 to point to the first top line in the fist box
    addi $t1, $t1, 18 # increment the overall iterator to 2
    
    j outer_loop
    
check_found_box:

    li $t6, 0 # Initialize counter for determining full square
    
    add $t7, $s0, 0
    add $t7, $t7, $t1
    lb $t5, ($t7)

    beq $t5, 32, top_empty # Check if top line of box is blank
    addi $t6, $t6, 1
    
top_empty:
    
    add $t7, $s0, 0
    add $t7, $t7, $t1
    addi $t7, $t7, 14
    lb $t5, ($t7)

    beq $t5, 32, left_empty # Check if left line of box is blank
    addi $t6, $t6, 1
    
left_empty:
    
    add $t7, $s0, 0
    add $t7, $t7, $t1
    addi $t7, $t7, 16
    lb $t5, ($t7)
    
    beq $t5, 32, right_empty # Check if right line of box is blank
    addi $t6, $t6, 1
    
right_empty:

    add $t7, $s0, 0
    add $t7, $t7, $t1
    addi $t7, $t7, 30
    lb $t5, ($t7)
    
    beq $t5, 32, down_empty # Check if left line of box is blank
    addi $t6, $t6, 1

down_empty:

    beq $t6, 3 success # Checks if the inputs placement will make a box
    j failure

success:
    
    li $v0, 4
    la $a0, reward
    syscall
 
failure:   
    # Return to main
    jr $ra
    	
