assume cs:code,ss:stack,ds:data
;int16h

data segment
STRING	db 128 dup(0);字符串以零结尾
data ends

stack segment stack
	db 128 dup(0)
stack ends

code segment

start:			mov ax,stack
				mov ss,ax
				mov sp,128
		
				call init_rag
				call clear_screen
				call get_string
		
				mov ax,4c00h
				int 21h
			
;=============================
get_string:	
				mov si,offset STRING
				mov di,160*0;显示位置
			
				mov bx,0;栈顶
			
getString:		mov ah,0
				int 16h
			
				cmp al,20h
				jb notChar
			
				call char_push
				call show_string
			
				jmp getString
			
				ret
			
;=============================
show_string:	
				push dx
				push ds
				push es
				push si
				push di
			
showString:		mov dl,ds:[si]
				cmp dl,0
				je showStringRet
				mov es:[di],dl
				add di,2
				inc si
				jmp showString
			
showStringRet:
			
				mov byte ptr es:[di],0
			
				pop di
				pop si
				pop es
				pop ds
				pop dx
			
				ret
;=============================
char_push:	
				cmp bx,126
				ja charPushRet
				mov ds:[si+bx],al
				inc bx
			
			
;============================
charPushRet:	ret
;=============================
notChar:	
				cmp ah,0eh;扫描码 删除键
				je backspace
				jmp getString
			
;=============================
backspace:
				call char_pop
				call show_string
				jmp getString
			
;=============================
char_pop:
				cmp bx,0
				je charPopRet
				dec bx
				mov byte ptr ds:[si+bx],0
			
;=============================
charPopRet:		ret
;=============================
init_rag:		mov bx,0b800h
				mov es,bx
			
				mov bx,data
				mov ds,bx
				ret
;=====================================
clear_screen:	mov bx,0B800H ;
				mov es,bx
				mov bx,0
					
				mov dx,0700H
				mov cx,2000
					
					
clearScreen:	mov es:[bx],dx
				add bx,2
					
				loop clearScreen
					
				ret
code ends

end start

