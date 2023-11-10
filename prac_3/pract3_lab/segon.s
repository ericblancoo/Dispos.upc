/* segon.s, usa una macro */
.set DDRB_o , 0x4
.equ PORTB_o , 0x5
.macro waitabit tot
	ldi r19,\tot
3: ldi r18,0xFF
2: ldi r17,0xFF
1:
	subi r17,0x01	
	brne 1b
	subi r18,0x01
	brne 2b
	subi r19,0x01
	brne 3b
.endm
.global main
main:
	ldi r16,0xFF
	out DDRB_o,r16
loop:
	ldi r16,0x00
	out PORTB_o,r16
	waitabit 41
	ldi r16,0xFF
	out PORTB_o,r16
	waitabit 41
	rjmp loop /* loop forever */
