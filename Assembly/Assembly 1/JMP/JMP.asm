[BITS 16]

; Programlar RAM'de bir yere yüklenirler. Nereye yüklendiği bizim için şu anda önemli değil
; Ama başladıkları bir adres vardır, bu adres geçerli bir RAM adresidir, yani 32 bitlik sistemlerde
; 0x00000000 ve 0xFFFFFFFF arasındadır.

; Bunun nedeni 32 bitlik sistemlerde yapabileceğiniz en büyük işlem maksimum 32 bitle yapılabilir.
; 32 bit 4 byte'tır, 4 byte 8 tane hexadecimal sayısı ile yazılabilir.

;          1 hexadecimal sayısı, 0 ile 15 (F) arasında herhangi bir değer alabilir
;          Yani 4 bittir. 4 bitin alabileceği en büyük değer 1111'dir. 1111 = 15
;          Yani 2 hexadecimal sayısı 1 byte'tır. 0xHH = 1 byte, H = herhangi bir hex sayısı.
;          32 bit = 4 byte = 8 hexadecimal
;
;          0x HH HH HH HH = 4 byte, H'nin alabileceği en büyük değer F olduğuna göre maksimum
;          32 bitlik RAM addresi 0xFFFFFFFF'dir, minimum da 0x00000000

; Program yazarken programımızın RAM'de nerede olduğunu bilmemiz çoğu zaman mümkün olmuyor.
; Bilsek bile her şeyi hexadecimal sayılarla yazmamız çok da kolay olmazdı, bu nedenden dolayı
; label'ları kullanıyoruz.

; Label şöyle tanımlanır: "label_adı:", Örneğin:

Label1: 

; Bu label programımızın o noktadaki RAM addresini temsil eder
; Eğer herhangi bir yerin RAM'deki adresini bilirsek, orayla ilgili işlemler yapabiliriz

; Yapabileceğimiz işlemlerden biri orayı çağırmak veya oradaki kodu çalıştırmaktır.
; Bunun için iki tane OPCODE'umuz vardır

; 1. OPCODE JMP
; JMP verilen RAM adresine veya label'a "zıplar". Yani oradaki kodu çalıştırmaya başlar
; 

;
;          Daha önceden konuştuğumuz 6 tane register vardı ya, şimdi bi tane daha ekleyebiliriz
;          IP kullanılmayan bir register'dır. Instruction Pointer'ın kısaltılmışıdır. Biz kullanamayız
;          ama CPU kendi içerisinde kullanılır. Biz IP'ye sadece indirect olarak erişebiliriz.
;          IP register'ı şu anda çalıştırılan kod'un RAM'deki adresini tutar.
;         
;          Eğer IP'nin değeri değişirse CPU o adresde bulunan kodu çalıştırmaya başlar
;          IP'de bulunan kod çalıştırıldıktan sonra CPU IP'ye 1 ekler ve sonraki addressde bulunan
;          kod parçasını çalıştırmaya devam eder
;

; JMP Instruction'ı da IP registerına indirect olarak erişmenin bir yoludur.
; JMP IP'deki değeri 1. Operand'ıyla değiştirir, Örneğin:

mov ax, 0x05

mov bx, ax

jmp Label1

; Varsayalım ki Label1 label'inin RAM'^deki adresi 0x00000000, çünkü programın başı orası.
; Label'den sonraki kod satırı, "mov ax, 0x05"'in RAM'deki addresi hala 0x00000000'dır, çünkü label
; RAM'de bir yer tutmaz, gerçek bir değeri yoktur

; Bundan sonraki kod satırının, "mov bx, ax", RAM'deki adresi ise 0x00000004 varsayalım.
; Programı başlattığımızda IP 0x00000000'dır, bir sonraki kod satırı okur. İlk MOV instruction'unu
; çalıştırır ve AX'e 0x05 değerini koyar. Daha sonra CPU, IP'ye 0x04 ekler.
; 0x04 eklemesinin sebebi, 16 bitlik MOV Komutunun RAM'de 4 byte büyüklüğünde olmasıdır.

; Şimdi IP 0x00000004'dür, CPU burada bulunan "mov bx, ax" komutunu çalıştırır. ve daha sonra IP'ye 
; bir kere daha 0x04 ekler.
; Şimdi jmp Label1 komutuna gelir. Bizim assembler'ımız yani compiler'ımız Label1'i 0x00000000 ile yani
; Label1'in temsil ettiği yer ile değiştirir ve bu komudu jmp 0x00000000 yapar

; Daha sonra CPU, IP registerına 0x00000000 değerini koyar ve buraya zıplayarak buradaki kodu çalıştırmaya
; çalışır. Böylece programımızın en başına dönmüş oluruz. 

