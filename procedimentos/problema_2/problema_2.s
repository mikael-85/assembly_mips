#================================================================================
# Autor do codigo: Mikael Freitas
#================================================================================
#
#================================================================================

.text
.globl main

########################################
# Inicio do programa
########################################
init:
    jal main    # procedimento principal
    j finit     # termina programa
########################################
# Fim do programa
########################################
finit:
    addi $a0, $zero, 0
    addi $v0, $zero, 17
    syscall
#---------------------------------------


gera_sequencia_fibonacci:
#=======================================================
    # *f = &vet[dim]
    # recebe $a0 = &fib[dim] | $a1 = conteudo de dim
    add $s5, $zero, $a0  # recebe &fib[0]
    add $s6, $zero, $a1  # recebe dim   

    move $s4, $zero      # $s4 = 0  
    sw  $s4, 0($s5)      # fib[0] = 0
    addi $s4, $zero, 1   # $s4 = 1 
    sw $s4, 4($s5)       # fib[1] = 1             

    #------------------------------------------------------
    #for (ptr = &f[2]; ptr < &f[dim]; ptr++) {
    #    *ptr = *(ptr - 1) + *(ptr - 2);
    #}
    #------------------------------------------------------

    # inicio do for
        # ptr = &f[2]
        addi $s7, $zero, 2  # $s7 = 2
        sll $s7, $s7, 2     # $s7 = $s7 x 4    
        add $s7, $s7, $s5   # endereco efetivo de &fib[2]
        
        sll $t2, $s6, 2     # size*4 
        add $t3, $t2, $s5   # &f[size] | f[dim] | &f[10]
        j testa_for2    
    
    condicao_for_2:    
       
        # (fib[2] -1) + (fib[2] -2)
        addi $t5, $s7, -4    # $s7 - 1byte
        lw $s0, 0($t5) # conteudo de ptr -1  
        addi $t6, $s7, -8    # $s7 - 2byte          
        lw $s1, 0($t6) # conteudo de ptr -2
        
        add $t7, $s1, $s0    # *ptr = *(ptr - 1) + *(ptr - 2)

    ##errado###########################################################
    #   ERRADO ESSA PARTE! 
    #   lw $t5, 0($s7)       # recebe o conteudo de *f[2]
    #   addiu $t5, $t5, -1    # *ptr -1
    #   addiu $t6, $t6, -2   # *ptr -2
    #   add $t7, $t5, $t6    # *ptr = *(ptr - 1) + *(ptr - 2)
    ###################################################################

       # salva *ptr na pilha do main
       sw $t7, 0($s7)       # guarda ptr 
       
       # incrementa ptr
       addi $s7, $s7, 4    #ptr++     (?) end + 1 byte 

    testa_for2:
        #ptr < &f[dim] ?
        slt $t4, $s7, $t3
        bne $t4, $zero, condicao_for_2 # se verdadeiro = 1 : 0 
    
    fim_for2:
        
        jr $ra  #volta para o main

#=======================================================
calcula_soma_elementos:
#-------------------------------------------------------
# Mapa da pilha:
#   $sp + 12: $ra
#   $sp + 8:  $s3
#   $sp + 4:  $s1
#   $sp + 0:  $s0   
#--------------------------------------------------------
# Mapa dos registradores:
    # obs.: O codigo nao esta otimizado, portanto alguns registradores nao estao no mapa
        
    #variavel local i: $s3
    #endereco temp:    $t0
#-------------------------------------  
# prologo
#=========================================================================================
# corpo
# int *calcula_soma_elementos(int f[], int dim)  <= recebe variavel $s2 e a dimensao(?) 

    la $t0, soma_sequencia  # carrega end de soma_sequencia
    move $s3, $zero         # $s3 = 0
    sw  $s3, 0($t0)         # armazena zero em soma_sequencia 
    add $s4, $zero, $a1     # dimensao
    add $s7, $zero, $a0     # f[]

#-------------------------------------------------------------
#   for (i = 0; i < dim; i++) {
#       soma_sequencia = soma_sequencia + f[i];
#   }
#   return &soma_sequencia;
#-------------------------------------------------------------
    # inicializa o for
    lw, $s5, 0($sp)     #=> carregamos o i da pilha
    move $s5, $zero     #=> zeramos o i
    j verifica_for 
   
    codigo_do_for:
        # fazer:
        # variavel local $s3 = f[i] + $s3
        # f[i]
        # i x 4 + f[0]
        sll $t7, $s5, 2     # ix4
        add $t7, $t7, $s7   # (ix4) + fib[0] end efetivo
        lw  $t6, 0($t7)     # conteudo de &fib[i]

        add $s3, $s3, $t6   # soma_sequencia = soma_sequencia + f[i] 
        
        # incrementa i
        addiu $s5, $s5, 1   # i++  
                
    verifica_for:
        #i < dim ?
        slt $s1, $s5, $s4  # i < dim ? 1 : 0
        bne $s1, $zero, codigo_do_for

        add $a0, $zero, $s3 # return soma_sequencia 

    fim_do_for:
        jr $ra  # volta para o main
