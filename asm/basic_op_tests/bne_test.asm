addi $a0, $zero, 1
addi $a1, $zero, 2
bne $a0, $a1, jumper
addi $a0, $a0, 1
jumper:
add $a2, $a0, $zero
programend:
j programend
