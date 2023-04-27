.data
space: .asciiz " "
newline: .asciiz "\n" # newline character for printing
rowLabel: .asciiz "  ab cd ef gh ij kl mn o"
userScore: .asciiz "The user's score is: "
computerScore: .asciiz "The computer's score is: "
.text 
.globl printBoard


printBoard:
	li $v0, 4
	la $a0, userScore
	syscall
	li $v0, 1
	move $a0, $s3
	syscall
	li $v0, 4
	la $a0, newline
	syscall
	li $v0, 4
	la $a0, computerScore
	syscall
	li $v0, 1
	move $a0, $s4
	syscall
	li $v0, 4
	la $a0, newline
	syscall
    	addi $t0, $s0, 0
    	addi $t7, $s1, 0
    	li $v0, 4 # printing the row label at the top of the board
    	la $a0, rowLabel
    	syscall
    	li $v0, 4
    	la $a0, newline
    	syscall
    	li $t1, 0
    	li $t2, 0
    	li $t3, 15
    	li $t5, 11
	print_board:
        	print_row:
            		li $t4, 0
            		lb $t8, 0($t7)
            		li $v0, 11
            		move $a0, $t8
            		syscall
            		li $v0, 4
            		la $a0, space
            		syscall
           		addi $t7, $t7, 1
           	print_columns:
           		lb $t6, 0($t0)
           		li $v0, 11
           		move $a0, $t6
           		syscall
           		li $v0, 4
            		la $a0, space
            		syscall
           		addi $t0, $t0, 1
           		addi $t4, $t4, 1
           		blt $t4, $t3, print_columns
           	last_column:
           		addi $t2, $t2, 1
           		li $v0, 4
           		la $a0, newline
           		syscall
           		blt $t2, $t5, print_row

           jr $ra
