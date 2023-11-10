.global main
	mregistre = 16
	.set DDRB_o , 0x4
	.equ PINB_o , 0x3
main:
	ldi mregistre,0xFF
	out DDRB_o,mregistre
loop:
	out PINB_o,mregistre
	call DELAY
	rjmp loop

DELAY:
	ldi r17, 0xFF
DELAY1:
	ldi r18, 0xAF
DELAY2:
	ldi r19, 0x80
DELAY3:	
	dec r19
	brne DELAY3
	dec r18
	brne DELAY2
	dec r17
	brne DELAY1
	ret
	
