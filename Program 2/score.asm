; Nick Broza ECE-109 
; LC-3 program to convert input characters into
; 7 segment display output

	
	.ORIG x3000	
START	AND R0, R0, #0
		AND R1, R1, #0 
		AND R2, R2, #0
		AND R3, R3, #0
		AND R4, R4, #0
		AND R5, R5, #0
		AND R6, R6, #0
		AND R7, R7, #0
		
		ST R0, OFST ;Reset offset
		
		JSR INPUT ;Get character 1
		LD R5, POS25
		ADD R6, R6, R5 ;Add 25 to offset
		ST R6, OFST

		JSR INPUT ;Get character 2
		LD R5, POS25
		ADD R6, R6, R5 ;Add 25 to offset
		ST R6, OFST

		JSR INPUT ;Get character 3	
		LD R5, POS25
		ADD R6, R6, R5 ;Add 25 to offset
		ST R6, OFST

		JSR INPUT ;Get character 4	
		LD R5, POS25
		ADD R6, R6, R5 ;Add 25 to offset
		ST R6, OFST
		
		BR START

CLEARSCR
		ST R7, CLRRET ;Store return address
		LD R5, STARTN
		LD R4, TOTPIX
		LD R1, BLACK
CLRLOOP	STR R1, R5, #0 ;Write pixel to color
		ADD R5, R5, #1
		ADD R4, R4, #-1
		BRp CLRLOOP
		LD R7, CLRRET
		RET
		

QUIT
		LEA R0, EPROMPT ;Print ending prompt
		PUTS
		HALT

ENT
		BR START ;Go back to start

NUMCHK	.FILL #0
BLACK	.FILL x0000
TOTPIX	.FILL #15620
STARTN	.FILL xC000
NEG123	.FILL #-123
NEG127	.FILL #-127		
NUMUSED	.FILL #0
NEG10	.FILL #-10	
SPROMPT	.STRINGZ "\nEnter a number (0-9) or a character (a-f): "
EPROMPT	.STRINGZ "\nThank you for playing - Go Wolfpack!"
NEG113	.FILL #-113
RETCHK	.BLKW #1
POS25	.FILL #25
CLRRET	.BLKW #1
NEG48	.FILL #-48
NEG49	.FILL #-49
NEG50	.FILL #-50
NEG51	.FILL #-51
		
INPUT
		ST R7, RETCHK ;Store return address
		LEA R0, SPROMPT
		PUTS
		
INCHAR	GETC
		OUT
		
		LD R1, OFST 
		BRz TEST1 ;Check if this is first character, if it is clear previous characters
		BRp TEST2 ;If this isnt first character, skip over clear

TEST1	JSR CLEARSCR
		
TEST2	AND R1, R0, #0
		ADD R1, R1, #0
		
		LD R1, NEG113 ;Check for q
		ADD R1, R0, R1
		BRz QUIT
		
		LD R1, NEG10 ;Check for enter
		ADD R1, R0, R1
		BRz ENT
		
C0
		LD R3, NEG48
		ADD R2, R0, R3 ;0
		BRnp C1 ;If the entered character isnt 0, check next character
		JSR SEGA ;If entered character is 0, turn on corresponding segments
		JSR SEGB
		JSR SEGC
		JSR SEGD
		JSR SEGE
		JSR SEGF
		LD R7, RETCHK
		RET
		
C1		LD R3, NEG49
		ADD R2, R0, R3 ;1
		BRnp C2
		JSR SEGB
		JSR SEGC
		LD R7, RETCHK
		RET
		
C2		LD R3, NEG50
		ADD R2, R0, R3 ;2
		BRnp C3
		JSR SEGA
		JSR SEGB
		JSR SEGD
		JSR SEGE
		JSR SEGG
		LD R7, RETCHK
		RET
		
C3		LD R3, NEG51
		ADD R2, R0, R3 ;3
		BRnp C4
		JSR SEGA
		JSR SEGB
		JSR SEGC
		JSR SEGD
		JSR SEGG
		LD R7, RETCHK
		RET
		
C4		LD R3, NEG52
		ADD R2, R0, R3 ;4
		BRnp C5
		JSR SEGB
		JSR SEGC
		JSR SEGF
		JSR SEGG
		LD R7, RETCHK
		RET
	
	
C5		LD R3, NEG53		
		ADD R2, R0, R3 ;5
		BRnp C6
		JSR SEGA
		JSR SEGC
		JSR SEGD
		JSR SEGF
		JSR SEGG
		LD R7, RETCHK
		RET
		
