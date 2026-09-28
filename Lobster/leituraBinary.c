#include <stdio.h>
#include <stdint.h>

#define W 301
#define H 324
#define D 56

int main() {

    FILE *entrada = fopen("lobster_301x324x56_uint8.raw", "rb");
    FILE *saida = fopen("coordenadas.txt", "w");

    if (!entrada || !saida) {
        printf("Erro ao abrir arquivo.\n");
        return 1;
    }

    uint8_t volume[D][H][W];

    fread(volume, sizeof(uint8_t), W*H*D, entrada);

    for(int z=0; z<D; z++) {
        for(int y=0; y<H; y++) {
            for(int x=0; x<W; x++) {

                if(volume[z][y][x] != 0) {
                    fprintf(saida,"%d %d %d\n", x, y, z);
                }
            }
        }
    }

    fclose(entrada);
    fclose(saida);

    return 0;
}