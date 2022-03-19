## Problema 1

* Tradução do programas em C para assembly do processador MIPS. 
#### Código em C:


```C
int a[10]={0,1,2,3,4,5,6,7,8,9};
int i, j, k;

int main(void){
  i = 1;
  goto abc;
  def:
  j = 1;
  k = 4;
  goto ghi;
  i = 2;
  abc:
  goto def;
  ghi:
  if (i==j){
    a[2] = a[3];
  }else{
    [2] = a[4];
  }
  while(k>0){
    a[k] = 7;
    k = k - 1;
  }
  if((i>k) && (i<10)){
    if((k==6) || (j>=i)){
      a[9] = 400;
    }else{
      a[9] = 500;
    }
  }
  switch(j){
    case 0: a[6] = 4; break;
    case 1: a[6] = 5; break;
    case 2: a[6] = 6; break;
    case 3: a[6] = 7; break;
  }
}
```
### Abordagens
#### Laço dentro do laço:

```C
if((i>k) && (i<10)){
  if((k==6) || (j>=i)){
    a[9] = 400;
  }else{
    a[9] = 500;
  }
}
```

A primeira condição do if dividi em duas partes, e como temos o parâmetro ((cond1)&&(cond2)), ambas assertivas necessitam serem verdadeiras para que siga para a outra parte do if. A primeira condição testamos se, (i>k), caso for falso ele salta para o rótulo ‘falso’ (#else), do contrário, testa a segunda condição se i<10, caso falso, salta para o rótulo ‘falso’.

![Imagem 1](https://github.com/mikael-85/assembly_mips/blob/main/desvios/problema_1/arquivos/arq.png)

Dentro do if temos ainda outras duas condições, testadas com desvio condicional para cada uma das assertivas. ((cond1)||(cond2)). Como apenas uma dessas afirmações necessita ser verdadeira, testamos primeiramente se (k==6), caso verdadeiro, o programa salta condicionalmente para o rótulo 'verdadeiro', caso falso, ele ainda testa a segunda afirmação: (j>=k), caso verdadeiro, salta condicionalmente para o rótulo 'verdadeiro', caso falso, salta para o rótulo 'falso'. Notando que, o sinal >= foi testado em dois passos, o primeiro se j>i salta para ‘verdadeiro’, caso contrário, é feito o segundo teste, j = i, se for verdadeiro, ele salta para ‘verdadeiro’, caso contrário, se nenhuma dessas condições forem verdadeiras, o programa salta para o rótulo 'falso'.

![imagem 2](https://github.com/mikael-85/assembly_mips/blob/main/desvios/problema_1/arquivos/arq1.png)

### Valores após compilar e executar

#### Valores das variáveis:  
* i = 1; 
* j = 1;
* k = 0;

### Valores do vetor a após compilado e executado: 
* vetor a = 0,7,7,7,7,5,5,7,8,400.
