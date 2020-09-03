;课程设计1
assume cs:code,ss:stack,ds:data

data segment
		dw 1234
data ends

stack segment stack
		
		db 128 dup(0)
		
stack ends

code segment

start:		mov ax,stack	;set the stack
			mov ss,ax
			mov sp,128
			
			mov ax,data
			mov ds,ax
			mov si,0	;set the data source
			
			mov ax,0B800H	;set the data destination
			mov es,ax
			mov di,160*10
			add di,40*2
			
			mov ax,ds:[si]	;set the dilidend
			mov dx,0	;clear the remainder
			
			call short_div	;function
			
			mov ax,4C00H
			int 21H
			
;=========================================
short_div:	mov cx,10
			div cx
			add dl,30H
			mov es:[di],dl
			mov cx,ax
			jcxz short_divRet
			mov dx,0	;clear the remainder
			sub di,2	;back forward
			jmp short_div
			
short_divRet:	ret

code ends
end start