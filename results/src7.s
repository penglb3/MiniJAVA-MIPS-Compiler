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
symbol_3: # [class] c7
.text
symbol_4: # [function] sum
  addiu $sp, $sp, -12
  sw $ra, 8($sp)
  sw $fp, 4($sp)
  sw $a0, 0($sp)
  move $fp, $sp
symbol_6: # [variable] s
  li $t0,0
  addiu $sp,$sp,-4
  sw $t0,0($sp)
#  IF #0_0
  move $t7, $fp
  lw $t0, 12($t7)
  addiu $sp, $sp, -4
  sw $t0, 0($sp)
  lw $t1, 0($sp)
  addiu $sp, $sp, 4
  li $t0, 0
  sle $t0, $t1, $t0
  beqz $t0, false_0_0
  li $v0, 1
  j next_0
false_0_0:
# ELSE IF #0_1
  move $t7, $fp
  lw $t0, 12($t7)
  addiu $sp, $sp, -4
  sw $t0, 0($sp)
  lw $t1, 0($sp)
  addiu $sp, $sp, 4
  li $t0, 1
  seq $t0, $t1, $t0
  beqz $t0, false_0_1
  li $v0, 1
  j next_0
false_0_1:
# ELSE #0
  move $t7, $fp
  addiu $s1, $t7, -4
  addiu $sp, $sp, -4
  sw $s1, 0($sp)
  addiu $sp, $sp, -4
  move $t7, $fp
  lw $t0, 12($t7)
  addiu $sp, $sp, -4
  sw $t0, 0($sp)
  lw $t1, 0($sp)
  addiu $sp, $sp, 4
  li $t0, 1
  sub $t0, $t1, $t0
  sw $t0, 0($sp)
  jal symbol_4
  addiu $sp, $sp, 4
  move $t0, $v0
  addiu $sp, $sp, -4
  sw $t0, 0($sp)
  addiu $sp, $sp, -4
  move $t7, $fp
  lw $t0, 12($t7)
  addiu $sp, $sp, -4
  sw $t0, 0($sp)
  lw $t1, 0($sp)
  addiu $sp, $sp, 4
  li $t0, 2
  sub $t0, $t1, $t0
  sw $t0, 0($sp)
  jal symbol_4
  addiu $sp, $sp, 4
  move $t0, $v0
  lw $t1, 0($sp)
  addiu $sp, $sp, 4
  add $t0, $t1, $t0
  move $s2, $t0
  lw $s1, 0($sp)
  addiu $sp, $sp, 4
  sw $s2, 0($s1)
  move $t7, $fp
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
  li $t0, 5
  sw $t0, 0($sp)
  jal symbol_4
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
