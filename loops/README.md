## Problema 1

* Tradução do programas em C para assembly do processador MIPS. 
#### Código em C:

```C
int a[10]={0,1,2,3,4,5,6,7,8,9};
int i, j, k;
int acc = 0;

int main(void){
  i = 1;
  j = 2;
  k = 4;
  for(i=0; i<10; i++){
    a[i] = a[i] + 3;
  }

  for(i=0; i<10; i++){
    for(j = i; j<10; j++){
      acc = acc + a[j];
    }
  }
  a[6] = acc;
  while(a[k]<acc){
    a[k] = a[k] + 10;
  }
  do{
    a[7] = a[k] + 1;
  }while(a[7]<a[8])
}
```



### Abordagens
#### Segundo laço de repetição:

```C
for(i=0; i<10; i++){
  for(j = i; j<10; j++){
    acc = acc + a[j];
  }
}
```

Para solucionar a parte do segundo if onde temos um laço dentro do laço, optei por utilizar 5 rótulos, o primeiro, ‘inicializa_for2’ serve para inicializar os valores 0 em i e iguala i a j.
O programa pula incondicionalmente para o rótulo ‘verifica_condição2’, que consiste em verificar se i<10, caso falso, o programa salta para ‘condicao_falsa2’ e sai do laço de repetição. 
Caso verdadeiro, o programa salta ‘verifica_segunda_condicao’, onde verifica se, j<10, caso verdadeiro, salta para o rótulo ‘incrementa_acc’, executando o código do rótulo até j=>10, e neste caso, o programa volta para o rótulo ‘condicao_verdadeira2’.
No rótulo: ‘incrementa_acc’, o código básicamente incrementa acc com acc = acc+a[j], e incrementa j: j++. voltando para o rótulo ‘verifica_segunda_condicao'

### Valores após compilar e executar

#### Valores das variáveis:  
* i = 10; 
* j = 10;
* k = 4;

### Valores do vetor a após compilado e executado: 
* vetor a = 3, 4, 5, 6, 497, 8, 495, 498, 11, 12.
