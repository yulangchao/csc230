;
; CSc 230 Assignment 1 
; Question 1
;

; This program should calculate:
; R0 = R16 + R17 + R18
;
;--*1 Do not change anything between here and the line starting with *--
.cseg
	ldi	r16, 0x30
	ldi r17, 0x31
	ldi r18, 0x32
;*--1 Do not change anything above this line to the --*

;***
; Your code goes here:
;
   add r0,r16
   add r0,r17
   add r0,r18

;****

;--*2 Do not change anything between here and the line starting with *--
done:	jmp done
;*--2 Do not change anything above this line to the --*


