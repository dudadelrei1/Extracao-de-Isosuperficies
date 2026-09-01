# Angiografia

Este diretório contém o código desenvolvido para a leitura e organização de um conjunto de imagens de angiografia utilizado como dado volumétrico.
O código realiza a leitura sequencial das imagens que compõem o exame de angiografia e organiza as diferentes fatias para formar a representação de um volume tridimensional. Cada imagem corresponde a uma seção do volume em uma determinada posição no eixo Z.

## Funcionamento

O programa utiliza um conjunto de imagens de angiografia previamente armazenadas em uma sequência. As imagens são carregadas individualmente e organizadas de acordo com sua ordem.

Cada imagem representa uma fatia bidimensional do volume:

```text
Imagem 0 → Z = 0
Imagem 1 → Z = 1
Imagem 2 → Z = 2
...
Imagem N → Z = N
```

Quando todas as imagens são consideradas em conjunto, elas formam um conjunto de dados volumétricos tridimensional.

## Leitura das imagens

As imagens são carregadas utilizando a função `loadImage()` do Processing.

O programa percorre a sequência de arquivos e armazena cada imagem em uma estrutura de dados:

```java
PImage[] imgs;
```

Cada posição do vetor corresponde a uma fatia do volume:

```text
imgs[0] → primeira imagem
imgs[1] → segunda imagem
imgs[2] → terceira imagem
...
```

Dessa forma, o vetor funciona como uma representação simplificada da terceira dimensão do conjunto de dados.

## Organização das fatias

A ordem das imagens é importante para preservar a estrutura espacial do exame.

As imagens são organizadas de forma crescente ao longo do eixo Z:

```text
        Z
        ↑
        │
   ┌─────────┐
   │ Imagem N│
   ├─────────┤
   │   ...   │
   ├─────────┤
   │ Imagem 1│
   ├─────────┤
   │ Imagem 0│
   └─────────┘
```

Assim, cada imagem representa uma seção transversal e a sequência completa representa o volume de angiografia.

## Acesso aos pixels

Depois que uma imagem é carregada, o programa pode acessar os valores de seus pixels utilizando suas coordenadas `(x, y)`.

Para um pixel localizado na posição:

```text
(x, y)
```

o valor de intensidade pode ser obtido diretamente da imagem.

Considerando todas as imagens, cada ponto do volume pode ser representado por:

```text
(x, y, z)
```

onde:

* `x` representa a posição horizontal na imagem;
* `y` representa a posição vertical na imagem;
* `z` representa a posição da fatia dentro da sequência.

Assim, o conjunto de imagens pode ser interpretado como um campo de dados tridimensional.

## Representação volumétrica

A organização das imagens permite representar o exame como:

```text
Volume(x, y, z)
```

em que cada coordenada `(x, y, z)` está associada a um valor de intensidade proveniente da imagem correspondente.

Por exemplo:

```text
Volume(100, 150, 20)
```

corresponde ao pixel `(100, 150)` da imagem localizada na fatia `20`.

Essa estrutura é necessária para trabalhar posteriormente com algoritmos de visualização e extração de superfícies tridimensionais.

## Dados de angiografia

Diferentemente do dataset sintético do Gingerbread Man, os dados de angiografia representam uma estrutura obtida a partir de um exame médico.

Nesse caso, a geometria não é definida diretamente por equações matemáticas. Ela está contida nos valores de intensidade das imagens.

As diferentes intensidades presentes nas fatias representam as informações estruturais do exame e podem ser utilizadas para identificar regiões de interesse no volume.

## Preparação para o Marching Cubes

Após a leitura e organização das imagens, o conjunto pode ser utilizado como entrada para o algoritmo **Marching Cubes**.

O fluxo do processamento é:

```text
Imagens de angiografia
        ↓
Leitura das imagens
        ↓
Organização das fatias
        ↓
Volume 3D
        ↓
Definição do isovalor
        ↓
Marching Cubes
        ↓
Extração da isosuperfície
        ↓
Malha 3D
```

O Marching Cubes poderá percorrer o volume formado pelas imagens e analisar os valores de intensidade dos voxels para identificar a superfície correspondente ao isovalor escolhido.

## Diferença em relação aos dados sintéticos

O dataset de angiografia possui uma característica diferente do Gingerbread Man.

No Gingerbread Man, o volume é **gerado matematicamente**, permitindo conhecer previamente a geometria utilizada para sua construção.

Na angiografia, os dados são provenientes de imagens e apresentam uma estrutura muito mais complexa.

Dessa forma, os dois tipos de dados podem ser utilizados em etapas diferentes do projeto:

```text
Dados sintéticos
      ↓
Validação do algoritmo
      ↓
Gingerbread Man
      ↓
        Marching Cubes
      ↑
Angiografia
      ↓
Aplicação em dados reais
```

O dataset sintético permite testar o funcionamento do algoritmo em uma situação controlada, enquanto a angiografia possibilita avaliar sua aplicação em dados volumétricos mais complexos.

## Resultado

Ao final da leitura, as imagens de angiografia estão organizadas em uma sequência que permite sua interpretação como um **volume tridimensional**.

Esse volume constitui uma das entradas utilizadas no projeto para estudar a **extração de isosuperfícies a partir de dados volumétricos**, servindo como base para a aplicação do Marching Cubes e posterior geração de modelos 3D.

