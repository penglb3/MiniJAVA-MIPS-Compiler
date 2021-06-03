#********************************Symbol Table************************************

#          Name Nest-Level  Tree-Node Predefined        Kind      Type      Value     Offset  Dimension     Argnum

#  1     system          0                   yes      class                                                       
#  2    println          1                   yes  procedure                                                      1
#  3     Point0          0                            class                               56                      
#  4      parr0          1                            array  type-tree                     0          1           
#  5          x          1                         variable  type-tree                    48                      
#  6          y          1                         variable  type-tree                    52                      
#  7         f0          1  proc-tree             procedure                                                      0
#  8     Point1          0                            class                               60                      
#  9         t1          1                         variable  type-tree                     0                      
# 10         p1          1                         variable  type-tree                     4                      
# 11         f1          1  proc-tree             procedure                                                      0
# 12     Point2          0                            class                              120                      
# 13        p21          1                         variable  type-tree                     0                      
# 14        p20          1                         variable  type-tree                    60                      
# 15         xy          1                         variable  type-tree                   116                      
# 16       main          1  proc-tree             procedure                                                      0
# 17         xx          2                         variable  type-tree                    -4                      
# 18         px          2                         variable  type-tree                   -64                      
.data
S38: .asciiz "Before x="
S48: .asciiz "After x="
S73: .asciiz "Before t1="
S84: .asciiz "After t1="
S123: .asciiz "p21.p1.x="
S133: .asciiz "p20.parr0:"
S144: .asciiz "p20.x="
.text
.globl main
# Point0 BEGINS
.data
symbol_3: # [class] Point0
symbol_4: # [array] parr0
.space 48 # ARRAY SPACE.
symbol_5: # [variable] x
.word 5
symbol_6: # [variable] y
.word 0
.text
symbol_7: # [procedure] f0
  addiu $sp, $sp, -12
  sw $ra, 8($sp)
  sw $fp, 4($sp)
  sw $a0, 0($sp)
  move $fp, $sp
  li $v0, 4
  la $a0, S38
  syscall
  li $v0, 1
  lw $t7, 0($fp)
  lw $a0, 48($t7)
  syscall
  li $v0, 0xB
  li $a0, 0xA
  syscall
  lw $t7, 0($fp)
  addiu $s1, $t7, 48
  addiu $sp, $sp, -4
  sw $s1, 0($sp)
  lw $t7, 0($fp)
  lw $t0, 48($t7)
  addiu $sp, $sp, -4
  sw $t0, 0($sp)
  lw $t1, 0($sp)
  addiu $sp, $sp, 4
  lw $t7, 0($fp)
  lw $t0, 48($t7)
  mul $t0, $t1, $t0
  move $s2, $t0
  lw $s1, 0($sp)
  addiu $sp, $sp, 4
  sw $s2, 0($s1)
  lw $t7, 0($fp)
  addiu $s1, $t7, 52
  addiu $sp, $sp, -4
  sw $s1, 0($sp)
  li $s2, 1
  lw $s1, 0($sp)
  addiu $sp, $sp, 4
  sw $s2, 0($s1)
loop_0:
  lw $t7, 0($fp)
  lw $t0, 52($t7)
  addiu $sp, $sp, -4
  sw $t0, 0($sp)
  lw $t1, 0($sp)
  addiu $sp, $sp, 4
  li $t0, 12
  slt $t0, $t1, $t0
  beqz $t0, loop_0_end
  lw $t7, 0($fp)
  lw $s0, 52($t7)
  sll $s0, $s0, 2
  lw $t7, 0($fp)
  add $t7, $t7, $s0
  addiu $s1, $t7, 0
  addiu $sp, $sp, -4
  sw $s1, 0($sp)
  lw $t7, 0($fp)
  lw $t0, 52($t7)
  addiu $sp, $sp, -4
  sw $t0, 0($sp)
  lw $t1, 0($sp)
  addiu $sp, $sp, 4
  li $t0, 1
  sub $t0, $t1, $t0
  sll $t0, $t0, 2
  lw $t7, 0($fp)
  add $t7, $t7, $t0
  lw $t0, 0($t7)
  addiu $sp, $sp, -4
  sw $t0, 0($sp)
  lw $t1, 0($sp)
  addiu $sp, $sp, 4
  li $t0, 1
  add $t0, $t1, $t0
  move $s2, $t0
  lw $s1, 0($sp)
  addiu $sp, $sp, 4
  sw $s2, 0($s1)
  lw $t7, 0($fp)
  addiu $s1, $t7, 52
  addiu $sp, $sp, -4
  sw $s1, 0($sp)
  lw $t7, 0($fp)
  lw $t0, 52($t7)
  addiu $sp, $sp, -4
  sw $t0, 0($sp)
  lw $t1, 0($sp)
  addiu $sp, $sp, 4
  li $t0, 1
  add $t0, $t1, $t0
  move $s2, $t0
  lw $s1, 0($sp)
  addiu $sp, $sp, 4
  sw $s2, 0($s1)
  j loop_0
loop_0_end:
  li $v0, 4
  la $a0, S48
  syscall
  li $v0, 1
  lw $t7, 0($fp)
  lw $a0, 48($t7)
  syscall
  li $v0, 0xB
  li $a0, 0xA
  syscall
  move $sp, $fp
  lw $ra, 8($sp)
  lw $fp, 4($sp)
  lw $a3, 0($sp)
  addiu $sp, $sp, 12
  jr $ra
