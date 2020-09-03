assume cs:code,ds:data,ss:stack
;仿loop指令
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
		
		call cpy_new_7ch
		call set_new_7ch
		
		call init_reg
		
		mov di,160*12
		mov cx,80
		
		mov bx,offset s - se
		
s:		mov byte ptr es:[di],'!'
		add di,2
		
		int 7ch;loop 标号处地址 - loop指令后第一个指令的地址
		
se:     nop
		
		mov ax,4c00h
		int 21h
		
;===================init_reg====================
init_reg:
				mov bx,0b800h
				mov es,bx
				
				
				ret
;=============change the int 0 cs:ip================
set_new_7ch:
				
				mov bx,0
				mov es,bx
				
				cli
				mov word ptr es:[7ch*4],7e00h;low address
				mov word ptr es:[7ch*4+2],0;hight address
				sti
				ret
;===================keyboard interupt===============
new_7ch:		
				push bp
				mov bp,sp
				dec cx
				jcxz new_7chRet
				
				; bp ip cs pushf
				add ss:[bp+2],bx
				
new_7chRet:		pop bp
				iret
				
new_7ch_end:	nop
		
;===============modified int 7ch===================
cpy_new_7ch:	
				mov bx,cs
				mov ds,bx
				mov si,offset new_7ch;set source
				
				mov bx,0
				mov es,bx
				mov di,7e00h;set determination--which can save code securily
				
				mov cx,offset new_7ch_end - new_7ch
				cld
				rep movsb;cpy the code
				
				ret
		
;==================================
show_char:	
			ret

code ends

end start