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
.data

NUMBER:
	    .word 0xa0d1   ; Lowest 16-bit (Least Significant Word - LSW)
	    .word 0x6549   ; 2nd 16-bit
	    .word 0x1cf0   ; 3rd 16-bit
	    .word 0x2be5   ; Highest 16-bit (Most Significant Word - MSW)

.text


_start:
		    mov.w   &NUMBER, R4     ; Load NUMBER[0] (LSW) into R4
		    mov.w   &NUMBER+2, R5   ; Load NUMBER[1] into R5
		    mov.w   &NUMBER+4, R6   ; Load NUMBER[2] into R6
		    mov.w   &NUMBER+6, R7   ; Load NUMBER[3] (MSW) into R7

		    ; -----------------------
		    ; 64-bit Left Shift (Rotate Left through Carry)
		    ; -----------------------

		    rlc.w   R4          ; Rotate left R4 (lowest 16-bit), MSB goes to Carry
		    rlc.w   R5          ; Rotate left R5, previous Carry affects LSB
		    rlc.w   R6          ; Rotate left R6, previous Carry affects LSB
		    rlc.w   R7          ; Rotate left R7 (highest 16-bit), previous Carry affects LSB

		    ; -----------------------
		    ; Store the updated value back into memory
		    ; -----------------------
		    mov.w   R4, &NUMBER
		    mov.w   R5, &NUMBER+2
		    mov.w   R6, &NUMBER+4
		    mov.w   R7, &NUMBER+6

		    ; Infinite loop (to prevent program termination)

			jmp $

                                            

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
            
