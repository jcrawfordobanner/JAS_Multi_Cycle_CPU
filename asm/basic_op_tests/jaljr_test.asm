addi $a0, $zero, 1
addi $a1, $zero, 2
jumper:
addi $a0, $a0, 1
bne $a0, 3, firsttime
jr $ra
firsttime:
jal jumper
addi $a0, $a0, 1
add $a2, $a0, $zero
programend:
j programend
