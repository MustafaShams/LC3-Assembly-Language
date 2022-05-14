
.ORIG x3000			; Program begins here
;-------------
;Instructions
;-------------
LD R6, Value_addr		; R6 <-- pointer to value to be displayed as binary
LDR R1, R6, #0			; R1 <-- value to be displayed as binary 
;-------------------------------
;INSERT CODE STARTING FROM HERE
;--------------------------------

ADD R2, R2, #15			;set R2 Counter value to 16
ADD R2, R2, #1			
ADD R3, R3, #4			;set R3 value counter to 4

START	
	ADD R3, R3, #0		;check to see if R3 is positive
	BRp NUMBER		;if R3 is, jump ahead to NUMBER and skip putting a space
		
	LEA R0, Space		;print out a space
	PUTS
	ADD R3, R3, #4		;reinitialize R3 value to 4

	NUMBER
	ADD R3, R3, #-1		;decrement R3 counter by 1	
	
	ADD R1, R1, #0		;Check to see if R1 current value is positive
	BRzp POSITIVE		;jump to POSITIVE if it is
	LEA R0, One		;load "1" string in R0
	PUTS			;print R0 out
	BR SKIP			;jump ahead to SKIP
			
	POSITIVE
	LEA R0, Zero		;if positive, load "0" to R0
	PUTS			;print R0 out
							
	SKIP
	ADD R2, R2, #0		;check value amount in R2 counter
	BRz END			;jump to end of loop if R2 is zero
	ADD R1, R1, R1		;shift R1 to the left (R1 <- R1 * 2)

	ADD R2, R2, #-1		;decrement R2 by 1
	BRp START		;jump back to start of loop

END
	LEA R0, Newline		;load "\n" to R0 and print it at the very end
	PUTS			


HALT
;---------------	
;Data
;---------------
Value_addr	.FILL xAA00	; The address where value to be displayed is stored


One .STRINGZ "1"
Space .STRINGZ " "
Newline .STRINGZ "\n"
Zero .STRINGZ "0"

.ORIG xAA00					; Remote data
Value .FILL xABCD				; <----!!!NUMBER TO BE DISPLAYED AS BINARY!!! Note: label is redundant.
;---------------	
;END of PROGRAM
;---------------	
.END

