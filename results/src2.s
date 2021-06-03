#********************************Symbol Table************************************

#          Name Nest-Level  Tree-Node Predefined        Kind      Type      Value     Offset  Dimension     Argnum

#  1     system          0                   yes      class                                                       
#  2    println          1                   yes  procedure                                                      1
#  3       rect          0                            class                                8                      
#  4      width          1                         variable  type-tree                     0                      
#  5     length          1                         variable  type-tree                     4                      
#  6    getArea          1  proc-tree              function  type-tree                                           0
#  7         mc          0                            class                                4                      
#  8        len          1                         variable  type-tree                     0                      
#  9       main          1  proc-tree             procedure                                                      0
# 10       area          2                         variable  type-tree                    -4                      
.data
S45: .asciiz "test case 2:  "
.text
.globl main
# rect BEGINS
.data
symbol_3: # [class] rect
symbol_4: # [variable] width
.word 3
symbol_5: # [variable] length
.word 7
.text
symbol_6: # [function] getArea
  addiu $sp, $sp, -12
  sw $ra, 8($sp)
  sw $fp, 4($sp)
  sw $a0, 0($sp)
  move $fp, $sp
  li $v0, 4
  la $a0, S45
  syscall
  li $v0, 1
  lw $t7, 0($fp)
  lw $a0, 0($t7)
  syscall
  li $v0, 0xB
  li $a0, 0xA
  syscall
  li $v0, 1
  lw $t7, 0($fp)
  lw $a0, 4($t7)
  syscall
  li $v0, 0xB
  li $a0, 0xA
  syscall
  lw $t7, 0($fp)
  lw $t0, 0($t7)
  addiu $sp, $sp, -4
  sw $t0, 0($sp)
  lw $t1, 0($sp)
  addiu $sp, $sp, 4
  lw $t7, 0($fp)
  lw $t0, 4($t7)
  mul $t0, $t1, $t0
  move $v0, $t0
  move $sp, $fp
  lw $ra, 8($sp)
  lw $fp, 4($sp)
  lw $a3, 0($sp)
  addiu $sp, $sp, 12
  jr $ra
# rect ENDS
# mc BEGINS
.data
symbol_7: # [class] mc
symbol_8: # [variable] len
.word 0
.text
main:
  addiu $sp, $sp, -12
  sw $ra, 8($sp)
  sw $fp, 4($sp)
  la $a0, symbol_7
  sw $a0, 0($sp)
  move $fp, $sp
symbol_10: # [variable] area
  li $t0,0
  addiu $sp,$sp,-4
  sw $t0,0($sp)
#  IF #0_0
  la $a0, symbol_3+0
  move $t7, $a0
  lw $t0, 0($t7)
  addiu $sp, $sp, -4
  sw $t0, 0($sp)
  lw $t1, 0($sp)
  addiu $sp, $sp, 4
  li $t0, 0
  sgt $t0, $t1, $t0
  beqz $t0, false_0_0
  la $a0, symbol_3+0
  move $t7, $a0
  addiu $s1, $t7, 0
  addiu $sp, $sp, -4
  sw $s1, 0($sp)
  li $s2, 5
  lw $s1, 0($sp)
  addiu $sp, $sp, 4
  sw $s2, 0($s1)
  j next_0
false_0_0:
next_0:
  la $a0, symbol_3+0
  jal symbol_6
  la $a0, symbol_3+0
  move $t7, $a0
  addiu $s1, $t7, 4
  addiu $sp, $sp, -4
  sw $s1, 0($sp)
  li $s2, 4
  lw $s1, 0($sp)
  addiu $sp, $sp, 4
  sw $s2, 0($s1)
  move $t7, $fp
  addiu $s1, $t7, -4
  addiu $sp, $sp, -4
  sw $s1, 0($sp)
  la $a0, symbol_3+0
  jal symbol_6
  move $t0, $v0
  move $s2, $t0
  lw $s1, 0($sp)
  addiu $sp, $sp, 4
  sw $s2, 0($s1)
  li $v0, 1
  move $t7, $fp
  lw $a0, -4($t7)
  syscall
  li $v0, 0xB
  li $a0, 0xA
  syscall
  la $a0, symbol_3+0
  jal symbol_6
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
# mc ENDS
