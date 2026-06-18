# Construção de Esfera Utilizando Isosuperfícies com Marching Cubes em Imagens

## Descrição

Este projeto tem como objetivo reconstruir uma esfera tridimensional a partir de um conjunto de imagens volumétricas utilizando o algoritmo **Marching Cubes**. A técnica baseia-se na extração de uma **isosuperfície** de um volume discreto representado por voxels, gerando uma malha triangular que aproxima a superfície do objeto.

## Fundamentação Teórica

### Imagens Volumétricas

Um volume tridimensional pode ser representado por uma matriz de voxels:

[V(x,y,z)]

onde cada voxel armazena um valor escalar correspondente à intensidade do sinal ou à densidade do material naquele ponto do espaço.

Para a construção de uma superfície, define-se um valor limiar (isovalor) ( \tau ). A superfície desejada é formada pelos pontos que satisfazem:

[V(x,y,z)=\tau]

Essa superfície recebe o nome de **isosuperfície**.

### Esfera como Isosuperfície

Uma esfera de raio (r) e centro ((x_c,y_c,z_c)) pode ser descrita implicitamente por:

[f(x,y,z)=(x-x_c)^2+(y-y_c)^2+(z-z_c)^2-r^2]

Os pontos pertencentes à superfície da esfera satisfazem:

[f(x,y,z)=0]

Portanto, a esfera pode ser interpretada como uma isosuperfície do campo escalar definido por (f).

## Algoritmo Marching Cubes

O Marching Cubes, proposto por Lorensen e Cline (1987), percorre o volume voxel a voxel para reconstruir uma superfície triangular.

### Passo 1 – Formação dos Cubos

O volume é dividido em pequenos cubos formados por oito voxels vizinhos.

v7 ------ v6
|          |
|          |
v4 ------ v5

v3 ------ v2
|          |
|          |
v0 ------ v1

Cada cubo possui 8 vértices.

### Passo 2 – Classificação dos Vértices

Para cada vértice (v_i):

* Se (V(v_i) \geq \tau), o vértice é considerado interno.
* Caso contrário, é considerado externo.

Cada vértice gera um bit:
1 → dentro
0 → fora

Como existem 8 vértices, obtém-se uma configuração binária de 8 bits:

[2^8 = 256]

possíveis configurações.

### Passo 3 – Consulta da Tabela de Casos

O índice binário gerado é utilizado para acessar uma tabela pré-computada que informa:

* quais arestas são interceptadas pela isosuperfície;
* como formar os triângulos correspondentes.

Por exemplo:

00000000 → nenhum triângulo
11111111 → nenhum triângulo
00001111 → caso intermediário

### Passo 4 – Interpolação dos Pontos

Quando a superfície cruza uma aresta do cubo, sua posição é estimada por interpolação linear.

Se uma aresta possui extremos:

[P_1=(x_1,y_1,z_1)]

[P_2=(x_2,y_2,z_2)]

com valores escalares:

[s_1] e

[s_2]

o ponto de interseção é calculado por:

[P=P_1+t(P_2-P_1)]

onde

[t=\frac{\tau-s_1}{s_2-s_1}]

Essa etapa produz uma aproximação muito mais suave da superfície.

### Passo 5 – Geração da Malha

Os pontos interpolados são conectados de acordo com a tabela de casos, formando triângulos.

A união de todos os triângulos gera a malha final da esfera.

Volume de Voxels
       ↓
Formação dos Cubos
       ↓
Classificação dos Vértices
       ↓
Interpolação das Arestas
       ↓
Geração dos Triângulos
       ↓
Malha da Esfera

## Implementação

### Entrada

O algoritmo recebe:

* conjunto de imagens 2D empilhadas (slices);
* volume tridimensional correspondente;
* valor de isosuperfície (threshold).

### Renderização

Após a reconstrução, a malha pode ser visualizada no software:

* MeshLab

### Artigo Clássico

Lorensen, W. E.; Cline, H. E. *Marching Cubes: A High Resolution 3D Surface Construction Algorithm*. SIGGRAPH '87, 1987.

Esse trabalho introduziu o algoritmo Marching Cubes e permanece como a principal referência para reconstrução de superfícies a partir de dados volumétricos.
