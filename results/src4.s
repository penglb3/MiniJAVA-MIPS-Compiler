#********************************Symbol Table************************************

#          Name Nest-Level  Tree-Node Predefined        Kind      Type      Value     Offset  Dimension     Argnum

#  1     system          0                   yes      class                                                       
#  2    println          1                   yes  procedure                                                      1
#  3         c4          0                            class                               40                      
#  4          x          1                            array  type-tree                     0          1           
#  5         ia          1                            array  type-tree                    40          1           
#  6       main          1  proc-tree             procedure                                                      0
#  7          y          2                            array  type-tree                  -100          1           
#  8          z          2                         variable  type-tree                  -104                      
.data
S36: .asciiz "z="
S39: .asciiz "ia[0]="
S46: .asciiz "ia[1]="
S53: .asciiz "ia[2]="
.text
.globl main
# c4 BEGINS
.data
symbol_3:
symbol_4:
.space 40 # ARRAY SPACE.
symbol_5:
.word 3
.word 5
.word 7
.space 0 # ARRAY SPACE.
.text
main:
  addiu $sp, $sp, -12
  sw $ra, 8($sp)
  sw $fp, 4($sp)
  la $a0, symbol_3
  sw $a0, 0($sp)
  move $fp, $sp
symbol_7:
  addiu $sp,$sp,-100
symbol_8:
  li $t0,0
  addiu $sp,$sp,-4
  sw $t0,0($sp)
  move $t7, $fp
  add $t7, $t7, $zero
  addiu $s1, $t7, -88
  addiu $sp, $sp, -4
  sw $s1, 0($sp)
  li $s2, 17
  lw $s1, 0($sp)
  addiu $sp, $sp, 4
  sw $s2, 0($s1)
  move $t7, $fp
  add $t7, $t7, $zero
  addiu $s1, $t7, -104
  addiu $sp, $sp, -4
  sw $s1, 0($sp)
  move $t7, $fp
  add $t7, $t7, $zero
  lw $t1, -88($t7)
  addiu $sp, $sp, -4
  sw $t1, 0($sp)
  lw $t1, 0($sp)
  addiu $sp, $sp, 4
  li $t2, 3
  add $t0, $t1, $t2
  move $s2, $t0
  lw $s1, 0($sp)
  addiu $sp, $sp, 4
  sw $s2, 0($s1)
  lw $t7, 0($fp)
  add $t7, $t7, $zero
  addiu $s1, $t7, 48
  addiu $sp, $sp, -4
  sw $s1, 0($sp)
  li $s2, 27
  lw $s1, 0($sp)
  addiu $sp, $sp, 4
  sw $s2, 0($s1)
  li $v0, 4
  la $a0, S36
  syscall
  li $v0, 1
  move $t7, $fp
  add $t7, $t7, $zero
  lw $a0, -104($t7)
  syscall
  li $v0, 0xB
  li $a0, 0xA
  syscall
  li $v0, 4
  la $a0, S39
  syscall
  li $v0, 1
  lw $t7, 0($fp)
  add $t7, $t7, $zero
  lw $a0, 40($t7)
  syscall
  li $v0, 0xB
  li $a0, 0xA
  syscall
  li $v0, 4
  la $a0, S36
  syscall
  li $v0, 1
  move $t7, $fp
  add $t7, $t7, $zero
  lw $a0, -104($t7)
  syscall
  li $v0, 0xB
  li $a0, 0xA
  syscall
  li $v0, 4
  la $a0, S46
  syscall
  li $v0, 1
  lw $t7, 0($fp)
  add $t7, $t7, $zero
  lw $a0, 44($t7)
  syscall
  li $v0, 0xB
  li $a0, 0xA
  syscall
  li $v0, 4
  la $a0, S53
  syscall
  li $v0, 1
  lw $t7, 0($fp)
  add $t7, $t7, $zero
  lw $a0, 48($t7)
  syscall
  li $v0, 0xB
  li $a0, 0xA
  syscall
  move $t7, $fp
  add $t7, $t7, $zero
  addiu $s1, $t7, -104
  addiu $sp, $sp, -4
  sw $s1, 0($sp)
  li $s2, -1
  lw $s1, 0($sp)
  addiu $sp, $sp, 4
  sw $s2, 0($s1)
