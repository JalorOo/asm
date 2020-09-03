assume cs:code,ds:data,ss:stack

data segment 

			;0123456789ABCDEF
		
		db	'1. display      '
		db	'2. brows        '
		db	'3. replace      '
		db	'4. modify       '
		
data ends

stack segment

		dw 0,0,0,0
		dw 0,0,0,0
		dw 0,0,0,0
		dw 0,0,0,0
	
stack ends

;实验六

code segment

start:	mov ax,stack
		mov ss,ax
		mov sp,32;栈顶标记
		
		mov ax,data
		mov ds,ax
		
		mov bx,0
		
		mov cx,4
		
upRow:		push cx
			mov cx,4
			mov di,0
		
upLetter:	mov al,ds:[bx+di+3]
			and al,11011111B
			mov ds:[bx+di+3],al
			inc di
			loop upLetter
			
			add bx,10H
			pop cx
			loop upRow
			
			mov ax,4C00H
			int 21H

code ends

end start
		
