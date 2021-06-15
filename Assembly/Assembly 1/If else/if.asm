[BITS 16]

;
; Diğer programalama dillerinin aksine assembly'de if ve else komutları yok.
; Bunlar yerine karşılaştırma yapan bir OPCODE var: CMP. CMP "Compare"in kısaltılmışıdır. 
; CMP iki OPERAND'ını karşılaştırır ve bir sonuç üretir.
;
; Karşılaştırmanın sonucunu bir değer olarak döndürmez, karşılaştırmanın sonucunu almak
; için yeni bir register'a ihtiyaç duyarız. Bu FLAGS register'ıdır.
;
; FLAGS register'ı da IP (Instruction Pointer) gibi direct olarak erişilemeyen bir register'dır
;
; FLAGS register'ı 16 bitlik sistemlerde 16 bit yani 2 bytetır ve her bir byte'ı başka bir anlama
; gelir, eğer herhangi bir biti 1 ise, o bit temsil ettiği olay gerçekleşmiş demektir. "Reserved" gelecekte
; kullanılmak için saklanmış demektir ve ya şuanki haliyle kullanılmaz veya başka bilgisayarlarda başka anlamları
; olabilir demektir.
;
;                                     FLAGS REGISTER
;    
;      Bit sayısı (ilk bit 0'dır)         Anlamı                  Kısaltması            Açıklama
;     ------------------------------------------------------------------------------------------------------------------------------------------------------
;                 0                     Carry Flag                    CF        Positif sayılarla yapılan matematiksel işlemde 16 bit dışına taşma olmuşsa 1 olur
;                 1                      Reserved           
;                 2                     Parity Flag                   PF        Matematiksel işlemde çıkan sonucun 1 olan bit saysı çift ise parity 1 olur
;                 3                      Reserved 
;                 4                     Adjust Flag                   AF        ----
;                 5                      Reserved
;                 6                     Zero Flag                     ZF        Matematiksel işlemin sonucu 0 ise Zero Flag 1 olur
;                 7                     Sign Flag                     SF        Eğer matematiksel işlemin sonucu negatifse sign flag 1 olur
;                 8        	            Trap Flag                     TF        ----
;                 9                   Interrupt Flag                  IF        ----
;                10                   Direction Flag                  DF        ----
;                11                   Overflow Flag                   OF        Pozitif veya negatif sayılarla yapılan matematiksel işlemde 16 bit'in dışına çıkılarak pozitifin negatife dönmesi yani 16 bit dışına taşmasıyla overflow 1 olur
;              12-13                IO Privelege Level               IOPL       ----
;                14                  Nested Task Flag                 NT        ----
;                15                      Reserved            
;
; CMP OPCODE'u karşılaştırma yaptıktan sonra bu flaglerin bir veya birkaçını 1 yapar, 
; yani "set"ler, veya 1 değerini 0 yapar, yani "clear"lar.
; 
; Bu flaglerin değerlerini kontrol ederek yaptığımız karşılaştırmanın sonucunu alabilir ve
; sonuca göre belli label'lara gidebiliriz. 
;
; Assembly dili bunu kolaylaştırmak için label'a gitme ve kontrol etme işini conditional jumplar
; kullanarak birleştirir. Toplam 15 tane conditional jumpımız var.
;
;              OPCODE'un adı         Anlamı                         Test ettiği flagler
;
;                JZ, JE           Jump if zero/if equal                     ZF
;                JNZ, JNE         Jump if not zero/if not equal             ZF
;                JC               Jump if carry                             CF
;                JNC              Jump if not carry                         CF
;                JO               Jump if overflow                          OF
;                JNO              Jump if not overflow                      OF
;                JS               Jump if signed                            SF
;                JNS              Jump if not signed                        SF
;                JP, JPE          Jump if parity/ even parity               PF
;                JNP, JPO         Jump if not parity/ odd parity            PF
;                JCXZ             Jump if cx is 0                           CX (REGISTER)
;                JG, JNLE         Jump if greater/if not less or equal      OF, SF, ZF
;                JGE, JNL         Jump if greater equal/ if not less        OF, SF
;                JL, JNGE         Jump if less/if not greater or equal      OF, SF
;                JLE, JNG         Jump if less equal/if not greater         OF, SF, ZF
;
; Örneğin 3 sayının en büyüğünü bulmaya çalışalım
;



global start

start:
	mov al, [number1]
	mov dl, [number2]
	mov cl, [number3]
	
	cmp al, dl          ; karşılaştır
	jge greater         ; eğer AL, DL'den büyükse veya AL, DL'ye eşitse greater'a git
	
	cmp dl, cl          ; Eğer değilse DL büyüktür, o yüzden DL ile CL ye karşılaştır
	jge greater3        ; Eğer DL büyükse en büyük DL'dir
	
	mov [max], cl       ; En büyük CL'dir
	
	jmp $
	
greater:

	cmp al, cl          ; Eğer AL, CL'den büyükse veya ona eşitse
	jge greater2        ; En büyük AL'dir
	
	mov [max], cl       ; En büyük CL'dir
	
	jmp $
	
greater2:
	
	mov [max], al       ; En büyük AL'dir
	
	jmp $
	
greater3:
	
	mov [max], dl       ; En büyük DL'dir
	
	jmp $

number1: db 0x50
number2: db 0x35
number3: db 0x4F

max: resb 1


; Bunu C kodunda şöyle de yazabiliriz
;
;     if(number1 >= number2)
;     {
;         if(number1 >= number3) max = number1; 
;         else max = number3;
;     }
;     else if(number2 >= number3)
;     {
;          max = number2;
;     }
;     else max = number3;



