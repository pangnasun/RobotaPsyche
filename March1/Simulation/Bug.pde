class Bug {
  PVector location;  //bug'slocation
  PVector nLocation;  //a location where the bug moves to
  PVector velocity;    //bug's velocity
  PVector acceleration;   //bug's acceleration

  float maxforce;   //max steering force
  float maxspeed;    //max bug's speed
  DNA bDNA;       //bug's DNA

  PImage[] images;   //array of bug's images for animation purposes
  PImage[] dyImages;   //array of dying bug's images
  int imageCount;      //number of bug's images
  int dyImageCount;    //number of dying bug's images
  float frame;         //frame to set the rate at which bug's images change
  float dyFrame;       //frame to set the rate at which dying bug's images change

  float desiredseparation;   //the separate distance between bugs

  Bug(float x, float y, DNA _DNA) {
    //initiating varraibles
    acceleration = new PVector(0, 0);
    velocity = new PVector(0, 0);
    location = new PVector(x, y);
    maxspeed = 2;
    maxforce = 1;
    desiredseparation = 100;
    bDNA = _DNA;

    ////random target for the bug to move to
    nLocation = new PVector(random(width/2), random(height/2)); 


    //loading images
    String imagePrefix = "images/bugSprite/bug";
    imageCount = 4;
    images = new PImage[imageCount];

    for (int i = 1; i <= imageCount; i++) {
      // Use nf() to number format 'i' into four digits
      String filename = imagePrefix + i + ".png";
      images[i - 1] = loadImage(filename);
    }

    //loading images of dying bugs
    String dyImagePrefix = "images/bugSprite/ddBug";
    dyImageCount = 3;
    dyImages = new PImage[dyImageCount];

    for (int i = 1; i <= dyImageCount; i++) {
      // Use nf() to number format 'i' into four digits
      String filename = dyImagePrefix + i + ".png";
      dyImages[i - 1] = loadImage(filename);
    }
  }

  //makes a copy of this bug's DNA and return the DNA
  DNA getDNA() {
    return new DNA(bDNA.getColor(), bDNA.getSize(), bDNA.getSurv());
  }

  //update location
  void update() {
    velocity.add(acceleration);
    velocity.limit(maxspeed);
    location.add(velocity);
    acceleration.mult(0); // clear the acceleration for the next frame
  }

  //apply forces (alignment, cohesion, separation, and seeking) in comparision to other bugs
  void applyForce(ArrayList<Bug> bugs) {
    PVector force = align(bugs);
    force.add(cohesion(bugs));
    force.add(separate(bugs));

    //keep changing target location, so the bug seems to move randomly
    if (millis() %30 == 0) {
      nLocation = new PVector(random(width/2), random(height/2));
    }
    force.add(seek(nLocation));
    force.div(4);  //average the forces

    acceleration.add(force);
  }

  // given a target, the bug will move toward that target
  PVector seek(PVector target) {    
    PVector desired = PVector.sub(target, location);
    desired.normalize();    
    desired.mult(maxspeed);
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);

    return steer;
  }

 //check this bug's location in comparision to other bugs' in order to align with other bugs
  PVector align (ArrayList<Bug> bugs) {
    // This is an arbitrary value and could
    // vary from boid to boid.
    float neighbordist = 50;
    PVector sum = new PVector(0, 0);
    int count = 0;
    for (Bug other : bugs) {
      float d = PVector.dist(location, other.location);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.velocity);
        // For an average, we need to keep track of
        // how many boids are within the distance.
        count++;
      }
    }
    if (count > 0) {
      sum.div(count);
      sum.normalize();
      sum.mult(maxspeed);
      PVector steer = PVector.sub(sum, velocity);
      steer.limit(maxforce);
      return steer;
      // If we don’t find any close boids,
      // the steering force is zero.
    } else {
      return new PVector(0, 0);
    }
  }

//check with other bugs,so they will stay together in a group 
  PVector cohesion (ArrayList<Bug> bugs) {
    float neighbordist = 50;
    PVector sum = new PVector(0, 0);
    int count = 0;
    for (Bug other : bugs) {
      float d = PVector.dist(location, other.location);
      if ((d > 0) && (d < neighbordist)) {
        // Adding up all the others’ locations
        sum.add(other.location);
        count++;
      }
    }
    if (count > 0) {
      sum.div(count);
      // Here we make use of the seek() function we
      // wrote in Example 6.8.  The target
      // we seek is the average location of
      // our neighbors.
      return seek(sum);
    } else {
      return new PVector(0, 0);
    }
  }

//check its location with other bugs, so they won't get too close to each other
  PVector separate (ArrayList<Bug> bugs) {
    // float desiredseparation = 100; // how close is too close.
    PVector sum = new PVector();  // Start with an empty PVector.
    int count = 0;  // We have to keep track of how many Vehicles are too close.

    for (Bug other : bugs) {
      float d = PVector.dist(location, other.location);
      if ((d > 0) && (d < desiredseparation)) {
        PVector diff = PVector.sub(location, other.location); 
        diff.normalize();
        // Add all the vectors together and increment the count.
        sum.add(diff); 
        count++;
      }
    }

    // now calculate the average:
    if (count  > 0) {
      sum.div(count);

      // Scale average to maxspeed
      // (this becomes desired).
      sum.setMag(maxspeed);

      // Apply Reynolds’s steering formula:
      // error is our current velocty minus our desired velocity
      PVector steer = PVector.sub(sum, velocity);
      steer.limit(maxforce);

      // Apply the force to the Vehicle’s
      // acceleration.
      return steer;
    } else {

      return new PVector(0, 0);
    }
  }

//display the bug
  void mDisplay() {  
    float theta = velocity.heading() + PI/2;
    imageMode(CENTER);
    pushMatrix();
    translate(location.x, location.y);
    rotate(PI);
    rotate(theta);
    bDisplay(0, 0);
    popMatrix();
    imageMode(CORNER);
  }

//changing images of bug to create an animation
  void bDisplay(float xpos, float ypos) {
    tint(bDNA.bColor);
    frame = (frame + 0.1) % (imageCount - 1); //set the framerate to slow down the chnage of images
    int f = int(frame + 1);
    image(images[f], xpos, ypos);
  }

//display the dying bugs
  void nDisplay() {
    float theta = velocity.heading() + PI/2;
    imageMode(CENTER);
    pushMatrix();
    translate(location.x, location.y);
    rotate(PI);
    rotate(theta);
    cDisplay(0, 0);
    popMatrix();
    imageMode(CORNER);
  }
  void cDisplay(float xpos, float ypos) {
    noTint();
    dyFrame = (dyFrame + 0.1) % (dyImageCount - 1);
    int f = int(dyFrame + 1);
    image(dyImages[f], xpos, ypos);
    //delay(100);
  }

//check when bugs go off screen, so they reappear
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
