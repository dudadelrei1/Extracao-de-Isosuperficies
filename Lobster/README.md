# Marching Cubes: Volume RAW → Malha PLY

Pipeline simples para converter um volume tomográfico 3D (formato `.raw`, 8 bits) em malhas de superfície 3D (`.ply`) usando o algoritmo **Marching Cubes**, com extração de várias isosuperfícies de uma só vez.

O exemplo incluído usa o volume **Lobster** (lagosta), de dimensões **301 × 324 × 56** voxels.

## Visão geral

```
lobster_301x324x56_uint8.raw
            │
            ▼   leituraBinary.c
      coordenadas.txt      (x y z valor, um voxel por linha)
            │
            ▼   MarchingCubesTXT2PLYs.pde (Processing)
mciso60-Lobster.ply, mciso70-Lobster.ply, ... mciso110-Lobster.ply
```

## Arquivos

| Arquivo | Descrição |
|---|---|
| `lobster_301x324x56_uint8.raw` | Volume de entrada: 301×324×56 voxels, `uint8`, sem cabeçalho (5.461.344 bytes). |
| `leituraBinary.c` | Lê o `.raw` e grava em texto as coordenadas dos voxels não nulos. |
| `coordenadas.txt` | Saída do programa em C e entrada do Processing (arquivo grande, ~69 MB). |
| `MarchingCubesTXT2PLYs.pde` | Sketch do Processing que aplica o Marching Cubes e exporta arquivos `.ply`. |

## Requisitos

- Compilador C (GCC, Clang ou MSVC)
- [Processing 4](https://processing.org/download)
- Opcional, para visualizar os resultados: [MeshLab](https://www.meshlab.net/) ou [CloudCompare](https://www.cloudcompare.org/)

## Como usar

### 1. Converter o volume RAW em texto (C)

```bash
gcc leituraBinary.c -o leituraBinary
./leituraBinary
```

O programa lê `lobster_301x324x56_uint8.raw` e gera `coordenadas.txt`, com uma linha por voxel diferente de zero.

**Formato esperado pelo Processing:**

```
x y z valor
```

> ⚠️ **Atenção:** o sketch do Processing lê **4 colunas** (`x y z valor`). Portanto, o `fprintf` do `leituraBinary.c` deve gravar também o valor do voxel:
>
> ```c
> fprintf(saida, "%d %d %d %d\n", x, y, z, volume[z][y][x]);
> ```
>
> Se gravar só `x y z`, o Processing dará erro de índice ao tentar ler a quarta coluna.

Os valores do volume (0–255) são as densidades que serão comparadas com as isosuperfícies.

### 2. Gerar as malhas PLY (Processing)

1. Abra `MarchingCubesTXT2PLYs.pde` no Processing.
2. Coloque o `coordenadas.txt` na **pasta do sketch** (o `loadStrings` procura o arquivo lá).
3. Ajuste os parâmetros em `setup()`, se necessário (veja abaixo).
4. Clique em **Run**.

O sketch percorre todos os cubos do volume, gera os triângulos para cada isovalor e salva um `.ply` por isovalor na pasta do sketch. O progresso (isovalor, número de vértices e de faces) aparece no console.

## Parâmetros

Definidos no início de `setup()` em `MarchingCubesTXT2PLYs.pde`:

| Parâmetro | Valor padrão | Significado |
|---|---|---|
| `isomenor` | `60` | Menor isovalor extraído. |
| `isomaior` | `110` | Maior isovalor extraído. |
| `delta` | `10` | Passo entre isovalores. Com os padrões: 60, 70, 80, 90, 100, 110. |
| `Dimension` | `56` | Profundidade do volume (eixo Z). |
| `Weight` | `301` | Largura do volume (eixo X). |
| `Height` | `324` | Altura do volume (eixo Y). |
| `txt` | `"coordenadas.txt"` | Arquivo de entrada. |
| `nome` | `"mciso"` | Prefixo dos arquivos de saída. |
| `zip` | `"-Lobster"` | Sufixo dos arquivos de saída. |

> As dimensões em `leituraBinary.c` (`W`, `H`, `D`) e no `.pde` devem ser **as mesmas**, e precisam corresponder ao volume `.raw` usado.

## Saída

Para cada isovalor `a` é gerado um arquivo com o nome `<nome><a><zip>.ply`. Com as configurações padrão:

```
mciso60-Lobster.ply
mciso70-Lobster.ply
mciso80-Lobster.ply
mciso90-Lobster.ply
mciso100-Lobster.ply
mciso110-Lobster.ply
```

Os arquivos estão no formato **PLY ASCII 1.0**, com vértices (`x y z`) e faces triangulares, e podem ser abertos diretamente no MeshLab, CloudCompare, Blender, entre outros.

## Como funciona

1. **Leitura:** o volume é carregado em um array 3D `volume[z][y][x]`.
2. **Classificação dos cubos:** cada cubo de 2×2×2 voxels tem seus 8 cantos comparados ao isovalor, formando um índice de 8 bits (`cubeIndex`).
3. **Tabelas do Marching Cubes:** `edgeTable` indica quais arestas são cortadas pela superfície, e `triTable` define os triângulos a gerar (256 configurações).
4. **Interpolação linear:** a posição de cada vértice na aresta é calculada por interpolação entre os valores dos dois cantos (`interp`).
5. **Exportação:** vértices e faces são gravados em um arquivo PLY.

## Observações

- **Memória no C:** o programa aloca o volume inteiro na pilha (`uint8_t volume[D][H][W]`, ~5,2 MB). Em alguns sistemas (por exemplo, Windows com o limite padrão de 1 MB) isso pode causar *stack overflow*. Se acontecer, declare o array como `static` ou use `malloc`.
- **Tamanho do `coordenadas.txt`:** o arquivo gerado tem cerca de 69 MB e mais de 3,8 milhões de linhas. Considere não versioná-lo (adicione ao `.gitignore`) e gerá-lo localmente.
- **Vértices duplicados:** cada triângulo grava seus próprios 3 vértices, sem compartilhamento entre faces vizinhas. Isso deixa os arquivos maiores, e pode ser resolvido com "Merge Close Vertices" no MeshLab.
- **Voxels nulos:** como o `coordenadas.txt` só contém voxels diferentes de zero, o volume no Processing começa zerado e é preenchido apenas com esses valores.
- Para usar outro volume, altere as dimensões e o nome do arquivo no `.c` e no `.pde`.
