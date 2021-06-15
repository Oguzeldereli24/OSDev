[BITS 16]

;
; Bilgi depolamak ve bu verilere erişmek için sadece Stack'i kullanmayız
; Diğer programlama dillerine benzer olarak assembly'de de değişkenler bulunur
;

;
; Diğer programlama dillerinin aksine assembly'de data type diye bir şey yoktur
; Bütün değişkenler hexadecimal olarak saklanır, int, char gibi türler yoktur
; her şey byte olarak depolanır
;

;
; Temel olarak 5 türü vardır değişkenlerin
; 
; byte = 1 byte
; word = 2 byte
; double word = 4 byte
; quad word = 8 byte
;

;
; Bu türlerin her biri için bir direktif vardır. Direktif OPCODE yani CPU'nun çalıştırdığı kod değildir. 
; Derleyicimize, yani compiler'ımıza komut verir ve değerle ne yapması gerektiğini söyler. CPU ya vermez komutu.
; db, dw, dd, dq en fazla kullanılan değişken tanımlama direktifleridir. 
; Başlarındaki d "define"'ın kasıltılmışıdır.
;
; byte = 1 byte: db. Define Byte demektir.
;

db 0x05

; word = 2 byte: dw Define Word

dw 0x90FD

; double word = 4 byte: dd Define double word

dd 0x5F4C9DFE

; quad word = 8 byte: dq define quad word

dq 0x8D9E1A260A6C7E4D


; Programlar yukardıan aşağı okunduğu için bu direktiflerin yerleştirildiği 
; yerler orada bulunan RAM adresine koyulur. Yani program 0x00000000 adresinden
; başlıyorsa ve oraya

dw 0xFFEE

;
; konulursa bu durumda 0x00000000 RAM adresinde 0xEE, 0x00000001 RAM adresinde 0xFF bulunur
; Bunun nedeni modern sistemlerin bilgileri little Endian formatıyla depolamasıdır.
;

;
; Ayrıca bazı durumlarda tam olarak bu byte sınırlamalarına uymayabiliriz
; Örneğin bir string yani yazı depolarken direkt olarak böyle yapılabilir
;

db "Hello"

;
; Fakat buradaki her bir karakteri 1 byte olarak tanımlayacağımız için Little Endian yoktur
; Little endian 1 byte'tan büyük verilerin depolama formatlarını gösterir
; Burada "Hello" string'i RAM'e düz bir şekilde yerleştirilir ve ters döndürülmez. 
;

; Ayrıca birden fazla byte virgül ile ayrılarak yazılabilir

db 0x57, 0x7D, 0x83, 0x57, 0x83

dw 0x5770, 0x7D83, 0x5770, 0x83FE

;
; İkinci satırda her bir word için Little Endian geçerlidir.
;
; Bu değişkenlere erişmek için onlara bir label kullanarak isim verebiliriz
; Öteki türlü onların direkt RAM adreslerini bilmemiz gerekir, yani imkansızdır.
;
; Örneğin şöyle bir C kodumuz olsun:
;
;     short abc = 16;
;     short cde = 20;
;     short def = abc + cde;
;
; Bunun assembly versiyonu şuna benzer bir şey olabilir
;

abc: dw 0x0010
cde: dw 0x0014
def: dw ?          ; Değerini bilmiyorsak ? koyabiliriz

mov ax, abc
mov bx, cde
add ax, bx
mov [def], ax

;
; Burada yeni bir operatörümüz var 
; [] köşeli parantez, C'deki * yani pointer operatörüne neredeyse eşdeğerdir  
; [adres], içinde bulunan RAM adresindeki değeri alır veya bu RAM' adresindeki değeri gösterir.
; def bir label olduğundan dolayı bulunduğu kod satırının adresini tutar.
; [def] def'in tuttuğu adresin içindeki değer demektir.
; Böylece "mov [def], ax" def'in içinde tuttuğu RAM adresindeki yerin değerini, ax yap; demektir.
;

;
; Eğer bir değişkenin değeri bilinmiyorsa ve bu değişken için yer ayrılmak isteniyorsa RESB direktifi
; kullanılr. RESB, reserve byte'ın kısaltılmışıdır ve RESW, RESD, RESQ gibi alternatifleri vardır.
; RES direktifinden sonra o veri büyüklüğünden kaç tane ayırtılacağı belirtir.
; RES direktifinden önce yine bir label eklenebilir.
;

tablo: resb 64 ; 64 byte'lık yer ayırır
alan: resw 64 ; 64 word'lük yer ayırır yani toplam 128 byte.
			  ; Her 2 byte da Little Endian'a göre formatlanır.

; 
; Değişmez, yani constant değişkenler için EQU direktifini kullanırız
;

constant equ 0x50

;
; constant değeri bir label değildir ve bir RAM adresi tutmaz. Bundan sonra constant değerini
; kullandığımız her yerde, constant silinir ve yerine 0x50 yazılır. Bunu compiler otomatik olarak
; yapar, programı derlerken. Örneğin:
;

mov ax, constant         ; ax'e 0x50 değerini koyar
mov constant ax          ; Böyle bir şey yok, hatalıdır
						 ; Constantlar değiştirilemez
						 
; 
; Birden fazla byte'ı aynı yerde tanımlamak istersek TIMES direktifini kullanabiliriz. Örneğin
;

times 128 db 0xFF  ; buraya 128 tane 0xFF yerleştirir.













