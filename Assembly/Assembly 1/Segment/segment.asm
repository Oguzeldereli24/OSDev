[BITS 16]

;
; Her program 3 temel kısımdan oluşur. Bu kısımlar:
;
; Code
; Initialized Data
; Uninitialized data'dır
;
; Code: çalıştırdığımız koddur. Bütün OPCODE ve benzeri öğeler bu kısma dahildir
; Initialized Data: Başlangıç değerini bildiğimiz değişkenlerdir.
; Uninitialized Data: Başlangıç değerini bilmediğimiz ve yer ayırdığımız değişkenlerdir.
;
; Kodumuzu yazarken compiler'ımıza yazdığımız kodun hangi kısıma dahil olduğunu söylememiz önemlidir.,
; Böylece kod, verilere dokunamaz veya değersiz bir değişken istenilmeden kullanılmaz.
;
; Bu kısımlara section adı verilir. NASM assembler'ında (compiler'ında) SECTION aynı zamanda bir direktiftir.
; Ve şu şekilde tanımlanır SECTION .NAME
;
; NAME kısmına içinde bulunduğumuz kısmın adı yazılır. Bu ad:
;
; Code için "text"
; Initialized Data için "data"
; Uninitialized Data için "bss"dir
;
; Örneğin bi başlangıç labelimiz olsun:

section .text           ; Başlangıçta kod yazacağımız için burası .text section'u

start:
	mov sp, 0x9000      ; stack'imizi bir yere koyalım
	mov sp, bp

	mov ax, 0x05
	mov bx, 0x03

	add bx, ax          ; toplama işlemi yapalım
	add bx, [number]
	
	mov word [result], bx 

section .data

number: dw 0x0010       ; Başlangıç değerini bildiğimiz için number değişkenini .data kısmına koyacağız

section .bss

result: resw 1          ; Result değişkeninin değeri daha hesaplanmadığı için ona yer ayırdık. 16 bitlik işlem
						; Olduğu için 1 tane word ayırdık.

;
; Tıpkı bizim programımızı parçalara ayırdığımız gibi RAM'de de bu kısımları temsil eden parçalar var
; Bunlara "segment" denir.
;
; Segmentlar bir verinin RAM'deki adresini hesaplamak için kullanılırlar. 
;
; Normalde bir veri RAM'de 0x00000000 adresinde ise hesaplamasında segment kullanılmamıştır ve o RAM'deki gerçek 
; adresidir. Segmentlar kullanıldığı zaman gerçek adreste bir segment offset eklenir. Segmentlar 16 bit registerlardır.
;
; Temelde 3 tane segment vardır:
;
; cs : Code Segment'ın kısaltmasıdır. Text Section'ını temsil eder ve çalışan kodun RAM'deki adresinin hesaplanması için
;      kullanılır.
; ds : Data Segment'ın kısaltmasıdır. Data ve BSS Section'larını temsil eder ve verinin RAM'deki adresinin hesaplanması
;      için kullanılır.
; ss : Stack Segment'ın kısaltmasıdır. SP'nin RAM'deki adresinin hesaplanması için kullanılır.
;
; Segment Offset hesaplaması:
;
; Segment'lar ile RAM'de bir adres şu formatla yazılır
;
; Segment:Offset
;
; Hem Segment hem de Offset 16 bitlik sistemlerde bir word'dür ve bu formatın temsil ettiği gerçek RAM adresi şu şekilde
; bulunur:
; 
; Segment * 0x10 + Offset
;
; Yani Segment 16 ile çarpılır ve Offset Eklenir.
; Yine aynı örneğe bakalım:
;

section .text           ; Başlangıçta kod yazacağımız için burası .text section'u
						;
start:                  ; Burası aynı zamanda CS:start adresidir. CS (Code Segment)'ın içerisinde ne değer bulunursa 
	mov sp, 0x9000      ; bulunsun eğer start 0x0000 ise (yani programın başıysa) burası 0x0000 diye gösterilir
	mov sp, bp          ; Buna rağmen RAM'de gerçekten 0x0000 adresinde bulunmak zorunda değildir.
	mov ax, 0x05        ; Mesela CS = 0x0010 ise buranın gerçek adresi RAM'de 0x0100 dir (0x0010 * 0x10 + 0x0000 = 0x0100)
	mov bx, 0x03        ; Ama buna rağmen bir yerde 0x0000 adresi geçiyorsa yine programın başını işaret edebilir. 
                        ; Bunun nedeni kod çalıştırmayı sağlayan IP register'ının çalıştıracağı kodun CS:IP değerinde bulunmasıdır
	add bx, ax          ; 
	add bx, [number]
	
	mov word [result], bx 

section .data

number: dw 0x0010       ; Başlangıç değerini bildiğimiz için number değişkenini .data kısmına koyacağız
						; Aynı şekilde burada number değişkeni DS (Data Segment)'a offset olarak eklenir.
						; Burası da 0x0000 adresi olarak ifade edilebilir fakat RAM'de aslında DS:0x0000 adresidir.
section .bss

result: resw 1          ; Result değişkeninin değeri daha hesaplanmadığı için ona yer ayırdık. 16 bitlik işlem
						; Olduğu için 1 tane word ayırdık.
						
;
; Bunların yanında iki tane de kullanıma açık ve pek bir işlevi olmaya 2 segment daha var, bunlar FS ve GS segmentleri
; Bu iki segment'in CS, DS ve SS gibi özellikleri yoktur. İsteğe bağlı kullanım içindirler.
;
