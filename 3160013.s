# Author: Alexander Ventouras
# Date: 17-11-2017
# Description: This program calculates the ammount of change that 
# has to be given to the driver, for the parking lot value of 5 euros
# and 24 cents. 
# If the driver gives more money than 20 euros, or more cents than 
# 99, or a negative euro or cent value, the system warns the driver 
# that there is an error. 
# If the driver gives less money than 5 euros and 24 cents, the system
# warns the driver that the ammount is less than needed.
# If the driver gives exactly 5 euros and 24 cents, the system prints 
# the message "Change = 0".
# If none of the above is true, the system prints the quantity of each
# coin and banknote it has to give in change.
# All the values are int.

# Registers' description:
# $t0: The euro ammount that driver gives at the system.
# $t1: The cent ammount  "     "       "      "     "  .
# $t2-$t5: At lines 75-91, these registers are used to check whether the 
# values the driver gave are inside the limits, or if there is no change.
# $t2: After the line 91, is used as the remaining ammount of change the system 
# has to give to the driver.
# $t3: After the line 91, is used as the current address of the counter of each 
# value of change in table "Counters".
# $t4: a) At lines 103-161, is used as an intermidiate register for augmenting the 
# 	   counters mentioned above.
#      b) After line 161 is used as intermidiate register to check whether 
# 	   each counter of coins' and banknotes' value is 0 or 1 or 2. 

		.text
		.globl main	

# Start of program; Initial messages.		
main: 	la $a0, startmsg1	# Print the String
		li $v0, 4			# "--Parking Ticket Payment--\n"
		syscall				# at screen
	
		la $a0, CLRF		# Change the line of the screen
		li $v0, 4
		syscall
		
		la $a0, startmsg2	# Print the String
		li $v0, 4			# "Fee: 5 euros and 24 cents\n"
		syscall				# at screen
	
		la $a0, CLRF		# Change the line of the screen
		li $v0, 4
		syscall
		
		# Prompt messages; Input of euros' and cents' ammounts.	
		la $a0, promptmsg1	# Print the String
		li $v0, 4			# "Euros: (<=20): "
		syscall				# at screen
	
		li $v0, 5			# Read the ammount of euros
		syscall
	
		move $t0, $v0		# Save euros in $t0
	
		la $a0, promptmsg2	# Print the String
		li $v0, 4			# "Cents: (<=99): "
		syscall				# at screen
		
		li $v0, 5			# Read the ammount of cents
		syscall
	
		move $t1, $v0		# Save cents in $t1
		
		la $a0, CLRF		# Change the line of the screen
		li $v0, 4
		syscall

		# Checking of the values' bounds; Redirections to various parts of program.
		sle $t2, $t0, 20  	# euros<=20
		sge $t3, $t0, 0		# euros>=0
		and $t4, $t2, $t3	# euros<=20 && euros>=0. Free t2,t3. Alloc t4.
	
		sle $t2, $t1, 99  	# cents<=99
		sge $t3, $t1, 0		# cents>=0
		and $t5, $t2, $t3	# cents<=99 && euros>=0. Free t2,t3. Alloc t5.
	
		and $t2, $t4, $t5	# euros<=20 && euros>=0 && cents<=99 && euros>=0. Free t4,t5. Alloc t2.
	
		beq $t2, 0, Errmsg	# if(euros<=20 && euros>=0 && cents<=99 && cents>=0) is false goto error msg. Free t2.
	
		seq $t3, $t0, 5		# euros==5
		seq $t4, $t1, 24	# cents==24
		and $t5, $t3, $t4	# euros==5 && cents==24. Free t3,t4. Alloc t5.
	
		beq $t5, 1, NoChan	# if (euros==5 && cents==24) is true goto NoC (No change). Free t5.
		
		# Calculating the total ammount (in cents).		
		move $t2, $t0		# Copy euros in $t2 (Ammount). Alloc t2.
		mul $t2, $t2, 100	# ammount = euros*100
		add $t2, $t2, $t1	# ammount = euros*100 + cents
		sub $t2, $t2, 524	# ammount = ammount - 524
		
		la $t3, Counters	# t3 = address of Counters[0]. Alloc t3.
		
		# Calculating the ammount of each coin and banknote the system has to give as change.
		blt $t2, 1000, eu5	# if (ammount < 1000) goto euro5.
		li $t4, 1			# t4 = 1. Alloc t4.
		sw $t4,($t3)			# Counters[0] (10 euros) = 1. Free t4.	
		sub $t2, $t2, 1000	# ammount = ammount - 1000.
		
