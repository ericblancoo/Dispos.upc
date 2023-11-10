DDRB_o = 0x4
PORTB_o = 0x5
DDRD_o = 0x0a
PORTD_o = 0x0b
UDR0 = 0xc6
UBRR0H = 0xc5	;inicialitza USART I/O Data Register
UBRR0L = 0xc4	;inicialitza USART Baud Rate Register Low (Registre que diu bits/S de la transmisió)
UCSR0C = 0xc2	;inicialitza registre
UCSR0B = 0xC1	;inicialitza registre
UCSR0A = 0xC0	;inicialitza registre
estat = r18



led_on:
	sbi PORTB_o, 0x05
	ret

led_off:
	cbi PORTB_o, 0x05
	ret

check_L:
	cpi r16, 'l'
	ret

check_E:
	cpi r16, 'e'
	ret

check_D:
	cpi r16, 'd'
	ret

/* rutina de recepció de bytes, el valor es recull al registre r16 */
rx: 	lds r16,UCSR0A 		
	sbrs r16,7 		; Si el bit 7 esta a 1 (rebem dada i salta el flag) el programa saltara una posicició i carregara la dada a r16
	rjmp rx
	lds r16,UDR0
	ret
	
/* rutina de transmissió de byte, el valor a transmetre està al registre r16 */
tx: 	lds r17,UCSR0A 
	sbrs r17,5		;indica si el bit 5 esta activat, es a dir, si esta llest per rebre nova data i per tant llest per transmetre el que ja te
	rjmp tx
	sts UDR0,r16
	ret
.global main
main:
	/* set baud rate a 9600*/
	ldi r16, 0
	sts UBRR0H,r16 		;son bits reservats per a definir els bps de transferencia 
	ldi r16, 103		;el mateix que l'anterior pero aqui el definirem a 9600 qu es el valor 103 a UBRR0n
	sts UBRR0L,r16 
	/* set frame format */
				/* tot i que el valor dels registres després d’un reset ja és correcte	(asíncron, 8 bits de dades, 1 bit de parada, sense paritat,velocitat normal, comunicació no multiprocesso				r)assegurem aquesta configuració escrivint el valor als registres*/

	ldi r16, 0b00100000	;carregarem aixó a (USART Control and Status Register n A)-  interesa activar el Bit 5 - que es el que fa que el flag UDREn s'activi quan esta llest per rebre noves dades, el bi				t 1 tambe ens interesa tenirlo a 0 perque la nostre transmisió serà sincrona i tots els demes a 0 tambe per tant r16 = 0b00100000 (nomes activem el bit 5)

	sts UCSR0A,r16		;carreguem bits explicats en la instrucció anterior en UCSR0A
	ldi r16, 0b00000110	; carreguem aixó a UCR0C, volem activar a transmisio i recepsió de 8 bits segguint la taula del manual ens indica que és activant els bits 1 i 2
	sts UCSR0C,r16		; carreguem els bits a UCSR0C
	
	/* enable rx, tx, sense interrupcions */
	ldi r16, 0b00011000	; carreguem aixó a UCR0B, nomes interesa activar els bits 3 i 4, per activar la transmisió (TX) amb el bit 3, i activar la recepció (RX) amb el bit 4 
	sts UCSR0B,r16		;carreguem lo anterior a UCR0B utilitzant sts per poder escriure en un registre de memoria reservat
	
	/* configuració dels pins */
	ldi r16,0b00000010	;carreguem la pota TX com a sortida i RX com a sortida
	out DDRD_o,r16
	ldi r16, 0b00100000
	out DDRB_o, r16
	
loop:
	call led_off
	
	
s0:	ldi r16, '3'
	call tx
	call rx
	call led_off
	call check_L
	breq s1
	rjmp s0

s1:	ldi r16, '2'
	call tx
	call rx
	call check_E
	breq s2
	call check_L
	breq s1
	rjmp s0

s2:	ldi r16, '1'
	call tx
	call rx
	call check_L
	breq s1
	call check_D
	brne s0
	call led_on
	ldi r16, '0'
	call tx
	call rx
	rjmp s0
