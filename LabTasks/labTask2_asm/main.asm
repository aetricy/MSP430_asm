;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file
            
;-------------------------------------------------------------------------------
            .def    RESET                   ; Export program entry-point to
                                            ; make it known to linker.
;-------------------------------------------------------------------------------
            .text                           ; Assemble into program memory.
            .retain                         ; Override ELF conditional linking
                                            ; and retain current section.
            .retainrefs                     ; And retain any sections that have
                                            ; references to current section.

;-------------------------------------------------------------------------------
RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer


;-------------------------------------------------------------------------------
; Main loop here
;-------------------------------------------------------------------------------,


		mov.w #18,r5 	;YEAR
		mov.w #5,r6		;MONTH
		mov.w #5,r7 	;DAY

		; Rotate Left 9 Times
		rlc.w r5
		rlc.w r5
		rlc.w r5
		rlc.w r5
		rlc.w r5
		rlc.w r5
		rlc.w r5
		rlc.w r5
		rlc.w r5

		; Rotate Left 5 Times
		rlc.w r6
		rlc.w r6
		rlc.w r6
		rlc.w r6
		rlc.w r6

		; R7 = R5 or R6 or R7
		bis.w r5,r6
		bis.w r6,r7

		mov.w r7,r9

		;Infinity Loop
		jmp $
		nop

;-------------------------------------------------------------------------------
; Stack Pointer definition
;-------------------------------------------------------------------------------
            .global __STACK_END
            .sect   .stack
            
;-------------------------------------------------------------------------------
; Interrupt Vectors
;-------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET
            
