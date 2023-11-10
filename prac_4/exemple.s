.set DDRB_o , 0x4
.equ PORTB_o , 0x5
DDRD_o = 0x0a
PORTD_o = 0x0b
TCCR0A_o = 0x24
TCCR0B_o = 0x25
OCR0A_o = 0x27

	
.global main
waitabit: ldi r19,41 /*subrutina feta en anteriors practiques que fan un bucle d'espera ( semiperiode 500ms = periode de 1000ms*/
wait3: ldi r18,0xFF
wait2: ldi r17,0xFF
wait1: subi r17,0x01
	brne wait1
	subi r18,0x01
	brne wait2
	subi r19,0x01
	brne wait3
	ret
	
main: 	ldi r16,0b01000000
	out DDRD_o,r16 /*configurem bit 6, pota 6, com a sortida i les demes com a entrada en el portD*/
	ldi r16,0b00000000
	out PORTD_o,r16/*definim els pins del portD = 0*/
	ldi r16,124
	out OCR0A_o,r16 /*definim limit timer amb 124 */
	ldi r16,0b01000010 /* els dos primers bits es per activar el toggle OCOA on encenem el timer. Els seguents dos bits son per tenir OCB0 desconenctat. I els dos ultims son per posar el mode CTC (clear data on compare match), per feer toggle just cuan el timmer arriba al seu limit. Els demes bits son reservats*/
	out TCCR0A_o,r16  
	ldi r16,0b00000011/* amb els primers dos bits i amb els tres ultims posem el prescaler a 64. el 4rt bit es per WGM02 que serveix pr a acabar de configurar amb el WGM01 i 00 del TCCR0A i el CTC */
	out TCCR0B_o,r16 
	
loop:  call waitabit /*cridem waitabit*/
	in r20,TCCR0A_o/*mirem el valor del timer*/ 
	cbr r20,0b01000000/* posem el segon bit de r20 a 0*/
	out TCCR0A_o,r20/*parem el timer ja que hem posat el segon bit a 0*/
	call waitabit/*cridem waitabit*/
	in r20,TCCR0A_o/*llegim timer*/
	sbr r20,0b01000000/*posem a 1 el segon bit de r20*/
	out TCCR0A_o,r20/* encenem el timer despres de posar el segon bit a 1*/
	rjmp loop