eu5:	blt $t2, 500, eu2	# if (ammount < 500) goto euro2.
		li $t4, 1			# t4 = 1. Alloc t4.
		sw $t4,4($t3)		# Counters[1] (5 euros) = 1. Free t4.
		sub $t2, $t2, 500	# ammount = ammount - 500
		
eu2:	blt $t2, 200, eu1	# if (ammount < 200) goto euro1
		li $t4, 1			# t4 = 1. Alloc t4.
		sw $t4,8($t3)		# Counters[2] (2 euros) = 1.
		sub $t2, $t2, 200	# ammount = ammount - 200
		blt $t2, 200, eu1	# if (ammount < 200) goto euro1 
		add $t4, $t4, 1		# t4 = t4 + 1
		sw $t4,8($t3)		# Counters[2] (2 euros) = 2. Free t4.
		sub $t2, $t2, 200	# ammount = ammount - 200
		
eu1:	blt $t2, 100, ce50	# if (ammount < 100) goto cent50
		li $t4, 1			# t4 = 1. Alloc t4.
		sw $t4,12($t3)		# Counters[3] (1 euro) = 1. Free t4.
		sub $t2, $t2, 100	# ammount = ammount - 100
		
ce50:	blt $t2, 50, ce20	# if (ammount < 50) goto cent20
		li $t4, 1			# t4 = 1. Alloc t4.
		sw $t4,16($t3)		# Counters[4] (50 cents) = 1. Free t4.
		sub $t2, $t2, 50	# ammount = ammount - 50
		
ce20:	blt $t2, 20, ce10	# if (ammount < 20) goto cent10 
		li $t4, 1			# t4 = 1. Alloc t4.
		sw $t4,20($t3)		# Counters[5] (20 cents) = 1.
		sub $t2, $t2, 20	# ammount = ammount - 20
		blt $t2, 200, ce10	# if (ammount < 20) goto cent10
		add $t4, $t4, 1		# t4 = t4 + 1
		sw $t4,20($t3)		# Counters[2] (20 cents) = 2. Free t4.
		sub $t2, $t2, 20	# ammount = ammount - 20
		
ce10:	blt $t2, 10, ce5	# if (ammount < 10) goto cent5
		li $t4, 1			# t4 = 1. Alloc t4.
		sw $t4,24($t3)		# Counters[6] (10 cents) = 1. Free t4.
		sub $t2, $t2, 10	# ammount = ammount - 10
		
ce5:	blt $t2, 5, ce2		# if (ammount < 5) goto cent2
		li $t4, 1			# t4 = 1. Alloc t4.
		sw $t4,28($t3)		# Counters[7] (5 cents) = 1. Free t4.
		sub $t2, $t2, 5		# ammount = ammount - 5
		
ce2:	blt $t2, 2, ce1		# if (ammount < 2) goto cent1 
		li $t4, 1			# t4 = 1. Alloc t4.
		sw $t4,32($t3)		# Counters[8] (2 cents) = 1.
		sub $t2, $t2, 2		# ammount = ammount - 2
		blt $t2, 2, ce1		# if (ammount < 2) goto cent1
		add $t4, $t4, 1		# t4 = t4 + 1
		sw $t4,32($t3)		# Counters[2] (2 euros) = 2. Free t4.
		sub $t2, $t2, 2		# ammount = ammount - 2
		
