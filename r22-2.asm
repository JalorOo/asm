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
		
		call get_color
;=================================
get_color:	mov ah,0
			int 16h
			
			mov ah,1
			cmp al,'r'
			je red
			cmp al,'g'
			je green
			cmp al,'b'
			je blue
			jmp get_color
			
			ret
			
red:		shl ah,1
green:		shl ah,1

blue:		mov bx,0b800h
			mov es,bx
			mov bx,1
			
			mov cx,2000
			
setColor:	and byte ptr es:[bx],11111000b
			or es:[bx],ah
			add bx,2
			loop setColor
			
			jmp get_color
			
getColorRet:		mov ax,4c00h
					int 21h
					

code ends

end start

