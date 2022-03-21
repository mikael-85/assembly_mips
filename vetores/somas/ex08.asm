#===================================================================
# Descrição: 
# a[k] = a[i] + a[j];
# onde:
# a[10] = {0,1,2,3,4,5,6,7,8,9} -> inteiros c/ tamanho 4 bytes;
# i = 1; 
# j = 2;
# k = 0;
#
#===================================================================
# Convensão dos registradores
#===================================================================
# $0        - Sempre zero
# $at       - Temporário para assembly (reservado)
# $v0, $v1  - Valores retornado de uma rotina
# $a0 - $a3 - Argumentos para uma sub-rotina
# $t0 - $t7 - Temporário (não preservados na chamada da função)
# $s0 - $s7 - Registradores salvos (preservado na chamada da função)
# $t8, $t9  - Temporários
# $k0, $k1  - Kernel (reservado para o S.O)
# $gp       - Ponteiro global
# $sp       - Ponteiro para a pilha (stack pointer)
# $fp       - Ponteiro para o quadro (frame pointer)
# $ra       - End de retorno (usando em algumas instruções)
#===================================================================
.text
# definir os valores 0,1 e 2 nas variaveis K, i e J
    addi $t1, $zero, 1 # i
    addi $t2, $zero, 2 # j
    addi $t3, $zero, 0 # k
# armazenar as variáveis na memória
    la $s1, variavel_I
    sw $t1, 0($s1)
    la $s1 variavel_J
    sw $t2, 0($s1)
    la $s1, variavel_K
    sw $t3, 0($s1)
# calcular o endereço efetivo de a[i], a[j] e a[k] fazer a soma e armazenar na memoria    
    la $s0, vetorA # endereço base de vetorA
    # I - endereço efetivo 1 x 4 = 4 + eb
    sll $t1, $t1, 2
    add $s1, $t1, $s0 # endereço efetivo do a[i]
    lw  $t4, 0($s1)   # conteúdo de a[i]
    # J - endereço efeitivo 2 x 4 = 8 + eb
    sll $t2, $t2, 2
    add $s2, $t2, $s0 # endereço efetivo de a[j]
    lw  $t5, 0($s2)   # conteudo de a[j]
    # soma de a[i] + a[j]
    add $t6, $t4, $t5
    # armazenar em a[k]
    sll $t3, $t3, 2     # redundante? 0 x 4 = 0
    add $s3, $t3, $s0   # endereço efetivo de a[j] 
    # armazena a[k]/$t6 na memoria 0($s3)
    sw $t6, 0($s3)

.data 
    variavelI:  .word 0 
    variavelJ:  .word 0
    variavelK:  .word 0
    # vetor a[10] = (1,2,3,4,5,6,7,8,9,10)
    vetorA:     .word 1, 2, 3, 4, 5, 6, 7, 8, 9, 10    
    
