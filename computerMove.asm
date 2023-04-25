{\rtf1\ansi\ansicpg1252\cocoartf2638
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0

\f0\fs24 \cf0 .data\
rows: .word 8\
cols: .word 8\
board: .space 256\
validMoves: .space 240\
validMovesCount: .word 0\
\
.text\
.globl computerMove\
\
computerMove:\
    jal findValidMoves \
\
\
    lw $t0, validMovesCount\
    li $t1, 2\
    div $t0, $t1 \
    mflo $t0\
    jal generateRandomNumber\
    move $t1, $v0 \
\
    \
    sll $t1, $t1, 2\
    la $t2, validMoves\
    add $t2, $t2, $t1 \
    lw $s6, ($t2) \
    addi $t2, $t2, 4 \
    lw $s7, ($t2)\
\
    jr $ra \
\
findValidMoves:\
    lw $t0, rows\
    lw $t1, cols\
\
\
    li $t2, 1\
    li $t8, 0\
\
outer_loop2:\
\
    li $t3, 1\
\
inner_loop2:\
\
    move $a0, $t2\
    move $a1, $t3\
    jal checkForEmptySpace\
\
    beq $v0, 1, storeValidMove \
\
\
    addi $t3, $t3, 2   # increment j\
    blt $t3, $t1, inner_loop2 \
\
\
    addi $t2, $t2, 2   \
    blt $t2, $t0, outer_loop2 \
\
\
    sw $t8, validMovesCount\
    jr $ra\
\
storeValidMove:\
    la $t4, validMoves\
    sll $t5, $t8, 2\
    add $t4, $t4, $t5\
    sw $t2, ($t4)\
    addi $t4, $t4, 4\
    sw $t3, ($t4) # Store the column\
\
    addi $t8, $t8, 2\
    j inner_loop2\
\
checkForEmptySpace:\
    lw $t0, cols\
    lw $t1, rows\
    mult $a0, $t0\
mflo $t0\
add $t0, $t0, $a1\
sll $t0, $t0, 2 \
\
\
la $t1, board\
\
\
add $t1, $t1, $t0\
\
\
lw $t2, ($t1)\
seq $v0, $t2, 0\
jr $ra\
\
generateRandomNumber:\
li $v0, 0xABAD1DEA\
move $a0, $t0\
li $a1, 0\
li $a2, 0xFFFF\
\
\
loop1:\
    and $t0, $v0, $a2\
    srl $t0, $t0, 16\
    xor $v0, $v0, $t0\
\
    addiu $a1, $a1, 1\
    blt $a1, $a2, loop1\
\
\
div $v0, $a0\
mflo $v0\
jr $ra\
}