; Busyness vector: xC600

.orig x3000				; "Main" begins here
				; call MENU subroutine for option selection.
				; use return value to branch to appropriate subroutine call.				

BEGIN
	LD R1, MENU		
	JSRR	R1
   
	ADD	R6, R1, #-1
	BRz	One
	ADD	R6, R1, #-2
	BRz	Two
	ADD	R6, R1, #-3
	BRz	Three
	ADD	R6, R1, #-4
	BRz	Four
	ADD	R6, R1, #-5
	BRz	Five
	ADD	R6, R1, #-6
	BRz	Six
	ADD	R6, R1, #-7
	BRz	Seven

	LEA	R0,goodbye
	PUTS
	PUTS
	BR 	Seven

One
	LD	R0, ALL_MACHINES_BUSY
	JSRR	R0
	
  ADD	R2, R2, #0
	BRnp	ALL_BUSY
	LEA	R0, allnotbusy
	PUTS
	BR	BEGIN
ALL_BUSY
  LEA	R0, allbusy
	PUTS
	BR	BEGIN

Two
	LD	R0, ALL_MACHINES_FREE
	JSRR	R0
 
	ADD	R2, R2, #0 
	BRnp	MACHINES_ALL_FREE
	LEA	R0, allnotfree
	PUTS
	BR	BEGIN
MACHINES_ALL_FREE
	LEA	R0, allfree
	PUTS
	BR	BEGIN

Three	
	LD	R0, NUM_BUSY_MACHINES
	JSRR	R0
 
	LEA	R0, busymachine1
	PUTS	
	LD	R0, PRINT_NUMBER
	JSRR	R0
	LEA	R0, busymachine2
	PUTS
	BR	BEGIN

Four
	LD	R0, NUM_FREE_MACHINES
	JSRR	R0
 
	LEA	R0, freemachine1
	PUTS
	LD	R0, PRINT_NUMBER
	JSRR	R0
	LEA	R0, freemachine2
	PUTS
	BR	BEGIN
 
Five
	LD  R0, GET_MACHINE_NUM
	JSRR  R0
 
	LD	R0, MACHINE_STATUS		
	JSRR	R0
 
	LEA	R0, status1
	PUTS
	ST	R2, Status
	ADD	R2, R1, #0
	
  LD	R0, PRINT_NUMBER
	JSRR	R0
	
  LD	R2, Status
	BRp	MACHINE_FREE
	LEA	R0, status2
	PUTS
	BR	BEGIN
MACHINE_FREE
	LEA	R0, status3
	PUTS
	BR	BEGIN
 
Six
	LD	R0, FIRST_FREE
	JSRR	R0
 
	ADD	R0, R2, #-16
	BRz	NONE_FREE
	LEA	R0, firstfree1
	PUTS
	
  LD	R0, PRINT_NUMBER
	JSRR	R0
	BR	BEGIN

NONE_FREE
	LEA	R0, firstfree2
	PUTS
	BR	BEGIN

Seven
	LEA	R0, goodbye
	PUTS
	HALT
;---------------	
;Data 
;---------------
; subroutine addresses:
	MENU	.FILL	x3300
	ALL_MACHINES_BUSY	.FILL	x3600
	ALL_MACHINES_FREE	.FILL	x3900
	NUM_BUSY_MACHINES	.FILL	x4200
	NUM_FREE_MACHINES	.FILL	x4500
	MACHINE_STATUS	.FILL	x4800
	FIRST_FREE	.FILL	x5100
	GET_MACHINE_NUM		.FILL	x5400
	PRINT_NUMBER	.FILL	x5700
; Other data 
	toASCII		.FILL	#48
	Status  .FILL	xFFFF
; Strings for reports from menu subroutines:
goodbye         .stringz "Goodbye!\n"
allbusy         .stringz "All machines are busy\n"
allnotbusy      .stringz "Not all machines are busy\n"
allfree         .stringz "All machines are free\n"
allnotfree		.stringz "Not all machines are free\n"
busymachine1    .stringz "There are "
busymachine2    .stringz " busy machines\n"
freemachine1    .stringz "There are "
freemachine2    .stringz " free machines\n"
status1         .stringz "Machine "
status2		    .stringz " is busy\n"
status3		    .stringz " is free\n"
firstfree1      .stringz "The first available machine is number "
firstfree2      .stringz "No machines are free\n"
;line      .stringz "\n"


