;让a与b的每个数字相加，把结果放到c上
assume cs:code

a segment
	db 1,2,3,4,5,6,7,8
a ends

b segment
	db 1,2,3,4,5,6,7,8
b ends

c segment
	db 0,0,0,0,0,0,0,0
c ends

code segment

start:		

		mov ax,c
		mov es,ax ;data to

		mov bx,0 ;initial the excursion address
		mov cx,8 ;loop 8 times

addNumber:	mov ax,a
		mov ds,ax ;data form

		mov dl,ds:[bx]
		
		mov ax,b
		mov ds,ax

		add dl,ds:[bx]
		
		mov es:[bx],dl

		inc bx
		loop addNumber

		mov ax,4C00H
		int 21H

code ends

end start
