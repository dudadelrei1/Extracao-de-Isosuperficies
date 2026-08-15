# Boston Teapot — Conversão de Dados e Marching Cubes

Esta pasta contém os arquivos utilizados no processamento do dataset **Boston Teapot**, disponibilizado pela coleção **Open SciVis Datasets**, no contexto do projeto de Iniciação Científica em **Síntese de Modelos 3D e Extração de Isosuperfícies**.

## Fluxo do processamento

```text
boston_teapot_256x256x178_uint8.raw
              │
              ▼
       leituraBinary.c
              │
              ▼
        coordenadas.txt
              │
              ▼
    MarchingCubesTXT2PLYs.pde
              │
              ▼
           arquivos .ply
```

## Arquivos

### `boston_teapot_256x256x178_uint8.raw`

Arquivo binário contendo os dados volumétricos do dataset Boston Teapot.

- **Dimensões:** 256 × 256 × 178
- **Tipo de dado:** `uint8`

### `leituraBinary.c`

Programa desenvolvido em C para realizar a leitura do arquivo binário e converter seus dados para uma representação em arquivo de texto.

O programa percorre o volume tridimensional e gera o arquivo `coordenadas.txt`, que será utilizado como entrada pelo algoritmo Marching Cubes.

### `coordenadas.txt`

Arquivo intermediário contendo a representação textual dos dados do volume.

### `MarchingCubesTXT2PLYs.pde`

Implementação do algoritmo **Marching Cubes** em Processing.

O programa lê `coordenadas.txt`, reconstrói o volume e gera malhas tridimensionais no formato `.PLY` para os isovalores definidos no código.

## Como executar

### 1. Converter o arquivo binário

Compile e execute o programa:

```bash
gcc leituraBinary.c -o leituraBinary
./leituraBinary
```

**Entrada:** `boston_teapot_256x256x178_uint8.raw`

**Saída:** `coordenadas.txt`

### 2. Gerar a malha 3D

Abra `MarchingCubesTXT2PLYs.pde` no Processing e execute o programa.

Os arquivos `.PLY` serão gerados para os isovalores configurados no código.

## Adaptação para outros datasets

Os códigos desta pasta foram utilizados com o **Boston Teapot**, porém não são exclusivos desse dataset.

O `leituraBinary.c` pode ser utilizado com outros arquivos binários, desde que sejam ajustados os parâmetros correspondentes às dimensões do volume, ao tipo dos dados e ao arquivo de entrada.

Da mesma forma, o `MarchingCubesTXT2PLYs.pde` pode ser utilizado com outros arquivos de texto que estejam no formato esperado pelo programa. Nesse caso, devem ser ajustados os parâmetros referentes às dimensões do volume, ao arquivo de entrada e aos valores de isovalor.

Assim, o Boston Teapot representa uma aplicação dos códigos a um dataset específico, enquanto os códigos podem ser adaptados para outros volumes.

## Resultado

O processamento produz uma ou mais **malhas tridimensionais no formato PLY**, obtidas a partir da extração de isosuperfícies do volume do Boston Teapot utilizando o algoritmo **Marching Cubes**.
