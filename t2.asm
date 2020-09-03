assume cs:code,ss:stack,ds:data ;αָ��

data segment
	dw 	0123H,0456H,0789H,0ABCH,0DEFH,0FEDH,0CBAH,0987H
data ends

stack segment stack
	dw 	0,0,0,0,0,0,0,0	
	dw 	0,0,0,0,0,0,0,0
stack ends

code segment

start:		mov ax,stack
		mov ss,ax
		mov sp,32
	
		mov bx,0
		mov cx,8

pushData:	push cs:[bx]
		add bx,2
		loop pushData
		
		
		mov bx,0
		mov cx,8

popData:	pop cs:[bx]
		add bx,2
		loop popData

		mov ax,4C00H
		int 21H		

code ends

end start

