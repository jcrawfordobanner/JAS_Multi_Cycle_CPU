###### REGISTER USE DEFINITIONS
# $a0 -> Holds the base pointer at the stage in recursion
# $a1 -> Incrementing thing
# $a2 -> Resultant memory pointer
# $a3 -> Pointer to final value in array (essentially indicates size)

# $t0 -> First of two temp variables
# $t1 -> Second of two temp variables
# $t2 -> Holds output of comparison

# $sp -> Holds the base pointer at stages in recursion
# $ra -> Holds the previous point in the recusion stack
######

##### RECURSIVE INSERTION SORT IN PLACE
#### Testing on an array of length: 6

# Pre insertion sort work:
## Initialize temps
addi $a0, $zero, 0x2000
add $a1, $zero, $zero
add $a2, $a0, $a1
addi $a3, $a0, 20
addi $t0, $zero, 20
addi $v0, $zero, 1
addi $sp, $zero, 0x3ffc

## Initialize array: [20, 16, 12, 8, 4, 0]
init:
beq $a2, $a3, endinit
sw $t0, ($a2)
sub $t0, $t0, 4
addi $a1, $a1, 0x4
add $a2, $a1, $a0
j init
endinit:
sw $t0, ($a2)

## Post initialization reset temps
addi $a0, $zero, 0x2000
add $a1, $zero, $zero
add $a2, $a0, $a1
j insert

# Recursive step: go to end of array
# Allows sort to work backwards
recurse:
beq $a0, $a3, donerecurse
addi $sp, $sp, -8
sw $ra, 4($sp)
sw $a0, ($sp)
addi $a0, $a0, 4
jal recurse

# Sort step:
## Assuming everything after $a0 is sorted, place the value at $a0 in the right spot
## Loop through array until the spot is found
lw $ra, 4($sp)
lw $a0, ($sp)
addi $sp, $sp, 8
add $a1, $zero, $zero
add $a2, $a0, $a1

# Set the value to sort as $t0, and the next value in the array as $t1
# If $t0 > $t1, => switch the values around in the array, and move down array
# Otherwise, we've found the appropriate spot for $t0
# Use $a2 as the pointer moving through array

whileswitch:
beq $a2, $a3, doneswitch
checkswitch:
lw $t0, ($a2)
lw $t1, 4($a2)
slt $t2, $t0, $t1
bne $t2, 0, doneswitch
sw $t1, ($a2)
sw $t0, 4($a2)
addi $a1, $a1, 4
add $a2, $a1, $a0
j whileswitch

donerecurse:
jr $ra
doneswitch:
jr $ra

insert:
jal recurse
# Check if the insertion sort code works
# Loop through entire array, check that it's in ascending order
add $t3, $zero, $zero
checker:
beq $a0, $a3, donechecker
lw $t0, ($a0)
lw $t1, 4($a0)
slt $t2, $t0, $t1
add $t3, $t3, $t2
addi $a0, $a0, 4
j checker

donechecker:
xori $t4, $t3, 5
# IF SUCCESSFUL: $t4 -> 0
# IF FAILED: $t4 -> 1
add $v0, $t4, $zero

programend:
j programend
