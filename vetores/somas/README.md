# Algumas somas utilizando vetores

### Exercício 7
  * Efetuar a soma entre as posições a[2] = a[4] + a[1]; sendo a[10] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9}  

#### Passos: 
  * Calcular o endereço do vetor a[10]
  * Calcular o endereço efetivo das posições a[2], a[4] e a[1] em registradores 
  * Atribuir os valores contidos nas posições dos endereços efetivos calculados nos registradores
  * Efetuar as somas
  * Guardar o resultado de a[2] na posição correta na memória 
## 
### Exercício 8
  * Atribuir a soma de a[i] + a[j]  em a[k]; onde i = 1, j = 2 e k = 0; sendo a[10] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9}

#### Passos: 
  * Definir os valores de 0, 1 e 2 nas variáveis k, i e j 
  * Armazenar o valor das variáveis na memória
  * Calcular o endereço efetivo de a[i], a[j] e a[k]
  * Calcular o resultado de a[j] + a[i]
  * Armazenar na memória o resultado da soma em a[k]

### Exercício 9
  * Traduzir o trecho a seguir de C para assembly do mips:

```C
int a[10]={0,1,2,3,4,5,6,7,8,9};
int i, j, k;
int main(void){
 i = 1;
 j = 3;
 k = 4;
 a[1] = 5;
 a[2] = a[3] + 20;
 a[3] = a[4] + 200000;
 a[4] = 10000;
 a[5] = a[6] + a[7] - a[8];
 a[6] = a[7] + i;
 a[7] = a[8] - a[i];
 a[j] = a[i+2] - i + j;
 a[k] = a[a[i]];
}
```
#### Releitura de trecho: 
 * a[k] =  a[a[i]]; -> sendo i = 1 e a[1] = 5: a[k]= a[a[1]] logo: a[k] = a[5]
 * a[j] = a[i+2] - i + j; sendo a[i] = a[1], logo a[j] = a[3] - 1 + 3
  
