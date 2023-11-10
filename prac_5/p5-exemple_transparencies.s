.set DDRB_o , 0x4
.equ PORTB_o , 0x5
PORTD_o = 0x0B
DDRD_o = 0x0A
UDR0 = 0xC6
UBRR0H = 0xC5
UBRR0L = 0xC4
UCSR0C = 0xC2
UCSR0B = 0xC1
UCSR0A = 0xC0
SREG= 0x3F
UDRE0 = 5 /*Guarda BIT ( flag ) del bit 5 de UCSR0A*/ 
.global main

/*-------------------------------------------------RX--------( RX ja es transparent ja que no modifiques un registre que utilitzes en un altre lloc)*/	

rx: 	lds r16,UCSR0A
	sbrs r16,7 /* (Skip bit ... set) --> salta 1 instrució si el bit 7 de r16 està a 1, per tant si aquest estigues a 1 saltaria a lds i no faria el rjmp, sino tornaria a fer rx fins que fos 1*/
	rjmp rx
	lds r16,UDR0
	ret

/*-------------------------------------------------TX-----------------------------------------------( TX fet amb subrutina transparent)*/
	
tx:	push r17
	in r17,SREG
	push r17
	/*|*/
	/*|*/
int_tx:	lds r17,UCSR0A
	sbrs r17,5
	rjmp int_tx /* hem de saltar nomes al codi en que es repeteix la comprobació del bit 5 de r17 per no estar tota l'estona fent push de r17 ja que sino reventaria, la solució es ffer rjmp a una etiqueta 			amb el codi intern de tx*/
	sts UDR0,r16
	/*|*/
	/*|*/
	pop r17
	out SREG, r17
	pop r17
	ret
	
main:
	ldi r16, 0
	sts UBRR0H,r16
	ldi r16, 103
	sts UBRR0L, r16
	ldi r16, 0b00100000
	sts UCSR0A, r16
	ldi r16, 0b00000110
	sts UCSR0C, r16
	ldi r16, 0b00011000
	sts UCSR0B,r16
	ldi r16,0b00000010
	out DDRD_o,r16
loop:
	call rx
	call tx
	rjmp loop
