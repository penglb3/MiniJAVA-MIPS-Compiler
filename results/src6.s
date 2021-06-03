#********************************Symbol Table************************************

#          Name Nest-Level  Tree-Node Predefined        Kind      Type      Value     Offset  Dimension     Argnum

#  1     system          0                   yes      class                                                       
#  2    println          1                   yes  procedure                                                      1
#  3         c6          0                            class                                0                      
#  4    product          1  proc-tree              function  type-tree                                           3
#  5          p          2                          ref_arg  type-tree                    12                      
#  6          x          2                          val_arg  type-tree                    16                      
#  7          y          2                          val_arg  type-tree                    20                      
#  8       main          1  proc-tree             procedure                                                      0
#  9          x          2                         variable  type-tree                    -4                      
# 10          p          2                         variable  type-tree                    -8                      
.data
.text
.globl main
# c6 BEGINS
.data
symbol_3: # [class] c6
.text
symbol_4: # [function] product
  addiu $sp, $sp, -12
  sw $ra, 8($sp)
  sw $fp, 4($sp)
  sw $a0, 0($sp)
  move $fp, $sp
  move $t7, $fp
  addiu $s1, $t7, 12
  addiu $sp, $sp, -4
  sw $s1, 0($sp)
  move $t7, $fp
  lw $t0, 16($t7)
  addiu $sp, $sp, -4
  sw $t0, 0($sp)
  lw $t1, 0($sp)
  addiu $sp, $sp, 4
  move $t7, $fp
  lw $t0, 20($t7)
  mul $t0, $t1, $t0
  move $s2, $t0
  lw $s1, 0($sp)
  addiu $sp, $sp, 4
  sw $s2, 0($s1)
  move $t7, $fp
  lw $t0, 12($t7)
  addiu $sp, $sp, -4
  sw $t0, 0($sp)
  lw $t1, 0($sp)
  addiu $sp, $sp, 4
  move $t7, $fp
  lw $t0, 12($t7)
  mul $t0, $t1, $t0
  move $v0, $t0
  move $sp, $fp
  lw $ra, 8($sp)
  lw $fp, 4($sp)
  lw $a3, 0($sp)
  addiu $sp, $sp, 12
  jr $ra
.text
main:
  addiu $sp, $sp, -12
  sw $ra, 8($sp)
  sw $fp, 4($sp)
  la $a0, symbol_3
  sw $a0, 0($sp)
  move $fp, $sp
symbol_9: # [variable] x
  li $t0,0
  addiu $sp,$sp,-4
  sw $t0,0($sp)
symbol_10: # [variable] p
  li $t0,0
  addiu $sp,$sp,-4
  sw $t0,0($sp)
  move $t7, $fp
  addiu $s1, $t7, -8
  addiu $sp, $sp, -4
  sw $s1, 0($sp)
  li $s2, 0
  lw $s1, 0($sp)
  addiu $sp, $sp, 4
  sw $s2, 0($s1)
  move $t7, $fp
  addiu $s1, $t7, -4
  addiu $sp, $sp, -4
  sw $s1, 0($sp)
  addiu $sp, $sp, -12
  move $t7, $fp
  lw $t0, -8($t7)
  sw $t0, 0($sp)
  li $t0, 3
  sw $t0, 4($sp)
  li $t0, 4
  sw $t0, 8($sp)
  jal symbol_4
  move $t7, $fp
  addiu $a2, $t7, -8
  lw $t3, 0($sp)
  sw $t3, 0($a2)
  addiu $sp, $sp, 12
  move $t0, $v0
  move $s2, $t0
  lw $s1, 0($sp)
  addiu $sp, $sp, 4
  sw $s2, 0($s1)
  li $v0, 1
  move $t7, $fp
  lw $a0, -8($t7)
  syscall
  li $v0, 0xB
  li $a0, 0xA
  syscall
  li $v0, 1
  move $t7, $fp
  lw $a0, -4($t7)
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
# c6 ENDS
