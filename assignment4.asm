.ORIG x3000		
;-------------
;Instructions
;-------------

; output intro prompt
						
; Set up flags, counters, accumulators as needed

; Get first character, test for '\n', '+', '-', digit, or a non-digit 	
					
					; is very first character = '\n'? if so, just quit (no message)!

					; is it = '+'? if so, ignore it, go get digits

					; is it = '-'? if so, set neg flag, go get digits
					
					; is it < '0'? if so, it is invalid	- o/p error message, start over

					; is it > '9'? if so, it is invalid	- o/p error message, start over
				
					; if none of the above, first character is first numeric digit!
					; Go get remaining digits

					; remember to end with a newline!
; Now get (remaining) digits (max 5) from user and build up number in accumulator

INTRO
	LD R0, introPromptPtr	;Prompts for message
	PUTS			
	GETC			;gets first character (+, -, or num)
	OUT
	ADD R2, R0, #-10	;check if first input was ENTER
	BRz ERROR		;if input, output error
	LD R7, DEC_INPUT_3200	;else, load subroutine
	JSRR R7 
	ADD R0, R0, #0		;check if subroutine was successful (0 = true, 1 = false)
	BRz SUCCESS

ERROR				;if error, output error msg and restart
	LD R0, NEWL
	OUT				
 	LD R0, errorMessagePtr
	PUTS
	BR INTRO				

SUCCESS
	LD R0, NEWL
	OUT
	LD R0, NEWL
	OUT
HALT

;---------------	
; Program Data
;---------------

DEC_INPUT_3200		.FILL x3200
introPromptPtr		.FILL x4000
errorMessagePtr		.FILL x4100
NEWL			.FILL '\n'

;=======================================================================
; Subroutine: INPUT_DEC_3200
; Parameter: R0
; Postcondition: Converts DEC to 2's complement binary 
; Return Value: returns binary value to R5
;=======================================================================

.ORIG x3200
ST R1, BACKUP_R1_3200
ST R2, BACKUP_R2_3200
ST R4, BACKUP_R4_3200
ST R5, BACKUP_R5_3200
ST R6, BACKUP_R6_3200
ST R7, BACKUP_R7_3200

LD R1, DEC_5	;counter set to 5
LD R2, DEC_10	;counter set to 10

SIGN
	LD R5, PLUSSIGN	
	ADD R4, R0, R5		;check if ascii char entered was '+'
	BRz PREFIRSTNUM		;if so, go to PREFIRSTNUM
	ADD R4, R0, #0		;else, restore value of R4 to R0
	LD R5, MINUSSIGN	
	ADD R4, R4, R5		;check if ascii char entered was '-'
	BRnp FIRSTNUM		;if not (R0 is not '+' or '-'), go to FIRSTNUM
	LD R6, DEC_N1		;if so (R0 = '-'), mark R6 to convert end result to negative 
	BR PREFIRSTNUM		;go to PREFIRSTNUM

PREFIRSTNUM
	GETC
	OUT
	LD R5, DEC_N10
	ADD R4, R0, R5
	BRz ENDCHECK

FIRSTNUM
	LD R5, NUMCHECK1	
	ADD R4, R0, R5		;check if R0 is greater than '9' making it not a number
	BRp ERROR2		;if so, output error msg
	LD R5, NUMCHECK2	
	ADD R4, R0, R5		;else, check if R0 is less than '0' making it not a number
	BRn ERROR2		;if so, output error msg
	ADD R3, R4, #0		;store value of R0 into R5
	ADD R1, R1, #-1		;increment counter R1

OTHERNUMS
	GETC
	OUT
	LD R5, DEC_N10
	ADD R4, R0, R5
	BRz ENDCHECK
	LD R5, NUMCHECK1	
	ADD R4, R0, R5		;check if R0 is greater than '9' making it not a number
	BRp ERROR2		;if so, output error msg
	LD R5, NUMCHECK2	
	ADD R4, R0, R5		;else, check if R0 is less than '0' making it not a number
	BRn ERROR2		;if so, output error msg
	
	ADD R5, R3, #0			;set value of R5 to R3
	ADD R2, R2, #-1			;decrement counter R2
	LOOP
		ADD R3, R3, R5		; R3 <- R3 + R5
		ADD R2, R2, #-1 	;decrement counter R2	 
		BRp LOOP		;Loops 10 times
	LD R2, DEC_10			;regenerate R2 counter
	
	
	ADD R3, R3, R4		
	ADD R1, R1, #-1		;decrement counter R1
	BRp OTHERNUMS		;Loop 5 times
	
	ENDCHECK		
	LD R0, DEC_0		;load #0 into R0 to indicate no errors occured in subroutine
	ADD R6, R6, #0		;checks if the first input was a '-' ascii character
	BRn CONVERTNEG		;if so, convert R3 into 2's complement negative
	BR END			;else, end the subroutine

CONVERTNEG
	NOT R3, R3
	ADD R3, R3, #1
	BR END			;end subroutine

ERROR2
	AND R3, R3, #0		;set R5 back to 0
	LD R0, DEC_N1		;set R0 to #-1 to indicate an error occured in the subroutine

END	

LD R1, BACKUP_R1_3200
LD R2, BACKUP_R2_3200
LD R4, BACKUP_R4_3200
LD R5, BACKUP_R5_3200
LD R6, BACKUP_R6_3200
LD R7, BACKUP_R7_3200

RET

;========================
; Subroutine Data
;========================
BACKUP_R1_3200	.BLKW #1
BACKUP_R2_3200	.BLKW #1
BACKUP_R4_3200	.BLKW #1
BACKUP_R5_3200	.BLKW #1
BACKUP_R6_3200	.BLKW #1
BACKUP_R7_3200	.BLKW #1
DEC_10		.FILL #10
DEC_5		.FILL #5
DEC_0		.FILL #0
DEC_N1		.FILL #-1
DEC_N10		.FILL #-10
PLUSSIGN	.FILL #-43
MINUSSIGN	.FILL #-45
NUMCHECK1	.FILL #-57
NUMCHECK2	.FILL #-48
NEWLINE		.FILL '\n'
;------------
; Remote data
;------------
					.ORIG x4000			; intro prompt
					.STRINGZ	"Input a positive or negative decimal number (max 5 digits), followed by ENTER\n"
					
					
					.ORIG x4100			; error message
					.STRINGZ	"ERROR: invalid input\n"


;---------------
; END of PROGRAM
;---------------
					.END

;-------------------
; PURPOSE of PROGRAM
;-------------------
; Convert a sequence of up to 5 user-entered ascii numeric digits into a 16-bit two's complement binary representation of the number.
; if the input sequence is less than 5 digits, it will be terminated with a newline (ENTER).
; Input validation is performed on the individual characters as they are input, but not on the magnitude of the number


