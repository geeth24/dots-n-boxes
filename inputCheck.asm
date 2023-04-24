.data
prompt1: .asciiz "Enter the first (lowercase) character: "
prompt2: .asciiz "Enter the second (lowercase) character: "
evenText: .asciiz "Invalid move. Try again."
oddText: .asciiz "Possible move. Good job!"
newLine: .asciiz "\n"
msg2: .asciiz "Wrong input"

.text
.globl inputCheck

inputCheck:
    li $v0, 4
    la $a0, prompt1
    syscall

    li $v0, 12          
    syscall             
    move $t0, $v0     

    # Check if first charater is after 'o'
    li $t2, 'o'
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

    # Check if second character is after 'k'
    li $t2, 'k'
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
    j exit              

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

exit:
	jr $ra
	