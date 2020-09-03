assume cs:code,ss:stack,ds:data

data segment
	db 128 dup(0)
data ends

stack segment stack
	db 128 dup(0)
stack ends

code segment

start:	
		mov ax,stack
		mov ss,ax
		mov sp,128
		
		call cpy_new_int9
		call sav_old_int9
		call set_new_int9
		
		
		mov ax,4c00h
		int 21h
		
		
		
;==================================
set_new_int9:
			push bx
			push es
			mov bx,0
			mov es,bx
			
			cli
			mov word ptr es:[9*4],7e00h
			mov word ptr es:[9*4+2],0
			sti
			
			pop es
			pop bx
			ret
;=================================
sav_old_int9:
			mov bx,0
			mov es,bx
			
			cli
			push es:[9*4]
			pop es:[200h]			;int 9 ip
			push es:[9*4+2]
			pop es:[202h]			;int 9 cs
			sti
			ret
;=================================
new_int9:	
			push ax
			in al,60h
			pushf
			call dword ptr cs:[200h]   ;cs = 0
			
			cmp al,48h
			je isUp
			cmp al,39h
			jne int9Ret
			call screen_color_change

int9Ret:	
			pop ax
			iret

new_int9_end:	nop

;=================================
isUp:		mov bx,0b800h
			mov es,bx
			mov di,160*10+40*2
			mov byte ptr es:[di],'U'
			jmp int9Ret
;=================================
screen_color_change:

				push bx
				push cx
				push es
				mov bx,0b800h
				mov es,bx
				mov bx,1
				
				mov cx,2000
				
changeColor:	inc byte ptr es:[bx]
				
				add bx,2
				
				loop changeColor
				
				pop es
				pop cx
				pop bx
				ret
;=================================
init_reg:
		mov bx,0b800h
		mov es,bx
		
		ret
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

