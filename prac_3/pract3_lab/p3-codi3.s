DDRB_o = 0x4
PORTB_o = 0x5
PINB = 0x3
DDRD_o = 0x0A
PORTD_o = 0x0B	
wait600Hz:
	ldi r18,17
wait2:
	ldi r17,0xFF
wait1:
	subi r17,0x01
	brne wait1
	subi r18,0x01
	brne wait2
	subi r20,1
	brne wait600Hz
	ret
.global main
main:
	ldi r16, 0xFF
	ldi r19, 0x00
	ldi r22, 0b10000000
	out DDRB_o,r16
	out DDRD_o, r19
	
comprovacio_led_pin7:
	in r23, 0x09 /*p0000000 & 10000000*/
	and r23, r22
	brne comprovacio_led_pin7
	rjmp loop1500ms
	
loop1500ms:
	sbi PINB, 0x5
	ldi r20, 255
	rcall wait600Hz
	ldi r20, 255
	rcall wait600Hz
	ldi r20, 255
	rcall wait600Hz
	ldi r20, 255
	rcall wait600Hz
	ldi r20, 255
	rcall wait600Hz
	ldi r20, 255
	rcall wait600Hz
	ldi r20, 255
	rcall wait600Hz
	ldi r20, 15
	rcall wait600Hz
	SBI PINB, 0x5
	rjmp comprovacio_led_pin7 /* loop forever */
