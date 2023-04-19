.data
buffer: .space 5 # buffer to store input string
newline: .asciiz "\n" # newline character for printing33
rowLabel: .asciiz "1234567"
board: .space 100
space: .asciiz " "
dot: .asciiz "."
line: .asciiz "|"
dash: .asciiz "_" 

.text

li $v0, 4 # printing the row label at the top of the board
la $a0, rowLabel
syscall
lb $t2, dot
lb $t3, space 
li $t4, 0
li $t5, 4 # number of rows
# populate the board with spaces using a 2d array

li $t0, 1 # initial column label
la $s0, board # saves the address of the board
addi $t1, $s0, 0 # 
intialize_board: 
    initialize_label: 
        sw $t0, 0($t1)
        addi $t1, $t1, 4
        addi $t0, $t0, 1
    initialize_spaces:
        # store byte into memory
        sb $t2, 0($t1)
        addi $t1, $t1, 1
        sb $t3, 0($t1)
        addi $t3, $t3, 1
        addi $t4, $t4, 1
        blt $t4, $t5, initialize_spaces         
        

 
print_board:
    li $t0, 1 # initial column label
    la $s0, board # saves the address of the board
    addi $t1, $s0, 0 # 
    print_row:
        lb $t2, 0($t1) # loads byte from the memory address $t1
        li $v0, 1 # system call number 1
        move $a0, $t2 # move the char into the argument register
        syscall # print the char
        addi $t1, $t1, 4 # move to the next byte
        addi $t0, $t0, 1 # increment the column
        bne $t0, 8, print_row # branch to print_row if t0 != 8
    li $v0, 4 # system call number 4
    la $a0, newline # load the address of newline
    syscall # print the newline
    li $v0, 4
    la $a0, dash
    syscall
    li $v0, 4
    la $a0, newline
    syscall
    addi $s0, $s0, 4 # move to the next row
    addi $t3, $t3, 1 # increment the row
    bne $t3, 8, print_board # branch to print_board if t3 != 8
    





li $v0, 8 # syscall for reading string
la $a0, buffer # address of buffer to store string
li $a1, 5 # maximum length of string to read
syscall

lb $t0, 0($a0) # load first character into $t0
subu $t0, $t0, '0' # convert character to integer

lb $t1, 1($a0) # load second character into $t1
subu $t1, $t1, '0' # convert character to integer

lb $t2, 2($a0) # load third character into $t2
subu $t2, $t2, '0' # convert character to integer

lb $t3, 3($a0) # load fourth character into $t3
subu $t3, $t3, '0' # convert character to integer

# print the integers on new lines
li $v0, 1
move $a0, $t0
syscall

li $v0, 4
la $a0, newline
syscall

li $v0, 1
move $a0, $t1
syscall

li $v0, 4
la $a0, newline
syscall

li $v0, 1
move $a0, $t2
syscall

li $v0, 4
la $a0, newline
syscall

li $v0, 1
move $a0, $t3
syscall

