#===================================================================
# Descrição: 
# a[2] = a[4] + a[1]
# sendo a[10] = {0...9}
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
# endereço base do vetor (eb)
    la $s0, vetorA
# a[1] = $t1
    lw $t1, 4($s0)  # ee = (eb + i.d) => ee = [eb + (1x4)] = 4
# a[4] = $t4 
    lw $t4, 16($s0) # ee = (eb + i.d) => ee = [eb + (4x4)] = 16
# somamos a[4] + a[1] e armazenamos em a[2]
    add $t2, $t1, $t4
# guardamos a[2] na memória
    sw $t2, 8($s0) # # ee = (eb + i.d) => ee = [eb + (2x4)] = 8

.data
    vetorA: .word 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
