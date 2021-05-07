;ECE109 - Spring 2021
;Program 1: Print sum of all even numbers between two numbers
;Nick Broza, March 31st 2021
		
		.ORIG x3000
START	AND R0, R0, #0
		AND R1, R1, #0 
		AND R2, R2, #0
		AND R3, R3, #0
		AND R4, R4, #0
		AND R5, R5, #0
		AND R6, R6, #0
		AND R7, R7, #0
		
STARTN1	LEA R0, PROMPT ;Output prompt
		PUTS
		
STARTC1	GETC ;Get first character
		OUT

		;Check q
		LD R1, q ;Load hex value of q
		ADD R1, R0, R1
		BRz QUIT
		ADD R1, R0, #0 ;Move character to R1
		
		LD R3, NEG48 ;Load -48 into R3
		ADD R2, R1, R3
		BRn STARTC1 ;If less than 48, back to start
		LD R3, NEG57
		ADD R2, R1, R3
		BRp STARTC1 ;If greater than 57, back to start
		AND R3, R3, #0 ;Clear R3
		AND R2, R2, #0 ;Clear R2
		ST R1, CHAR1
		
STARTC2	GETC ;Get second character
		OUT
		
		;Check q
		LD R1, q ;Load hex value of q
		ADD R1, R0, R1
		BRz QUIT
		ADD R1, R0, #0 ;Move character to R1
		
		;Check enter key
		LD R3, NEG10 ;Load -10 into R1
		ADD R2, R1, R3 
		BRz STORE2 ;If enter key pressed store number
		
		;Check less than 0/greater than 6
		LD R3, NEG48 ;Load -48 into R3
		ADD R2, R1, R3
		BRn STARTC2 ;If less than 48, back to start
		LD R3, NEG54
		ADD R2, R1, R3
		BRp STARTC2 ;If greater than 57, back to start
		AND R2, R2, #0 ;Clear R2
		
		;Check CHAR1 value
		LD R3, NEG49
		LD R2, CHAR1
		ADD R3, R2, R3
		BRp STARTC2 ;If CHAR1 is greater than 1, back for valid input
		BRn STORE1 ;If CHAR1 is 0, store CHAR2 as NUM1
		
		;Build NUM1
		ADD R1, R1, x000A ;Add 10 to CHAR2
		
STORE1	LD R3, NEG48 ;Store when CHAR1 is 10s
		ADD R1, R1, R3
		ST R1, NUM1 ;NUM1 in decimal
		BR STARTN2
		
STORE2	LD R1, CHAR1 ;Store when CHAR1 is 1s
		LD R3, NEG48
		ADD R1, R1, R3
		ST R1, NUM1 ;NUM1 in decimal
		BR STARTN2
		
STARTN2	LEA R0, PROMPT ;Output prompt
		PUTS

STARTC3	GETC ;Get first character
		OUT
		
		;Check q
		LD R1, q ;Load hex value of q
		ADD R1, R0, R1
		BRz QUIT
		ADD R1, R0, #0 ;Move character to R1
		
		LD R3, NEG48 ;Load -48 into R3
		ADD R2, R1, R3
		BRn STARTC3 ;If less than 48, back to start
		LD R3, NEG57
		ADD R2, R1, R3
		BRp STARTC3 ;If greater than 57, back to start
		AND R3, R3, #0 ;Clear R3
		AND R2, R2, #0 ;Clear R2
		ST R1, CHAR1

