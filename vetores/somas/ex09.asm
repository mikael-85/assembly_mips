#-------------------------------------------------------------------------------
# Releitura: 
# a[k] =  a[a[i]]; -> sendo i = 1 e a[1] = 5: a[k]= a[a[1]] logo: a[k] = a[5]
# a[j] = a[i+2] - i + j; sendo a[i] = a[1], logo a[j] = a[3] - 1 + 3
#
#================================================================================
# Autor do codigo: Mikael Freitas
#================================================================================
# Convencao, mapa de registradores:  
#--------------------------------------------------------------------------------
# $t0 - $t7 - Temporario (nao preservados na chamada da funcao)
# $t8, $t9  - Temporarios
# $s0 - $s7 - Registradores salvos (preservado na chamada da funcao)
#--------------------------------------------------------------------------------
# $t0 -> endereço base temporario das variaveis utilizadas
# $t1 -> armazena resultados temporarios/endereços temporarios 
# $s1 -> endereço base do vetorA
# $s2 -> conteudo de I 
# $s3 -> conteudo de J  
# $s4 -> conteudo de K
# $s5 -> conteudo de a[6]
# $s6 -> conteudo de a[7]
# $s7 -> conteudo de a[8]
#================================================================================
.text
# i = 1
    la $t0, variavelI
    addi $s2, $zero, 1
    sw $s2, 0($t0)
# j = 3
    la $t0, variavelJ
    addi $s3, $zero, 3
    sw $s3, 0($t0)
# k = 4
    la $t0, variavelK
    addi $s4, $zero, 4
    sw $s4, 0($t0)    
# a[1] = 5
    la $s1, vetorA # endereco base do vetorA
    addi $t4, $zero, 5     
    sw $t4, 4($s1) # armazena 5 em a[1]
# a[2] = a[3] + 20;
    addi $t4, $zero, 20
    lw  $t5, 12($s1)
    add $t4, $t5, $t4
    sw  $t4, 8($s1) # a[2] = a[3] + 20
# a[3] = a[4] + 200 000 => 0x030D40 
    # 200000 = 0x0003 0D40 
    # lui $re2, 0x0003
    # ori $reg2, $reg2, 0x0D40
    lw $t5, 16($s1) # carregar conteudo de a[4]
    lui $t6, 0x0003 
    ori $t6, $t6, 0x0D40
    add $t5, $t5, $t6 # a[4] + 200000
    sw  $t5, 12($s1)  # armazena em a[3]   
# a[4] = 10000;
    addi $t5, $zero, 10000
    sw   $t5, 16($s1) # armazena o conteudo de $t5 em a[4]
# a[5] = a[6] + a[7] - a[8];
    lw  $s5, 24($s1)    # carrega o conteudo de a[6] em $s5
    lw  $s6, 28($s1)    # carrega o conteudo de a[7] em $s6      
    lw  $s7, 32($s1)    # carrega o conteudo de a[8] em $s7 
    add $t7, $s6, $s5   # faz a soma de a[6] + a[7] e armazena em $t7
    sub $t4, $t7, $s7   # faz a subtracao do resultado da soma em $t7 menos $s7
    sw  $t4, 20($s1)    # armazena em a[5] o resultado das operacoes
# a[6] = a[7] + i;
    add $t4, $s6, $s2
    sw  $t4 24($s1)     # armazena o conteudo de $t4 em a[6]    
# a[7] = a[8] - a[i];
    #achar o a[i]
    sll $t1, $s2, 2     # multiplicar o i por 4
    add $t1, $s1, $t1   # soma eb com $t1 para ee de a[i]
    lw  $t2, 0($t1)     # conteudo de a[i] em $t2
    sub $s6, $s7, $t2   # $s6 = a[8] - a[i]
    sw  $s6, 28($s1)    # armazena $s6 em a[7] 
# a[j] = a[i+2] - i + j;
    # a[i+2]
    addi $t3, $s2, 2    # i + 2
    sll $t1, $t3, 2     # multiplica por 4x[i+2] 
    add $t1, $s1, $t1   # soma o eb: vetorA + 4x[i+2] = ef
    lw  $t7, 0($t1)     # armazena o conteudo de a[i+2] em $t7
    # a[i+2] - i - j
    sub $t7, $t7, $s2   # $t7 = a[i+2] - i 
    add $t7, $t7, $s3   # $t7 = [a[i+2] - i] + j
    # endereço efetivo de a[j]:
    sll $t1, $s3, 2     # multiplica jx4 e armazena em $t1
    add $t1, $s1, $t1   # soma end base vetorA + jx4 = ef a[j]
    # armazenar o conteudo de a[i+2] - i + j; em a[j]:
    sw $t7 0($t1)       # armazena resultado em a[j]
# a[k] = a[a[i]];
    # encontrar o endereço efetivo de a[i]
    # encontrar o conteudo de a[i]
    sll $t1, $s2, 2     # ix4 
    add $t1, $s1, $t1   # ix5 + eb vetorA
    lw  $t2, 0($t1)     # conteudo de a[i] em $t2
    # encontrar o endereço efetivo de a[a[i]]
    # encontrar o conteudo de a[a[i]]
    sll $t1, $t2, 2     # multiplica por 4 o conteudo de a[i]
    add $t1, $s1, $t1   # endereço efetivo de a[a[i]] 
    lw  $s8, 0($t1)     # carrega em $s8 o conteudo de a[a[i]]
    # encontrar o endereço efetivo de a[k]
    sll $t1, $s4, 2     # multiplica K por 4
    add $t1, $s1, $t1   # endereço efetivo de a[k]
    # armazenar em a[k] | a[k] = a[conteudo de a[i]]
    sw $s8, 0($t1)      # armazena no ee de a[k] o conteudo de a[a[i]] de $s8

.data 
    variavelI:  .word 0
    variavelJ:  .word 0
    variavelK:  .word 0
    vetorA:     .word 0,1,2,3,4,5,6,7,8,9
    
