assume cs:code,ss:stack,ds:data

data segment
	db 128 dup(0)
data ends

stack segment stack
	db 128 dup(0)
stack ends

code segment

start:	mov ax,stack
		mov ss,ax
		mov sp,128
		
		call cpy_new_int9
		call sav_old_int9
		call set_new_int9
		
t:		mov ax,1000h
		jmp t
		
		mov ax,4c00h
		int 21h
;=================================
set_new_int9:
		mov bx,0
		mov es,bx
		
		cli
		mov word ptr es:[9*4],7e00h
		mov word ptr es:[9*4+2],0
		sti		
		ret
;=================================
sav_old_int9:	
		mov bx,0
		mov es,bx
		
		cli
		push es:[9*4]
		pop es:[200h]
		push es:[9*4+2]
		pop es:[202h]
		sti
		
		ret
;=================================
new_int9:
				push ax
				in al,60h
				pushf
				call dword ptr cs:[200h]
				
				cmp al,9eh
				jne int9Ret
				call set_srceen_letter
				
int9Ret:		pop ax
				iret
				
set_srceen_letter:

				push bx
				push cx
				push dx
				push es
				mov bx,0b800h
				mov es,bx
				
				mov bx,0
				mov dl,'A'
				
setScreenLetter:
				mov es:[bx],al
				add bx,2
				loop setScreenLetter
				
				pop es
				pop dx
				pop cx
				pop bx
				ret

new_int9_end:	nop
;==================================
cpy_new_int9:
		mov bx,cs
		mov ds,bx
		mov si,offset new_int9
		
		mov bx,0
		mov es,bx
		mov di,7e00h
		
		mov cx,offset new_int9_end - offset new_int9
		
		cld
		rep movsb
		
		
		ret

code ends

end start