STARTC4	GETC ;Get second character
		OUT
		
		; Check q
		LD R1, q ;Load hex value of q
		ADD R1, R0, R1
		BRz QUIT
		ADD R1, R0, #0 ;Move character to R1
		
		;Check enter key
		LD R3, NEG10 ;Load -10 into R1
		ADD R2, R1, R3 
		BRz STORE4 ;If enter key pressed store number
		
		;Check less than 0/greater than 6
		LD R3, NEG48 ;Load -48 into R3
		ADD R2, R1, R3
		BRn STARTC4 ;If less than 48, back to start
		LD R3, NEG54
		ADD R2, R1, R3
		BRp STARTC4 ;If greater than 57, back to start
		AND R2, R2, #0 ;Clear R2
		
		;Check CHAR1 value
		LD R3, NEG49
		LD R2, CHAR1
		ADD R3, R2, R3
		BRp STARTC4 ;If CHAR1 is greater than 1, back for valid input
		BRn STORE3 ;If CHAR1 is 0, store CHAR2 as NUM1
		
		ADD R1, R1, x000A ;Add 10 to CHAR2		
		
STORE3	LD R3, NEG48 ;Store when CHAR1 is 10s
		ADD R1, R1, R3
		ST R1, NUM2 ;NUM1 in decimal
		BR STARTCALC
		
STORE4	LD R1, CHAR1 ;Store when CHAR1 is 1s
		LD R3, NEG48
		ADD R1, R1, R3
		ST R1, NUM2 ;NUM1 in decimal
		BR STARTCALC		
		
STARTCALC	
		LD R5, NUM1
		LD R6, NUM2
		NOT R1, R6
		ADD R1, R1, #1 ;For some reason the not operation adds a -1
		ADD R1, R1, R5
		BRz ZERO ;NUM1 = NUM2
		BRp POSI ;NUM1 > NUM2
		BRn CALC ;NUM1 < NUM2
		
ZERO	AND R1, R5, #1	;Handle equal numbers
		BRp ODDZ
		ADD R4, R5, #0	;Handle equal numbers if even
		BR OUTPUT
		
ODDZ	AND R4, R4, #0	;Handle equal numbers if odd
		BR OUTPUT

POSI	ADD R3, R5, #0 ;Swap registers so that R5 < R6
		ADD R5, R6, #0
		ADD R6, R3, #0
		
CALC	AND R1, R5, #1
		BRnz CALC2 ;Branch if even
		ADD R5, R5, #1	;Add 1 to lower bound if odd
		
CALC2	AND R1, R6, #1
		BRnz LOOPA ;Branch if even
		ADD R6, R6, #-1	;Subtract 1 from uppper bound if odd
		
LOOPA	ADD R4, R6, #0
		NOT R3, R5
		ADD R3, R3, #1 ;For some reason the not operation adds a -1
		ADD R3, R3, R6
		BRz OUTPUT

LOOPB	ADD R6, R6, #-2
		ADD R4, R4, R6
		NOT R1, R6
		ADD R1, R1, #1 ;For some reason the not operation adds a -1
		ADD R2, R1, R5
		BRnp LOOPB


OUTPUT	LEA R0, SUM ;Prints output string
		PUTS
		AND R1, R1, #0
		ADD R2, R4, #0
		
PN		ADD R2, R2, #-10 ;Splits sum into tens and ones
		BRn OT
		ADD R1, R1, #1
		BR PN
		
OT		ADD R3, R1, R1 ;Prints tens
		BRz OO
		LD R3, POS48
		ADD R0, R1, R3
		OUT
		
OO		LD R3, POS48 ;Prints ones
		ADD R0, R2, #10
		ADD R0, R0, R3
		OUT
		BR START
		
QUIT	LEA R0, FINISH
		PUTS
		HALT

PROMPT	.STRINGZ "\nEnter a Number (0-16): "
FINISH	.STRINGZ "\nThank you for playing! "
SUM		.STRINGZ "\nThe sum of every even number between the two numbers is: "
q		.FILL xFF8F
POS48	.FILL x0030
NEG10	.FILL xFFF6
NEG48	.FILL xFFD0
NEG49	.FILL xFFCF
NEG54	.FILL xFFCA
NEG57	.FILL xFFC7
CHAR1	.BLKW #1
NUM1	.BLKW #2
NUM2	.BLKW #2
		.END
		
		
		
		