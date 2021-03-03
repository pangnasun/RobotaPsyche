
ArrayList<Bug> bugs;  //arraylist to store bugs

PImage img; // image of the background environment
Evolution evol;  //declare an evolutin object
Environment envi;  //declare an evironment object

//keep track of time 
int previousTime;  
int deltaTime;

void setup() {
  size (1200, 750);

  //initiate objects
  evol = new Evolution();
  envi = new Environment();

  //initiate arraylist
  bugs = new ArrayList<Bug>();

  //tracking time start from zero and change in time is 50
  previousTime = 0;
  deltaTime = 50;


  //load image
  img = loadImage("images/leaves.jpg");
}


void draw() {
  envi.display();   //display environment
  evol.run();      //run the evolution to make bugs interact with each other and the environment

  if (millis() > previousTime + deltaTime) {  //every 50 miilisecons
    evol.compColor(envi.e_color);    //compare color of bugs with environment to change their survivability
    previousTime = millis();
  }

  //loop through dying bugs arraylist to crate different animations
  for (int i = evol.dyingBugs.size() - 1; i >= 0; i--) {
    Bug b = evol.dyingBugs.get(i);
    b.nDisplay();
    b.bDNA.lastBreath--;

    if (b.bDNA.lastBreath == 0) { //remove the dying bugs from array list
      evol.dyingBugs.remove(b);
    }
  }
}

//when mouse is pressed, create a bug at the mouse's location
void mousePressed() {
  evol.addBoid(new Bug(mouseX, mouseY, new DNA(color(random(255), random(255), random(255)), 1, 0.5))); 
}


void keyPressed() {
  //when SPACE is pressed, randomly change environment color and add 100 bugs
  if (key == 32) {
    envi.update();
    for (int i = 0; i < 70; i++) {
      evol.addBoid(new Bug(random(width), random(height), new DNA(color(random(255), random(255), random(255)), 1, 0.5)));
    }
  }
  
   //when ENTER is pressed, add 50 bugs at random locations
  if (keyCode == ENTER) {
    for (int i = 0; i < 50; i++) {
      evol.addBoid(new Bug(random(width), random(height), new DNA(color(random(255), random(255), random(255)), 1, 0.5)));
    }
  }
}
