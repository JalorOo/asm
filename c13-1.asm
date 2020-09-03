assume cs:code,ds:data,ss:stack

data segment

	db 128 dup(0)

data ends

stack segment stack

	db 128 dup(0)

stack ends

code segment

start:	mov ax,stack
		mov ss,ax
		mov sp,128;initial stack
		
		call cpy_new_int0
		call set_new_int0
		
		int 0
		
		mov ax,4c00h
		int 21h
;=============change the int 0 cs:ip================
set_new_int0:
				
				mov bx,0
				mov es,bx
				
				cli
				mov word ptr es:[0*4],7e00h
				mov word ptr es:[0*4+2],0
				sti
				ret
;===================keyboard interupt===============
new_int0:		
				push bx
				push cx
				push dx
				push es
				
				mov bx,0b800h
				mov es,bx
				
				mov bx,0
				mov cx,2000
				mov dl,'!'
				
show_asc:		mov es:[bx],dl
				add bx,2
				loop show_asc
				
				pop es
				pop dx
				pop cx
				pop bx
				iret
				
new_int0_end:	nop
		
;===============modified int 0===================
cpy_new_int0:	
				mov bx,cs
				mov ds,bx
				mov si,offset new_int0;set source
				
				mov bx,0
				mov es,bx
				mov di,7e00h;set determination--which can save code securily
				
				mov cx,offset new_int0_end - new_int0
				cld
				rep movsb;cpy the code
				
				ret
		
;==================================
show_char:	
			ret

code ends

end start