ce1:	blt $t2, 1, cont1 	# if (ammount < 1) goto continue
		li $t4, 1			# t4 = 1. Alloc t4.
		sw $t4,36($t3)		# Counters[9] (1 cent) = 1. Free t4.
		sub $t2, $t2, 1		# ammount = ammount - 1	
		
		# Checking if the ammount of money given by the driver is not enough.
cont1:	bgez $t2, cont2		# if (ammount>=0) goto continue 
		la $a0, NoEnMon		# Print the String
		li $v0, 4			# "Error! Not enough money!"
		syscall				# at screen
		j endPrg			# goto end of Program
		
		# Printing all the ammounts of coins and notes the system has to give as change.
cont2: 	la $a0, Okmsg		# Print the String
		li $v0, 4			# "Change: \n"
		syscall				# at screen
		
		la $a0, CLRF		# Change the line of the screen
		li $v0, 4
		syscall
		
		lw $t4,($t3)		# $t4 = Counters[0]. Alloc t4.
		beq $t4,$zero,ch5e	# if ($t4 == 0) goto check5euros.
		
		la $a0, ($t4)		# Print the counter
		li $v0, 1			# of 10 euros
		syscall				# at screen
		
		la $a0, change10eu	# Print the String
		li $v0, 4			# " x 10 euros"
		syscall				# at screen
		
		la $a0, CLRF		# Change the line of the screen
		li $v0, 4
		syscall
		
ch5e:	lw $t4,4($t3)		# $t4 = Counters[1]. Alloc t4.
		beq $t4,$zero,ch2e	# if ($t4 == 0) goto check2euros.
		
		la $a0, ($t4)			# Print the counter
		li $v0, 1			# of 5 euros
		syscall				# at screen
		
		la $a0, change5eu	# Print the String
		li $v0, 4			# " x 5 euros"
		syscall				# at screen
		
		la $a0, CLRF		# Change the line of the screen
		li $v0, 4
		syscall
		
ch2e:	lw $t4,8($t3)		# $t4 = Counters[2]. Alloc t4.
		beq $t4,$zero,ch1e	# if ($t4 == 0) goto check1euro.
		
		la $a0, ($t4)			# Print the counter
		li $v0, 1			# of 2 euros
		syscall				# at screen
		
		la $a0, change2eu	# Print the String
		li $v0, 4			# " x 2 euros"
		syscall				# at screen
		
		la $a0, CLRF		# Change the line of the screen
		li $v0, 4
		syscall
		
ch1e:	lw $t4,12($t3)		# $t4 = Counters[3]. Alloc t4.
		beq $t4,$zero,ch50c	# if ($t4 == 0) goto check50cents.
		
		la $a0, ($t4)		# Print the counter
		li $v0, 1			# of 1 euro
		syscall				# at screen
			
		la $a0, change1eu	# Print the String
		li $v0, 4			# " x 1 euro"
		syscall				# at screen
		
		la $a0, CLRF		# Change the line of the screen
		li $v0, 4
		syscall
		
ch50c:	lw $t4,16($t3)		# $t4 = Counters[4]. Alloc t4.
		beq $t4,$zero,ch20c	# if ($t4 == 0) goto check20cents.
		
		la $a0, ($t4)		# Print the counter
		li $v0, 1			# of 50 cents
		syscall				# at screen
		
		la $a0, change50c	# Print the String
		li $v0, 4			# " x 50 cents"
		syscall				# at screen
		
		la $a0, CLRF		# Change the line of the screen
		li $v0, 4
		syscall
		
ch20c:	lw $t4,20($t3)		# $t4 = Counters[5]. Alloc t4.
		beq $t4,$zero,ch10c	# if ($t4 == 0) goto check10cents.
		
		la $a0, ($t4)		# Print the counter
		li $v0, 1			# of 20 cents
		syscall				# at screen
		
		la $a0, change20c	# Print the String
		li $v0, 4			# " x 20 cents"
		syscall				# at screen
		
		la $a0, CLRF		# Change the line of the screen
		li $v0, 4
		syscall
		
