// The vehicle class, more or less straight from the book
class Boid {

  PVector location;
  PVector velocity;
  PVector acceleration;
  // Additional variable for size
  float r;
  float maxforce;
  float maxspeed;
  DNA bDNA;
  
  Boid(float x, float y) {
    acceleration = new PVector(0, 0);
    velocity = new PVector(0, 0);
    location = new PVector(x, y);
    r = 3.0;
    //Arbitrary values for maxspeed and
    // force; try varying these!
    maxspeed = 4;
    maxforce = 10;
    
  }
  

  Boid(float x, float y, DNA _DNA) {
    acceleration = new PVector(0, 0);
    velocity = new PVector(0, 0);
    location = new PVector(x, y);
    r = 3.0;
    //Arbitrary values for maxspeed and
    // force; try varying these!
    maxspeed = 4;
    maxforce = 10;
    bDNA = _DNA;
  }
  DNA getDNA(){
    return bDNA;
  }
  // Update the velocity and location, based on the acceleration generated by the steering force
  void update() {
    velocity.add(acceleration);
    velocity.limit(maxspeed);
    location.add(velocity);
    acceleration.mult(0); // clear the acceleration for the next frame
  }

  // Newton’s second law; we could divide by mass if we wanted.
  // If there are multiple forces (e.g. gravity, wind) we use
  // this function for each one, and it is added to the acceleration
  void applyForce(ArrayList<Boid> boids) {
    PVector force = align(boids);
    force.add(cohesion(boids));
    force.add(separate(boids));
    
    force.div(3);
    
    acceleration.add(force);
  }

  // note that now this function returns a PVector which is the force
  PVector seek(PVector target) {
    PVector desired = PVector.sub(target, location);
    desired.normalize();
    desired.mult(maxspeed);
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);

    // Instead of applying the force we return the PVector.
    // applyForce(steer); // No longer done here
    return steer;
  }


  PVector align (ArrayList<Boid> boids) {
    // This is an arbitrary value and could
    // vary from boid to boid.
    float neighbordist = 50;
    PVector sum = new PVector(0, 0);
    int count = 0;
    for (Boid other : boids) {
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

  PVector cohesion (ArrayList<Boid> boids) {
    float neighbordist = 50;
    PVector sum = new PVector(0, 0);
    int count = 0;
    for (Boid other : boids) {
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

  PVector separate (ArrayList<Boid> boids) {
    float desiredseparation = 20; // how close is too close.
    PVector sum = new PVector();  // Start with an empty PVector.
    int count = 0;  // We have to keep track of how many Vehicles are too close.

    for (Boid other : boids) {
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
    if (count  > 1) {
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


















  /*
  What follows are different steering algorithms. A vehicle
   could use any one, and you could create addiotional ones.
   Each algorithm calculates the steering force and then
   applies it
   */

  /*
  // Calculate steering force to seek a target
   void seek(PVector target) {
   PVector desired = PVector.sub(target, location);
   desired.normalize();
   desired.mult(maxspeed);
   PVector steer = PVector.sub(desired, velocity);
   steer.limit(maxforce);
   applyForce(steer);
   }
   */
  // Calculate the steering force to follow a flow field
  //void follow(FlowField flow) {
  //  // Look up the vector at that spot in the flow field
  //  PVector desired = flow.lookup(location);
  //  desired.mult(maxspeed);

  //  // Steering is desired minus velocity
  //  PVector steer = PVector.sub(desired, velocity);
  //  steer.limit(maxforce);
  //  applyForce(steer);
  //}




  void display() {
    // Vehicle is a triangle pointing in
    // the direction of velocity; since it is drawn
    // pointing up, we rotate it an additional 90 degrees.
    float theta = velocity.heading() + PI/2;
    fill(175);
    stroke(0);
    pushMatrix();
    translate(location.x, location.y);
    rotate(theta);
    beginShape();
    vertex(0, -r*2);
    vertex(-r, r*2);
    vertex(r, r*2);
    endShape(CLOSE);
    popMatrix();
  }
}
