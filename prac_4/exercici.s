/* · Mirem el pin cada segon
	
	si no polsem led --> led canvia 
	si el polsem     --> led canvia

inici:	 led off
*/

/*DEFINICIONS*/
DDRB_o = 0x4
DDRD_o = 0x0A
PORTB_o = 0x5
PORTD_o = 0x0B
PINB = 0x3
PIND = 0x9
/*subrutines*/

wait:
	ldi r16, 82
wait3:
	ldi r17, 255
wait2:
	ldi r18, 255
wait1:
	subi r18, 0x01
	brne wait1
	subi r17, 0x01
	brne wait2
	subi r16, 0x01
	brne wait3
	
	ret
	
led_on:
	sbi PORTB_o, 0x05 /*posa la pota 13 (led)= 1*/
	ret
led_off:
	cbi PORTB_o, 0x05 /*posa la pota 13 (led)= 0*/
	ret
led_toggle:
	sbi PINB, 0x05 /*fa toggle de la pota 13 (led) 1/0 */
	ret
p_polsat: /*Z --> 1: polsat /_____/ 0: no polsat*/
	in r23, PIND /*in r23, PIND /*0 --> pulsat --> 10000000*/
	and r23, r24 /*and r23, r24  r24 --> 10000000*/
	ret

	/*quiero que salte cuando de 0*/
/* CODI */
.global main
main:
	/*inicialitzacions*/

	/*led (estat inicial)  == off*/
	ldi r24, 0b00100000
	ldi r22, 0x0
	ldi r21, 0x00
	ldi r20, 0xFF
	out DDRB_o, r20 /*definim set de potes B com a sortida*/
	out DDRD_o, r21 /*definim set de potes D com a entrada*/
	/* inicialitzar pull up*/
	out 0x35, r22 /*---> activem pull up posant el bit PUD a 0*/
	out PORTD_o, r24
	CALL led_off

	

loop:
	call p_polsat
	BRNE loop
	call led_toggle
	call wait
	rjmp loop
	
