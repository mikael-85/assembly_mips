## Problema 1

* Tradução do programas em C para assembly do processador MIPS. 
#### Código em C:


```C
int valor1 = 10;
int valor2 = 20;

int procedimento3(int x, int y) {
  int tmp;
  if (x < y) {
    tmp = x;
    x = y;
    y = tmp;
  }

  while (x > y) {
    x = x - 1;
    y = y + 1;
  }
  return x;
 }
  int procedimento2(int x) {
    int resultado;
    resultado = procedimento3(x, valor1) - procedimento3(x, valor2);
    return resultado;
  }

  int procedimento1(int x, int y) {
    int vetorA[10];
    int i;
    int acumulador;

    acumulador = 0;
    for (int i = 0; i < 10; i++) {
      vetorA[i] = i * x + y;
      vetorA[i] = procedimento2(vetorA[i]);
      acumulador = acumulador + vetorA[i];
    }
    return acumulador;
  }
  int main(void) {
    int n;
    int m;
    int resultado;
    n = 5;
    m = 3;
    resultado = procedimento1(n, m);
    return 0;
}
```

### Abordagens
#### Procedimento:
Trabalhar com procedimentos foi interessante, pois em cada procedimento é necessário (não obrigatório) um mapa da pilha para poder, antes de iniciar, se basear nela e ver onde todas as variáveis e registradores necessários são armazenados. É interessante
salientar também que, argumentos são passados através dos registradores $a0 - $a3, e o retorno de procedimentos (resultados das funções) através dos registradores $v0 - $v1.

#### exemplo de mapa da pilha e dos registradores antes de iniciar o procedimento:

```Assembly
#------------------------------------
# Mapa da pilha:
# 
#   tamanho pilha total: 60 bytes
#   ******************************
#   $sp + 56: $ra - end de retorno
#   $sp + 52: $s2 - vetA[9]
#   $sp + 48: $s2 - vetA[8]
#   $sp + 44: $s2 - vetA[7]
#   $sp + 40: $s2 - vetA[6]
#   $sp + 36: $s2 - vetA[5]
#   $sp + 32: $s2 - vetA[4]
#   $sp + 28: $s2 - vetA[3]
#   $sp + 24: $s2 - vetA[2]
#   $sp + 20: $s2 - vetA[1]
#   $sp + 16: $s2 - vetA[0]
#   $sp + 12: $s4 - y
#   $sp + 8: $s3 - x
#   $sp + 4: $s1 - acumulador
#   $sp + 0: $s0 - i
#-------------------------------------
# Mapa dos registradores
#
#   i: $s0
#   acumulaodor: $s1
#   vetor[10]: $s2
#   x: $s3
#   y: $s4
#   ends: $t0
#   valores temps: $t1
#   ix4: $s7
```
Outra questão importante é o uso da instrução jal - salta para um rótulo especificado e armazena o endereço de retorno na pilha. Alguns procedimentos não necessitam armazenar o $ra, como os procedimentos que não chamam outros procedimentos, conhecidos como procedimentos folhas.

### Valores após compilar e executar

#### Valores:  
Após compilado e executado, apresentou o resultado de -50
