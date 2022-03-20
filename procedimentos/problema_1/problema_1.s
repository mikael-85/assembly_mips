#================================================================================
# Autor do codigo: Mikael Freitas
#================================================================================
#   
#================================================================================

.data
    valor1: .word 10
    valor2: .word 20
    resultado_teste: .word 0

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

procedimento3:
#-------------------------------------------------------
# Descricao:
#   recebe dois valores como parametro do procedimento2
#   testa se x < y e executa o corpo
#   enquanto o x > y executa corpo 
#   retorna x
#-------------------------------------------------------
# Argumento do procedimento:
#   : $a0
#   : $a1
#-------------------------------------------------------
# Mapa da pilha:
#   
#   tamanho pilha total: 16 bytes
#   ******************************
#   $sp + 12: $ra  
#   $sp + 8:  $s3 - x 
#   $sp + 4:  $s4 - y
#   $sp + 0:  $t1 - temp
#
#--------------------------------------------------------
# Mapa dos registradores
#   x:              $s3
#   y:              $s4
#   temp:           $t1
#   ends:           $t0
#---------------------------------------------------------
#=========================================================
#prologo
    # ajuste da pilha
    addiu $sp, $sp, -16 #-> 16 bytes
    sw $ra, 12($sp)    #-> armazenamos endereço de retorno procedimento1 (apos chamar procedimento2)
    sw $s3, 8($sp)     #-> armazena x   
    sw $s4, 4($sp)     #-> armazena y  
    sw $t1, 0($sp)     #-> temp  
#---------------------------------------------------------
#corpo
#=========================================================
#int procedimento3(int x, int y) {
#    int tmp;
#    if (x < y) {
#        tmp = x;
#        x = y;
#        y = tmp;
#    }
#    while (x > y) {
#        x = x - 1;
#        y = y + 1;
#    }
#    return x;
#}
#=========================================================
    # colocar os valores dos procedimentos em reg temps:
    add $s3, $zero, $a0     #  x
    add $s4, $zero, $a1     #  y -> valor1
    # testar se X < y
    slt $t5, $s3, $s4       # se x < y, $t5 = 1 : 0
    bne $t5, $zero, condicao1  # sendo x < y, condicao verdadeira, salta 
    
    condicao2: # falso, portando executar laço while
    j testa_while
    
    instrucao_while:
    # x = x - 1
    addiu $s3, $s3, -1 
    # y = y + 1
    addiu $s4, $s4, +1

    testa_while:
    slt $t6, $s4, $s3 # se y menor que x, $t6 = 1
    bne $t6, $zero, instrucao_while # enquanto y < x
    j fim_while # se condicao nao for mais verdadeira salta pra fim_while
    
    condicao1: # verdadeiro
    add $t1, $zero, $s3     # temp = x
    add $s3, $zero, $s4     # x = y
    add $s4, $zero, $t1     # y = temp
    
    j testa_while # teste
    
    fim_while:
    # colocar o valor de x em $v0 para retornar x
    add $v0, $zero, $s3     # return x
#---------------------------------------------------------
#epilogo
    # ajuste da pilha
    lw $t1, 0($sp) 
    lw $s4, 4($sp)
    lw $s3, 8($sp)
    lw $ra, 12($sp)
    addiu $sp, $sp, 16 #-> 16 bytes
    jr $ra # salta para o procedimento chamador  no caso procedimento2

###########################################################

procedimento2:
#-------------------------------------------------------
# Descricao:
#   guarda o resultado do procedimento3 - procedimento3
#-------------------------------------------------------
# Argumento do procedimento:
#   x : $a1
#-------------------------------------------------------
# Mapa da pilha:
#   
#   tamanho pilha total: 16 bytes
#   ******************************
#   $sp + 12: $ra  - precisa salvar? Sim! procedimento chamado que chama outro procedimento
#   $sp + 8: $t1  - resultado 
#   $sp + 4: $t2 -  temp da primeira chamada de procedimento3(x,valor1)
#   $sp + 0: $t3 -  temp da segunda chamada de procedimento3(x,valor2)  
#--------------------------------------------------------
# Mapa dos registradores
#   x:              $s3
#   ends:           $t0 
#   resultado temp: $t1
#   proc3_v1 temp:  $t2
#   proc3_v2 temp:  $t3
#   valor1   temp:  $t4
#---------------------------------------------------------
#=========================================================
#prologo
    # ajuste da pilha
    addiu $sp, $sp, -16 #-> 16 bytes
    sw $ra, 12($sp)    #-> armazenamos endereço de retorno procedimento1 (apos chamar procedimento2)
    sw $t1, 8($sp)     #-> armazena resultado   
    sw $t2, 4($sp)     #-> armazena temp de procedimento3(x,valor1)  
    sw $t3, 0($sp)     #-> armazena temp de procedimento3(x,valor1)    

