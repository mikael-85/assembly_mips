#===================================================================
# Descrição: 
# Codigo a = b + c 
#1 - definir as variaveis na memoria
#2 - definir valores
#3 - executar a soma
#4 - guardar na memoria
#===================================================================
# Convensão dos registradores
#===================================================================
# $0        - Sempre zero
# $at       - Temporário para assembly (reservado)
# $v0, $v1  - Valore retornado de uma rotina
# $a0 - $a3 - Argumentos para uma sub-rotina
# $t0 - $t7 - Temporário (não preservados na chamada da função)
# $s0 - $s7 - Registradores salvos (preservado na chamada da função)
# $t8,$t9   - Temporários
# $k0, $k1  - Kernel (reservado para o S.O)
# $gp       - Ponteiro global
# $sp       - Ponteiro para a pilha (stack pointer)
# $fp       - Ponteiro para o quadro (frame pointer)
# $ra       - End de retorno (usando em algumas instruções)
#===================================================================
.text
#===================================================================
# s1 = A
# s2 = B
# s3 = C
#====================================================================
# Carregando endereço de variavelB em $t0 e o conteúdo de $t0 em $s2
    la $t0, variavelB
    lw $s2, 0($t0)
# Carregando endereço de variavelC em $t0 e o conteúdo de $t0 em $s3
    la $t0, variavelC
    lw $s3, 0($t0)
# Soma valores de $s2 e #s3 guardando resultado em $s1    
    add $s1, $s2, $s3
# Armazena conteúdo de $s1 em variavelA
    la $t0, variavelA  # copia end de variavelA em $t0
    sw $s1, 0($t0)     # armazena o conteudo de #s1 no end efetivo 0($t0)



.data
    variavelA: .word 0
    variavelB: .word 1
    variavelC: .word 2
