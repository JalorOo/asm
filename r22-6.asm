assume cs:code,ss:stack,ds:data
;课题实验二

data segment
	db 128 dup(0)
data ends

stack segment stack
	db 128 dup(0)
stack ends

code segment

start:			mov ax,stack
				mov ss,ax
				mov sp,128
		
				call cpy_boot
				
				;设置新的cs:ip
				mov bx,0
				push bx
				mov bx,7e00h
				push bx
				retf
		
				mov ax,4c00h
				int 21h
				
;===================================
boot:
				jmp boot_start
			
;******************************************************	
;******************************************************	
;******************************************************			
OPTION_1		db	'1) restart pc',0
OPTION_2		db	'2) start system',0
OPTION_3		db	'3) show clock',0
OPTION_4		db	'4) set clock',0

ADDRESS_OPT		dw	offset OPTION_1 - boot + 7e00h
				dw	offset OPTION_2 - boot + 7e00h
				dw	offset OPTION_3 - boot + 7e00h
				dw	offset OPTION_4 - boot + 7e00h

;******************************************************	
;******************************************************	
;******************************************************	
				
boot_start:		
				call init_reg
				call clear_screen
				call show_opt
				jmp choose_opt
				
				mov ax,4c00h
				int 21h
;===================================
choose_opt:		call clear_buff
				
				mov ah,0
				int 16h
				
				cmp al,'1'
				je isChooseOne
				cmp al,'2'
				je isChooseTwo
				cmp al,'3'
				je isChooseThr
				cmp al,'4'
				je isChooseFour
				
				jmp choose_opt
				
;===================================
isChooseOne:
				mov di,160*3
				mov byte ptr es:[di],'1'
				
				jmp choose_opt
;===================================
isChooseTwo:
				mov di,160*3
				mov byte ptr es:[di],'2'
				
				jmp choose_opt
;===================================
isChooseThr:
				mov di,160*3
				mov byte ptr es:[di],'3'
				
				jmp choose_opt
;===================================
isChooseFour:
				mov di,160*3
				mov byte ptr es:[di],'4'
				
				jmp choose_opt
;===================================
clear_buff:		mov ah,1
				int 16h
				jz	clearBuffRet
				
				mov ah,0
				int 16h
				
				jmp clear_buff
				
clearBuffRet:	
				ret
;===================================
show_opt:		
				mov bx,offset ADDRESS_OPT - boot + 7e00h
				mov cx,4
				mov di,160*10 + 30*2
				
showOpt:		mov si,ds:[bx]
				call show_str
				add bx,2
				add di,160
				loop showOpt
				ret
				
;===================================
;显示字符串
show_str:		
				push dx
				push di
				push si
				
showStr:		mov dl,ds:[si]
				cmp dl,0
				je showStrRet
				mov es:[di],dl
				add di,2
				inc si
				jmp showStr
				
showStrRet:		
				pop si
				pop di
				pop dx
				ret
;===================================
clear_screen:	
				mov bx,0
				mov dx,0700h
				mov cx,2000
				
clearScreen:	mov es:[bx],dx
				add bx,2
				loop clearScreen
				ret
;===================================
;初始化ds、es
init_reg:		
				mov bx,0b800h
				mov es,bx
				
				mov bx,0
				mov ds,bx
				ret
				
				
boot_end:		nop




;=============================
;复制启动项到0:7e00h
cpy_boot:	
				mov bx,cs
				mov ds,bx
				mov si,offset boot
			
				mov bx,0
				mov es,bx
				mov di,7e00h
			
				mov cx,offset boot_end - offset boot
				cld
				rep movsb
				ret
code ends

end start

