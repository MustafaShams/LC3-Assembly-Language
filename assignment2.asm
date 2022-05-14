
.ORIG x3000			; Program begins here
;-------------
;Instructions
;-------------
;----------------------------------------------
;output prompt
;----------------------------------------------	
LEA R0, intro			; get starting address of prompt string
PUTS			    	; Invokes BIOS routine to output string

;-------------------------------
;INSERT YOUR CODE here
;--------------------------------
LEA R0, newline

GETC			;take input from keyboard and print it out
OUT
ADD R1, R0, #0		;store input in R1 then output newline
LD R0, newline
OUT


GETC			;take input from keyboard and print it out
OUT
ADD R2, R0, #0		;store input in R2 then output newline
LD R0, newline
OUT


ADD R0, R1, #0		;output the two numbers in the required format
OUT			;with a minus and equal sign
LEA R0, minussign
PUTS
ADD R0, R2, #0
OUT
LEA R0, equalsign
PUTS


ADD R3, R2, #0		;Turn R2 negative 2's complement and store in R3
NOT R3, R3
ADD R3, R3, 1

ADD R4, R1, R3		;Add R1 and R3 and store it in R4	
BRz ZERO		;check if the sum was zero
BRp POSITIVE		;check if the sum was positive


NOT R4, R4		;IF NEGATIVE
ADD R4, R4, 1		;turn R4 back from 2s complement negative to positive
LEA R0, negativesign	;print out negative sign
PUTS

ZERO			;IF ZERO
POSITIVE		;IF POSITIVE 
ADD R4, R4, #15		;add 15 three times and then 3 to add 48 to R4
ADD R4, R4, #15		;this converts from ascii to numeric value
ADD R4, R4, #15		
ADD R4, R4, #3

ADD R0, R4, #0		;put R4 value into R0 and print out followed by newline
OUT		
LD R0, newline
OUT

HALT				; Stop execution of program
;------	
;Data
;------
; String to prompt user. Note: already includes terminating newline!
intro 	.STRINGZ	"ENTER two numbers (i.e '0'....'9')\n" 		; prompt string - use with LEA, followed by PUTS.
newline .FILL '\n'	; newline character - use with LD followed by OUT

equalsign .STRINGZ " = "
minussign .STRINGZ " - "
negativesign .STRINGZ "-"

;---------------	
;END of PROGRAM
;---------------	
.END

