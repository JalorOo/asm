assume cs:code,ds:data,ss:stack

;编程：在屏幕中间分别显示 绿色、绿底红色、白底蓝色的字符串‘welcome to masm!’
data segment
	   ;0123456789ABCDEF
	db 'welcome to masm!'
	   ;0000 0000
	   ; rgb  rgb
	db  00000010B
	db	00100100B
	db  01110001B
data ends

stack segment stack
	db 128 dup(0)
stack ends

code segment

start: 	    
			mov ax,stack ;设置栈段
			mov ss,ax
			mov sp,128
			
			call setup

			call setShow
			
			mov ax,4C00H
			int 21H

;====================================================

setup:		
			mov ax,data ;设置数据段
			mov ds,ax
			
			mov ax,0B800H
			mov es,ax ;设置显示段
			
			ret
;====================================================			
			
setShow:	mov cx,3 ;循环行
			
			mov bx,16;指向颜色
			mov di,160*10+30*2 ;显示字符的位置
			mov si,0 ;读取字符
			
showline:	push cx
			push di
			push si
			mov ah,ds:[bx]
			mov cx,16
			
showNumber:	
			
			mov al,ds:[si]

			
			mov es:[di],ax
			
			inc si
			add di,2
			
			loop showNumber
			
			inc bx;换颜色
			pop si ;字符读取开头
			pop di
			add di,160 ;换行
			pop cx
			
			loop showline

			ret

code ends

end start