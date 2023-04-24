.data
newline: .asciiz "\n" # newline character for printing
rowLabel: .asciiz "  abcdefghijklmno"
columnLabel: .byte 'a','b','c','d','e','f','g','h','i','j','k'
board: .space 400
space: .asciiz " "
dot: .asciiz "."
line: .asciiz "|"
dash: .asciiz "_" 

.text

.globl main

main:
    li $v0, 4 # printing the row label at the top of the board
    la $a0, rowLabel
    syscall
    li $v0, 4
    la $a0, newline
    syscall
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
    li $t6, 0
    li $t7, 16

    default_board:
        init_column:
            li $t4, 0
            beq $t6, $zero, init_row
            row_space:
                sb $s2, 0($t0)
                addi $t0, $t0, 1
                addi $t4, $t4, 1
                blt $t4, $t7, row_space
                li $t6, 0
                j init_column	
            init_row:
                sb $s3, 0($t0)
                addi $t0, $t0, 1
                beq $t4, $t2, last_column
                addi $t4, $t4, 1
                sb $s2, 0($t0)
                addi $t0, $t0, 1
                blt $t4, $t2, init_row
            last_column:
                addi $t5, $t5, 1
                li $t6, 1
                blt $t5, $t3, init_column
            
                
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

        li $v0, 10
        syscall
