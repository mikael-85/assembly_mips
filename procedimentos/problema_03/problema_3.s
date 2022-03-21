.data 
    soma:   .word 0
    nota1:  .word 0
    nota2:  .word 0

.text
.globl main

# Inicio do programa

init:
    jal main
finit:
    addi $a0, $zero, 0
    addi $v0, $zero, 17
    syscall

soma_notas:
# Descricao:
#   Somar dois inteiros e retornar um valor
#-------------------------------------------------------
# Argumento do procedimento:
#   x: $a0
#   y: $a1   
#-------------------------------------------------------
# Mapa da pilha:
#   *devemos colocar a variavel temp da soma na pilha
#   $sp + 4: $s0
#   $sp + 0: temp   
#--------------------------------------------------------
# Mapa dos registradores
#   temp: $s0 
#--------------------------------------------------------
# Retorno do procedimento
#--------------------------------------------------------
#=========================================================
# prologo
    addiu $sp. $sp -8   # ajusta a pilha
    sw $s0, 4($sp)      # armazena $s0 na pilha (?)

# corpo do programa
    add, $s0, $a0, $a1
    sw   $s0, 0($sp)      # armazena temp na pilha 
    addu $v0, $zero, $s0  # valor de retorno deve estar em $v0 e $v1 

# epilogo
    lw $s0, 4($sp)      # restaura valor original de $s0
    addiu $sp, $sp, 8   # ajusta a pilha       
    jr $ra              # retorna procedimento caller

main:
# Descricao:
#  procedimento principal do programa
#-------------------------------------------------------
# Argumento do procedimento:
#  nenhum
#-------------------------------------------------------
# Mapa da pilha:
#   $sp + 12: $ra
#   $sp + 8:  $s2
#   $sp + 4:  $s1
#   $sp + 0:  $s0   
#--------------------------------------------------------
# Mapa dos registradores
#   nota1: $s0
#   nota2: $s1
#   soma:  $s2
#   ends:  $t0
#--------------------------------------------------------
# Retorno do procedimento
#--------------------------------------------------------
#=========================================================
# prologo
    addiu $sp, $sp, -16     # ajustamos a pilha 
    sw $ra, 12($sp)         # endereço de retorno da pilha
    sw $s2, 8($sp)          
    sw $s1, 4($sp)
    sw $s0, 0($sp)

# corpo
    #nota1 = 3 
    addi $s0, $zero, 3
    la $t0, nota1
    sw $s0, 0($t0)  
    #nota2 = 4
    addi $s1, $zero, 4
    la $t0, nota2
    sw $s1, 0($t0)
    # soma_notas(nota1, nota2)
    #* colocar valores nos registradores a0 a a3 e na pilha 
    addu $a0, $a0, $s0  #nota1
    addu $a1, $a0, $s1  #nota2
    jal soma_notas  # chama o procedimento soma_notas
    addu $s2, $zero, $v0  # transfere o valor de retorno de soma_notas para $s2 (soma)
    la $t0, soma
    sw $s2, 0($t0)        # salva o valor de soma_notas na variavel soma 
    #retun 0
    addi $v0, $zero, 0            
# epilogo
    lw $s0, 0($sp)
    lw $s1, 4($sp)
    lw $s2, 8($sp)
    lw $ra, 12($sp)    
    addiu $sp, $sp, 16
    jr $ra # retorna para o procedimento chamador
    
