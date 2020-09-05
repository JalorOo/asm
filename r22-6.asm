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
				call sav_old_int9
				
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

ADDRESS_OPT		dw	offset OPTION_1 - offset boot + 7e00h
				dw	offset OPTION_2 - offset boot + 7e00h
				dw	offset OPTION_3 - offset boot + 7e00h
				dw	offset OPTION_4 - offset boot + 7e00h
				
TIME_CMOS		db	9,8,7,4,2,0
TIME_STYLE		db	'YY/MM/DD HH:MM:SS',0

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
				call show_clock
				
				jmp boot_start
;===================================
isChooseFour:
				mov di,160*3
				mov byte ptr es:[di],'4'
				
				jmp choose_opt
				

;===================================
;显示时间
show_clock:		
				call show_style
				call set_new_int9
				
				mov bx,offset TIME_CMOS - offset boot + 7e00h
				
showTime:		mov si,bx
				mov di,160*20
				mov cx,6
				
showDate:		mov al,ds:[si]
				
				out 70h,al
				in al,71h
				
				mov ah,al
				shr ah,1
				shr ah,1
				shr ah,1
				shr ah,1
				and al,00001111b
				
				add ah,30h
				add al,30h
				
				mov es:[di],ah
				mov es:[di+2],al
				
				add di,6
				inc si
				
				loop showDate
				
				jmp showTime
				
				ret
;==================================		
showTimeRet:	
				call set_old_int9
				ret
;===================================
;设置回原来的int9
set_old_int9:	
				push bx
				push es
				mov bx,0
				mov es,bx
				
				cli
				push es:[200h]
				pop es:[9*4]
				push es:[202h]
				pop es:[9*4+2]
				sti
				
				pop es
				pop bx
				ret
;===================================
;设置新的int9
set_new_int9:		
				push bx
				push es
				
				mov bx,0
				mov es,bx
				
				cli
				mov word ptr es:[9*4],offset new_int9 - offset boot + 7e00h
				mov word ptr es:[9*4+2],0
				sti
				
				pop es
				pop bx
				ret
;=====================================
;新的int9的内容			
new_int9:		
				push ax
				
				call clear_buff
				
				in al,60h
				pushf
				call dword ptr cs:[200h]
				
				cmp al,01h
				je isEsc
				
				cmp al,3bh
				jne int9Ret
				call change_time_color
				
int9Ret:		pop ax
				iret
;===================================			
isEsc:			
				pop ax
				add sp,4
				popf
				jmp showTimeRet
;===================================
;改变时间的颜色			
change_time_color:

				push bx
				push cx
				push es
				
				mov bx,0b800h
				mov es,bx
				mov bx,160*20+1
				
				mov cx,17
				
changeTimeColor:
				inc byte ptr es:[bx]
				add bx,2
				loop changeTimeColor
				
				pop es
				pop cx
				pop bx
				ret							
;===================================
show_style:		
				mov si,offset TIME_STYLE - offset boot + 7e00h
				mov di,160*20
				
				call show_str
				ret
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
;清理屏幕上的内容
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
sav_old_int9:	mov bx,0
				mov es,bx
				
				push es:[9*4]
				pop es:[200h]
				push es:[9*4+2]
				pop es:[202h]
				
				ret
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

