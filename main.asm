.data
newline: .asciiz "\n" # newline character for printing
columnLabel: .byte 'a','b','c','d','e','f','g','h','i','j','k'
board: .space 400
space: .asciiz " "
dot: .asciiz "."
line: .asciiz "|"
dash: .asciiz "_" 
taken: .asciiz "That space is taken, please try again."
empty: .asciiz "That space is empty"
.text

.globl main

main:

    la $s0, board # $s0 will permanently hold the initial address of the board
    la $s1, columnLabel # $s1 will permanently hold the initial address of the column label
    lb $s2, space
    lb $s3, dot
    lb $s4, dash
    addi $t0, $s0, 0 # $t0 will be the moving address of the current position in the board
    addi $t1, $s1, 0 # $t1 will be the moving address of the current column label
    li $t2, 8 # number of columns
    li $t3, 6 # number of rows
    li $t5, 0 # current row
    li $t6, 0 # binary value used to determine whether current row contains only spaces or dots and spaces
    li $t7, 16 # total number of rows including both dotted rows and rows of spaces

    default_board:
        init_column:
            li $t4, 0 # initializing the counter for the number of columns
            beq $t6, $zero, init_row # checking binary value if current row is supposed to have all spaces
            row_space: # initializing a row of spaces
                sb $s2, 0($t0)
                addi $t0, $t0, 1
                addi $t4, $t4, 1
                blt $t4, $t7, row_space
                li $t6, 0 # resetting the binary value to insert row of dots and spaces next
                j init_column	
            init_row: # initializing a row of dots and spaces
                sb $s3, 0($t0)
                addi $t0, $t0, 1
                beq $t4, $t2, last_column # not inserting an extra space when the last column is reached
                addi $t4, $t4, 1
                sb $s2, 0($t0)
                addi $t0, $t0, 1
                blt $t4, $t2, init_row
            last_column:
                addi $t5, $t5, 1
                li $t6, 1 # resetting the binary value to insert row of spaces next
                blt $t5, $t3, init_column # branch if the 8x6 matrix is not complete yet
            
        jal printBoard # subroutine to print the board                        
        jal inputCheck # subroutine to check the user's input
	    jal printBoard
                jal inputCheck # subroutine to check the user's input
	    jal printBoard
                jal inputCheck # subroutine to check the user's input
	    jal printBoard
                jal inputCheck # subroutine to check the user's input
	    jal printBoard
                jal inputCheck # subroutine to check the user's input
	    jal printBoard
                jal inputCheck # subroutine to check the user's input
	    jal printBoard

    end:
    li $v0, 10
    syscall   


        li $v0, 10
        syscall
