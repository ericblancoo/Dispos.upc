DDRB_o = 0x4
PORTD_o = 0x0B
DDRD_o = 0x0A
UDR0 = 0xC6
UBRR0H = 0xC5
UBRR0L = 0xC4
UCSR0C = 0xC2
UCSR0B = 0xC1
UCSR0A = 0xC0
PORTB = 0x05
.global main

rx: lds r16,UCSR0A
	sbrs r16,7
	rjmp rx
	lds r16,UDR0
	ret
tx: lds r17,UCSR0A
	sbrs r17,5
	rjmp tx
	sts UDR0,r16
	ret
comprova_N:
	cpi r16, 0b1001110
	breq comprovanum
	cpi r16, 0b1101110
	breq comprovanum
	ret
comprovanum:
	andi r23, 57
	breq reset
	rcall envianum
	ret
envianum:
	rcall suma1
	sts UDR0, r23
	ret
suma1:
	addi r23, 1
	ret	
reset:
	ldi r23, 47
	ret
	
main:
	ldi r23, 47
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
	ldi r16, 0b00100000
	out DDRB_o, r16
loop:
	call rx
	call tx
	rcall comprova_N
	rjmp loop
