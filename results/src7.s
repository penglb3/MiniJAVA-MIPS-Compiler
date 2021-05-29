#********************************Symbol Table************************************

#          Name Nest-Level  Tree-Node Predefined        Kind      Type      Value     Offset  Dimension     Argnum

#  1     system          0                   yes      class                                                       
#  2    println          1                   yes  procedure                                                      1
#  3         c7          0                            class                                0                      
#  4        sum          1  proc-tree              function  type-tree                                           1
#  5          i          2                          val_arg  type-tree                    12                      
#  6          s          2                         variable  type-tree                    -4                      
#  7       main          1  proc-tree             procedure                                                      0
.data
S35: .asciiz "sum(5)="
.text
.globl main
# c7 BEGINS
.data
symbol_3:
.text
symbol_4:
  addiu $sp, $sp, -12
  sw $ra, 8($sp)
  sw $fp, 4($sp)
  sw $a0, 0($sp)
  move $fp, $sp
symbol_6:
  li $t0,0
  addiu $sp,$sp,-4
  sw $t0,0($sp)
# IF #0
  move $t7, $fp
  add $t7, $t7, $zero
  lw $t1, 12($t7)
  addiu $sp, $sp, -4
  sw $t1, 0($sp)
  lw $t1, 0($sp)
  addiu $sp, $sp, 4
  li $t2, 0
  sle $t0, $t1, $t2
  beqz $t0, false_0_0
  li $v0, 1
  j next_0
false_0_0:
# IF #0
  move $t7, $fp
  add $t7, $t7, $zero
  lw $t1, 12($t7)
  addiu $sp, $sp, -4
  sw $t1, 0($sp)
  lw $t1, 0($sp)
  addiu $sp, $sp, 4
  li $t2, 1
  seq $t0, $t1, $t2
  beqz $t0, false_0_1
  li $v0, 1
  j next_0
false_0_1:
# ELSE #0
  move $t7, $fp
  add $t7, $t7, $zero
  addiu $s1, $t7, -4
  addiu $sp, $sp, -4
  sw $s1, 0($sp)
  addiu $sp, $sp, -4
  move $t7, $fp
  add $t7, $t7, $zero
  lw $t1, 12($t7)
  addiu $sp, $sp, -4
  sw $t1, 0($sp)
  lw $t1, 0($sp)
  addiu $sp, $sp, 4
  li $t2, 1
  sub $t0, $t1, $t2
  move $a0, $t0
  sw $a0, 0($sp)
  move $s4, $a0
  jal symbol_4
  move $a0, $s4
  addiu $sp, $sp, 4
  move $t0, $v0
  move $t1, $t0
  addiu $sp, $sp, -4
  sw $t1, 0($sp)
  addiu $sp, $sp, -4
  move $t7, $fp
  add $t7, $t7, $zero
  lw $t1, 12($t7)
  addiu $sp, $sp, -4
  sw $t1, 0($sp)
  lw $t1, 0($sp)
  addiu $sp, $sp, 4
  li $t2, 2
  sub $t0, $t1, $t2
  move $a0, $t0
  sw $a0, 0($sp)
  move $s4, $a0
  jal symbol_4
  move $a0, $s4
  addiu $sp, $sp, 4
  move $t0, $v0
  lw $t1, 0($sp)
  addiu $sp, $sp, 4
  move $t2, $t0
  add $t0, $t1, $t2
  move $s2, $t0
  lw $s1, 0($sp)
  addiu $sp, $sp, 4
  sw $s2, 0($s1)
  move $t7, $fp
  add $t7, $t7, $zero
  lw $v0, -4($t7)
next_0:
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
  li $v0, 4
  la $a0, S35
  syscall
  addiu $sp, $sp, -4
  li $a0, 5
  sw $a0, 0($sp)
  move $s4, $a0
  jal symbol_4
  move $a0, $s4
  addiu $sp, $sp, 4
  move $t0, $v0
  li $v0, 1
  move $a0, $t0
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
# c7 ENDS
