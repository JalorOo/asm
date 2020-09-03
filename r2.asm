assume cs:code,ss:stack,ds:data

data segment

	dd 1000000

data ends

stack segment

	db 128 dup(0)

stack ends

code segment

	start:		mov ax,data
				mov ds,ax
				
				mov ax,stack
				mov ss,ax
				mov sp,128
				
				
				mov bx,0
				mov ax,ds:[bx+0]
				mov dx,ds:[bx+2]
				
				mov cx,10
				
				call long_div
				
				mov ax,4c00H
				int 21H
				
;=======================================
long_div:		
				push ax
				mov ax,dx
				mov dx,0
				div cx
				
				mov bx,ax  ;h ans
				pop ax
				div cx
				
				mov cx,dx
				mov dx,bx
				
				ret

code ends

end start