#Epilogo    
#=======================================================
#=======================================================
imprime_soma:
#=======================================================
    la $a0, printf
    li $v0, 4
    syscall
    jr $ra  # volta para o main

imprime_inteiro:   
   move $a0, $a1    # $a1 = valor do main
    li $v0, 1
    syscall    
    jr $ra  # retorna para o main

main:
#-------------------------------------------------------
# Descricao:
#   cria ponteiro_soma_sequencial
#   cria variavel temp fib
#   chama demais procedimentos
#-------------------------------------------------------
# Argumento do procedimento:
#   nenhum
#
#-------------------------------------------------------
# Mapa da pilha:
#  
#   tamanho pilha total: 54 bytes
#   ******************************
#   $sp + 52: $ra     #-> armazenamos endereço de retorno (main)
#   $sp + 48: $s2     #-> fib[9]   
#   $sp + 44: $s2     #-> fib[8]
#   $sp + 40: $s2     #-> fib[7]
#   $sp + 36: $s2     #-> fib[6]
#   $sp + 32: $s2     #-> fib[5]
#   $sp + 28: $s2     #-> fib[4]
#   $sp + 24: $s2     #-> fib[3]
#   $sp + 20: $s2     #-> fib[2]
#   $sp + 16: $s2     #-> fib[1]
#   $sp + 12: $s2     #-> fib[0]
#   $sp + 8:  $s3 - 
#   $sp + 4:  $s1 - temp
#   $sp + 0:  $s0 - temp
#--------------------------------------------------------
# Mapa dos registradores
#   # obs.: O codigo nao esta otimizado, portanto alguns registradores nao estao no mapa
#   variaveis_temp: $s1
#   end_temp:       $t0
#   fib:            $s2
#--------------------------------------------------------
#=========================================================
    # maior para o menor
    addiu $sp, $sp, -56 # ajustar a pilha
    sw $ra, 52($sp)     #-> armazenamos endereço de retorno (main)
    sw $s2, 48($sp)     #-> armazena fib[9]   
    sw $s2, 44($sp)     #-> armazena fib[8]
    sw $s2, 40($sp)     #-> armazena fib[7]
    sw $s2, 36($sp)     #-> armazena fib[6]
    sw $s2, 32($sp)     #-> armazena fib[5]
    sw $s2, 28($sp)     #-> armazena fib[4]
    sw $s2, 24($sp)     #-> armazena fib[3]
    sw $s2, 20($sp)     #-> armazena fib[2]
    sw $s2, 16($sp)     #-> armazena fib[1]
    sw $s2, 12($sp)     #-> armazena fib[0]
    sw  $s3 8($sp)      #-> 
    sw  $s1 4($sp)      #->
    sw  $s0 0($sp)      #->    
    
# corpo do procedimento
    
    addi $s2, $sp, 12     #=> end base de fib[dim] 
       
    la, $t0, dimensao   #=> end base de dimensao
    lw, $s7, 0($t0)     #=> conteudo de dimensao
    # parametros para passar para gera_sequencia_fibonacci:
    add $a1, $zero, $s7 #=> conteudo de dimensao
    add $a0, $zero, $s2 #=> &fib[0]
    # chamar gera_sequencia_fibonacci
    jal gera_sequencia_fibonacci
        #$ra aponta para aqui! primeira vez    
    jal calcula_soma_elementos
        #$ra aponta para aqui! segunda vez 
    # atribuir retorno em ponteiro_soma_sequencia    
    add $s6, $zero, $a0 # ponteiro_soma_sequencia = calcula_soma_elementos(fib, dimensao);
    add $a1, $zero, $s6 # valor da soma para imprimir

    #=====================================
    #teste: Salva valor da soma na memoria
    la $t0, teste
    sw $s6, 0($t0)  # - ok: $s6 = 88
    #fim_teste
    #=====================================
    
    jal imprime_soma
    jal imprime_inteiro

#epilogo
   
    lw  $s0 0($sp)      #-> 
    lw  $s1 4($sp)      #->
    lw  $s3 8($sp)      #-> 
    lw $s2, 12($sp)     #-> armazena fib[0]
    lw $s2, 16($sp)     #-> armazena fib[1]
    lw $s2, 20($sp)     #-> armazena fib[2]       
    lw $s2, 24($sp)     #-> armazena fib[3] 
    lw $s2, 28($sp)     #-> armazena fib[4] 
    lw $s2, 32($sp)     #-> armazena fib[5]
    lw $s2, 36($sp)     #-> armazena fib[6]
    lw $s2, 40($sp)     #-> armazena fib[7]
    lw $s2, 44($sp)     #-> armazena fib[8]
    lw $s2, 48($sp)     #-> armazena fib[9]
    lw $ra, 52($sp)     #-> armazenamos endereço de retorno (main)
    addiu $sp, $sp, 56 # limpa a pilha
    jr $ra
#=======================================================

.data
soma_sequencia: .word 0     # variavél global
dimensao:       .word 10    # contante do tamanho do vetor
teste:          .word 0
printf:         .asciiz "a soma dos elementos de fibonacci e\n" 
