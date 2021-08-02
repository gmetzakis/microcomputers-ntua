new_line macro
    print 0ah       
    print 0dh     
endm   turn

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
    input db 21 dup(?)      
ends

stack segment
    
ends

code segment
start:
    mov ax, data
    mov ds, ax
    mov es, ax
    
    
    mov di, offset input
    cld             ;df = 0
    mov cx, 16      ;Metrhths 
    mov bl,00h
    push bx
    
read_loop: 
    pop  bx
    push bx       
    call read_key   ;diavazw
    pop bx
    cmp al, 80h     ;plhktro termatismou ENTER
    je stop         ;opou exw orisei na vazei to 80h
    stosb           ;save sth mnhmh 
    cmp al,39h
    jg print0
    inc bl          ;an einai <39h exoume arithmo -> bl++
print0:     
    push bx
    print al        ;printaroume oti diavasoume 
    
    loop read_loop     
                     
process:            ;edw exoume apothikevmena oti diavasame,
    new_line        ;kai ston bl, to plhthos twn arithmwn
    cld
    mov si, offset input 
    mov cx, 16
    pop bx
    mov dl,bl
    push dx
    push bx 
loop_1:       
    lodsb     ;diavazoume apo mnhmh
    call big_to_small ;edw kanoume ta kefalaia peza
    cmp al, 39h
    jle print_digits    ;kai an einai grammata, ta ksanaapothikevoume
    stosb         ;sth mnhmh giati prwta printaroume ta pshfia
    loop loop_1
    
print_digits:
    print al 
    pop bx
    dec bl   ;gia kathe arithmo pou printaroume, meiwnoume ton bl
    push bx  ;pou exei to plhthos twn arithmwn, opote otan bl=0
    cmp bl,00h    ;teleiwsame me tous arithmous kai printaroume "-"
    je add_pavla    
    loop loop_1
    
add_pavla:
    print "-" 
    pop bx 
    pop dx 
    push dx
    cmp cl,0
    je therest    ;edw vlepoume posa grammata exoun meinei pou den
    dec cx        ;exoume epeksergastei akoma (an dld o teleftaios
therest:          ;arithmos htan o 14os xarakthras, shmainei oti
    cmp cl,0      ;iparxoun 2 akoma grammata pou prepei na kanoume
    je letters_start  ;pezous char, kai na prosthesoyme sth stiva)
    lodsb
    call big_to_small
    stosb
    loop therest 
    
letters_start:
    pop dx 
    mov bx,dx
    mov dx,16
    sub dx,bx
    mov cx,dx    ;edw exoume ston cx pia, to plhthos twn grammatwn
         
print_letters:  
    cmp cl,00h   ;kai kanw thn antistoixh diadikasia gia 
    je restart   ;grammata exw
    lodsb
    print al   
    
    loop print_letters 
restart:
    new_line    
    jmp start
   
stop:
    mov ax, 4c00h  
    int 21h    
ends
  

big_to_small proc near
    cmp al, 'A'
    jl cap_end   ;an den einai (A..Z) tote den kanw tipota
    cmp al, 'Z'
    jg cap_end
    add al, 32   ;alliws prosthetw 32h, gia na exw (a..z)
cap_end:
    ret
big_to_small endp 

read_key proc near 
ignore:
    mov ah, 8
    int 21h  
    
    cmp al, 0dh   ;elegxos an paththei to ENTER (vazw al=80h)
    jne contin    ;gia na mhn mperdeftw me to 'D' sth sinexeia
    mov al,80h
    jmp exit
              
contin:                       
    cmp al, 30h   ;oi klasikoi elegxoi
    jl ignore
    
    cmp al, 39h
    jg its_letter
    
    jmp exit
    
its_letter:
    cmp al, 'A'
    jl ignore
    cmp al, 'Z'
    jg ignore                      
exit: 
    ret
read_key endp 
  
     
end start