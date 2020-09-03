assume cs:code,ss:stack,ds:data
;Q1：设计一个 程序 程序处理 的字符串以 0 结尾 并显示在屏幕上

;Q2: 在屏幕上显示4行字符串 每一行需要换行输出
data segment

		db		'1) restart pc ',0
		db		'2) start system ',0
		db		'3) show clock ',0
		db		'4) set clock ',0

data ends

stack segment stack
				
		db      128 dup(0)
				
stack ends

code segment

start:			mov ax,stack
				mov ss, ax
				mov sp,128
				
				call init_start
				
				mov si,0
				mov di,160*10 + 30*2
				
				call showString
				mov di,160*11 +30*2
				inc si
				call showString
				mov di,160*12 +30*2
				inc si
				call showString
				mov di,160*13 +30*2
				inc si
				call showString
				
				mov ax,4C00H
				int 21H
				
;================================================
showString:		mov cx,0
				
show:			mov cl,ds:[si]
				jcxz nextline
				mov ch,00000010B	;设置颜色
				mov es:[di],cx
				inc si
				add di,2
				jmp showString
								

nextline:		ret
				
;================================================
init_start:		mov ax,data
				mov ds,ax
				
				mov ax,0B800H
				mov es,ax ;设置显示段
				
				ret
code ends

end start