# Point0 ENDS
# Point1 BEGINS
.data
symbol_8: # [class] Point1
symbol_9: # [variable] t1
.word 12
symbol_10: # [variable] p1
.space 48 # ARRAY SPACE.
.word 5
.word 0
.text
symbol_11: # [procedure] f1
  addiu $sp, $sp, -12
  sw $ra, 8($sp)
  sw $fp, 4($sp)
  sw $a0, 0($sp)
  move $fp, $sp
  li $v0, 4
  la $a0, S73
  syscall
  li $v0, 1
  lw $t7, 0($fp)
  lw $a0, 0($t7)
  syscall
  li $v0, 0xB
  li $a0, 0xA
  syscall
  lw $t7, 0($fp)
  addiu $s1, $t7, 0
  addiu $sp, $sp, -4
  sw $s1, 0($sp)
  li $s2, 1024
  lw $s1, 0($sp)
  addiu $sp, $sp, 4
  sw $s2, 0($s1)
  lw $a0, 0($fp)
  addiu $a0, $a0, 4
  jal symbol_7
  li $v0, 4
  la $a0, S84
  syscall
  li $v0, 1
  lw $t7, 0($fp)
  lw $a0, 0($t7)
  syscall
  li $v0, 0xB
  li $a0, 0xA
  syscall
  move $sp, $fp
  lw $ra, 8($sp)
  lw $fp, 4($sp)
  lw $a3, 0($sp)
  addiu $sp, $sp, 12
  jr $ra
# Point1 ENDS
# Point2 BEGINS
.data
symbol_12: # [class] Point2
symbol_13: # [variable] p21
.word 12
.space 48 # ARRAY SPACE.
.word 5
.word 0
symbol_14: # [variable] p20
.space 48 # ARRAY SPACE.
.word 5
.word 0
symbol_15: # [variable] xy
.word 0
.text
main:
  addiu $sp, $sp, -12
  sw $ra, 8($sp)
  sw $fp, 4($sp)
  la $a0, symbol_12
  sw $a0, 0($sp)
  move $fp, $sp
symbol_17: # [variable] xx
  li $t0,22
  addiu $sp,$sp,-4
  sw $t0,0($sp)
symbol_18: # [variable] px
  li $t0,12
  addiu $sp,$sp,-4
  sw $t0,0($sp)
  addiu $sp,$sp,-48
  li $t0,5
  addiu $sp,$sp,-4
  sw $t0,0($sp)
  li $t0,0
  addiu $sp,$sp,-4
  sw $t0,0($sp)
  la $a0, symbol_3+0
  jal symbol_7
  la $a0, symbol_13+0
  jal symbol_11
  move $a0, $fp
  move $t7, $a0
  addiu $s1, $t7, 48
  addiu $sp, $sp, -4
  sw $s1, 0($sp)
  move $t7, $fp
  lw $s2, -4($t7)
  lw $s1, 0($sp)
  addiu $sp, $sp, 4
  sw $s2, 0($s1)
  move $a0, $fp
  jal symbol_7
  la $a0, symbol_13+0
  move $t7, $a0
  addiu $s1, $t7, 0
  addiu $sp, $sp, -4
  sw $s1, 0($sp)
  li $s2, 133
  lw $s1, 0($sp)
  addiu $sp, $sp, 4
  sw $s2, 0($s1)
  la $a0, symbol_13+0
  jal symbol_11
  li $v0, 4
  la $a0, S123
  syscall
  li $v0, 1
  la $a0, symbol_13+4
  move $t7, $a0
  lw $a0, 48($t7)
  syscall
  li $v0, 0xB
  li $a0, 0xA
  syscall
  la $a0, symbol_14+0
  jal symbol_7
  lw $t7, 0($fp)
  addiu $s1, $t7, 116
  addiu $sp, $sp, -4
  sw $s1, 0($sp)
  li $s2, 0
  lw $s1, 0($sp)
  addiu $sp, $sp, 4
  sw $s2, 0($s1)
loop_1:
  lw $t7, 0($fp)
  lw $t0, 116($t7)
  addiu $sp, $sp, -4
  sw $t0, 0($sp)
  lw $t1, 0($sp)
  addiu $sp, $sp, 4
  li $t0, 12
  slt $t0, $t1, $t0
  beqz $t0, loop_1_end
  li $v0, 4
  la $a0, S133
  syscall
  li $v0, 1
  lw $t7, 0($fp)
  lw $s0, 116($t7)
  sll $s0, $s0, 2
  la $a0, symbol_14+0
  move $t7, $a0
  add $t7, $t7, $s0
  lw $a0, 0($t7)
  syscall
  li $v0, 0xB
  li $a0, 0xA
  syscall
  lw $t7, 0($fp)
  addiu $s1, $t7, 116
  addiu $sp, $sp, -4
  sw $s1, 0($sp)
  lw $t7, 0($fp)
  lw $t0, 116($t7)
  addiu $sp, $sp, -4
  sw $t0, 0($sp)
  lw $t1, 0($sp)
  addiu $sp, $sp, 4
  li $t0, 1
  add $t0, $t1, $t0
  move $s2, $t0
  lw $s1, 0($sp)
  addiu $sp, $sp, 4
  sw $s2, 0($s1)
  j loop_1
loop_1_end:
  la $a0, symbol_8+0
  jal symbol_11
  li $v0, 4
  la $a0, S144
  syscall
  li $v0, 1
  la $a0, symbol_14+0
  move $t7, $a0
  lw $a0, 48($t7)
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
# Point2 ENDS
