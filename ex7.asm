assume cs:code,ds:data,ss:stack

data segment


		db	'1975','1976','1977','1978','1979','1980','1981','1982','1983'
		db	'1984','1985','1986','1987','1988','1989','1990','1991','1992'
		db	'1993','1994','1995'
		;以上是表示21年的21个字符串 year


		dd	16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514
		dd	345980,590827,803530,1183000,1843000,2759000,3753000,4649000,5937000
		;以上是表示21年公司总收入的21个dword数据	sum

		dw	3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037,5635,8226
		dw	11542,14430,15257,17800

		;employee


data ends

table segment
					;0123456789ABCDEF
		db	21 dup ('year summ ne ?? ')
table ends


stack segment stack
		db	128 dup (0)
stack ends



code segment
start:	mov ax,stack
		mov ss,ax
		mov sp,128			;设置栈


		mov bx,data
		mov ds,bx			;设置数据段

		mov bx,table
		mov es,bx			;设置数据输出

		mov si,0			;年份
		mov di,4*21			;营业额
		mov bx,4*21*2		;员工数
		mov bp,0
		
		mov cx,21			;循环21次
		
setData:	push ds:[si]		;修改年份
			pop es:[bp]
			push ds:[si+2]
			pop es:[bp+2]
		
			mov ax,ds:[di]		;低位字节
			mov dx,ds:[di+2]	;高位字节，修改营业额
			mov es:[bp+5],ax
			mov es:[bp+7],dx
			
			push ds:[bx]
			pop es:[bp+10]		;修改员工数
			
			div word ptr ds:[bx]
			
			mov es:[bp+0DH],ax	;修改平均工资
			add si,4
			add di,4
			add bx,2
			add bp,16
			
		
			loop setData




		mov ax,4C00H
		int 21H



code ends



end start
