assume cs:code,ss:stack,ds:data

data segment
	db 128 dup(0)
data ends

stack segment
	db 128 dup(0)
stack ends

code segment

start:	
		mov ax,stack
		mov ss,ax
		mov sp,128
		
		call clean_screen
		
		call init_reg
time:	
		mov al,9; 读取年
		mov di,160*10 + 25*2
		call show
		mov al,8; 读取月
		mov di,160*10 + 28*2
		call show
		mov al,7; 读取日
		mov di,160*10 + 31*2
		call show
		mov al,4; 读取时
		mov di,160*10 + 34*2
		call show
		mov al,2; 读取分
		mov di,160*10 + 37*2
		call show
		mov al,0; 读取秒
		mov di,160*10 + 40*2
		call show
		jmp time
		
		mov ax,4c00h
		int 21h
;================================	
clean_screen:
					mov bx,0B800H;
					mov es,bx
					mov bx,0
					
					mov dx,0700H ;空字符串
					mov cx,2000
					
					
clearScreen:		mov es:[bx],dx
					add bx,2
					
					loop clearScreen
					
					ret
		
;=================================
init_reg:
		mov bx,0b800h
		mov es,bx
		
		ret
		
;=================================
show:
		out 70h,al
		in al,71h
		
		mov ah,al
		mov cl,4
		shr ah,cl
		and al,00001111b
		
		add ah,30h
		add al,30h
		
		mov es:[di],ah
		mov es:[di+2],al
		
		ret

code ends

end start

