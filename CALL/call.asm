[BITS 16]

;
; Daha önce kullandığımız JMP OPCODE'unun farklı bir versiyonu da CALL'dur.
;

;
; JMP'den farklı olarak CALL ile çağırılan yere geri dönebiliriz.
; Bunu yapabilmek için call çağırıldığı adresi stack'de depolar.
; RET OPCODE'u stack'den 2 byte'lık veri alır ve bu RAM adresine zıplar
; Örneğin add diye bir fonksiyonumuz olsun ve iki parametresi olsun, a ve b
; Bu parametreleri ax ve bx registerlarından alsın ve onları toplasın.
;

addTwoNumbers:
	add ax, bx          		; bx register'ındaki değeri ax'e ekle
	ret                  		; Stack'den geri dönüş adresini al ve dön

; Şimdi başlangıç fonksiyonumuz 

start:
	
	mov ax, 0x05         		; işlemimiz 5 + 7 olsun
	mov bx, 0x07
	
	call addTwoNumbers    		; Stack'e bu adresi koy ve fonksiyona git 
	
	; Burada ax 0x0C olacaktır, 0x05 + 0x07 = 0x0C 
	
	jmp $                 		; $ buranın RAM'deki adresi demektir.
								; loop: jmp loop
								; diye de yazılabilir ve aynı şeye denk gelir		

; Bu kodun aynısı şu şekilde de yazabiliriz ama yukarıdaki gibi daha doğrudur çünkü hatalara izin vermez

addTwoNumbers1:
	add ax, bx            		; AX ve BX'i ekle  
	pop cx                		; Stack'den dönüş adresini al
	jmp cx                		; geri dön
	
start1:
	mov ax, 0x05          	 	; işlemimiz 0x05 + 0x07 olsun
	mov bx, 0x07
	
	mov ax, geriDonusNoktası	; elimizle bir geri dönüş noktası tanımladık çünkü 
								; buranın IP'sine (Instruction Pointer) direkt olarak ulaşamayız
								; Buranın RAM adresini ax'e koy
	push ax                 	; ax değerini Stack'e koy
	jmp addTwoNumbers1      	; Fonksiyona git
	
geriDonusNoktası:           	; Buraya geri dön
	
	jmp $                    	; Sonsuz loopa gir, öl.

						  