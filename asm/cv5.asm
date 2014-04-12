;******************************************************************************
;                                       X36SKD
;
;                              �lohy ze cvi�en� ��slo 5
;------------------------------------------------------------------------------
;
; Autor: Ale� Roub�ek
; Datum: 2004-11-03
;
;******************************************************************************

.org 0x0100

jmp ukol5         ; skoci na zacatek vybrane casti

;******************************************************************************
;
;       P��klad 1: Nastaven� registru na hodnotu 
;
;******************************************************************************

pr1:            ldi R16, 15             ; dekadicky (kladn�)
                ldi R18, -10            ; dekadicky (z�porn�)
                ldi R24, 0xA4           ; hexadecim�ln�
                ldi R31, 0b10100101     ; bin�rn�
                
                jmp konec

;******************************************************************************
;
;       P��klad 2: Sou�et dvou 8-bit ��sel 
;
;******************************************************************************

pr2:            ldi R16, 0x5A
                ldi R17, 0x63
                add R16, R17

                jmp konec

;******************************************************************************
;
;       P��klad 3: Sou�et dvou 16-bit ��sel 
;
;******************************************************************************

pr3:            ldi R16, 0xB1
                ldi R17, 0x3A
                ldi R18, 0x62
                ldi R19, 0x5F

                add R16, R18    ; nastavuje carry
                adc R17, R19    ; p�i�te carry k v�sledku
                
                jmp konec

;******************************************************************************
;
;       �loha 1: Vym��te obsah registru R30 a R31
;
;******************************************************************************

ukol1:          ldi R30, 0x10
                ldi R31, 0x20

                mov R1, R30     ; nabufferujeme hodnotu R30 do R1
                mov R30, R31    ; presune obsah R31 do R30
                mov R31, R1     ; presune obsah R30 do R31
                
                jmp konec

;******************************************************************************
;
;       �loha 2: Sou�et dvou 32-bitov�ch ��sel
;
;******************************************************************************

ukol2:          ldi R16, 0x8C
                ldi R17, 0xF3
                ldi R18, 0x75
                ldi R19, 0x11

                ldi R20, 0xAE
                ldi R21, 0x2F
                ldi R22, 0xFE
                ldi R23, 0x2D

                add R16, R20
                adc R17, R21
                adc R18, R22
                adc R19, R23
        
                jmp konec

;******************************************************************************
;
;       �loha 3: Spo��tat v�raz R20=(4*R16+3*R17-R18)/8
;
;******************************************************************************

ukol3:          ldi R16, 5
                ldi R17, 10
                ldi R18, 58

                lsl R16         ; vyn�sob� R16 �ty�mi
                lsl R16

                mov R19, R17    ; vyn�sob� R17 t�emi
                lsl R17
                add R17, R19

                mov R20, R16    ; presune R16 do R20
                add R20, R17    ; pricte R17
                clc             ; vymaze carry
                sub R20, R18    ; odecte R18 od R20

                asr R20         ; vyd�l� R20 osmi
                asr R20
                asr R20

                jmp konec

;******************************************************************************
;
;       �loha 4: Aritmetick� posuv 32-bitov�ho ��sla (1x vpravo)
;
;******************************************************************************

ukol4:          ldi R16, 0xFA
                ldi R17, 0x9B
                ldi R18, 0x1C
                ldi R19, 0xCD

                asr R19
                ror R18
                ror R17
                ror R16

                jmp konec

;******************************************************************************
;
;       �loha 5: proho�te doln� dva bity s horn�mi dv�ma bity slabiky
;
;******************************************************************************

ukol5:          ldi R16, 0x7B
                ldi R18, 0b11000011
                clr R17

                or R17, R16
                and R17, R18
                mov R19, R17

                lsl R17
                lsl R17
                lsl R17
                lsl R17
                lsl R17
                lsl R17

                or R16, R18
                and R16, R17
                
                lsr R19
                lsr R19
                lsr R19
                lsr R19
                lsr R19
                lsr R19
                
                or R16, R19 

                ;nefunguje

konec:          nop             ; konec programu