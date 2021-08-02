print macro char
    push dx
    push ax
    
    mov dl, char
    mov ah, 2
    int 21h 
    
    pop ax
    pop dx
endm

new_line macro
    print 0ah    
    print 0dh      
endm   

data segment
ends

stack segment
ends

code segment
start:
    mov ax, data  ; segment registers
    mov ds, ax
    mov es, ax   
    
    call hex_key   ;diavazoume to 1o pshfio
    cmp al, 'Q'    ;an einai to 'Q', stamata
    je stop  
    mov bl, al
 
    call hex_key   ;diavazoume to 2o pshfio
    cmp al, 'Q'    ;omoia me prin
    je stop
    
    print " "      ;twra pia o bl exei to 1o
    print "="      ;kai o al to 2o
    print " "
    print "0"
    print "0"     
    mov dl,bl      ;printaroume to 1o(bl)
    call print_digit
    
    mov cl,4
    shl bl,cl      ;afou valoume ta 4LSB sta 4MSB
    
    add bl, al     ;prosthetoume ton al sto bl
    mov dl, al     ;printaroume to 2o(al)
    call print_digit
              
    print "h"  
    print " "
    print "="   
    print " "
    call print_dec ;kaloume tis antistoixes routines
    print "d"      ;gia metatroph se dekadikh, oktadikh
    print " "      ;kai diadikh morfh
    print "="  
    print " "
    call print_oct
    print "o" 
    print " "
    print "=" 
    print " "
    call print_bin
    print "b"
    new_line  
    
    jmp start 



         
print_digit proc near
    cmp dl, 9     ;o dl exei thn timh poy tha printaroume
    jg addr1
    add dl, 30h   ;an einai pshfio(0..9) tote prosthetoume 30h
    jmp addr2
addr1:
    add dl, 37h   ;an einai gramma(A..F) tote prosthetoume 37h
addr2:
    print dl
    ret 
print_digit endp


PRINT_DEC proc near    
     push dx 
     push cx
     push ax 
     

     mov ah, 00h
     mov al, bl
     mov cl, 100    ; kratame tis 100des
     div cl         ; diairesh me 100
     mov dl, al     
     call print_digit ;printaroyme tis 100des
     
     mov cl, 10     ; kratame tis 10des
     mov al, ah     
     mov ah, 0
     div cl 
     mov dl, al
     call print_digit  ;printaroyme tis 10des
     
     mov dl, ah     
     call print_digit  ;printaroyme tis monades

     pop ax
     pop cx
     pop dx  
     ret
    
PRINT_DEC endp 
 
PRINT_OCT proc near   
     push dx 
     push cx 
     
     mov cl, 6
     mov dl, bl     ; print 1o pshfio
     sar dl, cl  
     and dl, 03h 
     call print_digit   
     
     
     mov cl, 3
     mov dl, bl     
     sar dl, cl  
     and dl, 07h 
     call print_digit  ;print 2o pshfio 
     
     mov dl, bl    
     and dl, 07h 
     call print_digit  ;print 3o pshfio

     pop cx
     pop dx
     ret
PRINT_OCT endp 

PRINT_BIN proc near
    push bx
    push cx
    
    mov cx, 8      ;8 fores tha kanei rol
again:
    rol bl, 1
    jc print1
    mov dl, 00h    ; print 0 an meta to rol 
    call print_digit  ;den iparxei kratoumeno
    LOOP again
    pop cx
    pop bx
    ret
print1:
    mov dl, 01h     
    call print_digit   ;alliws print 1
    LOOP again  
    pop cx
    pop bx
    ret   
PRINT_BIN endp 
 
hex_key proc near 
not_good: 
    mov ah, 1
    int 21h
    
    cmp al, 'Q'    ;elegxos gia termatismo
    je exit
                       
    cmp al, 30h
    jl not_good
    
    cmp al, 39h    ;paei sthn letter an einai
    jg letter      ;megalitero apo 9 gia 2o elegxo
    
    sub al, 30h    ;alliws einai arithmos -> -30h
    jmp exit
    
letter:
    cmp al, 'A'    ;an profanws <A h >F de mou kanei
    jl not_good
    cmp al, 'F'
    jg not_good
    
    sub al, 37h ;einai gramma, ara afairw 37h                          
exit: 
    ret
hex_key endp 

    
stop:
    mov ax, 4c00h 
    int 21h    
ends
end start 
