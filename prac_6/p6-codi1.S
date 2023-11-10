DDRB_o = 0x4
PORTB_o = 0x5
PINB = 0x3	
PORTD_o = 0x0b
DDRD_o = 0x0a
UDR0 = 0xc6
SREG = 0x3f
UBRR0H = 0xc5
UBRR0L = 0xc4
UCSR0C = 0xc2
UCSR0B = 0xC1
UCSR0A = 0xC0
estat = r18
.global main
.global __vector_18

check_l:
	cpi r16, 'l'
	ret
check_e:
	cpi r16, 'e'
	ret
check_d:
	cpi r16, 'd'
	ret
led_on:
	push r17
	ldi r17, 0x05
	out PORTB_o, r17
	pop r17
	ret
led_on:
	push r17
	ldi r17, 0b00000000
	out PORTB_o, r17
	pop r17
	ret

	
__vector_18:
				; 
	lds r16, UDR0		; 	     |\		___________________
	cpi estat, 0		;  __________| \       /                   \
	breq s0			; |	        \     |	quan entra a la     |
	cpi estat, 1		; |		 )    |	interrupció salta a |
	breq s1			; |__________   /     |	l'estat q li toca   |
	rjmp s2			; 	     | /       \___________________/
				; 	     |/


	
s0:				;_______________________
	call check_l		;			|
	breq if_l		;			|
else_l:				;			|
	call led_off		;    ____     ___	|
	ldi r16, '3'		;   | ___|   /   |	|
	call tx			;   | |__   /_/| |	|
	ldi estat, 0		;   |__	 |     | |	|
	reti		  	;    __| |     | | 	|
if_l:				;   |____|     |_|	|
	call led_off	;   ____;  			|___
	ldi r16, '2'	;   \				   /
	call tx		;    \				  /
	ldi estat, 0	;     \				 /
	reti		;      \________________________/


s1:				;_______________________
	call check_e		;			|
	breq if_e		;			|
else_e:				;			|
	call check_l		;			|
	breq if_l		;			|
	call led_off		;    ____    ____ 	|
	ldi r16, '3'		;   | ___|  / __ \ 	|
	call tx			;   | |__  /_/ / | 	|
	ldi estat, 0		;   |__  |    / /   	|
	reti		  	;   ___| |   / /__  	|
if_e:				;   |____|  /_____| 	|
	call led_off	;   ____;  			|___
	ldi r16, '1'	;   \				   /
	call tx		;    \				  /
	ldi estat, 1	;     \				 /
	reti		;      \________________________/

s2:				;_______________________
	call check_d		;			|
	breq if_d		;			|
else_d:				;			|
	call check_l		;			|
	breq if_l		;			|
	call led_off		;    ____    _____ 	|
	ldi r16, '3'		;   | ___|  / __  \ 	|
	call tx			;   | |__  /_/ _| | 	|
	ldi estat, 0		;   |__  |  _ |_  |	|
	reti		  	;   ___| | \ \__| |	|
if_d:				;   |____|  \_____/  	|
	call led_on 	;   ____;  			|___
	ldi r16, '0'	;   \				   /
	call tx		;    \				  /
	ldi estat, 2	;     \				 /
	reti		;      \________________________/



/* rutina de transmissió de byte, el valor a transmetre està al registre r16 */
tx: lds 	r17,UCSR0A  
	sbrs	r17,5
	rjmp	tx 	
	sts     UDR0,r16 
	ret 

main:
	/* set baud rate a 9600*/
	ldi	r16, 0 
	sts	UBRR0H,r16 
	ldi	r16, 103 
	sts	UBRR0L,r16

	/* set frame format */
	/* el valor de reset dels registres ja és correcte:
asíncron, sense paritat, 1 stop, 8 dades,
velocitat normal, comunicació no multiprocessor */
	/*assegurem el que volem encara que en reset ja ho sigui*/ 
	ldi	r16, 0b00100000 
	sts	UCSR0A, r16

	ldi	r16, 0b00000110
	sts	UCSR0C, r16
	
	/* enable rx, tx, amb interrupció de rx */ 
	ldi 	r16, 0b10011000 
	sts	UCSR0B,r16 

	/* configuració dels pins, és possible que no calgui */ 
	ldi	r16,0b00000010 
	out	DDRD_o,r16

	/*habilitem interrupcions */
	sei

/*el bucle principal no fa res*/
loop:	rjmp	loop
	ret