loop_0:
  move $t7, $fp
  add $t7, $t7, $zero
  lw $t1, -104($t7)
  addiu $sp, $sp, -4
  sw $t1, 0($sp)
  lw $t1, 0($sp)
  addiu $sp, $sp, 4
  li $t2, 2
  slt $t0, $t1, $t2
  beqz $t0, loop_0_end
  move $t7, $fp
  add $t7, $t7, $zero
  lw $t1, -104($t7)
  addiu $sp, $sp, -4
  sw $t1, 0($sp)
  lw $t1, 0($sp)
  addiu $sp, $sp, 4
  li $t2, 1
  add $t0, $t1, $t2
  sll $t0, $t0, 2
  lw $t7, 0($fp)
  add $t7, $t7, $t0
  addiu $s1, $t7, 40
  addiu $sp, $sp, -4
  sw $s1, 0($sp)
  li $t1, 1
  addiu $sp, $sp, -4
  sw $t1, 0($sp)
  move $t7, $fp
  add $t7, $t7, $zero
  lw $t1, -104($t7)
  addiu $sp, $sp, -4
  sw $t1, 0($sp)
  lw $t1, 0($sp)
  addiu $sp, $sp, 4
  li $t2, 2
  mul $t0, $t1, $t2
  lw $t1, 0($sp)
  addiu $sp, $sp, 4
  move $t2, $t0
  add $t0, $t1, $t2
  move $t1, $t0
  addiu $sp, $sp, -4
  sw $t1, 0($sp)
  move $t7, $fp
  add $t7, $t7, $zero
  lw $t1, -104($t7)
  addiu $sp, $sp, -4
  sw $t1, 0($sp)
  lw $t1, 0($sp)
  addiu $sp, $sp, 4
  move $t7, $fp
  add $t7, $t7, $zero
  lw $t2, -104($t7)
  mul $t0, $t1, $t2
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
  addiu $s1, $t7, -104
  addiu $sp, $sp, -4
  sw $s1, 0($sp)
  move $t7, $fp
  add $t7, $t7, $zero
  lw $t1, -104($t7)
  addiu $sp, $sp, -4
  sw $t1, 0($sp)
  lw $t1, 0($sp)
  addiu $sp, $sp, 4
  li $t2, 1
  add $t0, $t1, $t2
  move $s2, $t0
  lw $s1, 0($sp)
  addiu $sp, $sp, 4
  sw $s2, 0($s1)
  j loop_0
loop_0_end:
  move $t7, $fp
  add $t7, $t7, $zero
  addiu $s1, $t7, -104
  addiu $sp, $sp, -4
  sw $s1, 0($sp)
  li $s2, 0
  lw $s1, 0($sp)
  addiu $sp, $sp, 4
  sw $s2, 0($s1)
loop_1:
  move $t7, $fp
  add $t7, $t7, $zero
  lw $t1, -104($t7)
  addiu $sp, $sp, -4
  sw $t1, 0($sp)
  lw $t1, 0($sp)
  addiu $sp, $sp, 4
  li $t2, 2
  sle $t0, $t1, $t2
  beqz $t0, loop_1_end
  li $v0, 1
  move $t7, $fp
  add $t7, $t7, $zero
  lw $s0, -104($t7)
  sll $s0, $s0, 2
  lw $t7, 0($fp)
  add $t7, $t7, $s0
  lw $a0, 40($t7)
  syscall
  li $v0, 0xB
  li $a0, 0xA
  syscall
  move $t7, $fp
  add $t7, $t7, $zero
  addiu $s1, $t7, -104
  addiu $sp, $sp, -4
  sw $s1, 0($sp)
  move $t7, $fp
  add $t7, $t7, $zero
  lw $t1, -104($t7)
  addiu $sp, $sp, -4
  sw $t1, 0($sp)
  lw $t1, 0($sp)
  addiu $sp, $sp, 4
  li $t2, 1
  add $t0, $t1, $t2
  move $s2, $t0
  lw $s1, 0($sp)
  addiu $sp, $sp, 4
  sw $s2, 0($s1)
  j loop_1
loop_1_end:
  move $sp, $fp
  lw $ra, 8($sp)
  lw $fp, 4($sp)
  lw $a3, 0($sp)
  addiu $sp, $sp, 12
  li $v0, 10
  syscall
# c4 ENDS
