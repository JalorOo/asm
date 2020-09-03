assume cs:code



code segment



		mov ax,0FFFFH
		mov ds,ax

		mov ax,20H
		mov es,ax

		mov bx,0
		mov cx,8

setNumber:	push ds:[bx]
		pop es:[bx]
		add bx,2
		
		loop setNumber


		mov ax,4C00H
		int 21H



code ends



end
