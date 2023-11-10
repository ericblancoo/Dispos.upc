/* primer.s, usa la crida a subrutina */
.set DDRB_o , 0x4
.equ PORTB_o , 0x5
.global main
waitabit:
	ldi r19,41
wait3:
	ldi r18,0xFF
wait2:
	ldi r17,0xFF
wait1:
	subi r17,0x01
	brne wait1
	subi r18,0x01
	brne wait2
	subi r19,0x01
	brne wait3
	ret
main:
	ldi r16,0xFF
	out DDRB_o,r16
loop:
	ldi r16,0x00
	out PORTB_o,r16
	rcall waitabit
	ldi r16,0xFF
	out PORTB_o,r16
	rcall waitabit
	rjmp loop /* loop forever */
