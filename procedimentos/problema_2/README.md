## Problema 2

* Tradução do programas em C para assembly do processador MIPS. 
#### Código em C:

### Abordagens

#### Ponteiros:
Sobre ponteiros, precisamos prestar atenção quando estamos referenciando ao conteúdo de um endereço ou a um endereço propriamente dito. No exercício 2 da lista 4, é interessante notar que, a subtração: *(ptr - 1) e *(ptr - 2) é feita no endereço a que ptr
referencia, e após obtido o endereço, carregamos o conteúdo desse endereço para posteriormente calcularmos (*(ptr - 1) + *(ptr - 2)).

```Assembly
condicao_for_2:
  # (fib[2] -1) + (fib[2] -2)
  addi $t5, $s7, -4 # $s7 - 1byte
  lw $s0, 0($t5) # conteudo de ptr -1
  addi $t6, $s7, -8 # $s7 - 2byte
  lw $s1, 0($t6) # conteudo de ptr -2
  add $t7, $s1, $s0 # *ptr = *(ptr - 1) + *(ptr - 2)
```
o teste da condição do laço for, na linha 73 do arquivo em anexo ‘lista 04 ex 02.s’, foi feito utilizando o endereço de ptr em comparação com o endereço do tamanho total def[dim], ou endereço de f[dim] + (dim x 4), que resulta no endereço efetivo do tamanho total do vetor f[dim], utilizado para a comparação do laço em questão:


```Assembly
# inicio do for
  # ptr = &f[2]
  addi $s7, $zero, 2 # $s7 = 2
  sll $s7, $s7, 2 # $s7 = $s7 x 4
  add $s7, $s7, $s5 # endereco efetivo de &fib[2]
  
  sll $t2, $s6, 2 # size*4
  add $t3, $t2, $s5 # &f[size] | f[dim] | &f[10]
  j testa_for2
  
testa_for2:
   #ptr < &f[dim] ?
   slt $t4, $s7, $t3
   bne $t4, $zero, condicao_for_2 # se verdadeiro = 1 : 0
```

### Valores após compilar e executar

#### Valores:  
Após compilado e executado, no console, a saída do programa foi:
*“A soma dos elementos de fibonacci e 88”, condizendo com o resultado esperado.*

