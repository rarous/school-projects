; Aleš Roubíèek

.org 0

jmp start

.cseg

str_1: .db "Programovani v assembleru ", 0
str_2: .db "je velka legrace.", 0
 
.dseg
.org 0x100

str_1c:.byte 32
str_2c:.byte 32
str:   .byte 64
 
.cseg
 
start:

loadstr_1:
        ldi r30, low(str_1<<1)
        ldi r31, high(str_1<<1)
        ldi r28, low(str_1c)
        ldi r29, high(str_1c)
cp_cycle1:
        lpm
        st Y+, r0
        adiw r30, 1
        tst r0
        brne cp_cycle1

loadstr_2:
        ldi r30, low(str_2<<1)
        ldi r31, high(str_2<<1)
        ldi r28, low(str_2c)
        ldi r29, high(str_2c)
cp_cycle2:
        lpm
        st Y+, r0
        adiw r30, 1
        tst r0
        brne cp_cycle2

copystr:
        ldi r26, low(str)
        ldi r27, high(str)
        ldi r28, low(str_1c)
        ldi r29, high(str_1c)

cp_cycle3:
        ld r0, Y
        tst r0
        breq next
        st X, r0
        adiw r26, 1
        adiw r28, 1
        jmp cp_cycle3

next:
        ldi r28, low(str_2c)
        ldi r29, high(str_2c)
cp_cycle4:
        ld r0, Y
        st X, r0
        adiw r26, 1
        adiw r28, 1
        tst r0
        brne cp_cycle4

end:
        nop