[BITS 16]

; Bu temel registerların anlatıldığı dosya

; Temelde CPU üzerinde 4 register vardır
; Bu registerların adı A, B, C ve D'dir
; Bunların her biri 1 byte'lık veri tutabilir 
; 16 bitlik sistemlerde bu regiserlar 16 bitlik veri tutar, yani 2 byte
; bu yüzden bunlara bilgi koyarken registerın adı önüne X ekleriz, örneğin: ax, bx, dx
; X extended'ın kısaltılmışıdır. ax = eXtended A

; A, B, C ve D registerları dışında iki tane daha temel register bulunur: di ve si
; bunların önüne x getirmeye gerek yoktur bunlar zaten 16 bittir.

; Assembly'de instructionlar (komutlar) LABEL OPCODE OPERAND syntax'ı ile yazılır
; OPCODE komutun kendisidir
; OPERANDS parametreleridir

; 1. OPCODE, MOV
; MOV move kelimesinin kısaltılmışıdır ve bilgi taşıma yapar. Örneğin

mov ax, 0x03

; bu satır AX register'ına 0x03 değerini koyar.
; registerlar arası taşıma da yapılabilir

mov bx, ax

; Bu satır da BX register'ına AX register'ındaki değeri, yani 0x03, değerini koyar.

; 2. OPCODE, ADD
; ADD birinci operand'ına ikincisini ekler, örneğin

add ax, 0x04

; Bu satırla beraber AX register'ındaki değer 0x07'dir, 0x03 + 0x04
; İki register arasında toplama da yapılabilir

add bx, ax

; Bu satırla beraber BX değeri 0x0A olur, 0x07 + 0x03 = 0x0A

; 3. OPCODE, SUB
; SUB subtract'in kısaltılmışıdır. Çıkarma işlemi yapar

sub bx, 0x02 

; BX = 0x08

; 4. OPCODE MUL
; MUL multiply'ın kısaltılmışıdır. Çarpma işlemi yapar
; Diğerlerinin aksine bunun 2 tane OPERAND'ı yoktur.
; Her zaman ax'deki sayıyı OPERAND olarak verilen sayıyla çarpar ve sonucu ax'e yazar

mov ax, 0x05
mov dx, 0x02

mul dx

; AX = 0x05 * 0x02 = 0x0A

; 5. OPCODE DIV
; DIV divide'ın kısaltılmışıdır. Bölme işlemi yapar
; Diğerlerinin aksine bunun 2 tane OPERAND'ı yoktur.
; Her zaman ax'deki sayıyı OPERAND olarak verilen sayıya böler ve sonucu ax'e yazar

mov ax, 0x0A
mov dx, 0x02

div dx

; AX = 0x0A / 0x02 = 0x05

; 6. OPCODE AND
; And mantıksal VE operasyonudur. 2 OPERAND alır. OPERAND'ların bitlerini karşılaştırır ve her bit için
; yeni bir sonuç üretir.
; Mantık tablosu şöyledir.
;
;      1. bit              2. bit             Sonuç
;        0                    0                 0
;        0                    1                 0
;        1                    0                 0
;        1                    1                 1
;
; Örneğin

mov al, 0b10101101
mov cl, 0b01101011
and al, cl

; al = 0b00101001
;
; 0b10101101
; 0b01101011
;------------
; 0b00101001
;

; 7. OPCODE OR
; And mantıksal VEYA operasyonudur. 2 OPERAND alır. OPERAND'ların bitlerini karşılaştırır ve her bit için
; yeni bir sonuç üretir.
; Mantık tablosu şöyledir.
;
;      1. bit              2. bit             Sonuç
;        0                    0                 0
;        0                    1                 1
;        1                    0                 1
;        1                    1                 1
;
; Örneğin

mov al, 0b10101101
mov cl, 0b01101011
or al, cl

; al = 0b11101111
;
; 0b10101101
; 0b01101011
;------------
; 0b11101111
;

; 8. OPCODE XOR
; And mantıksal DIŞLAYICI_VEYA operasyonudur. 2 OPERAND alır. OPERAND'ların bitlerini karşılaştırır ve her bit için
; yeni bir sonuç üretir.
; Mantık tablosu şöyledir.
;
;      1. bit              2. bit             Sonuç
;        0                    0                 0
;        0                    1                 1
;        1                    0                 1
;        1                    1                 0       <---- 
;
; XOR'u düşünmenin başka bir yolu bu işlemi bir karşılaştırma olarak düşünmektir. 2 bit'i karşılaştır bitler aynı
; ise cevap 0, bitler farklı ise cevap 1'dir.
;
; Örneğin

mov al, 0b10101101
mov cl, 0b01101011
xor al, cl

; al = 0b11000110
;
; 0b10101101
; 0b01101011
;------------
; 0b11000110
;

; 9. OPCODE NOT
; Mantıksal NOT operasyonudur. Bütün bitleri tersine çevirir

mov al, 0b10101101

not al

; al = 0b01010010

; 10. OPCODE INC
; Arttırma operasyonudur. Yanına gelen register'in değerini 1 arttırır.

mov ax, 0x09

inc ax

; ax = 0x0A

; 11. OPCODE DEC
; Azaltma operasyonudur. Yanına gelen register'in değerini 1 arttırır.

mov ax, 0x09

dec ax

; ax = 0x08



