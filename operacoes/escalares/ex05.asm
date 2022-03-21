#===================================================================
# Descrição: 
#  a = b; 
# sendo b = 1234
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
    la $s0, variavelB
    lw $t1, 0($s0)
    la $s0, variavelA
    sw $t1, 0($s0)

.data
    variavelA: .space 4
    variavelB: .word 1234
    
