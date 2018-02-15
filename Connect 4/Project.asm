.data
fp.ra:	4
fp.fp:	0
fp.a0:	8
fp.a1:	12
fp.a2:	16
fp.s0:	-4
fp.s1:	-8
fp.s2:	-12
fp.s3:	-16
fp.s4:	-20
fp.s5:	-24

title:	.asciiz	"WELCOME TO THE MIPS VERSION OF CONNECT-4!"
topline:	.asciiz	"________________________\n"
middleline:	.asciiz	"|   |   |   |   |   |   |\n"
bottomline:	.asciiz	"|___|___|___|___|___|___|\n"
modifyline:	.asciiz	"|   |   |   |   |   |   |\n"
prompt:	.asciiz	"Select a column: "
prompt2:	.asciiz	"Invalid Column selction. Choose a column between 1 and 6: "
uwin:	.asciiz	"USER WINS!!"
cwin:	.asciiz	"COMPUTER WINS!!"
tie:	.asciiz	"GRID IS FULL. TIE!!"
	.align	2
grid:	.space	24
againmsg:	.asciiz	"PLAY AGAIN (Nonzero=YES, 0=NO)?"
playerPeice:	.space 12
playerIndex: .byte 0
turn:	.byte 0
	.globl	main
	
	
	.text

main:
	li	$a0,65
	li	$a1,66
	li	$a2,67
	li	$s0,68
	li	$s1,69
	li	$s2,70
	li	$s3,71
	li	$s4,72
	li	$s5,73
	
a1:	jal	initialize_grid
	la	$a0,turn
	sb	$0,0($a0)
	la	$a0,playerIndex
	sb	$0,0($a0)
	
b1:
	jal	resetdisplay
	jal	print_game
	
	jal	select_col_user
	move	$a0,$v0
	move	$a2,$v0
	li	$a1,0
	jal	drop_piece
	jal	resetdisplay
	jal	print_game
	addi	$a0,$0,0
	jal	check_win
	beqz	$v0,d1
	jal	grid_full
	bnez	$v0,f1
	
	move	$a0,$a2
	jal	select_col_comp
	move	$a0,$v0
	li	$a1,1
	jal	drop_piece
	jal	resetdisplay
	jal	print_game
	addi	$a0,$0,1
	jal	check_win
	addi	$v0,$v0,-1
	beqz	$v0,e1
	jal	grid_full
	bnez	$v0,f1
	
	b	b1
c1:
        li      $v0,4
	la	$a0,againmsg
	syscall	
	
	li      $v0,5
	syscall
	bnez	$v0,a1
	
	li      $v0,10
	syscall	

d1:
        li      $v0,4
	la	$a0,uwin
	syscall
	b	c1
	
e1:	li      $v0,4
        la	$a0,cwin
	syscall	
	b	c1
	
f1:	li      $v0,4
        la	$a0,tie
	syscall	
	b	c1
#### #### #### #### #### #### #### #### #### ####
#Clears the console
#### #### #### #### #### #### #### #### #### ####
resetdisplay:
	addi	$sp,$sp,-8
	sw	$a0,4($sp)
	sw	$a1,0($sp)

	li	$a1,25
	
a2:	li	$a0,0xA
        li      $v0,11
	syscall
	addi	$a1,$a1,-1
	bgtz	$a1,a2
	
	li	$a0,0
	li	$a1,0

	

	lw	$a1,0($sp)
	lw	$a0,4($sp)
	addi	$sp,$sp,8
	jr	$ra

#### #### #### #### #### #### #### #### #### ####
#clears the grid
#### #### #### #### #### #### #### #### #### ####

initialize_grid:
	addi	$sp,$sp,-12
	sw	$a0,8($sp)
	sw	$a1,4($sp)
	sw	$a2,0($sp)

	la	$a0,grid
	li	$a1,24
	