#---------------------------------------------------------
#corpo
#==================================================================
    #int procedimento2(int x) {
        #int resultado;
        #resultado = procedimento3(x, valor1) - procedimento3(x, valor2);
        #return resultado;
    #}
#====================================================================
    # colocar x em um registrador $s3; x=$a0
    add $s3, $zero, $a0 # $s3 = x  
    # colocar valor1 em $a1
    la $t0, valor1  # carrega o endereço de valor1
    lw $t4, 0($t0)  # carrega o conteudo de valor1
    add $a1, $zero, $t4 # valor1 = $a1 para passar como argumento para procedimento3
    #chamar procedimento3 
    jal procedimento3 # agora o $ra guarda a proxima posição abaixo
        #$ra aponta agora para aqui!
    # volta do procedimento3 com valor de return em $v0
    # colocar o $v0 em um reg temp para utilizar mais tarde na subtracao $t2
    add $t2, $zero, $v0     # $t2 = procedimento3(x, valor1)
       
    # precisa colocar novamente $a0 em um reg ? 
    la $t0, valor2      # carrega do endereco de valor2 em $t0
    lw $t4, 0($t0)      # carrega o conteudo de valor2 em $t4
    add $a1, $zero, $t4 # coloca o valor2 em $a1 (y) para ser usado como argumento
    jal procedimento3
        #$ra agora aponta para aqui!
    # volta do procedimento 3 com o valor de retorno em $v0
    # colocar $v0 em um reg para usar na subtracao
    add $t3, $zero, $v0 # $t3 = $v0 (valor de retorno de procedimento3)
    # subtracao:  resultado = procedimento3(x, valor1) - procedimento3(x, valor2);
    sub $t1, $t2, $t3       # resultado = proc3(x,v1) - proc3(x,v2)
    # return resultado
    add $v1, $zero, $t1     # coloca resultado em $v1
       
#---------------------------------------------------------
#epilogo
    
    # ajustar a pilha => lw 
    lw $t3, 0($sp)     #-> restaura valor original do registrador  
    lw $t2, 4($sp)     #-> restaura valor original do registrador
    lw $t1, 8($sp)     #-> restaura valor original do registrador   
    lw $ra, 12($sp)    #-> restaura $ra do procedimento caller (procedimento1)
    addiu $sp, $sp, 16 #-> limpa a pilha
    jr $ra #=> volta para o procedimento1 com resultado em $v1

###########################################################

procedimento1: 
#-------------------------------------------------------
# Descricao:
#   procedimento que recebe dois valores do main, multiplica os dois valores pelo indice
#   incrementa o acumulador somando com o valor de vetorA[i]
#-------------------------------------------------------
# Argumento do procedimento:
#   x: $a0
#   y: $a1
#-------------------------------------------------------
# Mapa da pilha:
#   
#   tamanho pilha total: 60 bytes
#   ******************************
#   $sp + 56: $ra  - precisa salvar? Sim! procedimento chamado que chama outro procedimento
#   $sp + 52: $s2 - vetA[9]
#   $sp + 48: $s2 - vetA[8]
#   $sp + 44: $s2 - vetA[7]
#   $sp + 40: $s2 - vetA[6]
#   $sp + 36: $s2 - vetA[5]
#   $sp + 32: $s2 - vetA[4]
#   $sp + 28: $s2 - vetA[3]
#   $sp + 24: $s2 - vetA[2]
#   $sp + 20: $s2 - vetA[1]
#   $sp + 16: $s2 - vetA[0]
#   $sp + 12: $s4 - y
#   $sp + 8:  $s3 - x
#   $sp + 4:  $s1 - acumulador
#   $sp + 0:  $s0 - i 
#--------------------------------------------------------
# Mapa dos registradores
#   i:              $s0
#   acumulaodor:    $s1
#   vetor[10]:      $s2  
#   x:              $s3
#   y:              $s4
#   ends:           $t0
#   valores temps:  $t1
#   ix4:            $s7                
#--------------------------------------------------------
#=========================================================
# prologo
    # ajuste da pilha
    addiu $sp, $sp, -60 #-> 60 bytes
    sw $ra, 56($sp)     #-> armazenamos endereço de retorno (main)
    sw $s2, 52($sp)     #-> armazena vetA[9]   
    sw $s2, 48($sp)     #-> armazena vetA[8]
    sw $s2, 44($sp)     #-> armazena vetA[7]
    sw $s2, 40($sp)     #-> armazena vetA[6]
    sw $s2, 36($sp)     #-> armazena vetA[5]
    sw $s2, 32($sp)     #-> armazena vetA[4]
    sw $s2, 28($sp)     #-> armazena vetA[3]
    sw $s2, 24($sp)     #-> armazena vetA[2]
    sw $s2, 20($sp)     #-> armazena vetA[1]
    sw $s2, 16($sp)     #-> armazena vetA[0]
    sw $s4, 12($sp)     #-> armazena y
    sw $s3, 8($sp)      #-> armazena x
    sw $s1, 4($sp)      #-> armazena acumulador
    sw $s0, 0($sp)      #-> armazena i
