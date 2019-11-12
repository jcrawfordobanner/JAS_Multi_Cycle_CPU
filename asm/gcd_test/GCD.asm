addi $a0, $zero, 16
addi $a1, $zero, 24

add $t1, $zero, $a0
add $t2, $zero, $a1

Main:
slt $t5, $t1 $t2
slt $t6, $t2 $t1
beq $t5, 1 ALTB
beq $t6, 1 BLTA
beq $t1, $t2 END
ALTB:
sub $t2,$t2,$t1
j Main
BLTA:
sub $t1,$t1,$t2
j Main
END:
add $v0, $zero, $t1
programend:
j programend