ch10c:	lw $t4,24($t3)		# $t4 = Counters[6]. Alloc t4.
		beq $t4,$zero,ch5c	# if ($t4 == 0) goto check5cents.
		
		la $a0, ($t4)		# Print the counter
		li $v0, 1			# of 10 cents
		syscall				# at screen
		
		la $a0, change10c	# Print the String
		li $v0, 4			# " x 10 cents"
		syscall				# at screen
		
		la $a0, CLRF		# Change the line of the screen
		li $v0, 4
		syscall
		
ch5c:	lw $t4,28($t3)		# $t4 = Counters[7]. Alloc t4.
		beq $t4,$zero,ch2c	# if ($t4 == 0) goto check2cents.
		
		la $a0, ($t4)		# Print the counter
		li $v0, 1			# of 5 cents
		syscall				# at screen
		
		la $a0, change5c	# Print the String
		li $v0, 4			# " x 5 cents"
		syscall				# at screen
		
		la $a0, CLRF		# Change the line of the screen
		li $v0, 4
		syscall
		
ch2c:	lw $t4,32($t3)		# $t4 = Counters[8]. Alloc t4.
		beq $t4,$zero,ch1c	# if ($t4 == 0) goto check2cents.
		
		la $a0, ($t4)		# Print the counter
		li $v0, 1			# of 2 cents
		syscall				# at screen
		
		la $a0, change2c	# Print the String
		li $v0, 4			# " x 2 cents"
		syscall				# at screen
		
		la $a0, CLRF		# Change the line of the screen
		li $v0, 4
		syscall
		
ch1c:	lw $t4,36($t3)		# $t4 = Counters[9]. Alloc t4.
		beq $t4,$zero,endPrg# if ($t4 == 0) goto End of Program.
		
		la $a0, ($t4)		# Print the counter
		li $v0, 1			# of 1 cent
		syscall				# at screen
		
		la $a0, change1c	# Print the String
		li $v0, 4			# " x 1 cent"
		syscall				# at screen
		
		j endPrg			# Goto end of program
		
		# Error Message (printed if given values are out of bounds).
Errmsg:	la $a0, errormsg	# Print the String
		li $v0, 4			# "Error! Please try again."
		syscall				# at screen

		j endPrg			# Goto end of program
	
		# Message printed if the given ammount is exactly 5,24 euros.
NoChan:	la $a0, NoChange	# Print the String
		li $v0, 4			# "Change = 0"
		syscall				# at screen
	
		# End of program; Various lines in the above code redirecting here.
endPrg:	li $v0, 10			# End program
		syscall
	
			.data	
Counters:	.word   0, 0, 0, 0, 0, 0, 0, 0, 0, 0   	# Counters of each banknote and coins' change (10 euro --> 1 cent)
startmsg1: 	.asciiz "--Parking Ticket Payment--\n"
startmsg2: 	.asciiz "Fee: 5 euros and 24 cents\n"
promptmsg1:	.asciiz "Euros: (<=20): "
promptmsg2: .asciiz "Cents: (<=99): "
errormsg:	.asciiz "Error! Please try again."
NoEnMon:	.asciiz "Error! Not enough money!"
NoChange:	.asciiz "Change = 0"
Okmsg:		.asciiz	"Change: \n"
change10eu:	.asciiz " x 10 euros"
change5eu:	.asciiz " x 5 euros"
change2eu:	.asciiz " x 2 euros"
change1eu:	.asciiz " x 1 euro"
change50c:	.asciiz " x 50 cents"
change20c:	.asciiz " x 20 cents"
change10c:	.asciiz " x 10 cents"
change5c:	.asciiz " x 5 cents"
change2c:	.asciiz " x 2 cents"
change1c:	.asciiz " x 1 cent"
CLRF:		.asciiz "\n"