;-----------------------------------------------------------------------------------------------------------------
; Subroutine: MENU
; Inputs: None
; Postcondition: The subroutine has printed out a menu with numerical options, allowed the
;                  allowed the user to select an option, and returned the selected option.
; Return Value (R1): The option selected:  #1, #2, #3, #4, #5, #6 or #7 (may be character or number)
;                    no other return value is valid.
;-----------------------------------------------------------------------------------------------------------------
        .orig x3300
	ST	R7, BACKUP_R7_3300	
BEGIN_MENU
	LD	R0, menu_string_addr		
	PUTS
	
	GETC					
	OUT			
	ADD	R1, R0, #0
	LD R0, newline
	OUT
 
	ADD	R0, R1, #0
 
	LD	R2, DEC_55
	ADD	R1, R1, R2
	BRp	ERROR
 
  ADD	R1, R0, #0
  LD	R2, DEC_48		
	ADD	R1, R1, R2
	ADD	R1, R1, #-1			
	BRn	ERROR 
	ADD	R1, R0, #0
	ADD	R1, R1, R2
	BR	END_MENU
ERROR
	LEA	R0, error_msg_menu	
	PUTS
	BR	BEGIN_MENU
END_MENU
	LD	R7, BACKUP_R7_3300
	RET
;--------------------------------
;Data for subroutine MENU
;--------------------------------
error_msg_menu		.stringz "INVALID INPUT\n"
menu_string_addr	.fill x6000
BACKUP_R7_3300  .BLKW #1
DEC_48  .FILL	#-48
DEC_55  .FILL	#-55
newline  .FILL '\n'

