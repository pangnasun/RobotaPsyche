Shortcut to [current assignment](#Assignment-3-March-1-Bugs-Simulation)    
# RobotaPsyche

### Assignment 1: Driving a Car

#### Processing Code:
````
Mover m;
PVector force= new PVector(0, 0);
void setup() {
  fullScreen();
  m = new Mover();
  
}

void draw() {
  background(255);

  //// Apply the friction force vector to the object.
  //if (m.velocity.mag() > 0) {
  //  float c = 0.004; 
  //  PVector friction = m.velocity.get(); 
  //  friction.mult(-1); 
  //  friction.normalize(); 
  //  friction.mult(c); 
  //  m.applyForce(friction);
  //  println(friction.x);
  //  println(friction.y);
  //}

  m.update();
  m.checkEdges();
  m.display();
}

class Mover {

  PVector location;
  PVector velocity;
  PVector acceleration;
  float mass;

  PImage carTop;

  Mover() {
    location = new PVector(width/2, height/2);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    mass = .1;
    
    carTop = loadImage("images/transparent/car_top.png");
  }
  void update() {
    velocity.add(acceleration);
    acceleration.mult(0); // this makes sure the acceleration is zer0 for the next fram
    location.add(velocity);
  }

  void display() {
    stroke(0);
    fill(175);
    //ellipse(location.x, location.y, 16, 16);

    imageMode(CENTER);
    pushMatrix();
    translate(location.x, location.y);
    rotate(velocity.heading());
    image(carTop, 0, 0);   
    popMatrix();
  }

  void applyForce(PVector force) {
    PVector f = force.get(); // Make a copy of the PVector before using it!
    f.div(mass);
    acceleration.add(f);
  }

  void checkEdges() {
    if (location.x > width) {
      location.x = 0;
    } else if (location.x < 0) {
      location.x = width;
    }

    if (location.y > height) {
      location.y = 0;
    } else if (location.y < 0) {
      location.y = height;
    }
  }
}

//represent each key with a vector
void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      force.set(0, -0.01);
    } else if (keyCode == DOWN) {
      force.set(0, 0.01);
    } else if (keyCode == LEFT) {
      force.set(-0.01, 0);
    } else if (keyCode == RIGHT) {
      force.set(0.01, 0);
    }
    m.applyForce(force);
  }
}

````
##### Demo of my code:

[![Demo](Assignment_1/drivingCar_demo.gif)](https://www.youtube.com/watch?v=5idQny0czc4)

I am still working on adding friction to the applied forces. Currently, the only forces acting on the car are from the user using the arrow keys. 

#### UPDATED Processing Code: With friction

````

Mover m;
float initMag = 0.01; //value of force applied by the arrow key
PVector force= new PVector(0, 0);
void setup() {
  fullScreen();
  m = new Mover();
}

void draw() {
  background(255);

  //// Apply the friction force vector to the object.
  PVector friction = new PVector(0, 0); 
  if (m.velocity.mag() >= initMag) { //check if car moving in order to have friction
    float c = 0.0004; 
    friction = m.velocity.copy(); 
    friction.mult(-1); 
    friction.normalize(); 
    friction.mult(c); 
    m.applyForce(friction);
  } else {
    m.applyForce(friction); //if the car is not moving, don't apply friction
  }

  m.update();
  m.checkEdges();
  m.display();
}

class Mover {

  PVector location;
  PVector velocity;
  PVector acceleration;
  float mass;

  PImage carTop;

  Mover() {
    location = new PVector(width/2, height/2);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    mass = .1;

    carTop = loadImage("images/transparent/car_top.png");
  }
  void update() {
    velocity.add(acceleration);
    acceleration.mult(0); // this makes sure the acceleration is zer0 for the next fram
    location.add(velocity);
  }

  void display() {
    stroke(0);
    fill(175);
    //ellipse(location.x, location.y, 16, 16);

    imageMode(CENTER);
    pushMatrix();
    translate(location.x, location.y);
    rotate(velocity.heading());
    image(carTop, 0, 0);   
    popMatrix();
  }

  void applyForce(PVector force) {
    PVector f = force.get(); // Make a copy of the PVector before using it!
    f.div(mass);
    acceleration.add(f);
  }

  void checkEdges() {
    if (location.x > width) {
      location.x = 0;
    } else if (location.x < 0) {
      location.x = width;
    }

    if (location.y > height) {
      location.y = 0;
    } else if (location.y < 0) {
      location.y = height;
    }
  }
}

//represent each key with a vector
void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      force.set(0, -initMag);
    } else if (keyCode == DOWN) {
      force.set(0, initMag);
    } else if (keyCode == LEFT) {
      force.set(-initMag, 0);
    } else if (keyCode == RIGHT) {
      force.set(initMag, 0);
    }
    m.applyForce(force);
  }
}
````

##### Demo of my new code:

