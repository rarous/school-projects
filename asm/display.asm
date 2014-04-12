;******************************************************************************
;                        X36SKD - Strojový kód a data
;------------------------------------------------------------------------------
;             Autor: Aleš Roubíèek (roubia1@fel.cvut.cz)
; Datum vypracování: prosinec 2004
;******************************************************************************

.include "m169def.inc"
.org 0x0000

jmp start

.org 0x000A
reti
;jmp int_T2

.org 0x0100
.dseg

sekundy: .byte 1

.cseg
.include "znaky.inc"

start:
	ldi R16, 0x00
	out SPL, R16
	ldi R16, 0x04
	out SPH, R16

	call init_joy	; inicializace joysticku
	call init_disp	; inicializace displeje
	call clear_disp	; smaze displej

	ldi r16, 0b00000001
	sts TIMSK2, r16 ; povolení pøerušení od èasovaèe 2
	ldi r16, 0b00000101
	sts TCCR2A, r16 ; spuštìní èítaèe s dìlicím pomìrem 128
	ldi r16, 0b00001000
	sts ASSR, r16 	; vyber hodiny od krystalového oscilátoru 32768 Hz
	sei 			; povolení pøerušení (globální)
end:
	call show_joy_pos
	nop
	jmp end



;==============================================================================
;     Podprogram pro inicializaci joysticku
;==============================================================================

init_joy:
	;nastaveni portu E
	in r17, DDRE
	andi r17, 0b11110011
	in r16, PORTE
	ori r16, 0b00001100
	out DDRE, r17
	out PORTE, r16
	ldi r16, 0b00000000
	out DDRE, r16
	; nastaveni portu B
	in r17, DDRB
	andi r17, 0b00101111
	in r16, PORTB
	ori r16, 0b11010000
	out DDRB, r17
	out PORTB, r16
ret

;==============================================================================
;     Podprogram pro inicializaci displeje
;==============================================================================

init_disp:
	ldi R16, 0xB7
	sts LCDCRB, R16
	ldi R16, 0x10
	sts LCDFRR, R16
	ldi R16, 0x0F
	sts LCDCCR, R16
	ldi R16, 0x80
	sts LCDCRA, R16
ret

;==============================================================================
;     Podprogram pro smazani dspleje
;==============================================================================

clear_disp:
	ldi R16, 0x00

	sts LCDDR0, R16
	sts LCDDR0+5, R16
	sts LCDDR0+10, R16
	sts LCDDR0+15, R16

	sts LCDDR1, R16
	sts LCDDR1+5, R16
	sts LCDDR1+10, R16
	sts LCDDR1+15, R16

	sts LCDDR2, R16
	sts LCDDR2+5, R16
	sts LCDDR2+10, R16
	sts LCDDR2+15, R16

	sts LCDDR3, R16
	sts LCDDR3+5, R16
	sts LCDDR3+10, R16
	sts LCDDR3+15, R16
ret

;==============================================================================
;     Podprogram pro zobrazeni znaku '6' na displeji
;==============================================================================

show_6:
	ldi r16, 0x01
	sts LCDDR0, r16

	ldi r16, 0x04
	sts LCDDR0+5, r16

	ldi r16, 0x0F
	sts LCDDR0+10, r16

	ldi r16, 0x01
	sts LCDDR0+15, r16
ret

;==============================================================================
;     Podprogram pro zobrazeni ASCII znaku na displeji
;------------------------------------------------------------------------------
; vstupy:
;   R16 - zobrazovany znak
;   R17 - pozice znaku na displeji
; modifikuje:
;   R17, R18, R19
;==============================================================================

show_char:
	clr R18	; konstanta 0 pro vypocty s carry
	clr R19 ; pomocny registr

	; uprava relativni adresy znaku
	ldi R19, 42
	sub R16, R19
	ldi R19, 4	
	mul R16, R19
	mov R16, R0
	
	; nastavi registr Z na adresu tabulky znaku
	ldi R30, low(znaky<<1)	
	ldi R31, high(znaky<<1)
	
	; spocita adresu znaku v tabulce
 	clc
	add R30, R16
	adc R31, R18

	; nastavi registr Y na adresu registru
	ldi R28, LCDDR0
	ldi R29, 0x00
	ldi R19, 0x01
	ldi R20, 0xF0

	lsr R17
	; nastaveni horniho nebo dolniho niblu
	brcc dal
	ldi R19, 0x10
	ldi R20, 0x0F
