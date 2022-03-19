#================================================================================
# Autor do codigo: Mikael Freitas
#================================================================================
# 
#================================================================================

.text
main:
# i = 1
    la   $t0, variavelI
    addi $s1, $zero, 1
    sw   $s1, 0($t0)
# goto abc
    j abc    
def:
# j = 1
    la   $t0, variavelJ
    addi $s1, $zero, 1
    sw   $s1, 0($t0)   
# k = 4
    la   $t0, variavelK
    addi $s1, $zero, 4
    sw   $s1, 0($t0)
# goto ghi
    j ghi
# i = 2 
    la   $t0, variavelI
    addi $s1, $zero, 2
    sw   $s1, 0($t0)
abc:
# goto def
    j def
ghi:
# if(i==j){
    # variavel i 
    la $t0 variavelI
    lw $s1 0($t0)
    # variavel j
    la $t1 variavelJ
    lw $s2 0($t0)
# if (i == j)
    beq  $s1, $s2, l0 # pula pra condicao verdadeira
#}else{
l1: #condicao falsa
    # a[2] = a[4]
    la $t2, vetorA
    lw $s4, 16($t2)  # $s4 = a[4]
    sw $s4, 8($t2)   # a[2] = a[4]    
    j codigo #goto codigo - pula a condição verdadeira 
#}
l0: #condicao verdadeira
    # a[2] = a[3]
    la $t2, vetorA
    lw $s4, 12($t2)  # $s4 = a[3]
    sw $s4, 8($t2)   # a[2] = a[3]   
codigo: # sai do if else
#================================================================================
    la $t0, variavelK # carrega end variavelK
    lw $s1, 0($t0)    # carrega conteude de variavelK  
inicio_do_while:
    j testa_condicao
instrucoes_do_while:
    # a[k] = 7
    addi $t6, $zero, 7
    la $t2, vetorA
    sll $t4, $s1, 2   # multiplica k x 4 
    add $t5, $t2, $t4 # endefetivo de a[k]
    sw  $t6, 0($t5)   # a[k] = 7  
    # k = k - 1
    addi $s1, $s1,  -1    # k = k - 1  
    sw $s1, 0($t0)    # armazena valor de k atualizado  
testa_condicao:
    # pula se for maior que zero para instrucoes do while
    bgtz $s1 instrucoes_do_while # se $s1 > 0 
fim_while:
 #if((i>k) && (i<10)){
 # * slt $destino ,$primeiro, $segundo -> destino, primeiro < segundo = 1
 # * slt $destino, $k, $i  -> 1   
    la   $t0, variavelI
    la   $t1, variavelK
    lw   $s5, 0($t0) # variavelI 
    lw   $s6, 0($t1) # variavelK
    slt  $s7, $s6, $s5 # i>k?1:0 -> 1 se verdadeiro
    addi $t4, $zero, 10
    slt  $t6, $s5, $t4 # i<10?1:0 -> 1 se verdadeiro
#inicio do if
    beq $s7, $zero, falso  # pula se falso -> $s7 = 1 != 0  (i>k)
    beq $t6, $zero, falso  # pula se falso -> $t6 = 1 != 0  (i<10)
    la $t3, variavelJ
    lw $s3, 0($t3)         # conteudo de variavelJ
    addi $s4, $zero, 6
# testes: ((cond1)||(condi2)) 
    #******* Se for igual k == 6, solta para verdadeiro, se nao,
    #******* Testa se j>i se sim, salta, se nao testa se j = i e salta para verdadeiro
     
    beq $s6, $s4, verdadeiro    # ($t3(k) == #s4(6))?verdadeiro:falso  
    # (j>i)?verdadeiro:falso
    slt $s1, $s5, $s3           # i<j? se verdadeiro $s1 = 1 
    bne $s1, $zero, verdadeiro  # pula se j>i ou i<j | 1 !=0
    # (j=i)?verdadeiro:falso
    beq $s5, $s3, verdadeiro    # testa se i==j?verdadeiro:falso
           
falso: #else
    #a[9] = 500
    la $t2, vetorA
    addi $t0, $zero, 500
    sw $t0, 36($t2) # a[9] = 500
    j fim_if
verdadeiro: # corpo do codigo do if
    #a[9] = 400
    la $t2, vetorA
    addi $t1, $zero, 400
    sw $t1, 36($t2) # a[9] = 400
fim_if:
# verificar se o valor de j esta no intervalo de 0 a 3
    # testa se j é menor do que zero
    slt $s1, $s3, $zero # j<0?1:0
    bne $s1, $zero, fim_switch # j<0? fim do switch, fora do intervalo
    # testa se j é menor do que 4
    slti $s1, $s3, 4    # se j<4?1:0
    beq $s1, $zero, fim_switch  # j>4? fimdo switch, fora do intervalo
    # saltamos para o endereço da tabela de desvios referente a variavel j
    la $t5, tabela_desvios
    sll $t6, $s3, 2     # multiplica jx4
    addu $t1, $t6, $t5  # end efetivo de tabela_desvios[j]
    lw  $t4, 0($t1)     # conteudo de tabela_desvios[j]
    jr $t4              # pula para o rotulo no indice tabela_desvios[j]
# case 0
d0:
    # a[6] = 4;
    la $t2, vetorA
    addiu $s7, $zero, 4
    sw $s7, 24($t2)     # a[6] = 4
    j fim_switch
# case 1
d1:
    # a[6] = 5;  
    addiu $s7, $zero, 5
    sw $s7, 24($t2)     # a[6] = 5
    j fim_switch
# case 2
d2:
    # a[6] = 6;
    addiu $s7, $zero, 6
    sw $s7, 24($t2)     # a[6] = 6
    j fim_switch
# case 3
d3:
    # a[6] = 7;
    addiu $s7, $zero, 7
    sw $s7, 24($t2)     # a[6] = 7
    j fim_switch
fim_switch: 
# return 0           
    addi  $v0, $zero, 17 # serviço 17 do sistema - exit2
    addi  $a0, $zero, 0 # o valor de retorno do programa é zero
    syscall             # chamamos o serviço 17 do sistema com o valor 0

.data
    vetorA:    .word 0,1,2,3,4,5,6,7,8,9
    variavelI: .word 0
    variavelJ: .word 0
    variavelK: .word 0
    tabela_desvios: .word d0, d1, d2, d3
