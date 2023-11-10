DDRB_o = 0x4
DDRD_o = 0x0A
PORTB_o = 0x5
PORTD_o = 0x0B
PINB = 0x3
PIND = 0x9

to1:
	LDI r17,11
wait2:
	LDI r16, 241
wait1:	
	SUBI r16, 0x01
	BRNE wait1
	SUBI r17, 0x01
	BRNE wait2
	SBI PINB, 0x00
	SUBI r20, 0x01
	BRNE to1
	RET
.global main
main:

	LDI r18, 0xFF
	LDI r19, 0x00
	LDI r20, 2
	out DDRB_o, r18
	out DDRD_o, r19
loop:
	rcall to1
	rjmp loop
