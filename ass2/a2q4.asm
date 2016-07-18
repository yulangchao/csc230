;
; a2q4.asm
;
; Fix the button subroutine program so that it returns
; a different value for each button
;

;
; Definitions for PORTA and PORTL when using
; STS and LDS instructions (ie. memory mapped I/O)
;
.equ DDRB=0x24
.equ PORTB=0x25
.equ DDRL=0x10A
.equ PORTL=0x10B

;
; Definitions for using the Analog to Digital Conversion
.equ ADCSRA=0x7A
.equ ADMUX=0x7C
.equ ADCL=0x78
.equ ADCH=0x79


		; initialize the Analog to Digital conversion

		ldi r16, 0x87
		sts ADCSRA, r16
		ldi r16, 0x40
		sts ADMUX, r16

		; initialize PORTB and PORTL for ouput
		ldi	r16, 0xFF
		sts DDRB,r16
		sts DDRL,r16


		clr r0
		call display
lp:
		call check_button
		tst r24
		breq lp
		mov	r0, r24

		call display
		ldi r20, 99
		call delay
		ldi r20, 0
		mov r0, r20
		call display
		rjmp lp

;
; An improved version of the button test subroutine
;
; Returns in r24:
;	0 - no button pressed
;	1 - right button pressed
;	2 - up button pressed
;	4 - down button pressed
;	8 - left button pressed
;	16- select button pressed
;
; this function uses registers:
;	r24
;
; if you consider the word:
;	 value = (ADCH << 8) +  ADCL
; then:
;
; value > 0x3E8 - no button pressed
;
; Otherwise:
; value < 0x032 - right button pressed
; value < 0x0C3 - up button pressed
; value < 0x17C - down button pressed
; value < 0x22B - left button pressed
; value < 0x316 - select button pressed
; 
check_button:
		; start a2d
		lds	r16, ADCSRA	
		ori r16, 0x40
		sts	ADCSRA, r16

		; wait for it to complete
wait:		lds r16, ADCSRA
		andi r16, 0x40
		brne wait

		; read the value
		lds r16, ADCL
		lds r17, ADCH

		; put your new logic here:
		clr r24
        cpi r17,3
        brsh skip
		cpi r17,2
		brsh select
        cpi r17,1
		breq abc
		cpi r16,0x32
		brsh up
		ldi r24,1
		jmp skip


abc:   cpi r16,0x7C   ;check r16
        brsh left
		jmp down

select: ldi r24,16
        jmp skip
left:   ldi r24,8
        jmp skip
down:   ldi r24,4
        jmp skip
up:     ldi r24,2
        jmp skip
skip:
		ret

;
; delay
;
; set r20 before calling this function
; r20 = 0x40 is approximately 1 second delay
;
; this function uses registers:
;
;	r20
;	r21
;	r22
;
delay:	
del1:		nop
		ldi r21,0xFF
del2:		nop
		ldi r22, 0xFF
del3:		nop
		dec r22
		brne del3
		dec r21
		brne del2
		dec r20
		brne del1	
		ret

;
; display
; 
; display the value in r0 on the 6 bit LED strip
;
; registers used:
;	r0 - value to display
;
display:
		; copy your code from a2q2.asm here
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

