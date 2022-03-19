#================================================================================
# Autor do codigo: Mikael Freitas
#================================================================================
#
#================================================================================

.text
    la $t0, variavelI
    addi $s1, $zero, 1
    sw $s1 0($t0)       # i=1 
    la $t0, variavelJ
    addi $s2, $zero, 2
    sw $s2 0($t0)       # j=2 
    la $t0, variavelK
    addi $s3, $zero, 4
    sw $s3 0($t0)       # k=4
#=================================================================================  
# Primeiro laço
#=================================================================================  
# for(i=0; i<10; i++){
#   a[i] = a[i] + 3;
#  }
#=================================================================================
inicializa_for:
    # igualamos i=0 e verificamos a condição    
    la $t0, variavelI
    addi $s1, $zero, 0
    sw  $s1, 0($t0)     # armazenamos o valor de i=0
    j verifica_condicao
condicao_verdadeira:
# carregamos o conteudo de I
    la  $t2, variavelI
    lw  $s3, 0($t2)      # conteudo de i
# Carregamos o conteudo de a[i]
    la  $t1, vetorA      # end base vetorA
    sll $s4, $s3, 2      # multiplica ix4
    add $s4, $s4, $t1    # end efetivo de a[i]
    lw  $s5, 0($s4)      # conteudo de a[i]
# a[i] = a[i] + 3         
    addi $s5, $s5, 3     # a[i] = a[i] + 3
    sw   $s5, 0($s4)     # armazena em a[i] o resultado      
# Incrementamos o i: i++
    addi $s1, $s1, 1  # incrementa i
    sw   $s1, 0($t0)    # atualiza valor de i na memoria
verifica_condicao:
#verificar se i<10
    slti $s2, $s1, 10   # i<10?condicao_verdadeira:condicao_falsa
    bne  $s2, $zero, condicao_verdadeira   # se i<10, entao $s2 = 1, logo verdadeiro, salta para condicao_verdadeira  
condicao_falsa:     # fim do for
#=================================================================================  
# Segundo laço
#=================================================================================  
# for(i=0; i<10; i++){
#   for(j = i; j<10; j++){
#      acc = acc + a[j];
#   }
# }
#=================================================================================
inicializa_for2:
    # igualamos i=0 e verificamos a condicao    
    la $t0, variavelI
    addi $s1, $zero, 0
    sw  $s1, 0($t0)     # armazenamos o valor de i=0
    # igualamos o j=i e verificamos a condicao
    la $t3, variavelJ
    sw $s1 0($t3)       # armazenamos i em j ou seja: j=i 

    j verifica_condicao2

condicao_verdadeira2:
# Incrementamos o i: i++
    addi $s1, $s1, 1     # incrementa i
    sw   $s1, 0($t0)     # atualiza valor de i na memoria
# Iguala o I com J
    la $t4, variavelJ
    sw $s1, 0($t4)       # guarda o valor de i em j -> i=j   

verifica_condicao2:
#verificar se i<10
    slti $s2, $s1, 10   # i<10?verifica_segunda_condicao:condicao_falsa2
    bne  $s2, $zero, verifica_segunda_condicao   # se i<10, entao $s2 = 1, logo verdadeiro, salta
     
    j condicao_falsa2   # caso i >= 10, sai do for

verifica_segunda_condicao:
# verificamos se j<10
    la  $t4, variavelJ  
    lw, $t7, 0($t4)      # carrega conteudo de j
    
    # testa j<10
    slti $s2, $t7, 10    # $t7<10?1:0
    bne  $s2, $zero, incrementa_acc
    j condicao_verdadeira2      # caso j>10

