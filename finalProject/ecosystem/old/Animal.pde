// The vehicle class, more or less straight from the book
import java.util.*;
class Animal {
  ArrayList<ArrayList<Integer>> otherAnimals;
  Hashtable<Integer, int[]> dict;
  boolean state;

  PVector location;
  PVector velocity;
  PVector acceleration;
  float maxforce;
  float maxspeed;
  boolean alive;
  boolean isRed;
  int r;
  int serialNumber;
  final float tooClose = 25; // only pay attention to vehicles closer than this

  Animal(float x, float y, float vx, float vy, int sn) {


    dict = new Hashtable<Integer, int[]>();

    // internal variables from arguments
    location = new PVector(x, y);
    serialNumber = sn;

    // other internal variables
    acceleration = new PVector(0, 0);
    velocity = new PVector(vx, vy);
    maxforce = 1;
    maxspeed = 4;

    alive = true;

    // 50% chance of being red
    //if (round(random(1)) == 1) {
    //  isRed =  true;
    //} else {
    //  isRed = false;
    //}

    if (round(random(1)) == 1) {
      r =  10;
    } else {
      r = 3;
    }
  }

  // Return the distance from the given location to this vehicle
  float distanceTo(PVector l) {
    return PVector.sub(l, location).mag();
  }

  boolean offCanvas() {
    if (location.x > width) return true;
    if (location.y > height) return true;
    return false;
  }

  void noticeOtherAnimals(ArrayList<Animal> animals) {
    for (Animal other : animals) {
      noticeAnAnimal(other);
    }
  }

  void noticeAnAnimal(Animal other) {
    ArrayList<Integer> anim = new ArrayList<Integer>();
    anim.add((serialNumber));
    otherAnimals.add(anim);
  } 

  //void defineRelations(ArrayList<Animal> animals) {
  //  for (Animal animal : animals) {
  //    for(ArrayList<Integer> series: otherAnimals){
  //      if(series.get(0) == animal.serialNumber){
  //        int num = relation(animal);
  //        series.add(num);
  //        for(
  //        if(num == 1){

  //        }

  //      }

  //    }
  //  }
  //}

  void defineRelations(ArrayList<Animal> animals) {
    for (Animal animal : animals) {
      if ((dict.get(animal.serialNumber) == null ) && animal.serialNumber != this.serialNumber) {
        int[] codes = new int[3];
        int num= relation(animal);
        codes[0] = num;
        this.dict.put(animal.serialNumber, codes);
        //println("num" + num);
        int[] nCodes = new int[3];
        if (num == 1) {
          nCodes[0] =0;
          //println("here");
        } else if (num == 0) {
          nCodes[0] =1;
        } else {
          nCodes[0] =2;
        }
        animal.dict.put(this.serialNumber, nCodes);
      }
    }
  }





  int relation(Animal other) {
    float chance = random(100);

    if (other.r > r) {
      // If I am red, the threshold for aggression is 20 (i.e. 80% are aggressive)
      if (chance > 20) {
        return 1;
      }
    } else {
      // otherwise, the threshold is 80 (i.e. only 20% are aggressive)
      if (chance > 80) {
        return 1;
      }
    }

    return 2;
  }














  // Calculate the steering force to follow a flow field
  //void follow(FlowField flow) {
  //  // Look up the vector at that spot in the flow field
  //  PVector desired = flow.lookup(location);
  //  desired.mult(maxspeed);

  //  // Steering is desired minus velocity
  //  PVector steer = PVector.sub(desired, velocity);
  //  applyForce(applyLimits(steer));
  //}

  // Avoid aggressive vehicles and notice if they are also red
  void avoidAggressive(ArrayList<Animal>  animals) {

    // to accumilate all the individual avoidance vectors
    int count = 0; // how
    PVector sum = new PVector(0, 0);

    // Now look at each vehicle and if it is aggressive calculate the desired vector to avoid it
    for (Animal other : animals) {

      // What is the distance between me and another Vehicle?
      float d = PVector.dist(location, other.location);

      // If the distance is zero we are looking at ourselves so skip over ourselves
      if (d == 0) {
        continue;
      }

      // If the distance is greater than tooClose skip this vehicle
      if (d > tooClose) {
        continue;
      }

      // Is other vehicle aggressive?
      boolean otherIsAggressive = other.getIsAggressive();

      // If so, avoid it, using the same logic as in separate
      if (otherIsAggressive) {

        println(); // so messages are seaparated
        // Get the location of this vehicle relative to us
        PVector diff = PVector.sub(location, other.location); // in book, but  wrong way?

        println("I am " + serialNumber + " other is aggressive; will avoid; diff = " + diff);

        diff.normalize(); // why normalize? wouldn't we want to separate more from closer vehicles?
        diff.div(d); // closer vehicles generate stronger desire to flee
        println("after div, diff = " + diff);
        // We'll need the average, so add this location to the sum
        // of all locations and increment the count.
        sum.add(diff);
        count++;
      }
    }

    // We have checked all vehicles and have a sum total of all the avoidance vectors
    if (count > 0) { // If zero then no one is aggresive
      sum.div(count); // sum is now our desired velocity
      sum.normalize();
      // Scale desired velocity to maxspeed
      sum.mult(maxspeed);

      // Apply Reynolds’s steering formula:
      // error is our current velocty minus our desired velocity
      PVector steer = PVector.sub(sum, velocity);
      println("I am " + serialNumber +  " sum = " + sum + " my v = " + velocity + " steer = " + steer);

      steer.limit(maxforce);

      // Apply the force to the Vehicle’s
      // acceleration.
      applyForce(applyLimits(steer));
    }
  }

