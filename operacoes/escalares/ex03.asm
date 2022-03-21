#===================================================================
# Descrição: 
# Carregar um dado da memoria para registrdores 
# Guardar um dado de um registrador para memoria
# * Usando uma word, meia palavra e um byte
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
# carregamos o conteúdo do rótulo memory em $t0
    la $s0, memory
    lw $t0, 0($s0)
# carregamos meia palavra em $t1 com extensão de sinal
    lh $t1, 0($s0) # lhu - sem extensão de sinal
# carregamos 1 byte em $t2 com extensão de sinal
    lb $t2, 0($s0) # lbu - sem extensão de sinal

 # armazenamos os conteúdos dos registradores na memoria
 # palavra   
    la $s0, dataW
    sw $t0, 0($s0)  
# meia palavra
    la $s0, dataHW
    sh $t1, 0($s0)
# byte
    la $s0, dataB
    sb $t2, 0($s0)

.data
    memory: .word 0xABCDE080

    dataW:  .word 0
    dataHW: .half 0 
    dataB:  .byte 0