incrementa_acc:
   # carregamos o conteudo de j
    la  $t4, variavelJ  
    lw, $s3, 0($t4)     # conteudo de J
    la  $t5, vetorA     # end base vetorA
    sll $s4, $s3, 2     # multiplica jx4
    add $s7, $s4, $t5   # end efetivo do vetorA[j]
    lw  $t7, 0($s7)     # conteudo de vetorA[j]
    
    # incrementa e faz teste para jump verifica_segunda_condiçao caso verdadeiro
        
    # acc = acc + a[j]
    la  $t6, acc
    lw  $s6, 0($t6)   # conteudo de acc 
    add $s6, $t7, $s6 # acc = acc + a[j]
    sw  $s6, 0($t6)   # armazenamos o resultado de acc + a[j] em acc 

    # Incrementamos o j: j++
    addi $s3, $s3, 1     # incrementa j
    sw   $s3, 0($t4)     # atualiza valor de j na memoria 
    j verifica_segunda_condicao

condicao_falsa2:     # fim do for    
#a[6] = acc;
    la $t1, vetorA
    la $t2, acc
    lw $s4, 0($t2)  # conteudo de acc
    sw $s4, 24($t1) # armazena o conteudo de acc em vetorA[6]

#=================================================================================  
# Primeiro laço while
#=================================================================================  
# while(a[k]<acc){
#    a[k] = a[k] + 10;
# }
#=================================================================================
inicio_while:
    # buscar end do vetor e de acc
    la $t6, vetorA      # endereço base de vetorA
    la $t4, variavelK
    la $t5, acc
    lw $s4, 0($t4)      # conteudo de variavelK
    lw $s5, 0($t5)      # conteudo de acc

    j testa_condicao
instrucao_while:
    # a[k] = a[k] + 10
    lw   $s4, 0($t4)   # conteudo de k
    sll  $s7, $s4, 2   # kx4   
    add  $s7, $s7, $t6 # end efetivo de a[k]
    lw   $s1, 0($s7)   # conteudo de a[k]
    addi $s1, $s1, 10  # a[k] + 10
    sw   $s1, 0($s7)   # armazena a[k] 
testa_condicao:
    # a[k]<acc
    lw  $s4, 0($t4)     # conteudo de k
    sll $s6, $s4, 2     # multiplica variavelKx4
    add $s7, $s6, $t6   # end efetivo de vetorA[k]
    lw  $s3, 0($s7)     # conteudo de a[k]
    slt $t7, $s3, $s5   # se a[k]<acc?1:0
    bne $t7, $zero, instrucao_while # se verdadeiro, $t7 = 1, desvia para instrucao while

#=================================================================================  
# Segundo laço: do while
#=================================================================================  
# do{
#     a[7] = a[k] + 1;
# }while(a[7]<a[8])
#}
#=================================================================================
do: 
    # a[7] = a[k] + 1;
    la   $t3, vetorA      # end base do vetorA
    la   $t4, variavelK   # end de K
    lw   $s4, 0($t4)      # conteudo de k
    sll  $s5, $s4, 2      # multiplica kx4    
    add  $s5, $s5, $t3    # end efetivo de vetorA[k]
    lw   $s7, 0($s5)      # conteudo de vetorA[k]
    addi $s7, $s7, 1      # vetorA[k]+1
    sw   $s7, 28($t3)     # a[7] = a[k] + 1           

verifica_while2:
    # a[7] < a[8]
    lw  $s4, 28($t3)       # conteudo de a[7]
    lw  $s5, 32($t3)       # conteudo de a[8]  
    slt $s6, $s4, $s5      # a[7] < a[8]?1:0 
    bne $s6, $zero, do     # se $s6 = 1 salta para do 

fim:
    addi  $v0, $zero, 17 # serviço 17 - exit2
    addi  $a0, $zero, 0 # o valor de retorno do programa é 0
    syscall             # chamamos o serviço 17 do sistema - exit2, com o valor 0

.data
    variavelI:  .word 0
    variavelJ:  .word 0
    variavelK:  .word 0
    vetorA:     .word 0,1,2,3,4,5,6,7,8,9
    acc:        .word 0   
