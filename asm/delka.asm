; Aleš Roubíèek

.org 0
.include "m169def.inc"

jmp start

.cseg

mystr: .db "nejaky retezec", 0

.dseg
.org 0x100

str: .byte 32

.cseg

start:
        ldi r16, 0x00 ; zasobnik
        out SPL, r16
        ldi r16, 0x04
        out SPH, r16

loadstr_1:
        ldi r30, low(mystr<<1)
        ldi r31, high(mystr<<1)
        ldi r28, low(str)
        ldi r29, high(str)

cp_cycle1:
        lpm
        st Y+, r0
        adiw r30, 1
        tst r0
        brne cp_cycle1

        ldi r30, low(str)
        ldi r31, high(str)
        call strlen

 end:   nop



;********************************************************************
;             Podprogram pro zjisteni delky retezce
;
;   Vstupy:     R30, R31 - poc. adr. retezce v pameti dat
;   Vystup:     R0 - delka retezce
;   Pouziva:    R0, R1, R30, R31, SREG
;
;********************************************************************
strlen:
        clr r0
ln_cycle1:
        ld r1, Z
        tst r1
        breq ln_end
        inc r0
        adiw r30, 1
        jmp ln_cycle1

ln_end: ret