a3:	li	$a2,0x16
	sb	$a2,0($a0)
	addi	$a0,$a0,1
	addi	$a1,$a1,-1
	bgtz	$a1,a3
	
	lw	$a0,8($sp)
	lw	$a1,4($sp)
	lw	$a2,0($sp)
	addi	$sp,$sp,12
	jr	$ra

#### #### #### #### #### #### #### #### #### ####
#prints a 4row 6col grid with peices
#### #### #### #### #### #### #### #### #### ####

print_game:
	addi	$sp,$sp,-20
	sw	$a0,16($sp)
	sw	$a1,12($sp)
	sw	$s0,8($sp)
	sw	$s1,4($sp)
	sw	$s2,0($sp)

	la	$a1,grid

	la	$a0,topline
	li      $v0,4
	syscall	

	li	$s2,-4

a4:	la	$a0,middleline
        li      $v0,4
	syscall	
	
	li	$s0,-6
	
b4:	la	$a0,modifyline

	
	addi	$s0,$s0,7	
	sll	$s0,$s0,2	
	addi	$s0,$s0,-2	
	add	$a0,$a0,$s0
	addi	$s0,$s0,2
	srl	$s0,$s0,2
	addi	$s0,$s0,-7
	
	lb	$s1,0($a1)
	sb	$s1,0($a0)
	addi	$s0,$s0,1
	addi	$a1,$a1,1
	bltz	$s0,b4
	
	addi	$a0,$a0,-22
	li      $v0,4
	syscall	

	la	$a0,bottomline
	li      $v0,4
	syscall	
	addi	$s2,$s2,1
	bltz	$s2,a4
		

	li	$a0,32
	li	$a1,3


	la	$a0,title
	li      $v0,4
	syscall	

	li	$a0,0
	li	$a1,15



	lw	$a0,16($sp)
	lw	$a1,12($sp)
	lw	$s0,8($sp)
	lw	$s1,4($sp)
	lw	$s2,0($sp)
	addi	$sp,$sp,20
	jr	$ra


#### #### #### #### #### #### #### #### #### ####
#return $v0 = coloum selected by user
#check to make sure it is valid
#### #### #### #### #### #### #### #### #### ####

select_col_user:
	addi	$sp,$sp,-8
	sw	$ra,0($sp)
	sw	$a0,4($sp)
	
	la	$a0,prompt
	li      $v0,4
	syscall	
a5:	
        li      $v0,5
        syscall	
	addi	$v0,$v0,-1	
	bltz	$v0,b5
	addi	$a0,$v0,-5
	bgtz	$a0,b5
	
	la	$a0,grid
	add	$a0,$a0,$v0
	lb	$a0,0($a0)
	addi	$a0,$a0,-22
	beqz	$a0,c5

b5:	jal	resetdisplay
	jal	print_game
	la	$a0,prompt2
	li      $v0,4
	syscall	
	b	a5

c5:	lw	$ra,0($sp)
	lw	$a0,4($sp)
	addi	$sp,$sp,8
	jr	$ra

#### #### #### #### #### #### #### #### #### ####
#col = $a0 = col_num
#user = $a1 = 0 if player("O"), 1 if Comp("X")
#### #### #### #### #### #### #### #### #### ####

drop_piece:
	addi	$sp,$sp,-20
	sw	$a0,16($sp)
	sw	$a1,12($sp)
	sw	$a2,8($sp)
	sw	$s0,4($sp)
	sw	$s1,0($sp)
	
	la	$a2,grid
	add	$a2,$a2,$a0
	addi	$a2,$a2,6
	move	$s1,$0

a6:	lb	$s0,0($a2)
	addi	$s0,$s0,-22
	bnez	$s0,b6
	addi	$a2,$a2,6
	addi	$a0,$a0,6
	addi	$s1,$s1,1
	addi	$s1,$s1,-3
	bgtz	$s1,b6
	addi	$s1,$s1,3
	b	a6
b6:	
	addi	$a2,$a2,-6
	bnez	$a1,c6
	li	$s0,0x4f
	sb	$s0,0($a2)
	b	d6