C6		LD R3, NEG54
		ADD R2, R0, R3 ;6
		BRnp C7
		JSR SEGA
		JSR SEGC
		JSR SEGD
		JSR SEGE
		JSR SEGF
		JSR SEGG
		LD R7, RETCHK
		RET
		
C7		LD R3, NEG55
		ADD R2, R0, R3 ;7
		BRnp C8
		JSR SEGA
		JSR SEGB
		JSR SEGC
		LD R7, RETCHK
		RET

NEG52	.FILL #-52
		
C8		LD R3, NEG56
		ADD R2, R0, R3 ;8
		BRnp C9
		JSR SEGA
		JSR SEGB
		JSR SEGC
		JSR SEGD
		JSR SEGE
		JSR SEGF
		JSR SEGG
		LD R7, RETCHK
		RET
		
C9		LD R3, NEG57
		ADD R2, R0, R3 ;9
		BRnp Ca
		JSR SEGA
		JSR SEGB
		JSR SEGC
		JSR SEGD
		JSR SEGF
		JSR SEGG
		LD R7, RETCHK
		RET

OFST	.FILL #0
NEG53	.FILL #-53
NEG54	.FILL #-54
NEG55	.FILL #-55
NEG56	.FILL #-56
NEG57	.FILL #-57
		
Ca		LD R3, NEG97
		ADD R2, R0, R3 ;a
		BRnp Cb
		JSR SEGA
		JSR SEGB
		JSR SEGC
		JSR SEGE
		JSR SEGF
		JSR SEGG
		LD R7, RETCHK
		RET
		
Cb		LD R3, NEG98
		ADD R2, R0, R3 ;b
		BRnp Cc
		JSR SEGC
		JSR SEGD
		JSR SEGE
		JSR SEGF
		JSR SEGG
		LD R7, RETCHK
		RET
		
Cc		LD R3, NEG99
		ADD R2, R0, R3 ;c
		BRnp Cd
		JSR SEGA
		JSR SEGD
		JSR SEGE
		JSR SEGF
		LD R7, RETCHK
		RET
		
Cd		LD R3, NEG100
		ADD R2, R0, R3 ;d
		BRnp Ce
		JSR SEGB
		JSR SEGC
		JSR SEGD
		JSR SEGE
		JSR SEGG
		LD R7, RETCHK
		RET
		
Ce		LD R3, NEG101
		ADD R2, R0, R3 ;e
		BRnp Cf
		JSR SEGA
		JSR SEGD
		JSR SEGE
		JSR SEGF
		JSR SEGG
		LD R7, RETCHK
		RET
		
Cf		LD R3, NEG102
		ADD R2, R0, R3 ;f
		BRnp INCHAR
		JSR SEGA
		JSR SEGE
		JSR SEGF
		JSR SEGG
		LD R7, RETCHK
		RET
		
		
SEGA	ST R7, CHARRET ;Save return register
		LD R0, RED
		LD R1, CURA ;Load start pixel address	
		LD R3, PIX ;Load number of pixels
		LD R5, ROW ;Load width of screen
		LD R6, OFST ;Load in offset
		ADD R1, R1, R6 ;Add offset to start pixel
		ADD R4, R4, #-5 ;rows
SEGAS  	ADD R2, R2, #-10 ;columns
SEGA1	STR R0, R1, #0
		ADD R1, R1, #1
		ADD R2, R2, #1
		BRn SEGA1 
		BRz SEGA2 
SEGA2	ADD R4, R4, #1
		BRz AHOM 
		ADD R1, R1, R5
		ADD R1, R1, #-10
		STR R0, R1, #0
		ADD R3, R3, #-1
		BR SEGAS
AHOM	LD R7, CHARRET
		RET

SEGB	ST R7, BHOM
		LD R0, RED
		LD R1, CURB
		LD R3, PIX
		LD R5, ROW
		LD R6, OFST
		ADD R1, R1, R6
		ADD R4, R4, #-15 ;rows
SEGBS	ADD R2, R2, #-4 ;columns
SEGB1	STR R0, R1, #0
		ADD R1, R1, #1
		ADD R2, R2, #1
		BRn SEGB1
		BRz SEGB2
SEGB2	ADD R4, R4, #1
		BRz BHOM
		ADD R1, R1, R5
		ADD R1, R1, #-4 ;columns
		STR R0, R1, #0
		ADD R3, R3, #-1
		BR SEGBS
