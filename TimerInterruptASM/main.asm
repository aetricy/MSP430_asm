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
;-------------------------------------------------------------------------------

			clr.b   &PM5CTL0

			mov.w #CSKEY , &CSCTL0
			mov.w #DCOFSEL_0, &CSCTL1
			mov.w #SELS__DCOCLK ,&CSCTL2
			mov.w #DIVS__8 , &CSCTL3

			mov.w #TASSEL__SMCLK | ID__1 | MC__UP | TACLR, &TA0CTL


			mov.w #CCIE , &TA0CCTL0
			mov.w #62499 ,&TA0CCR0

			bis   #BIT0 , P1DIR
			nop
			bis   #GIE, SR
			nop

            jmp $
			nop


TIMERA0_VECTOR:
		xor.b #BIT0 , &P1OUT
		bic    #TAIFG, &TA0CTL
		reti

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
            
            .sect  TIMER0_A0_VECTOR
            .short TIMERA0_VECTOR
