.global main

mregistre = 16
.set DDRB_o , 0x4
.equ PORTB_o , 0x5

main:
	ldi mregistre,0xFF
	out DDRB_o,mregistre
loop:
	ldi mregistre,0x00
	out PORTB_o,mregistre
	ldi mregistre,0xFF
	out PORTB_o,mregistre
	rjmp loop