[![Demo 2](Assignment_1/drivingCar_frictionDemo.gif)](https://www.youtube.com/watch?v=6SW1KWJsN5o)

### Assignment 2 (February 15): "Playing" with Flow Fields

#### Some Products:
###### The flow field with the arrows pointing to the center:
<img src="Assignment_2_Feb15/images/centeringBullseye.png" width="800" height="623">

###### The flow field of a PImage:
<img src="Assignment_2_Feb15/images/vectoringImage.png" width="800" height="526">

###### Using array lists to create animted flow field:
[![Demo 1](Assignment_2_Feb15/gifs/animCenteringFlowField.gif)](https://youtu.be/h-oIYOQHUYs)

###### Creating vehicles in the flow field when the mouse is pressed:
[![Demo 2](Assignment_2_Feb15/gifs/createVehiclesOnClick.gif)](https://youtu.be/gRkRCqM0YEc)

###### Creating vehicles in the flow field that points to the center:
[![Demo 3](Assignment_2_Feb15/gifs/centeringFlowField.gif)](https://youtu.be/taa6phtvPCU)

###### Creating vehicles in the flow field where the arrows point to the closest point:
[![Demo 4](Assignment_2_Feb15/gifs/centeringRandomPoints.gif)](https://youtu.be/dUvdtBE9pd8)

#### Reflections:
###### Difficulties:
- Thinking in term of angles in order to get the arrows to point in the directions that I want
- Converting my concepts take a lot of time and headaches 
- Fall victim to my ambition

###### Interesting/Shocking Discoveriies:
- Quite fun playing with flow field although time consuming 
- I can not resize the canvas according to the size of my input image. In addition, size() does not take in variables as input
###### Questions:
- How to make a flow field that center a point gradually. The arrows should arrange in circle or spiral like shapes
- Still need to work on using angles to change directions of arrows 

### Assignment 3 (February 22): My Project Ideas
##### Boid DNA:
The main and most important variable in my DNA class is the survivablity variable. This variable is declared as a float and initiated with an initial value of 1, meaning that all the boids have the same chance of surviving. Then, as the process procedes, this parameter increaes or decreases depending on the interaction to show a certain boid's survivability. However, its value will never get greater than 1.

There are certain criteria that are put into consideration when determing the survivability of a boid. My DNA has other two vairables: color and size. Thus, depending on these two conditions, a boid's survivabilty may increase or decrease depending on how well its color and size let its adapt to its environment(flow field). For example, if its color matches with the flow field, it will have camaflouge and have a very high chance of surviving. On the other hand, if a boid size is really large but the flow field has narrow path, it won't be able to travel smoothly or keep up with the flock, so its survability will be really low.

### Assignment 3 (March 1): Bugs Simulation
#### My Final Product:
[![Demo](March1/Simulation/product/bugsSimulation.gif)](https://www.youtube.com/watch?v=SA2FcCZLtvE)
#### My Process:
##### Part 1:
I did not start working on the assignment immediately. Before working on the actual evolution project, I was exploring how different forces affect the behavior of the vehicles. I add and manipulate forces like separation, cohesion, and alignment to make those vehicles behave more like animals. Undertanding these forces actually comes in handy later on in the environment.

I started the assignment by creating a very simple DNA class with three main features: size, color, and survivability index. As mentioned in my previous [post](#Assignment-3-February-22-My-Project-Ideas), the evolution of my bots will hugely depend on how well their sizes and colors adapt to their environment. 
After I created the DNA class, I modified the Vehicle constructor to take in DNA variable as one of its parameters. I added another function to the Vehicle class so its DNA can be copied to create an exact same vehicle. 

##### Part 2:
Creating the evolution processing was another story. I began by having two vehicles create another bots when they came in contact with each other. New vehicles would have blended color of their parents' colors and their sizee, locations, and survivability index would be the averages of their parents'. However, after they came in contact with each other, they did not separate from each other becaue of the cohesion that was applied. As a result, they conitnuously produced new vehicles. I tried manipulate the applied forces by making the seperation stronger but it did not work because new vehicles created always got in contact with them. To try to fix this I created a boolean variable that keeps track of whether a vehicle has reproduced yet. If a vehicle has produced a new vehicle, this variable will be set to false, so even if the vehicles are still in contact, they will not produce new vehicles. I also set this variable to false for the new vehicles, so they will not produce new vehcles. New vehicles' location  are set to the distance between their parents, so getting in contact with their parents was unavoidable. Although this method worked, the number of new vehicles were so limited because parent vehicles could reproduce only once and childen can not reproduce. I needed to add functions with conditions that after a while, these vehicles should be able to reproduce. I took a break and thought of my next steps.

##### Part 3:
I started again with finding pictures for my vehicles and background environment. After spending a few hours just searching for visuals, I realized that I just wasted my time on something unnecessary, but, well,at least I got something to work with. The images I found for my vehicles were black-and-white sprites of a bug and a black-and-white environment image, so I created a new sketch to figure out how to load and show those images to make an animation effect. Again, I realized that I spent time on something unnecessary, but I couldnot resist the feeling of satisfaction.  

I chose to use black and white colors because I wanted to use the PImage tint() function to change the environment color randomly as well as create random colors for my bugs. The idea is to change the color of my environment randomly and let the bugs evolve their colors to match the environment. The closer their colors are to the environment, the higher their chance of survivability. I determined the color difference by finding the differences in theri RGBs (the red color value of a bug - red value color of the environment, the green color value of a bug - green value color of the environment, the blue color value of a bug - blue value color of the environment), add them up, and divide by 3 to find the average. Then I compare this to a certain value to see whether their survability should decrease. 

Going back to my work from part 2, I chose a different to pass gone my bug's DNA. Two bugs could only reproduce when they come in contact of each other if their survivabilities are greater than a set value. The new produced bug will the average of all their parents' DNA traits(colors, locations...). In addition, after they reproduced, the parent bugs would died and removed from the environment. 

When the program ran, users could press SPACE to change the environment color and add 100 bugs to the environment or they could press ENTER to just add 50 bugs. These features allowed continuous running of many simulations of bugs' adaption to the environment.


#### Reflections:
The processing could get really fustrating sometimes when I could not figure something out. When that happened, I would debug with the print fuction or get a pen and paper to sketch the algorithm. These two steps helped me solve at least 90% of the time. Still, the project turned out satisfying as soon as I got my program to meet some of my expectations. 

Things to keep in mind for my next project:
- Always backup your program in case for unforseen cases 
- Expect to spend 100% more time than you think you'll need to finish the program
- Focus on the functionality aspect of the program first