BHOM	LD R7, CHARRET
		RET

SEGC	ST R7, CHARRET
		LD R0, RED
		LD R1, CURC
		LD R3, PIX
		LD R5, ROW
		LD R6, OFST
		ADD R1, R1, R6
		ADD R4, R4, #-15 ;rows
SEGCS	ADD R2, R2, #-4 ;columns
SEGC1	STR R0, R1, #0
		ADD R1, R1, #1
		ADD R2, R2, #1
		BRn SEGC1
		BRz SEGC2
SEGC2	ADD R4, R4, #1
		BRz CHOM
		ADD R1, R1, R5
		ADD R1, R1, #-4 ;columns
		STR R0, R1, #0
		ADD R3, R3, #-1
		BR SEGCS
CHOM	LD R7, CHARRET
		RET

SEGD	ST R7, CHARRET
		LD R0, RED
		LD R1, CURD
		LD R3, PIX
		LD R5, ROW
		LD R6, OFST
		ADD R1, R1, R6
		ADD R4, R4, #-5 ;rows
SEGDS	ADD R2, R2, #-10 ;columns
SEGD1	STR R0, R1, #0
		ADD R1, R1, #1
		ADD R2, R2, #1
		BRn SEGD1
		BRz SEGD2
SEGD2	ADD R4, R4, #1
		BRz DHOM
		ADD R1, R1, R5
		ADD R1, R1, #-10 ;columns
		STR R0, R1, #0
		ADD R3, R3, #-1
		BR SEGDS
DHOM	LD R7, CHARRET
		RET
		
SEGE	ST R7, CHARRET
		LD R0, RED
		LD R1, CURE
		LD R3, PIX
		LD R5, ROW
		LD R6, OFST
		ADD R1, R1, R6
		ADD R4, R4, #-15 ;rows
SEGES	ADD R2, R2, #-4 ;columns
SEGE1	STR R0, R1, #0
		ADD R1, R1, #1
		ADD R2, R2, #1
		BRn SEGE1
		BRz SEGE2
SEGE2	ADD R4, R4, #1
		BRz EHOM
		ADD R1, R1, R5
		ADD R1, R1, #-4 ;columns
		STR R0, R1, #0
		ADD R3, R3, #-1
		BR SEGES
EHOM	LD R7, CHARRET
		RET		

SEGF	ST R7, CHARRET
		LD R0, RED
		LD R1, CURF
		LD R3, PIX
		LD R5, ROW
		LD R6, OFST
		ADD R1, R1, R6
		ADD R4, R4, #-15 ;rows
SEGFS	ADD R2, R2, #-4 ;columns
SEGF1	STR R0, R1, #0
		ADD R1, R1, #1
		ADD R2, R2, #1
		BRn SEGF1
		BRz SEGF2
SEGF2	ADD R4, R4, #1
		BRz FHOM
		ADD R1, R1, R5
		ADD R1, R1, #-4 ;columns
		STR R0, R1, #0
		ADD R3, R3, #-1
		BR SEGFS	
FHOM	LD R7, CHARRET
		RET		

SEGG	ST R7, CHARRET
		LD R0, RED
		LD R1, CURG
		LD R3, PIX
		LD R5, ROW
		LD R6, OFST
		ADD R1, R1, R6
		ADD R4, R4, #-5 ;rows
SEGGS	ADD R2, R2, #-10 ;columns
SEGG1	STR R0, R1, #0
		ADD R1, R1, #1
		ADD R2, R2, #1
		BRn SEGG1
		BRz SEGG2
SEGG2	ADD R4, R4, #1
		BRz GHOM
		ADD R1, R1, R5
		ADD R1, R1, #-10 ;columns
		STR R0, R1, #0
		ADD R3, R3, #-1
		BR SEGGS
GHOM	LD R7, CHARRET
		RET
				
RED		.FILL x7C00
PIX		.FILL #50
CURA	.FILL xD515
CURB	.FILL xD61E
CURC	.FILL xDE1E
CURD	.FILL xE415
CURE	.FILL xDE12
CURF	.FILL xD612
CURG	.FILL xDC95
ROW		.FILL #128
CHARRET	.BLKW #1

NEG97	.FILL #-97
NEG98	.FILL #-98
NEG99	.FILL #-99
NEG100	.FILL #-100
NEG101	.FILL #-101
NEG102	.FILL #-102

SUBRET	.BLKW #1
NEG58	.FILL #-58
COFST	.FILL #-1
		.END