c6:
	li	$s0,0x58
	sb	$s0,0($a2)

d6:	lw	$a0,16($sp)
	lw	$a1,12($sp)
	lw	$a2,8($sp)
	lw	$s0,4($sp)
	lw	$s1,0($sp)
	addi	$sp,$sp,20
	jr	$ra

#### #### #### #### #### #### #### #### #### ####
#return $v0 = col_num selected by computer
#### #### #### #### #### #### #### #### #### ####
	
select_col_comp:
	addi	$sp,$sp,-44
	sw	$fp,24($sp)
	addi	$fp,$sp,24
	sw	$ra,fp.ra($fp)
	sw	$a0,fp.a0($fp)
	sw	$a1,fp.a1($fp)
	sw	$a2,fp.a2($fp)
	sw	$s0,fp.s0($fp)
	sw	$s1,fp.s1($fp)
	sw	$s2,fp.s2($fp)
	sw	$s3,fp.s3($fp)
	sw	$s4,fp.s4($fp)
	sw	$s5,fp.s5($fp)
	
	#clear $v0 to invalid selection
	addi	$v0,$0,-1
	#store player's previous column
	la	$a1,playerPeice
	la	$a2,playerIndex
	lb	$s0,0($a2)
	add	$a1,$a1,$s0
	sb	$a0,0($a1)
	addi	$s0,$s0,1
	sb	$s0,0($a2)
	
	#increment's turn
	la	$a1,turn
	lb	$a2,0($a1)
	addi	$a2,$a2,1
	sb	$a2,0($a1)
	
	#first turn AI
	addi	$a2,$a2,-1
	bnez	$a2,b7
	
	addi	$a0,$a0,-2
	beqz	$a0,a7
	
	add	$v0,$0,2
	b	f7
a7:
	add	$v0,$0,3
	b	f7	
	
	#second turn AI
b7:	addi	$a2,$a2,-1
	bnez	$a2,c7
	
	addi	$a0,$a0,-2
	beqz	$a0,a7
	
	add	$v0,$0,2
	b	f7

	
	#thrid turn AI
	#first time a block might be required
c7:	addi	$a2,$a2,-1
	bnez	$a2,d7
	
	la	$a0,playerPeice
	lb	$s0,0($a0)
	lb	$s1,1($a0)
	lb	$s2,2($a0)
	
	beq	$s0,$s1,c71
	addi	$s0,$s0,-2
	beqz	$s0,d7
	addi	$s0,$s0,-1
	beqz	$s0,d7
	
c71:	beq	$s0,$s2,c72
	addi	$s0,$s0,-2
	beqz	$s0,c75
	addi	$s0,$s0,-1
	beqz	$s0,c76
c72:	add	$v0,$0,$s0
	b	f7
c75:	addi	$v0,$0,5
	b	f7
c76:	addi	$v0,$0,0
	b	f7
d7:
	addi	$a0,$0,0x4F
	la	$a1,grid
	addi	$a1,$a1,6
	li	$s0,-6
d71:	beqz	$s0,d74
	lb	$s1,0($a1)
	add	$a2,$0,$a1	
	addi	$a1,$a1,1
	addi	$s0,$s0,1
	bne	$s1,$a0,d71
d72:
	addi	$a2,$a2,6
	lb	$s1,0($a2)
	bne	$s1,$a0,d71
	addi	$a2,$a2,6
	lb	$s1,0($a2)
	bne	$s1,$a0,d71
	lb	$s1,-7($a1)
	addi	$s1,$s1,-22
	bnez	$s1,d73
	add	$v0,$s0,5
d73:	b	d71

d74:	la	$a1,grid
	addi	$a1,$a1,2
	lb	$a2,0($a1)
	addi	$a2,$a2,-22
	bnez	$a2,d75
	add	$v0,$0,2
	b	f7
d75:	addi	$a1,$a1,1
	lb	$a2,0($a1)
	addi	$a2,$a2,-22
	bnez	$a2,e7
	add	$v0,$0,3
	b	f7
