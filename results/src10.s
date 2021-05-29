#********************************Symbol Table************************************

#          Name Nest-Level  Tree-Node Predefined        Kind      Type      Value     Offset  Dimension     Argnum

#  1     system          0                   yes      class                                                       
#  2     readln          1                   yes  procedure                                                      1
#  3    println          1                   yes  procedure                                                      1
#  4       Test          0                            class                                0                      
#  5       main          1  proc-tree             procedure                                                      0
#  6          x          2                         variable  type-tree                    -4                      
#  7          i          2                         variable  type-tree                    -8                      
#  8      test2          0                            class                                0                      
#  9      test3          0                            class                                0                      
# 10      hahah          1  proc-tree              function  type-tree                                           0
.data
S39: .asciiz "i="
.text
.globl main
# Test BEGINS
.data
symbol_4:
.text
main:
  addiu $sp, $sp, -12
  sw $ra, 8($sp)
  sw $fp, 4($sp)
  la $a0, symbol_4
  sw $a0, 0($sp)
  move $fp, $sp
symbol_6:
  li $t0,0
  addiu $sp,$sp,-4
  sw $t0,0($sp)
symbol_7:
  li $t0,0
  addiu $sp,$sp,-4
  sw $t0,0($sp)
  li $v0,5
  syscall
  move $t7, $fp
  add $t7, $t7, $zero
  addiu $t0, $t7, -4
  sw $v0,0($t0)
# IF #0
  move $t7, $fp
  add $t7, $t7, $zero
  lw $t1, -4($t7)
  addiu $sp, $sp, -4
  sw $t1, 0($sp)
  lw $t1, 0($sp)
  addiu $sp, $sp, 4
  li $t2, 10
  sgt $t0, $t1, $t2
  beqz $t0, false_0_0
  move $t7, $fp
  add $t7, $t7, $zero
  addiu $s1, $t7, -8
  addiu $sp, $sp, -4
  sw $s1, 0($sp)
  li $s2, 1
  lw $s1, 0($sp)
  addiu $sp, $sp, 4
  sw $s2, 0($s1)
  j next_0
false_0_0:
next_0:
# IF #1
  move $t7, $fp
  add $t7, $t7, $zero
  lw $t1, -4($t7)
  addiu $sp, $sp, -4
  sw $t1, 0($sp)
  lw $t1, 0($sp)
  addiu $sp, $sp, 4
  li $t2, 6
  sgt $t0, $t1, $t2
  beqz $t0, false_1_0
  move $t7, $fp
  add $t7, $t7, $zero
  addiu $s1, $t7, -8
  addiu $sp, $sp, -4
  sw $s1, 0($sp)
  li $s2, 2
  lw $s1, 0($sp)
  addiu $sp, $sp, 4
  sw $s2, 0($s1)
  j next_1
false_1_0:
# IF #1
  move $t7, $fp
  add $t7, $t7, $zero
  lw $t1, -4($t7)
  addiu $sp, $sp, -4
  sw $t1, 0($sp)
  lw $t1, 0($sp)
  addiu $sp, $sp, 4
  li $t2, 3
  sgt $t0, $t1, $t2
  beqz $t0, false_1_1
  move $t7, $fp
  add $t7, $t7, $zero
  addiu $s1, $t7, -8
  addiu $sp, $sp, -4
  sw $s1, 0($sp)
  li $s2, 3
  lw $s1, 0($sp)
  addiu $sp, $sp, 4
  sw $s2, 0($s1)
  j next_1
false_1_1:
# ELSE #1
  move $t7, $fp
  add $t7, $t7, $zero
  addiu $s1, $t7, -8
  addiu $sp, $sp, -4
  sw $s1, 0($sp)
  li $s2, 4
  lw $s1, 0($sp)
  addiu $sp, $sp, 4
  sw $s2, 0($s1)
next_1:
  li $v0, 4
  la $a0, S39
  syscall
  li $v0, 1
  move $t7, $fp
  add $t7, $t7, $zero
  lw $a0, -8($t7)
  syscall
  li $v0, 0xB
  li $a0, 0xA
  syscall
  move $sp, $fp
  lw $ra, 8($sp)
  lw $fp, 4($sp)
  lw $a3, 0($sp)
  addiu $sp, $sp, 12
  li $v0, 10
  syscall
# Test ENDS
# test2 BEGINS
.data
symbol_8:
# test2 ENDS
# test3 BEGINS
.data
symbol_9:
.text
symbol_10:
  addiu $sp, $sp, -12
  sw $ra, 8($sp)
  sw $fp, 4($sp)
  sw $a0, 0($sp)
  move $fp, $sp
  move $sp, $fp
  lw $ra, 8($sp)
  lw $fp, 4($sp)
  lw $a3, 0($sp)
  addiu $sp, $sp, 12
  jr $ra
# test3 ENDS
