assume cs:code,ss:stack,ds:data

data segment stack
		db 128 dup(0)
data ends

stack segment stack
		db 128 dup(0)
stack ends

String segment
			;0123456789
		db 	'0000000000'

String ends

code segment
				

start:			mov bx,stack
				mov ss,bx
				mov sp,128
				
				mov di,160*3+20*2
				mov si,9
				
				mov ax,16
				mov dx,0
show_div:		mov cx,10
				call long_div
				call save_num
				mov cx,ax
				jcxz Finish
				jmp show_div
				
Finish:
				call show_string
				mov ax,4c00h
				int 21H

;=====================================
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
				
									
;=====================================
save_num:		
				push bx
				push es
				mov bx,String
				mov es,bx
				
				add cl,30H
				mov es:[si],cl
				dec si
				
				pop es
				pop bx
				ret	
				
;=====================================

show_string:	
				push bx
				push es
				inc si
				mov bx,String
				mov ds,bx

				mov bx,0B800H
				mov es,bx
				
showString:		mov dl,ds:[si]
				
				mov es:[di+0],dl
				mov byte ptr es:[di+1],00000010B
				
				add di,2
				mov cx,9
				sub cx,si
				inc si
				inc cx
				loop showString
				
				pop es
				pop bx
				ret

code ends

end start