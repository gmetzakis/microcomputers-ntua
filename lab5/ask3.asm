new_line macro
    print 0ah        
    print 0dh     
endm   

print_str macro string 
    mov dx, offset string
    mov ah, 9
    int 21h
endm       

print macro char
    mov dl, char
    mov ah, 2
    int 21h
endm
   
   
data segment             
    X_print   db  "X=",'$'    
    Y_print   db  "Y=",'$'
    ADD_print   db  "X+Y=",'$'
    SUB_print   db  "X-Y=",'$'   
ends

stack segment
    dw   128  dup(0)
ends

code segment
start:
    mov ax, data
    mov ds, ax
    mov es, ax
    
main proc far    
     
    mov cl, 00h; 
loop: 
    call read_num   
    mov ah, 00h
    push ax 
    inc cl          ; cl++   
    cmp cl, 04h     ;otan ginei 4, exw 4 egkira pathmena
    jz  print_results
    jmp loop
   
           

print_results: 
     new_line 
     print_str Y_print
     pop bx          
     pop cx         
     mov dl, cl     
     call print_bin
     mov dl, bl
     call print_bin  
                    ;EDW EXW STON BL TO LOW TOU Y
                    ;KAI STON CL TO HIGH TOU Y
     mov al, cl
     sal al,1
     sal al,1
     sal al,1
     sal al,1
     add al, bl     ; al = Y
     
     push ax
     print " "   
     pop ax 
  
     
     pop bx        
     pop cx         
     push ax       
     
     
     print_str X_print
     mov dl, cl     
     call print_bin
     mov dl, bl
     call print_bin 
                    ;EDW EXW STON BL TO LOW TOU X
                    ;KAI STON CL TO HIGH TOU X
        
     mov al, cl
     sal al,1
     sal al,1
     sal al,1
     sal al,1
     add al, bl     ; al = X
     
    
   
     push ax
     new_line
     print_str ADD_print                      
     pop ax         ;X
     mov bx,ax
     pop ax   
     xchg ax,bx
    
               
     mov ah, 00h
     mov bh, 00h       
     push ax
     add ax, bx
     mov dx,ax     ; dl = al + bl   
     
     push bx
     call print_decimal
     print " "
     print_str SUB_print     
     
     pop bx
     pop ax
     
     
     cmp al,bl
     JB arnhtikos
     mov dl,al
     sub dl,bl
     jmp print_abs
   
arnhtikos:
     mov dl,bl
     sub dl,al  
     push dx
     print "-"  
     pop dx
print_abs:
     call print_decimal
     new_line

jmp start

main endp     


read_num proc near
   
    ; Reads key asci code in al
    mov ah, 01h
    int 21h            
        
    cmp al, 30h  ;elegxos an o arithmos einai <0..9)
    jl read_num 
                 
    cmp al, 39h
    jle ok_dec          
    
    cmp al, 41h  ;elegxos an to gramma einai <A..F)
    jl read_num
               
    cmp al, 46h
    jg read_num   
    
    sub al, 37h  ;afairw 37h an gramma 
    jmp end_num
    
        
ok_dec: 
    sub al, 30h  ;afairw 30h an pshfio
      
end_num:
    ret
read_num endp    
    
    
print_asci proc near
    
    mov ax, 4c00h 
    int 21h    
ends  

print_hex proc near
    cmp dl, 9
    jg addr1
    add dl, 30h
    jmp addr2
addr1:
    add dl, 37h
addr2:
    print dl
    ret 
print_hex endp

print_bin proc near
    cmp dl, 9
    jg b_addr1
    add dl, 30h
    jmp b_addr2
b_addr1:
    add dl, 37h
b_addr2:
    print dl
    ret 
print_bin endp
  

print_dec proc near
    add dl, 30h
    print dl
    ret
print_dec endp    


print_decimal  proc near
     push ax
     push bx
     
     push dx        
      
     mov al,00H
     mov ah,00H 
     jmp ekato
     
ekato_plus:
     inc ah
     sub dx,0064H
     
ekato: 
     cmp dx,0064H
     JGE ekato_plus  
     jmp dekades
     
dekades_plus:
     inc al 
     sub dx,000AH
     
dekades:
     cmp dx,000AH
     JGE dekades_plus   
     push ax
     push dx
            
     mov dl,ah
     cmp dl,00h
     jz pass0
     call print_dec
     
     pop dx             ;edw bainoume an einai >=100
     pop ax             ;ara theloume na tipwsoume tis
     push dx            ;dekades akoma kai 0 na einai
     mov dl,al 
     call print_dec
     jmp pass1
       
pass0:
     pop dx         ;edw bainoume an <100, ara elegxoume
     pop ax         ;an einai kai <10 wste na tipwsoume
     push dx        ;mono tis monades
     mov dl,al
     cmp dl,00h
     jz pass1
     call print_dec
pass1: 
     pop dx   
     and dl, 0fh
     call print_dec
     pop dx
     pop bx
     pop ax
     ret
     
print_decimal    endp

end start 