;题目：让a中的前8个字型数据逆序放到b中
assume cs:code

a segment
	dw 1,2,3,4,5,6,7,8,0AH,0BH,0CH,0DH,0FH,0EH
a ends

b segment
	dw 0,0,0,0,0,0,0,0
b ends

code segment

start:	mov ax,b
	mov ss,ax
	mov sp,10H ;set stackSegment

	mov bx,0
	mov ax,a
	mov ds,ax ;setDataFrom
	
	mov cx,8
	
movFun:	push ds:[bx]
	inc bx
	inc bx
	loop movFun
	
	
	mov ax,4C00H
	int 21H

code ends

end start
