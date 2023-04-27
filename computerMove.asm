.data
random_seed: .word 1

.text
.globl computerMove
computerMove:

    # Generate a random row (letter between 'a' and 'k')
    jal generateRandom
    addi $t0, $v0, 'a'

    # Generate a random column (letter between 'a' and 'o')
    jal generateRandom
    addi $t1, $v0, 'a'

    # Call inputCheck to verify if it's a valid move
    move $s6, $t0
    move $s7, $t1
    jal inputCheck

    # If the move is not valid, try another move
    lb $t2, 0($s5)
    beq $t2, $s2, computerMove

    # If the move is valid, update the board
    jal checkForBoxes
    beq $v0, 1, updateScore

    # Return to main
    jr $ra

generateRandom:
    # Generate a random integer between 0 and 15
    lw $t0, random_seed
    li $t1, 1103515245
    li $t2, 12345
    li $t3, 31
    mul $t0, $t0, $t1
    add $t0, $t0, $t2
    and $t0, $t0, $t3
    sw $t0, random_seed
    jr $ra

updateScore:
    addi $s4, $s4, 1
    jr $ra
