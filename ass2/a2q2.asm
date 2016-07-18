;
; a2q2.asm
;
;
; Turn the code you wrote in a2q1.asm into a subroutine
; and then use that subroutine with the delay subroutine
; to have the LEDs count up in binary.
;
;
; These definitions allow you to communicate with
; PORTB and PORTL using the LDS and STS instructions
;
.equ DDRB=0x24
.equ PORTB=0x25
.equ DDRL=0x10A
.equ PORTL=0x10B


; Your code here
; Be sure that your code is an infite loop
     ldi r16,0x00
	 mov r0,r16
start:   
 
	  call display
      inc r0
      call delay
      jmp start






done:		jmp done	; if you get here, you're doing it wrong

;
; display
; 
; display the value in r0 on the 6 bit LED strip
;
; registers used:
;	r0 - value to display
;


display:
		ldi r16, 0xFF
		sts DDRB, r16		; PORTB all output
		sts DDRL, r16		; PORTL all output


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
        ret
;
; delay
;
; set r20 before calling this function
; r20 = 0x40 is approximately 1 second delay
;
; registers used:
;	r20
;	r21
;	r22
;
delay:	
del1:	nop
		ldi r21,0xFF
del2:	nop
		ldi r22, 0xFF
del3:	nop
		dec r22
		brne del3
		dec r21
		brne del2
		dec r20
		brne del1	
		ret