e7:	
	la	$a0,grid
	li	$a1,-6
x21:	beqz	$a1,e7
	lb	$a2,0($a0)
	addi	$a0,$a0,1
	addi	$a1,$a1,1
	addi	$a2,$a2,-22
	bnez	$a2,x21
	addi	$v0,$a1,5  

f7:	
	lw	$ra,fp.ra($fp)
	lw	$a0,fp.a0($fp)
	lw	$a1,fp.a1($fp)
	lw	$a2,fp.a2($fp)
	lw	$s0,fp.s0($fp)
	lw	$s1,fp.s1($fp)
	lw	$s2,fp.s2($fp)
	lw	$s3,fp.s3($fp)
	lw	$s4,fp.s4($fp)
	lw	$s5,fp.s5($fp)
	lw	$fp,0($fp)
	addi	$sp,$sp,44
	jr	$ra

#### #### #### #### #### #### #### #### #### ####
#return $v0 = 0 if player(0 user, 1 comp) has not won, 1 if they have
#### #### #### #### #### #### #### #### #### ####

check_win:
	addi	$sp,$sp,-44
	sw	$fp,24($sp)
	addi	$fp,$sp,24
	sw	$ra,fp.ra($fp)
	sw	$a0,fp.a0($fp)
	sw	$a1,fp.a1($fp)
	sw	$a2,fp.a2($fp)
	sw	$s0,fp.s0($fp)
	sw	$s1,fp.s1($fp)
	sw	$s2,fp.s2($fp)
	sw	$s3,fp.s3($fp)
	sw	$s4,fp.s4($fp)
	sw	$s5,fp.s5($fp)
	
	beqz	$a0,a8
	b	b8
a8:	addi	$a0,$0,0x4f
	b	vert
b8:	addi	$a0,$0,0x58
	#vertical win check
vert:	la	$a1,grid
	li	$s0,-6
a9:	beqz	$s0,horiz
	lb	$s1,0($a1)
	add	$a2,$0,$a1	
	addi	$a1,$a1,1
	addi	$s0,$s0,1
	bne	$s1,$a0,a9
b9:
	addi	$a2,$a2,6
	lb	$s1,0($a2)
	bne	$s1,$a0,a9
	addi	$a2,$a2,6
	lb	$s1,0($a2)
	bne	$s1,$a0,a9
	addi	$a2,$a2,6
	lb	$s1,0($a2)
	bne	$s1,$a0,a9
	lw	$v0,fp.a0($fp)
	b	x80

horiz:	la	$a1,grid
	li	$s0,-4
a10:	addi	$s3,$0,0
	beqz	$s0,diag1
	lb	$s1,0($a1)
	add	$a2,$0,$a1	
	addi	$a1,$a1,6
	addi	$s0,$s0,1
	beq	$s1,$a0,b10
	addi	$s3,$0,0
	b	b101

b10:	addi	$s3,$s3,1
b101:	addi	$a2,$a2,1
	lb	$s1,0($a2)
	beq	$s1,$a0,c10
	addi	$s3,$0,0
	b	c101
	
c10:	addi	$s3,$s3,1
c101:	addi	$a2,$a2,1
	lb	$s1,0($a2)
	beq	$s1,$a0,d10
	addi	$s3,$0,0
	b	d101
	
d10:	addi	$s3,$s3,1
d101:	addi	$a2,$a2,1
	lb	$s1,0($a2)
	beq	$s1,$a0,e10
	addi	$s3,$0,0
	b	e101
	
e10:	addi	$s3,$s3,-3
	beqz	$s3,horizWin
	addi	$s3,$s3,3
	
	addi	$s3,$s3,1
e101:	addi	$a2,$a2,1
	lb	$s1,0($a2)
	beq	$s1,$a0,f10
	addi	$s3,$0,0
	b	f101

f10:	addi	$s3,$s3,-3
	beqz	$s3,horizWin
	addi	$s3,$s3,3
	
	addi	$s3,$s3,1