# corpo do procedimento
    #=============================================================
    #for (int i = 0; i < 10; i++) {
    #    vetorA[i] = i * x + y;
    #    vetorA[i] = procedimento2(vetorA[i]);
    #    acumulador = acumulador + vetorA[i];
    #}
    #return acumulador; #* lembrar de colocar retorno em v0-v1 
#} 
    #=============================================================
    # Inicialização do for -> para i = $s0
    lw $s0, 0($sp)          # carrega o i
    addiu, $s0, $zero, 0    # inicializa o i=0

    ###################################
    # Inicializa o acumulador tambem
    lw $s1, 4($sp)      # carrega acumulador
    addiu $s1, $zero, 0 # inicializa acumulador
    ###################################

    j verifica_condicao     # testa se condicao verdadeira

    codigo_for:             # se condicao verdadeira
        #*caluclar end efetivo de vetA[i] usando a pilha:
        #ix4
        sll $s7, $s0, 2     #i x 4   
        #ix4 + 16 pois vetA[0] = 16($sp)
        addiu $t1, $s7, 16  #armazena em $t1 1x4 +16 
        #((ix4+12) + sp)
        add $t0, $t1, $sp   #endereço efetivo de vetA[i]

    #vetorA[i] = i* n + m
        
    #(?)######################################################################################################
    # carregar os valores de x e y da pilha, pois quando chama o procedimento2 $a0 e $a1 sao sobrescritos 
    lw $a0, 8($sp)  # x do procedimento1
    lw $a1, 12($sp) # y do procedimento1
        
    ########################################################################################################### 
           
    #atribuir n e m em duas variaveis temporárias
        addu $s3, $zero, $a0 # n ou x
        addu $s4, $zero, $a1 # m ou y  
        mul  $t1, $s0, $s3   # i * n = $t1
        add  $t1, $t1, $s4   # (i * n) + y    

    #atualizar na memoria/pilha em vetorA[i]
        sw $t1, 0($t0)  # armazena o resultado de i * n + m em vetA[i]
       
        ##########################################################################
        #***************
        #armazenar o i pois foi utilizado o registrador em outros procedimentos
        sw $s0, 0($sp) #armazena o i por registrador era temporario!
        #***************
        ##########################################################################
        
    # passar o valor de vetorA[i] como argumento para procedimento 2
        # passar o valor de vetorA[i] para $a0
        addu $a0, $zero, $t1   # colocar o valor de t1 que seria vetorA[i] em $a0 para passar como 
        #argumento. Sobrescrevera o argumento de main que nao sera utilizado mais
        jal procedimento2       # pulamos para o procedimento2 ja com vetA[i] em $a0
        #!  # => $ra referencia aqui!
    # 1- atualizar o valor de vetorA[i] com o return do procedimento 2
        # $v1 return do procedimento2
        add $t1, $zero, $v1     #=> coloca o $v1 em $t1
        add $s2, $zero, $t1     #-> variavel temporaria de vetorA[i]
    
    ########################################################################################################
    #**** $t0 foi utilizado pelo procedimento2, logo calcular de novo end efetivo aqui antes de armazenar...     
        #********* 
        lw $s0, 0($sp) # recupera o i da pilha
        sll $s7, $s0, 2 # i x 4
        addiu $t1, $s7, 16  #armazena em $t1 1x4 +16 
        add $t0, $t1, $sp   #endereço efetivo de vetA[i]
        #*********
    ########################################################################################################
        sw  $s2, 0($t0)         #-> coloca o valor de precedimento2(vetoraA[i]) em vetorA[i]
    
        
    # 2- atualizar o acumulador
        ######################
       # lw $s1, 4($sp) # atualizar acumulador da pilha, pois tinha 'lixo' do proc1
        ######################
        add $s1, $s1, $s2       #-> acumulador = acumulador + vetorA[i]
    # 3- incrementar i
        addi $s0, $s0, 1        # incrementa o i
    # 4- salvar i na pilha
        sw $s0, 0($sp)          # guarda valor de i na pilha
        sw $s1, 4($sp)          # guarda o acumulador na pilha 

    verifica_condicao:      # testa se condicao for verdadeira
        # i<10
        # *buscar valor de i na pilha antes do teste?    
        slti $t1, $s0, 10   # se i < 10 = 1 
        bne $t1, $zero, codigo_for  # se for verdadeiro executa o codigo for
    fim_for:                # sai do laço
        # return acumulador
        lw  $s1, 4($sp)      # carrega o acumulador da pilha
        add $v1, $zero, $s1 # coloca o valor do acumulador em $v1 para retornar ao caller

