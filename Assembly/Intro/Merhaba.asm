
[BITS 16]

start:
	
	mov ax, 0x10
	mov bx, 0x05
	
	call label1
	
	sub bx, 0x01
	
	jmp $
	
	; ax = 0x10
	; bx = 0x14

label1:
	
	add bx, ax 
	ret ; return
	
	