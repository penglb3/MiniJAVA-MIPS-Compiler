#********************************Symbol Table************************************

#          Name Nest-Level  Tree-Node Predefined        Kind      Type      Value     Offset  Dimension     Argnum

#  1      Point          0                            class                                8                      
#  2          x          1                         variable  type-tree                     0                      
#  3          y          1                         variable  type-tree                     4                      
#  4       Test          0                            class                                8                      
#  5         p0          1                         variable  type-tree                     0                      
#  6       main          1  proc-tree             procedure                                                      0
#  7          p          2                         variable  type-tree                    -8                      
#  8        xxx          2                         variable  type-tree                   -12                      
.data
.text
.globl main
# Point BEGINS
.data
symbol_1:
symbol_2:
.word 0
symbol_3:
.word 0
# Point ENDS
# Test BEGINS
.data
symbol_4:
symbol_5:
.word 0
.word 0
.text
main:
  addiu $sp, $sp, -12
  sw $ra, 8($sp)
  sw $fp, 4($sp)
  la $a0, symbol_4
  sw $a0, 0($sp)
  move $fp, $sp
symbol_7:
  li $t0,0
  addiu $sp,$sp,-4
  sw $t0,0($sp)
  li $t0,0
  addiu $sp,$sp,-4
  sw $t0,0($sp)
symbol_8:
  li $t0,0
  addiu $sp,$sp,-4
  sw $t0,0($sp)
  move $a0, $fp
  move $t7, $a0
  add $t7, $t7, $zero
  addiu $s1, $t7, 4
  addiu $sp, $sp, -4
  sw $s1, 0($sp)
  li $s2, 1
  lw $s1, 0($sp)
  addiu $sp, $sp, 4
  sw $s2, 0($s1)
  move $a0, $fp
  move $t7, $a0
  add $t7, $t7, $zero
  addiu $s1, $t7, 0
  addiu $sp, $sp, -4
  sw $s1, 0($sp)
  li $s2, 1
  lw $s1, 0($sp)
  addiu $sp, $sp, 4
  sw $s2, 0($s1)
  move $sp, $fp
  lw $ra, 8($sp)
  lw $fp, 4($sp)
  lw $a3, 0($sp)
  addiu $sp, $sp, 12
  li $v0, 10
  syscall
# Test ENDS
