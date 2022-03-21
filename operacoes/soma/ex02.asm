#===================================================================
# Descrição: 
# Codigo:   a = b + c + d + e
# 1 - reg1 =  b + c
# 2 - reg2 =  d + e
# 3 - reg3 = reg1 + reg2   
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
# carregando as constantes B, C, D, E nos respectivos registradores $s2, $s3, $s4, $s5
    la $t0, ConstanteB
    lw $s2, 0($t0)
    la $t0, ConstanteC
    lw $s3, 0($t0)
    la $t0, ConstanteD
    lw $s4, 0($t0)
    la $t0, ConstanteE
    lw $s5, 0($t0)
# efetuando as somas $t0 = $s2 + $s3 e $t1 = $s4 + $s5   
    add $t0, $s2, $s3
    add $t1, $s4, $s5
# efetuando a soma $s1 = $t0 + $t1    
    add $s1, $t0, $t1
# carregando endereço da VariavelA e salvando o resultado de #s1 no end efetivo de variavelA    
    la $t0, variavelA
    sw $s1, 0($t0) 

.data
    variavelA:  .word 0 
    ConstanteB: .word 1
    ConstanteC: .word 2
    ConstanteD: .word 3
    ConstanteE: .word 4
    
