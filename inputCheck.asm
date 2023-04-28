.data
prompt1: .asciiz "Enter the row label: "
prompt2: .asciiz "Enter the column label:  "
evenText: .asciiz "Invalid move. Try again.\n"
oddText: .asciiz "Possible move. Good job!"
newLine: .asciiz "\n"
msg2: .asciiz "\nWrong input\n"
taken: .asciiz "That space is taken, please try again.\n"
empty: .asciiz " That space is empty\n"
line: .asciiz "|"
value: .asciiz "Value of row label is: "
dash: .asciiz "_"
space: .asciiz " "
reward: .asciiz "point awarded"

.text
.globl inputCheck

inputCheck:
    li $v0, 4
    la $a0, prompt1
    syscall

    li $v0, 12          
    syscall             
    move $t0, $v0
    move $s6, $t0     
    move $t5, $t0

    # Check if first charater is after 'k'
    li $t2, 'k'
    bgt $t0, $t2, is_not_letter  

    sub $t1, $t0, 48    
    
    li $v0, 4           
    la $a0, newLine     
    syscall    

    li $v0, 4           
    la $a0, prompt2     
    syscall             

    li $v0, 12          
    syscall             
    move $t0, $v0  
    move $s7, $t0     
  

    # Check if second character is after 'o'
    li $t2, 'o'
    bgt $t0, $t2, is_not_letter   

    sub $t2, $t0, 48    

    add $t3, $t1, $t2   
  
    andi $t4, $t3, 1    
    beq $t4, $zero, even    

    li $v0, 4           
    la $a0, newLine     
    syscall
                   
    li $v0, 4           
    la $a0, oddText         
    syscall             
    j checkSpace
    
        

is_not_letter:
    # Print wrong input
    li $v0, 4 # system call for print string
    la $a0, msg2 # load the message string address
    syscall
    j inputCheck

even:
    li $v0, 4
    la $a0, newLine
    syscall

    li $v0, 4
    la $a0, evenText
    syscall
    
    j inputCheck
    
    checkSpace:
  	# $s6 subtract ascii of a
    	addi $s6, $s6, -97
     	# multiply by 16
     	mul $s6, $s6, 15
     	# create a offset register $s5 and add it to $s6
     	addi $s5, $s6, 0
        

     	# $s7 subtract ascii of a
    	addi $s7, $s7, -97
     	# add $s7 to $s5 and store in $s5
        add $s5, $s5, $s7
	li $v0, 1
	move $a0, $s5
	syscall
     	# Load the address of board ($s0), add the offset tho the address.
    	add $s5, $s0, $s5

    	# if the space in the data is equal to the character in the data then print empty else print taken
    	lb $t9, 0($s5)
    	beq $t9, $s2, print_empty
    	bne $t9, $s2, print_taken

    	print_empty:
    		li $v0, 4
    		la $a0, empty
    		syscall 
    		modifyBoard:
			lb $t6, line
			andi $t5, $t5, 0x0F
			li $t7, 2
			div $t5, $t7
			mfhi $t9
			beqz $t9, insert_line
			lb $t7, dash
				insert_dash:
					sb $t7, 0($s5)
					j checkForBoxes

				insert_line:
					sb $t6, 0($s5)
					j checkForBoxes


				



    	print_taken:
    		li $v0, 4
    		la $a0, taken
    		syscall
        	j inputCheck
	exit:
		lb $t0, space
		lb $t1, dash
		lb $t2, line
		addi $t5, $s0, -1
		li $t7, 6
		li $t6, 7
		start_dash:
			li $t4, 0
			_dash:
				addi $t5, $t5, 2
				lb $t3, 0($t5)
				beq $t3, $t0, insertDash
				addi $t4, $t4, 1
				beq $t4, $t7, start_line
				j _dash
		start_line:
			li $t4, 0
			_line:
				addi $t5, $t5, 2
				lb $t3, 0($t5)
				beq $t3, $t0, insertLine
				addi $t4, $t4, 1
				beq $t4, $t6, start_dash
				j _line
		insertDash: sb $t1, 0($t5)
				   j end
		insertLine: sb $t2, 0($t5)
		end:	jr $ra
		


# check for boxes code
checkForBoxes:

addi $t0, $s0, 0 # load the base address of the board into $t0

# calculate and store location in array line is stored in.
move $t4, $s5
sub $t4, $t4, $t0

li $t1, 0  # initialize the iterator to 0
addi $t0, $t0, 1 # increment $t0 to point to the first top line in the fist box
addi $t1, $t1, 1 # increment the overall iterator to 1
li $t2, 0  # initialize row to 0
li $t3, 0  # initialize column to 0

find_box_of_input:

outer_loop:
    
   addi $t2, $t2, 1
   bge $t2, 6, exit

inner_loop: 

    beq $t4, $t1, check_found_box # Check top line of box
    
    # Check left line of box
    addi $t5, $t1, 14
    beq $t4, $t5, check_found_box
    
    # Check right line of box
    addi $t5, $t1, 16
    beq $t4, $t5, check_found_box
    
    # check bottom line of box
    addi $t5, $t1, 30
    beq $t4, $t5, check_found_box
 failed:   
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
    bge $t6, 4 success # Checks if the inputs placement will make a box
    j failure

success:
    # problem here
    #addi $s3, $s3, 1
    li $v0, 4
    la $a0, reward
    syscall
    j exit
 
failure:   
    # Return to main
    j failed # go back to inner loop
	
	