# epilogo
    # falta fazer:
    # limpar a pilha
    lw $s0, 0($sp)      #-> restaura $s0
    lw $s1, 4($sp)      #-> restaura $s1
    lw $s3, 8($sp)      #-> restaura $s3
    lw $s4, 12($sp)     #-> restaura $s4
    lw $s2, 16($sp)     #-> restaura $s2
    lw $s2, 20($sp)     #-> restaura $s2
    lw $s2, 24($sp)     #-> restaura $s2
    lw $s2, 28($sp)     #-> restaura $s2
    lw $s2, 32($sp)     #-> restaura $s2
    lw $s2, 36($sp)     #-> restaura $s2
    lw $s2, 40($sp)     #-> restaura $s2
    lw $s2, 44($sp)     #-> restaura $s2
    lw $s2, 48($sp)     #-> restaura $s2 
    lw $s2, 52($sp)     #-> restaura $s2
    lw $ra, 56($sp)     #-> restaura endereço de retorno (main)
    addiu $sp, $sp, 60 #-> libera os 60 bytes

    # retornar o $ra da pilha para voltar para o main que foi o caller com jr $ra
    jr $ra  # retorna ao proocedimento chamador, no caso main

###########################################################
#---------------------------------------------------------
main:
# Descricao:
#  procedimento principal do programa
#-------------------------------------------------------
# Argumento do procedimento:
#  nenhum
#-------------------------------------------------------
# Mapa da pilha:
#   $sp + 12: $ra
#   $sp + 8:  $s2
#   $sp + 4:  $s1
#   $sp + 0:  $s0   
#--------------------------------------------------------
# Mapa dos registradores
#   n:          $s0
#   m:          $s1
#   resultado:  $s2
#   ends:       $t0
#--------------------------------------------------------
#=========================================================
# prologo
    # maior para o menor
    addiu $sp, $sp, -16     # ajustar a pilha
    sw  $ra 12($sp)
    sw  $s0 8($sp)
    sw  $s1 4($sp)
    sw  $s2 0($sp)
    
# corpo do procedimento
    addiu $s0, $zero, 5 # n
    addiu $s1, $zero, 3 # m
    # colocar valores de $s1 e $s2 em $a0 e $a1
    addu $a0, $zero, $s0 # n   
    addu $a1, $zero, $s1 # m 
    jal procedimento1 # envia os valores de $a0 e $a1 para procedimento 1  
        # procedimento1 retorna $v1
    # colocar $v1 em resultado
    add $s2, $zero, $v1     # resultado = procedimento1(n, m)
    sw  $s2, 8($sp)         # armazena o resultado na pilha

    # teste ######################
    la $t0, resultado_teste
    sw $s2, 0($t0) 
    
# epilogo
    # menor para o maior
    # j $ra  -> salta para procedimento chamador
    lw  $s2 0($sp)
    lw  $s1 4($sp)
    lw  $s0 8($sp)
    lw  $ra 12($sp)
    addiu $sp, $sp, 16     # ajustar a pilha
    jr $ra       # volta para procedimento chamador
        