;-----------------------------------------------------------------------------------------------------------------
; Subroutine: ALL_MACHINES_BUSY (#1)
; Inputs: None
; Postcondition: The subroutine has returned a value indicating whether all machines are busy
; Return value (R2): 1 if all machines are busy, 0 otherwise
;-----------------------------------------------------------------------------------------------------------------
         .orig x3600	

  ST R1, BACKUP_R1_3600
  ST R3, BACKUP_R3_3600
  ST R5, BACKUP_R5_3600 
  ST R7, BACKUP_R7_3600

	LDI	R1, busyness_addr_amb
	LD	R5, amb_16bit_counter	
	LD	R2, DEC_0

AMB_LOOP
	ADD	R1, R1, #0	
	BRn	AMB_END	
 
	ADD	R1, R1, R1
	ADD	R5, R5, #-1
	BRp	AMB_LOOP
	ADD	R2, R2, #1		

AMB_END


  LD R1, BACKUP_R1_3600
  LD R3, BACKUP_R3_3600
  LD R5, BACKUP_R5_3600 
	LD R7, BACKUP_R7_3600
	RET
;--------------------------------
;Data for subroutine ALL_MACHINES_BUSY
;--------------------------------
busyness_addr_amb	.fill xC600

BACKUP_R1_3600  .BLKW	#1
BACKUP_R3_3600  .BLKW	#1
BACKUP_R5_3600  .BLKW	#1 
BACKUP_R7_3600	.BLKW	#1
amb_16bit_counter	.FILL	#16
DEC_0  .FILL #0

;-----------------------------------------------------------------------------------------------------------------
; Subroutine: ALL_MACHINES_FREE (#2)
; Inputs: None
; Postcondition: The subroutine has returned a value indicating whether all machines are free
; Return value (R2): 1 if all machines are free, 0 otherwise
;-----------------------------------------------------------------------------------------------------------------

.orig x3900

	ST	R7, BACKUP_R7_3900
	
	LDI	R1, busyness_addr_amf 
	LD	R3, amf_16bit_counter
	LD R2, DECI_0
 
LOOP_AMF
	ADD	R1, R1, #0
	BRzp	END_AMF
	ADD	R1, R1, R1
	ADD	R3, R3, #-1
	BRp	LOOP_AMF
	ADD	R2, R2, #1	

END_AMF
	AND	R0, R0, #0
	AND	R1, R1, #0
	AND	R3, R3, #0
	AND	R6, R6, #0
	LD	R7, BACKUP_R7_3900
	RET
;--------------------------------
;Data for subroutine ALL_MACHINES_FREE
;--------------------------------
busyness_addr_amf	.fill xC600
BACKUP_R7_3900	.BLKW	#1
amf_16bit_counter	.FILL	#16
DECI_0  .FILL #0


;-----------------------------------------------------------------------------------------------------------------
; Subroutine: NUM_BUSY_MACHINES (#3)
; Inputs: None
; Postcondition: The subroutine has returned the number of busy machines.
; Return Value (R1): The number of machines that are busy (0)
;-----------------------------------------------------------------------------------------------------------------
.orig x4200
  ST R3, BACKUP_R3_4200
	ST R7, BACKUP_R7_4200
 
	LDI	R1, busyness_addr_nmb
	LD	R3, nmb_16bit_counter
	LD R2, DECIM_0 
 
LOOP_NMB
	ADD	R1, R1, #0
	BRn	CHECK
	ADD	R2, R2, #1	
 
CHECK
	ADD	R1, R1, R1
	ADD	R3, R3, #-1
	BRp	LOOP_NMB

  LD R3, BACKUP_R3_4200
	LD R7, BACKUP_R7_4200
RET
;--------------------------------
;Data for subroutine NUM_BUY_MACHINES
;--------------------------------
busyness_addr_nmb	.fill xC600
BACKUP_R3_4200  .BLKW #1
BACKUP_R7_4200	.BLKW #1
nmb_16bit_counter	.FILL #16
DECIM_0  .FILL #0

;-----------------------------------------------------------------------------------------------------------------
; Subroutine: NUM_FREE_MACHINES (#4)
; Inputs: None
; Postcondition: The subroutine has returned the number of free machines
; Return Value (R1): The number of machines that are free (1)
;-----------------------------------------------------------------------------------------------------------------
.orig x4500
  ST	R3, BACKUP_R3_4500
 	ST	R7, BACKUP_R7_4500
  
	LDI R1, busyness_addr_nmf
  LD	R3, nmf_16bit_counter
	LD R2, DECIMAL_0
 
LOOP_NMF
	ADD	R1,R1,#0
	BRzp	CHECKS
	ADD	R2, R2, #1

CHECKS
	ADD	R1, R1, R1
	ADD	R3, R3, #-1
	BRp	LOOP_NMF

NMF_END
  LD R3, BACKUP_R3_4500
	LD R7, BACKUP_R7_4500
RET

;--------------------------------
;Data for subroutine NUM FREE MACHINES
;--------------------------------
busyness_addr_nmf	.fill xC600
BACKUP_R3_4500  .BLKW #1
BACKUP_R7_4500  .BLKW #1
nmf_16bit_counter	.FILL	#16
DECIMAL_0  .FILL #0



;-----------------------------------------------------------------------------------------------------------------
; Subroutine: MACHINE_STATUS (#5)
; Input (R1): Which machine to check guaranteed in range {0,15}
; Postcondition: The subroutine has returned a value indicating whether the machine indicated
;                          by (R1) is busy or not.
; Return Value (R2): 0 if machine (R1) is busy, 1 if it is free
;              (R1) returned unchanged
;-----------------------------------------------------------------------------------------------------------------
.orig x4800

	RET
;--------------------------------
;Data for subroutine MACHINE_STATUS
;--------------------------------



;-----------------------------------------------------------------------------------------------------------------
; Subroutine: FIRST_FREE (#6)
; Inputs: None
; Postcondition: The subroutine has returned a value indicating the lowest numbered free machine
; Return Value (R2): the number of the free machine
;-----------------------------------------------------------------------------------------------------------------
.orig x5100

;--------------------------------
;Data for subroutine FIRST_FREE
;--------------------------------
busyness_addr_fmf	.fill xC600


;-----------------------------------------------------------------------------------------------------------------
; Subroutine: GET_MACHINE_NUM
; Inputs: None
; Postcondition: The number entered by the user at the keyboard has been converted into binary,
;                and stored in R1. The number has been validated to be in the range {0,15}
; Return Value (R1): The binary equivalent of the numeric keyboard entry
; NOTE: You can use your code from assignment 4 for this subroutine, changing the prompt, 
;       and with the addition of validation to restrict acceptable values to the range {0,15}
;-----------------------------------------------------------------------------------------------------------------

.orig x5400
	
;--------------------------------
;Data for subroutine Get input
;--------------------------------

;-----------------------------------------------------------------------------------------------------------------
; Subroutine: PRINT_NUM
; Inputs: R1, which is guaranteed to be in range {0,15}
; Postcondition: The subroutine has output the number in R1 as a decimal ascii string
; Return Value : R1 (unchanged from input)
;-----------------------------------------------------------------------------------------------------------------

.orig x5700

	ST	R7, BACKUP_R7_5700
	
  ADD	R5, R2, #0	
	ADD	R6, R2, #0 
  LD R2, DECIMA_0

TENTHSND
	LD	R1, DEC_10K
	ADD	R5, R1, R5
	BRzp	TENTHSND_COUNT
	LD	R0, DECI_48
	ADD	R0, R2, R0
	ADD	R2, R2, #0
	BRz	END_TENTHSND
	OUT

END_TENTHSND
	ADD	R5, R6, #0
	LD	R2, DECIMA_0
	BR	THSND

TENTHSND_COUNT
	ADD	R6, R5, #0
	ADD	R2, R2, #1
	BR	TENTHSND

THSND
	LD	R1, DEC_1K
	ADD	R5, R1, R5
	BRzp	THSND_COUNT
	LD	R0, DECI_48
	ADD	R0, R2, R0
	ADD	R2, R2, #0
	BRz	END_THSND
	OUT

END_THSND
	ADD	R5, R6, #0
	AND	R2, R2, #0
	BR	HUNDRED
THSND_COUNT
	ADD	R6, R5, #0
	ADD	R2, R2, #1
	BR	THSND

HUNDRED
	LD	R1, DEC_100
	ADD	R5, R1, R5
	BRzp	HUNDRED_COUNT
	LD	R0, DECI_48
	ADD	R0, R2, R0
	ADD	R2, R2, #0
	BRz	END_HUNDRED
	OUT

END_HUNDRED
	ADD	R5, R6, #0
	AND	R2, R2, #0
	BR	TEN

HUNDRED_COUNT
	ADD	R6, R5, #0
	ADD	R2, R2, #1
	BR	HUNDRED

TEN
	LD	R1, DEC_10
	ADD	R5, R1,R5
	BRzp	TEN_COUNT
	LD	R0, DECI_48
	ADD	R0, R2, R0
	ADD	R2, R2, #0
	BRz	END_TEN
	OUT
 
END_TEN
	ADD	R5, R6, #0
	AND	R2, R2, #0
	BR	ONE
TEN_COUNT
	ADD	R6, R5, #0
	ADD	R2, R2, #1
	BR	TEN

ONE
	LD	R1, DEC_1
	ADD	R5, R1, R5
	BRzp	ONE_COUNT
	LD	R0, DECI_48
	ADD	R0, R2, R0
	OUT
	ADD	R5, R6, #0
	AND	R2, R2, #0
	BR	END_ONE
ONE_COUNT
	ADD	R6, R5, #0
	ADD	R2, R2, #1
	BR	ONE

END_ONE
	LD	R7, BACKUP_R7_5700
	RET

;--------------------------------
;Data for subroutine print number
;--------------------------------
	DECI_48		.FILL	#48
	BACKUP_R7_5700  .BLKW #1
	DEC_10K	.FILL	#-10000
	DEC_1K  .FILL	#-1000
	DEC_100  .FILL	#-100
	DEC_10		.FILL	#-10
	DEC_1		.FILL	#-1
  DECIMA_0  .FILL #0
	



;=====================================================================================================================
        .ORIG x6000			; remote menu string
				.stringz "**********************\n* The Busyness Server *\n**********************\n1. Check to see whether all machines are busy\n2. Check to see whether all machines are free\n3. Report the number of busy machines\n4. Report the number of free machines\n5. Report the status of machine n\n6. Report the number of the first available machine\n7. Quit\n"

				.ORIG xC600			; Remote busyness vector
				.fill xABCD		; <----!!!VALUE FOR BUSYNESS VECTOR!!!

;---------------	
;END of PROGRAM
;---------------	
.END