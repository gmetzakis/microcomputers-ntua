print macro char
    mov dl, char
    mov ah, 2
    int 21h
endm

; plithos arithmwn sth mnhmh           
N EQU 255
            
data segment
    TABLE dw N dup(?)
ends

stack segment
ends
                             
code segment 
    
  
          
start:
    mov ax, data
    mov ds, ax
    mov es, ax

    
    ; fortwsh mnhmhs me sinexomenous arithmous
    mov cl, N
    cld                     ; df = 0
    mov di, OFFSET TABLE       
    mov al, 254
write_again:   
    stosb     
    dec al                 ; fortwsh epomenou dedomenou
    cmp al, 254
    jnz write_again
    
    
    mov cl, N
    cld                     ; df = 0
    mov di, OFFSET TABLE   
    mov dx, 0               ; arxikopoihsh kataxwrhtwn athroismatos
    mov bx, 0 
    mov ah, 0
load_again:   
    lodsb                   ; fortwsh se kataxwrhth
    add bx, ax   
    cmp cl,00h
    jz mooove
    loop load_again
mooove:         
    
    mov ax, bx              ; metakinhsh diairetaiou
    mov bx, N+1               ; diaireths
    div bx                  ; ektelesh diaireshs        
 
    mov dl, ah
    call print_hex_full
    mov dl, al
    call print_hex_full      
    
    
    mov cl, N
    cld                     ; df = 0
    mov di, OFFSET TABLE   
    mov dl, 255           ; dx = topiko min 
    mov bl, 0           ; bx = topiko max
load_again_2:   
    lodsb                   ; fortwsh se kataxwrhth 
local_min_calc:
    cmp al, dl             
    ja local_max_calc       
    mov dl, al
local_max_calc:
    cmp dl, bl           
    jb next
    mov dl, al      
next:   
    cmp cl,00h
    jz mooove_2
    loop load_again_2
mooove_2:              
    
     ; pairnei ena 2adiko pshfio kai to tipwnei 16dika      

    print " "
    print "m"
    print ":" 
    push dx
    mov dl, dh
    call print_hex_full 
    pop dx 
    call print_hex_full
    
    print " "
    print "M"
    print ":"
    mov dl, bh               ; ektipwsh 8MSB
    call print_hex_full         
    mov dl, bl               ; ektipwsh 8LSB
    call print_hex_full     
    
    
    mov ax, 4c00h ; exit 
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




print_hex_full  proc near
     push dx
     push ax
     push bx 
     push dx        ; save to apotelesma
      
     sar dx, 1
     sar dx, 1
     sar dx, 1
     sar dx, 1    
     and dl, 0fh 
     call print_hex   
     
     pop dx
     and dl, 0fh    
     call print_hex   
     pop bx
     pop ax
     pop dx
     ret  
print_hex_full    endp  

end start 