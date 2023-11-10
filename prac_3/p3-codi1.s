.set DDRB_o , 0x4
.set PINB_0, 0x03
.global main
wait3: ldi r18,17
wait2: ldi r17,0xFF 
wait1: subi r17,0x01
	brne wait1
	nop
	subi r18,0x01
	brne wait2
	ret
main:
	ldi r16,0xFF
	OUT DDRB_o, r16
loop:
	OUT PINB_0, r16
	rcall wait3	   
	rjmp loop