dal:
	add R28, R17
	subi R28, 1
	
	lpm R16, Z+
	mul R16, R19
	ld R1, Y
	and R1, R20
	or R0, R1
	st Y, R0
	
	adiw R28, 5
	lpm R16, Z+
	mul R16, R19
	ld R1, Y
	and R1, R20
	or R0, R1
	st Y, R0

	adiw R28, 5
	lpm R16, Z+
	mul R16, R19
	ld R1, Y
	and R1, R20
	or R0, R1
	st Y, R0

	adiw R28, 5
	lpm R16, Z
	mul R16, R19
	ld R1, Y
	and R1, R20
	or R0, R1
	st Y, R0
ret

;==============================================================================
;     Podprogram pro vypsani desitkovaho cisla
;------------------------------------------------------------------------------
; vstupy:
;   R16 - zobrazovane cislo
;==============================================================================

show_dec:
	mov R20, R16
	ldi R21, 100
	call deleni
	push R16
	push R19

	ldi R16, 0x30	; vypocet ASCII cisla
	add R16, R19
	ldi R17, 5
	call show_char	; zobrazi stovky
	pop R19

	ldi R16, 100
	mul R19, R16	; vynasobi vysledek po deleni stem

	pop R16
	sub R16, R0		; a odecte stovky od zadaneho cisla
	mov R20, R16	; provede deleni cisla deseti
	ldi R21, 10
	call deleni
	push R16
	push R19	

	ldi R16, 0x30	; vypocet ASCII cisla
	add R16, R19
	ldi R17, 6
	call show_char	; zobrazi desitky
	pop R19

	ldi R16, 10
	mul R19, R16
	
	pop R16
	sub R16, R0
	ldi R17, 0x30
	add R16, R17
	ldi R17, 7	
	call show_char	; zobrazi jednotky

ret

;==============================================================================
;     Podprogram pro deleni dvou 8-bit cisel
;------------------------------------------------------------------------------
; vstupy:
;   R20 - delenec  
;   R21 - delitel
; vystupy:
;	R19 - podil
;==============================================================================

deleni:
	clr R19
div_cyc:
	sub R20, R21
	brlo div_end
	inc R19
    jmp div_cyc
div_end:
ret

;==============================================================================
;     Podprogram pro zobrazeni stisknuteho tlacitka joysticku
;==============================================================================

show_joy_pos:

	in r16, PINE
	andi r16, 0b00001100
	in r17, PINB
	andi r17, 0b11010000
	or r16, r17

	push r16			; odlozeni R16 do zasobniku
	
	; pockame par cyklu
	nop
	nop
	nop
	nop

	in r16, PINE
	andi r16, 0b00001100
	in r17, PINB
	andi r17, 0b11010000
	or r17, r16

	pop r16				; nacteni R16 ze zasobniku

	cp r16, r17			; porovna r16 a r17
	brne show_joy_pos	; kdyz nejsou stejne jedeme znova

	;com r17				; invertuje vsechy bity

joy_nahoru:				;
	cpi r17, 0x40
	brne joy_dolu
	ldi r16, 40
	call show_dec

	jmp joy_konec

joy_dolu:
	cpi r17, 0x80
	brne joy_vlevo
	ldi r16, 80
	call show_dec

	jmp joy_konec

joy_vlevo:
	cpi r17, 0x04
	brne joy_vpravo
	ldi r16, 4
	call show_dec

	jmp joy_konec

joy_vpravo:
	cpi r17, 0x08
	brne joy_ret
	ldi r16, 8
	call show_dec

	jmp joy_konec

joy_ret:
	cpi r17, 0x10
	brne joy_nic
	ldi r16, 10
	call show_dec
	
	jmp joy_konec

joy_nic:
	clr r16
	call show_dec

	jmp joy_konec

joy_konec:
	
ret

;==============================================================================
;     Obsluha preruseni od casovace T2
;==============================================================================

int_T2:
	push r16
	push r17
	push r18
	in r16, SREG
	push r16
	lds r16, sekundy
	inc r16
	push r16
	lds r16, sekundy
	call show_dec
	pop r16
	sts sekundy, r16
	pop r16
	out SREG, r16
	pop r18
	pop r17
	pop r16
reti