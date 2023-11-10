DDRB_o = 0x4
DDRD_o = 0x0A
PORTB_o = 0x5
PORTD_o = 0x0B
PINB = 0x3
PIND = 0x9

to1:
	ldi r20, 150
	rcall wait1kHz
	ldi r20,150
	rcall wait1kHz
	ret
wait1kHz:
	ldi r18, 11

wait2:
	ldi r17, 241
wait1:
	subi r17, 0x01
	brne wait1
	subi r18, 0x01
	brne wait2
	sbi PINB, 0x00
	subi r20, 0x1
	brne wait1kHz
	ret
	
sl1:
	ldi r20, 150
	rcall wait1kHz_2
	ldi r20, 150
	rcall wait1kHz_2
	ret
wait1kHz_2:
	ldi r18, 11

wait2_2:
	ldi r17, 241
wait1_2:
	subi r17, 0x01
	brne wait1_2
	subi r18, 0x01
	brne wait2_2
	nop
	subi r20, 0x1
	brne wait1kHz_2
	ret
punt:
	rcall to1
	rcall sl1
	rjmp loop
ratlla:
	rcall to1
	rcall to1
	rcall to1
	rcall sl1
	rjmp loop
.global main
main:
	ldi r16, 0xFF
	ldi r19, 0x0
	ldi r21, 0b10010000
	out DDRB_o,r16
	out DDRD_o,r19 /* definim port D com a entrada */
	out 0x35, r19 /* activem bit PUD */
	out PORTD_o, r21 /* definim els pins que utilitzarem pull up */
	
loop:
	ldi r22, 0b00010000
	ldi r23, 0b10000000
	in r24, PIND
	and r24, r22
	brne punt
	in r25, PIND
	and r25, r23
	brne ratlla
	rjmp loop
	

