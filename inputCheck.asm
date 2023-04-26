.data
prompt1: .asciiz "Enter the row label: "
prompt2: .asciiz "Enter the column label:  "
evenText: .asciiz "Invalid move. Try again.\n"
oddText: .asciiz "Possible move. Good job!"
newLine: .asciiz "\n"
msg2: .asciiz "\nWrong input"
taken: .asciiz "That space is taken, please try again.\n"
empty: .asciiz " That space is empty\n"
line: .asciiz "|"

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

    # Check if first charater is after 'o'
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
  

    # Check if second character is after 'k'
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

    j exit

even:
    li $v0, 4
    la $a0, newLine
    syscall

    li $v0, 4
    la $a0, evenText
    syscall
    
    j exit
    
    checkSpace:
  	# $s6 subtract ascii of a
    	addi $s6, $s6, -97
     	# multiply by 16
     	mul $s6, $s6, 16
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
    	beq $t9, $s3, print_taken

    	print_empty:
    		li $v0, 4
    		la $a0, empty
    		syscall  
    		modifyBoard:
			lb $t6, line
			li $t7, 2
			div $t5, $t8
			mfhi $t9
			beqz $t9, insert_dash
				insert_line:
					sb $t6, 0($s5)
					j exit

				insert_dash:
					sb $s4, 0($s5)
					j exit



    	print_taken:
    	li $v0, 4
    	la $a0, taken
    	syscall
    
	exit:
		jr $ra
	
