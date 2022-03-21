#===================================================================
# Descrição: 
# a = 10 e b = 1000000 
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
 # a = 10   
    la $s0, variavelA
    addiu $t1, $s0, 10
    sw $t1, 0($s0) 
# b = 1000000 = 0x000f 4240
    lui $t2, 0x000F
    ori $t2, $t2, 0x4240
    la $s0, variavelB
    sw $t2, 0($s0)
.data
    variavelA: .word 0 
    variavelB: .word 0
    
