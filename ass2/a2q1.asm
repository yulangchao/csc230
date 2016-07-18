;
; a2q1.asm
;
; Write a program that displays the binary value in r16
; on the LEDs.
;
; See the assignment PDF for details on the pin numbers and ports.
;
;
;
; These definitions allow you to communicate with
; PORTB and PORTL using the LDS and STS instructions
;
.equ DDRB=0x24
.equ PORTB=0x25
.equ DDRL=0x10A
.equ PORTL=0x10B



		ldi r16, 0xFF
		sts DDRB, r16		; PORTB all output
		sts DDRL, r16		; PORTL all output

		ldi r16, 0x33		; display the value
		mov r0, r16			; in r0 on the LEDs

; Your code here
        ldi r18,0x00
		ldi r19,0x00
        mov r17,r0
		ANDI r17, 0b00100000
		BReq loop
		ori r18, 0b00000010
loop:
        mov r17,r0
		andi r17,0b00010000
		breq loop1
		ori r18,0b00001000
loop1:
		mov r17,r0
		andi r17,0b00001000
		breq loop2
		ori r19,0b00000010
loop2:
	    mov r17,r0
		andi r17,0b00000100
		breq loop3
		ori r19,0b00001000
loop3:
    	mov r17,r0
		andi r17,0b00000010
		breq loop4
		ori r19,0b00100000
loop4:
     	mov r17,r0
		andi r17,0b00000001
		breq loop5
		ori r19,0b10000000
loop5:
        sts PORTB, r18
		sts PortL, r19
	
        

        


;
; Don't change anything below here
;
done:	jmp done
