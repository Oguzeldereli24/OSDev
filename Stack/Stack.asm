[BITS 16]

; Programlar kullanıcakları bilgileri depolamak ve daha sonra kullanılabilecek halde tutmak için bir sürü
; yapı kullanırlar. Stack bunlardan biridir.

; Stack RAM'in herhangi bir yerinden başlayıp AŞAĞI doğru büyüyen bir veri depolama yapısıdır.
; AŞAĞI doğru büyümek, RAM'de yukarıda bir adresde başlayıp, içine veri ekledikçe aşağıya doğru artmak demek
; Örneğin:

;
;         +---------------------------+         0x......
;         |                           |
;         |      Burada başka         |         Burası önemli değil, burası programımız dışına çıkıyor
;         |      Programlar           |
;         |      Var                  |
;         |                           |
;         +---------------------------+         0x2FFFFFFF
;         |                           |
;         |                           |         Stackimiz yukarıdaki adresten başlıyor fakat yeni eklenecek bilgiler onun daha
;         |                           |         Yukarısında bulunan adreslere konmuyor, yeni gelen bütün bilgiler Bu ama
;         |        Stack              |         aşağı doğru ekleniyor Örnepin İki bytelık bir veri koyarsak buraya o veri
;         |                           |			0x2FFFFFFE adresinde bulunuyor. 1 byte'ı 0x2FFFFFFF'de, diğeri 0x2FFFFFFE'de
;         |                           |
;         |                           |
;         +---------------------------+         0x20000000
;         |                           |
;         |        Boş alan           |         Stack burada başlamıyor, ama şu anki stack'imize yeni bilgi eklendiğindde 
;         |        Stack için         |         bu bölgenin en tepesine eklenecek ve böylece aşağı doğru genişleyecek.
;         |                           |
;         +---------------------------+         0x10000000
;         |                           |
;         |       Programımız         |          Örneğin programımız buradan başlasın ve 1 MB uzunlunda olsun, 1MB = 0x10000000
;         |                           |
;         +---------------------------+         0x00000000
;
; Stack assembly'de çok kullanılan bir veri yapısı ve bunu kullanmak için bir takım register ve opcode'umuz var
;
;

; 
; Registerlar : SP, BP
; 

;
; SP, Stack Pointer'ın kısaltılmışıdır ve Stack'de bulunan en son veri'nin RAM adresini içerir
; BP, Base Pointer'ın kısaltılmışıdır ve Stack'in üst adresini yani başladığı yerin RAM adresini tutar.
; Diğeri tüm registerlar gibi bunlar da MOV, ADD, SUB gibi OPCODE'larla kullanılabilirler
;

mov sp, 0x9000
mov bp, sp
;
; OPCODE : PUSH, POP
;

;
; Stack'teki veriye erişmenin ve stack'e veri koymanın en kullanılabilir yolu PUSH ve POP opcodelarıdır.
; Stack LIFO yani "Last In First Out" yapısıdır. Yani stack'e en son koyduğumuz şey, stack'ten alıcağımız ilk şeydir.
; Bunu bi kağıt yığını olarak da düşünebiliriz. Depolamak istediğimiz bilgileri kağıtlara yazıp bir yere üst üste 
; koyduğumuzu düşünün. En üstteki kağıt, yani ulaşması en kolay kağıt, en son yazdığımız kağıttır. Ondan önce
; yazdığımız kağıtlara ulaşabilmek için ilk önce onların üstündeki kağıtları almamız lazımdır.
;
; Aynısı stack içinde geçerli, en kolay ulaştığımız bilgi Stack'in en sonuna koyduğumuz bilgidir. Ondan önceki bilgilere
; ulaşmak için en sondaki de dahil bütün bilgileri almamız lazımdır.
;

;
; Stack'le işlem yapmak için iki tane OPCODE'umuz var POP ve PUSH
; PUSH: Stack'in sonuna bir bilgi depolar
; POP: Stack'in en sonundaki bilgiyi başka bir yere aktarırır, taşır veya alır. 
; Hem POP, hem de PUSH sp'nin değerini gerekli biçimde değiştirir. POP sp'nin değerini arttırır
; PUSH ise azaltır
; Örneğin:
;

mov sp, 0x9000
mov bp, sp          

; Stack'imizi RAM'de 0x9000 addresine koyduk

mov ax, 0x90FD

; ax registerına bir değer koyduk

push ax

; Stack'imizin sonuna ax'de bulunan değeri koyduk, yani şu an 0x9000 adresinde 0x90, 0x8FFF adresinde 0xFD değeri var
;
;				Buna endianness denir. Endianness bilginin RAM'de hangi sırayla saklanacağını belirtir.
;				İki türü vardır, Little endian ve Big endian
;               Little Endian'da en küçük byte en küçük RAM adresinde saklanır
;               Big Endian'da en küçük byte en büyük RAM adresinde saklanır
;
;               Örneğin 0xFE641D3C sayısını RAM'e Little endian formatında koyarsanız
;               
;               0x00 adresinde 0x3C
;               0x01 adresinde 0x1D
;               0x02 adresinde 0x64
;               0x03 adresinde 0xFE
;   
;               bulunur. Yani RAM'de bu sayının byteları ters gözükür: 3C 1D 64 FE
;
;              	Big Endian'da bunun tam tersi olur:
;              
;				0x0 adresinde 0xFE
; 				0x1 addresine 0x64
;				0x2 adresinde 0x1D
; 				0x3 addresine 0x3C
;
;				bulunur.
;
; 				Modern bilgisayar sistemleri her zaman Little Endian kullanır.
;

;
; Daha önce Stack'e koyduğumuz değeri almak için de:
;

pop bx

;
; Bu stack'in sonundaki değeri bx register'ına koyar. Yani bx'de artık 0x90FD değeri vardır.
;

;
; Stack'i geçici değişkenleri depolamak için kullanırız. 
;