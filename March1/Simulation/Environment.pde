class Environment {
  PImage img;  //envrionment's image
  color e_color;  //environment's color
  Environment() {
    img = loadImage("images/leaves.jpg");
    e_color = color(random(255), random(255), random(255)); //random color
  }

///display image with color
  void display() {
    tint(e_color);
    image(img, 0, 0);
  }
  
/// radomly change the image's color
  void update() {
    e_color = color(random(255), random(255), random(255));
  }
}
