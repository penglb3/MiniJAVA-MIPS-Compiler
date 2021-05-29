#********************************Symbol Table************************************

#          Name Nest-Level  Tree-Node Predefined        Kind      Type      Value     Offset  Dimension     Argnum

#  1     system          0                   yes      class                                                       
#  2    println          1                   yes  procedure                                                      1
#  3         c5          0                            class                                0                      
#  4       func          1  proc-tree              function  type-tree                                           0
#  5       main          1  proc-tree             procedure                                                      0
.data
.text
.globl main
# c5 BEGINS
.data
symbol_3:
.text
symbol_4:
  addiu $sp, $sp, -12
  sw $ra, 8($sp)
  sw $fp, 4($sp)
  sw $a0, 0($sp)
  move $fp, $sp
  li $v0, 55
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
  move $s4, $a0
  jal symbol_4
  move $a0, $s4
  move $t0, $v0
  move $t1, $t0
  addiu $sp, $sp, -4
  sw $t1, 0($sp)
  move $s4, $a0
  jal symbol_4
  move $a0, $s4
  move $t0, $v0
  lw $t1, 0($sp)
  addiu $sp, $sp, 4
  move $t2, $t0
  add $t0, $t1, $t2
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
# c5 ENDS
