addi $a1, $zero, 1
sw $a1, 0x2000
lw $a2, 0x2000
programend:
j programend
