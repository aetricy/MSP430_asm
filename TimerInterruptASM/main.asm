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

			clr.b   &PM5CTL0                 ; Unlock GPIOs (for MSP430FRxx series)

            ; Configure Clock System
            mov.w #CSKEY , &CSCTL0           ; Unlock clock registers
            mov.w #DCOFSEL_0, &CSCTL1        ; Set DCO to lowest frequency
            mov.w #SELS__DCOCLK ,&CSCTL2     ; Select DCO as SMCLK source
            mov.w #DIVS__8 , &CSCTL3         ; Divide SMCLK by 8

            ; Configure Timer_A
            mov.w #TASSEL__SMCLK | ID__1 | MC__UP | TACLR, &TA0CTL
            	  ; Select SMCLK, divide by 2, up mode, clear timer
            mov.w #CCIE , &TA0CCTL0         ; Enable Timer_A interrupt for CCR0
            mov.w #62499 ,&TA0CCR0          ; Set CCR0 value (for timing interval)



			bis   #BIT0 , P1DIR             ; Set P1.0 as output (LED)
			nop
            bis   #GIE, SR                  ; Enable global interrupts
			nop


			; Infinite loop (CPU remains here, ISR handles the work)
            jmp $
			nop



TIMERA0_VECTOR:
		xor.b  #BIT0 , &P1OUT		; Toggle P1.0 (LED)
		bic    #TAIFG, &TA0CTL		; Clear interrupt flag
		reti						; Return from interrupt

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
            
            .sect  TIMER0_A0_VECTOR			; Timer_A0 Interrupt Vector	 (".int45")
            .short TIMERA0_VECTOR
