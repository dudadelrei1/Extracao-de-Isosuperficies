ArrayList<PVector> points;
ArrayList<int[]> colors;
PImage img;
void setup() {
  size(512, 512);
  img = createImage(512,512,RGB);
  
  //float[][][] m = new float[512][512][512];
  int[][][] m = new int[512][512][512];
  float tmp;

  for (int k = 0; k < 512; k++) {
    for (int j = 0; j < 512; j++) {
      for (int i = 0; i < 512; i++) {

         tmp = ((i-256)*(i-256))+((j-256)*(j-256))+((k-256)*(k-256)); 
         tmp = sqrt(tmp);
         m[i][j][k]=int(tmp/2.0);
         img.set(i,j, color(m[i][j][k],m[i][j][k],m[i][j][k]));
         //println(m[i][j][k]);

        //Azul
        //if (tmp >= 60.0 && tmp <= 65.0) {
          //set(i,j, color(m[i][j][k],m[i][j][k],m[i][j][k]));
        //}

         //Vermelha
        //if (tmp >= 250.0 && tmp <= 255.0) {
        //  set(i,j, color(m[i][j][k],m[i][j][k],m[i][j][k]));
        //}

      }
    }
    img.save("image" + k + ".png");
  }
  println("Imagens geradas!");
  exit();
}
