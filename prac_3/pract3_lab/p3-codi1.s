/* segon.s, usa una macro */
.set DDRB_o , 0x4
.equ PORTB_o , 0x5
.macro waitabit tot
	ldi r19,\tot
wait3:
	ldi r18,17
wait2:
	ldi r17,0xFF
wait1:
	subi r17,0x01
	brne wait1
	subi r18,0x01
	brne wait2
	subi r19,0x01
	brne wait3
.endm	
.global main
main:
	ldi r16,0x1
	out DDRB_o,r16
loop:
	ldi r16,0x00
	out PORTB_o,r16
	waitabit 0x1
	ldi r16,0x1
	out PORTB_o,r16
	waitabit 0x1
	rjmp loop /* loop forever */
