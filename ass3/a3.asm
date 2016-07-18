#define LCD_LIBONLY
.include "lcd.asm"

.cseg
	



    ldi r25,0x00

    
	mov r0,r25




	call lcd_init	
	call lcd_clr		; call lcd_init to Initialize the LCD
	call init_strings
    call setl1
    call setl2
  

    
loop:
    ldi r20,0x20
	call check_button
    call speedcontrol
    call lcd_clr
    call copy1
	call copy2
    call move1
    call move2
    call display_strings
    call displayled
	inc r0
	call check_button
    call speedcontrol
    call delay
	jmp loop



done:	

    jmp done


setl1:
    push XH
	push XL
	push r16
	push r17
    ldi  XH, high(l1ptr)
    ldi  XL, low(l1ptr)  
	ldi r16,high(msg1)
	ldi r17,low(msg1)
	st X+,r17
	st X,r16
	sbiw X,1

	ld YL,X+
	ld YH,X
	sbiw X,1
	
	pop r17
	pop r16
	pop XL
	pop XH
    ret



setl2:
    push XH
	push XL
	push r16
	push r17
    ldi  XH, high(l2ptr)
    ldi  XL, low(l2ptr)  
	ldi r16,high(msg2)
	ldi r17,low(msg2)
	st X+,r17
	st X,r16
	sbiw X,1

	ld ZL,X+
	ld ZH,X
	sbiw X,1
	
	pop r17
	pop r16
	pop XL
	pop XH
    ret

;copy first line11111111111111111111111111111111111111111111
;use r21,r23 
copy1:
    push XH
	push XL
	push YH
	push YL
	push r23
	clr r23
	clr r21
	
    ldi XH,high(line1)
	ldi XL,low(line1)
	
looper1:
    cpi r21,16
	brne next_char1
    jmp disit
next_char1:
    ld r22,Y+
	cpi r22,0
	brne stx1
	jmp nexttime
stx1:
    st X+,r22
	inc r21
	jmp looper1
	
nexttime:
    call setl1
	ld r22,Y+
	st X+,r22
	inc r21
    jmp looper1

disit:
    st X,r23
    pop r23
	pop YL
	pop YH
	pop XL
	pop XH
    ret

;movetonextptr

move1:
    adiw Y,1
	ld r17,Y
	tst r17
	breq try1
	ret
try1:
    call setl1
	ret

;copy2222222222222222222222222222222222222222222222222222
copy2:
    push XH
	push XL
	push ZH
	push ZL
	push r23
	clr r23
	clr r24
	
    ldi XH,high(line2)
	ldi XL,low(line2)


looper2:
    cpi r24,16
	brne next_char2
    jmp disit2
next_char2:
    ld r25,Z+
	cpi r25,0
	brne stx2
	jmp nexttime2
stx2:
    st X+,r25
	inc r24
	jmp looper2
	
nexttime2:
    call setl2
	ld r25,Z+
	st X+,r25
	inc r24
    jmp looper2

disit2:
    st X,r23
    pop r23
	pop ZL
	pop ZH
	pop XL
	pop XH
    ret

;movetonextptr

move2:
    adiw Z,1
	ld r17,Z
	tst r17
	breq try2
	ret
try2:
    call setl2
	ret




init_strings:
	push r16
	; copy strings from program memory to data memory
	ldi r16, high(msg1)		; this the destination
	push r16
	ldi r16, low(msg1)
	push r16
	ldi r16, high(msg1_p << 1) ; this is the source
	push r16
	ldi r16, low(msg1_p << 1)
	push r16
	call str_init			; copy from program to data
	pop r16					; remove the parameters from the stack
	pop r16
	pop r16
	pop r16

	ldi r16, high(msg2)
	push r16
	ldi r16, low(msg2)
	push r16
	ldi r16, high(msg2_p << 1)
	push r16
	ldi r16, low(msg2_p << 1)
	push r16
	call str_init
	pop r16
	pop r16
	pop r16
	pop r16

	pop r16
	ret




