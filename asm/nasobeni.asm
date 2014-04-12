;******************************************************************************
;                                    X36SKD
;
;             Program pro nasobeni dvou 8-bit sestnackovych cisel
;------------------------------------------------------------------------------
;
; Autor: Aleš Roubíèek
; Datum: 2004-10-06
;
;******************************************************************************

.org 0x0000     ; startovaci adresa programu

.def A = R16    ; prvni operand
.def B = R17    ; druhy operand
.def CL = R18   ; spodni byte vysledku
.def CH = R19   ; horni byte vysledku
.def ZERO = R20 ; konstanta 0

;******************************************************************************
;
;       Inicializace promennych
;
;******************************************************************************

nasobeni:       ldi A, 0x06     ; prirazeni 6 do prvniho operandu
                ldi B, 0x04     ; prirazeni 4 do druheho operandu
                clr CL          ; vynulovani vysledku
                clr CH
                clr ZERO        ; nastaveni nuly

;******************************************************************************
;
;       Nasobeni probiha pomoci B-krat opakovaneho scitani operandu A
;
;******************************************************************************

cyklus:         add CL, A       ; pricte k CL obsah operandu A
                adc CH, ZERO    ; pricte carry k hornimu bajtu vysledku
                dec B           ; zmenseni B o jednicku
                brne cyklus     ; pokud neni B rovno nule pokracuj v nasobeni

konec:          nop             ; konec - nedelat nic