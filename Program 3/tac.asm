;Nick Broza
;ECE109 Spring 2021
;Tic tac toe game in LC-3
		
		.ORIG x3000
START	AND R0, R0, #0
		AND R1, R1, #0 
		AND R2, R2, #0
		AND R3, R3, #0
		AND R4, R4, #0
		AND R5, R5, #0
		AND R6, R6, #0
		AND R7, R7, #0
	

		;Clear screen
		BR CLRSCR
STARTN	.FILL xC000
TOTPIX	.FILL #15620
BLACK	.FILL x0000
CLRSCR	LD R5, STARTN
		LD R4, TOTPIX
		LD R1, BLACK
_CLRLP	STR R1, R5, #0 ;Write pixel to color
		ADD R5, R5, #1
		ADD R4, R4, #-1
		BRp _CLRLP
		
		;Draw grid
		BR DRAWH
WHITE	.FILL x7FFF
NUMPIX	.FILL #90
HOFST	.FILL #0
HCOORD	.FILL xCF00
		.FILL xDE00	
DRAWH	LD R0, WHITE
		LD R1, NUMPIX
		LD R2, HOFST
		LEA R3, HCOORD ;Get offset address
		ADD R3, R3, R2
		LDR R3, R3, #0
		
_HLOOP	STR R0, R3, #0
		ADD R3, R3, #1
		ADD R1, R1, #-1
		BRp _HLOOP
		
		ADD R2, R2, #-1
		BRz _HEXT
		ADD R2, R2, #2
		ST R2, HOFST
		BR DRAWH
_HEXT   ;Exit	
		
		BR DRAWV
VROW	.FILL #128
VOFST	.FILL #0
VCOORD	.FILL xC01E
		.FILL xC03C
DRAWV	LD R0, WHITE
		LD R1, NUMPIX
		LD R2, VOFST
		LEA R3, VCOORD ;Get offset address
		ADD R3, R3, R2
		LDR R3, R3, #0
		LD R4, VROW
		
_VLOOP	STR R0, R3, #0
		ADD R3, R3, R4
		ADD R1, R1, #-1
		BRp _VLOOP
		
		ADD R2, R2, #-1
		BRz _VEXT
		ADD R2, R2, #2
		ST R2, VOFST
		BR DRAWV
_VEXT   ;Exit
		
		;Get input
		BR INPUT
XPROMP	.STRINGZ "\nX move: "
YPROMP	.STRINGZ "\nO move: "	
XADR	.FILL xA000
YADR	.FILL xA200
YELLOW	.FILL x7FED
GREEN	.FILL x03E0
COUNT	.FILL #0
INPUT	LEA R0, XPROMP ;X turn
		PUTS
		
		JSR GETMOV
		ADD R1, R0, #-9
		BRz QUIT ;q condition
		ADD R1, R0, #1
		BRz INPUT ;Invalid input
		
		JSR CHKMOVE
		ADD R0, R0, #0
		BRn INPUT ;If invalid repeat X move
		
		JSR WRTMOVE
		LD R1, XADR
		LD R2, YELLOW
		JSR DRAWB
		
		LD R0, COUNT ;Check number of turns
		ADD R0, R0, #1
		ST R0, COUNT
		ADD R0, R0, #-9
		BRzp QUIT ;Total turns met
		
_YTURN	LEA R0, YPROMP ;O turn
		PUTS

		JSR GETMOV
		ADD R1, R0, #-9
		BRz QUIT ;q condition
		ADD R1, R0, #1
		BRz _YTURN ;Invalid input		
		
		JSR CHKMOVE
		ADD R0, R0, #0
		BRn _YTURN ;If invalid repeat Y turn
		
		JSR WRTMOVE
		LD R1, YADR
		LD R2, GREEN
		JSR DRAWB
		
		LD R0, COUNT ;Add 1 to number of turns
		ADD R0, R0, #1
		ST R0, COUNT
		BR INPUT ;Repeat turns
		BR INPUT
QUIT	HALT
		
NEG113	.FILL #-113
NEG57	.FILL #-57
NEG48	.FILL #-48	
NEG10	.FILL #-10
GMADDR	.BLKW #1
GETMOV	ST R7, GMADDR
		GETC ;Get first character
		OUT
		
		ADD R6, R0, #0 ;First character stored in R6
		
		LD R1, NEG113 ;Check q
		ADD R1, R1, R0
		BRnp _NC1
		
		AND R0, R0, #0 ;If q set R0 to 9
		ADD R0, R0, #9
		LD R7, GMADDR
		RET
		
_NC1	LD R1, NEG48 ;Lower bound numeric
		ADD R1, R1, R0
		BRzp _NC2
		
		AND R0, R0, #0 ;If not numeric set R0 to -1
		ADD R0, R0, #-1
		LD R7, GMADDR
		RET

_NC2	LD R1, NEG57 ;Upper bound numeric
		ADD R1, R1, R0
		BRnz _MOV2
		
		AND R0, R0, #0 ;If not numeric set R0 to -1
		ADD R0, R0, #-1
		LD R7, GMADDR
		RET
		
_MOV2	GETC ;Get second character
		OUT
		
		LD R1, NEG113 ;Check q
		ADD R1, R1, R0
		BRnp _ENTCHK
		
		AND R0, R0, #0 ;If q set R0 to 9
		ADD R0, R0, #9
		LD R7, GMADDR
		RET

_ENTCHK LD R1, NEG10 ;Check enter
		ADD R1, R1, R0
		BRz _MOVOUT
		
		AND R0, R0, #0 ;If not enter set R0 to -1
		ADD R0, R0, #-1
		LD R7, GMADDR
		RET
		
_MOVOUT	LD R1, NEG48 ;Subtract ASCII offset
		ADD R0, R6, R1
		LD R7, GMADDR
		RET

MOVE0	.FILL #0 ;Space 
		.FILL #0 ;1
		.FILL #0 ;2
		.FILL #0 ;3
		.FILL #0 ;4
		.FILL #0 ;5
		.FILL #0 ;6
		.FILL #0 ;7
		.FILL #0 ;8	
CHKMOVE	LEA R1, MOVE0 ;Check if space is filled
		ADD R1, R1, R0
		LDR R1, R1, #0
		BRz _CRET0
		AND R0, R0, #0 ;If filled return with -1
		ADD R0, R0, #-1
_CRET0	RET

ADDR0	.FILL xC285
		.FILL xC2A3
		.FILL xC2C1
		.FILL xD185
		.FILL xD1A3
		.FILL xD1C1
		.FILL xE085
		.FILL xE0A3
		.FILL xE0C1
WRTMOVE	LEA R1, MOVE0 ;Write 1 to space
		ADD R1, R1, R0
		STR R1, R1, #0
		
		LEA R1, ADDR0 ;Load in starting address
		ADD R1, R1, R0
		LDR R0, R1, #0
		RET
		
BNUMROW	.FILL #20
BNUMCOL	.FILL #20
BROWOFT	.FILL #108	
DRAWB	LD R3, BROWOFT ;R0: Starting Address, R1: Address of block data, R2: Color
		LD R4, BNUMCOL
_COLLP	LD R5, BNUMROW ;Column loop
_BRLP	LDR R6, R1, #0 ;Row loop
		BRz _BRINC	
		STR R2, R0, #0
		
_BRINC	ADD R0, R0, #1
		ADD R1, R1, #1
		ADD R5, R5, #-1
		BRp _BRLP
		
		ADD R0, R0, R3
		ADD R4, R4, #-1
		BRp _COLLP
		RET		
		
		.END