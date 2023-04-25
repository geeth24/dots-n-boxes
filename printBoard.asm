.data
space: .asciiz " "
newline: .asciiz "\n" # newline character for printing

.text 
.globl printBoard


printBoard:
	li $t2, 8 # number of columns
	li $t5, 0
    	addi $t0, $s0, 0
    	addi $t7, $s1, 0
    	li $t3, 11
	print_board:
        	print_column:
            		li $t4, 0
            		lb $t8, 0($t7)
            		li $v0, 11
            		move $a0, $t8
            		syscall
            		li $v0, 4
            		la $a0, space
            		syscall
           		 addi $t7, $t7, 1

        	print_row:
            		lb $t6, 0($t0)
            		li $v0, 11
            		move $a0, $t6
            		syscall
            		addi $t0, $t0, 1
            		beq $t2, $t4, end_row
            		addi $t4, $t4, 1
            		
            		            
            		lb $t6, 0($t0)
            		li $v0, 11
            		move $a0, $t6
            		syscall
            		addi $t0, $t0, 1
            
            		li $v0, 4
            		la $a0, space
            		syscall
            
            
            		blt $t4, $t2, print_row
            		end_row:
                		li $v0, 4
                		la $a0, newline
                		syscall
                		addi $t5, $t5, 1
                		blt $t5, $t3, print_column
            		
           jr $ra
