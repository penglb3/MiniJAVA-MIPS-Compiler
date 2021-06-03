#********************************Symbol Table************************************

#          Name Nest-Level  Tree-Node Predefined        Kind      Type      Value     Offset  Dimension     Argnum

#  1     system          0                   yes      class                                                       
#  2    println          1                   yes  procedure                                                      1
#  3         c1          0                            class                                4                      
#  4          x          1                         variable  type-tree                     0                      
#  5       main          1  proc-tree             procedure                                                      0
#  6          x          2                         variable  type-tree                    -4                      
.data
S29: .asciiz "x>=0"
.text
.globl main
# c1 BEGINS
.data
symbol_3: # [class] c1
symbol_4: # [variable] x
.word -1
.text
main:
  addiu $sp, $sp, -12
  sw $ra, 8($sp)
  sw $fp, 4($sp)
  la $a0, symbol_3
  sw $a0, 0($sp)
  move $fp, $sp
symbol_6: # [variable] x
  li $t0,4
  addiu $sp,$sp,-4
  sw $t0,0($sp)
#  IF #0_0
  move $t7, $fp
  lw $t0, -4($t7)
  addiu $sp, $sp, -4
  sw $t0, 0($sp)
  lw $t1, 0($sp)
  addiu $sp, $sp, 4
  li $t0, 0
  sge $t0, $t1, $t0
  beqz $t0, false_0_0
  li $v0, 4
  la $a0, S29
  syscall
  j next_0
false_0_0:
next_0:
  move $sp, $fp
  lw $ra, 8($sp)
  lw $fp, 4($sp)
  lw $a3, 0($sp)
  addiu $sp, $sp, 12
  li $v0, 10
  syscall
# c1 ENDS