display_strings:

	; This subroutine sets the position the next
	; character will be output on the lcd
	;
	; The first parameter pushed on the stack is the Y position
	; 
	; The second parameter pushed on the stack is the X position
	; 
	; This call moves the cursor to the top left (ie. 0,0)

	push r16

	call lcd_clr

	ldi r16, 0x00
	push r16
	ldi r16, 0x00
	push r16
	call lcd_gotoxy
	pop r16
	pop r16

	; Now display msg1 on the first line
	ldi r16, high(line1)
	push r16
	ldi r16, low(line1)
	push r16
	call lcd_puts
	pop r16
	pop r16

	; Now move the cursor to the second line (ie. 0,1)
	ldi r16, 0x01
	push r16
	ldi r16, 0x00
	push r16
	call lcd_gotoxy
	pop r16
	pop r16

	; Now display msg1 on the second line
	ldi r16, high(line2)
	push r16
	ldi r16, low(line2)
	push r16
	call lcd_puts
	pop r16
	pop r16

	pop r16
	ret







;delay
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











; check button


check_button:
 	ldi r16, 0x87
	sts ADCSRA, r16
	ldi r16, 0x40
	sts ADMUX, r16

		ldi r24,0
		; start a2d
		lds	r16, ADCSRA	
		ori r16, 0x40
		sts	ADCSRA, r16

		; wait for it to complete
wait:	lds r16, ADCSRA
		andi r16, 0x40
		brne wait

		; read the value
		lds r16, ADCL
		lds r17, ADCH

		clr r24
		cpi r17, 3			;  if > 0x3E8, no button pressed 
		brne bsk1		    ;  
		cpi r16, 0xE8		; 
		brsh bsk_done		; 
bsk1:	tst r17				; if ADCH is 0, might be right or up  
		brne bsk2			; 
		cpi r16, 0x32		; < 0x32 is right
		brsh bsk3
		ldi r24, 0x01		; right button
		rjmp bsk_done
bsk3:	cpi r16, 0xC3		
		brsh bsk4	
		ldi r24, 0x02		; up			
		rjmp bsk_done
bsk4:	ldi r24, 0x04		; down (can happen in two tests)
		rjmp bsk_done
bsk2:	cpi r17, 0x01		; could be up,down, left or select
		brne bsk5
		cpi r16, 0x7c		; 
		brsh bsk7
		ldi r24, 0x04		; other possiblity for down
		rjmp bsk_done
bsk7:	ldi r24, 0x08		; left
		rjmp bsk_done
bsk5:	cpi r17, 0x02
		brne bsk6
		cpi r16, 0x2b
		brsh bsk6
		ldi r24, 0x08
		rjmp bsk_done
bsk6:	ldi r24, 0x10
bsk_done:

		ret

;speedcontrol
speedcontrol:
        cpi r24,0x04
		breq playagain
		cpi r24,0x02
		breq stop
		cpi r24,0x08
        breq speedup
		cpi r24,0x01
		breq slowdown
        ret  
stop: 
      call check_button
      call speedcontrol
      jmp stop
playagain:
      jmp loop
       
speedup:
      ldi r20,0x10
	  ret
slowdown:
      ldi r20,0x80
      ret


displayled:
    
		ldi r16, 0xFF
		sts DDRB, r16		; PORTB all output
		sts DDRL, r16		; PORTL all output


; Your code here
        ldi r18,0x00
		ldi r19,0x00
        mov r17,r0
		ANDI r17, 0b00100000
		BReq loop0
		ori r18, 0b00000010
loop0:
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

msg1_p:	.db "This is the first message displayed on the first line of the LCD.", 0	
msg2_p: .db "On the second line of the LCD there is another message that is scrolled.", 0

.dseg


msg1:	.byte 200
msg2:	.byte 200
line1:  .byte 17
line2:  .byte 17
l1ptr:  .byte 2
l2ptr:  .byte 2