f101:	addi	$a2,$a2,1
	lb	$s1,0($a2)
	beq	$s1,$a0,g10
	addi	$s3,$0,0
	
g10:	addi	$s3,$s3,-3
	beqz	$s3,horizWin
	bnez	$s0,a10
	beqz	$s0,diag1
	addi	$v0,$0,-1
	b	x80
	
horizWin:
	lw	$v0,fp.a0($fp)
	b	x80
	
diag1:	la	$a1,grid
	li	$s0,-3
a11:	beqz	$s0,diag2
	lb	$s1,0($a1)
	add	$a2,$0,$a1	
	addi	$a1,$a1,1
	addi	$s0,$s0,1
	bne	$s1,$a0,a11
b11:
	addi	$a2,$a2,7
	lb	$s1,0($a2)
	bne	$s1,$a0,a11
	addi	$a2,$a2,7
	lb	$s1,0($a2)
	bne	$s1,$a0,a11
	addi	$a2,$a2,7
	lb	$s1,0($a2)
	bne	$s1,$a0,a11
	lw	$v0,fp.a0($fp)
	b	x80
	
diag2:	la	$a1,grid
	addi	$a1,$a1,5
	li	$s0,-3
a12:	beqz	$s0,x80
	lb	$s1,0($a1)
	add	$a2,$0,$a1	
	addi	$a1,$a1,-1
	addi	$s0,$s0,1
	bne	$s1,$a0,a12
b12:
	addi	$a2,$a2,5
	lb	$s1,0($a2)
	bne	$s1,$a0,a12
	addi	$a2,$a2,5
	lb	$s1,0($a2)
	bne	$s1,$a0,a12
	addi	$a2,$a2,5
	lb	$s1,0($a2)
	bne	$s1,$a0,a12
	lw	$v0,fp.a0($fp)

x80:
	lw	$ra,fp.ra($fp)
	lw	$a0,fp.a0($fp)
	lw	$a1,fp.a1($fp)
	lw	$a2,fp.a2($fp)
	lw	$s0,fp.s0($fp)
	lw	$s1,fp.s1($fp)
	lw	$s2,fp.s2($fp)
	lw	$s3,fp.s3($fp)
	lw	$s4,fp.s4($fp)
	lw	$s5,fp.s5($fp)
	lw	$fp,0($fp)
	addi	$sp,$sp,44
	jr	$ra
	
###################################################
# output:
# v0: =0 if grid is NOT full
# =1 if grid is full.
###################################################
grid_full:
	addi	$sp,$sp,-44
	sw	$fp,24($sp)
	addi	$fp,$sp,24
	sw	$ra,fp.ra($fp)
	sw	$a0,fp.a0($fp)
	sw	$a1,fp.a1($fp)
	sw	$a2,fp.a2($fp)
	sw	$s0,fp.s0($fp)
	sw	$s1,fp.s1($fp)
	sw	$s2,fp.s2($fp)
	sw	$s3,fp.s3($fp)
	sw	$s4,fp.s4($fp)
	sw	$s5,fp.s5($fp)
	
	addi	$a0,$0,-7
	la	$a1,grid
a13:	lb	$a2,0($a1)
	addi	$a2,$a2,-22
	addi	$a0,$a0,1
	addi	$a1,$a1,1
	beqz	$a2,c13
	bltz	$a0,a13
b13:
	addi	$v0,$0,1
	b	d13
c13:
	addi	$v0,$0,0
d13:
	lw	$ra,fp.ra($fp)
	lw	$a0,fp.a0($fp)
	lw	$a1,fp.a1($fp)
	lw	$a2,fp.a2($fp)
	lw	$s0,fp.s0($fp)
	lw	$s1,fp.s1($fp)
	lw	$s2,fp.s2($fp)
	lw	$s3,fp.s3($fp)
	lw	$s4,fp.s4($fp)
	lw	$s5,fp.s5($fp)
	lw	$fp,0($fp)
	addi	$sp,$sp,44
	jr	$ra