  void avoidRedVehicles(ArrayList<Animal> animals) {
    // to accumilate all the individual avoidance vectors
    int count = 0; // how
    PVector sum = new PVector(0, 0);

    // Now look at each vehicle and if it is aggressive calculate the desired vector to avoid it
    for (Animal other : animals) {

      // What is the distance between me and another Vehicle?
      float d = PVector.dist(location, other.location);

      // If the distance is zero we are looking at ourselves so skip over ourselves
      if (d == 0) {
        continue;
      }

      // If the distance is greater than tooClose skip this vehicle
      if (d > tooClose) {
        continue;
      }

      // Is other vehicle red?
      boolean otherIsRed = other.getIsRed();

      // If the other vehicle is red, avoid it, using the same logic as in separate
      if (otherIsRed) {

        println(); // so messages are seaparated
        // Get the location of this vehicle relative to us
        PVector diff = PVector.sub(location, other.location); // in book, but  wrong way?

        println("I am " + serialNumber + " other is red; will avoid; diff = " + diff);

        diff.normalize(); // why normalize? wouldn't we want to separate more from closer vehicles?
        diff.div(d); // closer vehicles generate stronger desire to flee
        println("after div, diff = " + diff);
        // We'll need the average, so add this location to the sum
        // of all locations and increment the count.
        sum.add(diff);
        count++;
      }
    }

    // We have checked all vehicles and have a sum total of all the avoidance vectors
    if (count > 0) { // If zero then no one is aggresive
      sum.div(count); // sum is now our desired velocity
      sum.normalize();
      // Scale desired velocity to maxspeed
      sum.mult(maxspeed);

      // Apply Reynolds’s steering formula:
      // error is our current velocty minus our desired velocity
      PVector steer = PVector.sub(sum, velocity);
      println("I am " + serialNumber +  " sum = " + sum + " my v = " + velocity + " steer = " + steer);

      steer.limit(maxforce);

      // Apply the force to the Vehicle’s
      // acceleration.
      applyForce(applyLimits(steer));
    }
  }

  // Given the desired velocity, return the maximum steering force
  // given limits of speed and steering force
  PVector applyLimits(PVector desiredVelocity) {
    desiredVelocity.normalize();
    desiredVelocity.mult(maxspeed);
    PVector steerForce = PVector.sub(desiredVelocity, velocity);
    steerForce.limit(maxforce);
    return(steerForce);
  }

  // Newton’s second law; we could divide by mass if we wanted.
  // If there are multiple forces (e.g. gravity, wind) we use
  // this function for each one, and it is added to the acceleration
  private void applyForce(PVector force) {
    acceleration.add(force);
  }

  // Update the velocity and location, based on the acceleration generated by the steering force
  void update() {
    velocity.add(acceleration);
    velocity.limit(maxspeed);
    location.add(velocity);
    acceleration.mult(0); // clear the acceleration for the next frame
  }

  void display() {
    // Vehicle is a triangle pointing in
    // the direction of velocity; since it is drawn
    // pointing up, we rotate it an additional 90 degrees.
    float theta = velocity.heading() + PI/2;

    pushMatrix();
    translate(location.x, location.y);
    rotate(theta);

    // For debugging, print our serial number
    fill(0);
    text(serialNumber, 0, 0);

    if (isRed) {
      fill(255, 0, 0);
    } else {
      fill(175);
    }
    beginShape();
    vertex(0, -r*2);
    vertex(-r, r*2);
    vertex(r, r*2);
    endShape(CLOSE);

    popMatrix();
  }

  // Methods used for debugging

  void inspect() {
    println("\nVehicle inspector:");
    println("SerialNumber: " + serialNumber );
    println("Location: " + location + " velocity = " + velocity + " acceleration = " + acceleration);
    println("Maximum steering force = " + maxforce + ", maximum speed = " + maxspeed);
  }

  void setLocation(PVector _location) {
    location = _location;
  }

  // Private methods used only member methods

  private boolean getIsRed() {
    return (isRed);
  }

  // Am I aggressive?
  private  boolean getIsAggressive() {
    float chance = random(100);

    if (isRed) {
      // If I am red, the threshold for aggression is 20 (i.e. 80% are aggressive)
      return (chance > 20);
    } else {
      // otherwise, the threshold is 80 (i.e. only 20% are aggressive)
      return(chance > 80);
    }
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
