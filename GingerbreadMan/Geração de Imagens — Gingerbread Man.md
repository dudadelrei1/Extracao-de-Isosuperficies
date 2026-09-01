# Geração de Imagens — Gingerbread Man

Este código gera um conjunto de imagens em escala de cinza que representam as diferentes fatias de um modelo tridimensional do **Gingerbread Man**. As imagens são geradas a partir de funções matemáticas que definem as diferentes partes do modelo.

## Funcionamento

O programa trabalha com um volume de dimensões **512 × 512 × 512**. O centro do volume é definido no ponto:

```text
(cx, cy, cz) = (256, 256, 256)
```

As coordenadas de cada ponto são deslocadas em relação a esse centro, permitindo que as funções matemáticas sejam definidas considerando o centro do modelo como a origem `(0, 0, 0)`.

O Gingerbread Man é construído a partir de seis partes:

- Cabeça
- Tronco
- Braço direito
- Braço esquerdo
- Perna direita
- Perna esquerda

Cada parte é representada por uma **função implícita**, que recebe as coordenadas `(x, y, z)` e retorna um valor escalar.

## Funções utilizadas

As funções utilizam potências de quarta ordem para definir o formato das diferentes partes do modelo.

### Cabeça

A cabeça é definida por:

```text
x⁴ + (y - 8.5)⁴ + z⁴
```

O termo `(y - 8.5)` desloca a cabeça para cima em relação ao centro do modelo.

### Tronco

O tronco utiliza diferentes fatores de escala nos três eixos:

```text
x⁴ / 2 + y⁴ / 11 + z⁴ / 3
```

Esses fatores permitem controlar as dimensões do tronco em cada direção.

### Braços

Os braços são posicionados lateralmente por meio dos termos `x - 7` e `x + 7`.

**Braço direito:**

```text
(x - 7)⁴ / 13 + (y - 2.5)⁴ / 0.5 + z⁴ / 0.5
```

**Braço esquerdo:**

```text
(x + 7)⁴ / 13 + (y - 2.5)⁴ / 0.5 + z⁴ / 0.5
```

### Pernas

As pernas são posicionadas abaixo do tronco utilizando o termo `y + 8.5`.

**Perna direita:**

```text
(x - 1.5)⁴ / 0.1 + (y + 8.5)⁴ / 7 + z⁴ / 0.1
```

**Perna esquerda:**

```text
(x + 1.5)⁴ / 0.1 + (y + 8.5)⁴ / 7 + z⁴ / 0.1
```

## União das partes

Após calcular o valor correspondente a cada uma das seis partes, o programa combina os resultados utilizando a função `max()`:

```java
campo = max(
  fCabeca,
  fTronco,
  fBracoD,
  fBracoE,
  fPernaD,
  fPernaE
);
```

Dessa forma, cada ponto do volume passa a possuir um único valor correspondente ao campo escalar do Gingerbread Man.

## Conversão para escala de cinza

O valor obtido pelo campo é normalizado para o intervalo `[0, 1]` e posteriormente convertido para uma intensidade de cinza entre `0` e `255`.

O programa utiliza:

```java
float K = 50.0;
```

A normalização é realizada por:

```java
float valNorm = constrain(
  (campo + K) / (2.0 * K),
  0.0,
  1.0
);

int valByte = round(valNorm * 255.0);
```

Assim, o valor `0` do campo corresponde aproximadamente à intensidade **128** na imagem.

A relação entre os valores é:

| Campo | Intensidade | Representação |
|---|---:|---|
| `campo < 0` | `< 128` | Região externa |
| `campo = 0` | `128` | Isosuperfície |
| `campo > 0` | `> 128` | Região interna |

## Geração das imagens

O programa percorre as **512 posições do eixo Z**:

```java
for (int k = 0; k < 512; k++)
```

Para cada posição `k`, é criada uma imagem de tamanho `512 × 512`:

```java
img = createImage(512, 512, RGB);
```

Cada pixel `(i, j)` da imagem corresponde a um ponto `(x, y, z)` do volume:

```java
x = i - 256;
y = j - 256;
z = k - 256;
```

O valor do campo é então calculado para esse ponto, convertido para escala de cinza e armazenado no pixel correspondente.

Ao final de cada iteração, a imagem é salva como um arquivo PNG:

```java
img.save("gingerBreadMan" + nf(k, 3) + ".png");
```

Os arquivos são gerados seguindo a sequência:

```text
gingerBreadMan000.png
gingerBreadMan001.png
gingerBreadMan002.png
...
gingerBreadMan511.png
```

Cada arquivo representa uma **fatia do volume ao longo do eixo Z**.

## Estrutura do volume

O conjunto de imagens pode ser interpretado como um único volume tridimensional:

```text
gingerBreadMan000.png  → Z = 0
gingerBreadMan001.png  → Z = 1
gingerBreadMan002.png  → Z = 2
        ...
gingerBreadMan511.png  → Z = 511
```

Portanto, as imagens não são independentes. Quando organizadas na ordem correta, elas representam um volume de:

```text
512 × 512 × 512
```

ou **134.217.728 amostras**.

## Verificação dos dados

Durante a execução, o programa também verifica os valores gerados.

São armazenadas informações sobre:

- Menor intensidade de cinza encontrada;
- Maior intensidade de cinza encontrada;
- Quantidade de níveis de cinza diferentes utilizados.

Para verificar os níveis distintos, o código utiliza um vetor:

```java
boolean[] valoresPresentes = new boolean[256];
```

Isso permite identificar quais das 256 possíveis intensidades de cinza aparecem no volume gerado.

## Aplicação futura

O conjunto de imagens será utilizado posteriormente como **dados sintéticos para testes e validação do algoritmo Marching Cubes**.

A ideia é utilizar as 512 imagens para reconstruir o volume tridimensional e, a partir dele, extrair a isosuperfície correspondente ao Gingerbread Man.

O fluxo planejado é:

```text
Funções matemáticas
       ↓
Campo escalar 3D
       ↓
512 × 512 × 512
       ↓
512 imagens PNG
       ↓
Reconstrução do volume
       ↓
Marching Cubes
       ↓
Isosuperfície
       ↓
Modelo 3D
```

Como o modelo é gerado matematicamente, ele poderá ser utilizado como um **dataset sintético controlado**, permitindo avaliar o funcionamento da implementação do Marching Cubes antes da aplicação em conjuntos de dados mais complexos.

## Resultado

Ao executar o código, são geradas:

- **512 imagens PNG**;
- Resolução de **512 × 512 pixels** por imagem;
- Representação em **escala de cinza**;
- Um volume tridimensional equivalente a **512³ voxels**.

O conjunto de imagens constitui a representação volumétrica do Gingerbread Man e será utilizado posteriormente no processo de **extração de isosuperfícies e reconstrução do modelo 3D**.