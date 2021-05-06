
import java.util.*; // import  to use dictionary
class Animal {
  Hashtable<Integer, int[]> dict;    //create a dictionary to learn about other animals

  float desiredseparation;  //separate distance

  PVector location;
  PVector velocity;
  PVector acceleration;
  float maxforce;
  float maxspeed;
  boolean alive;
  boolean isRed;
  int r;
  int serialNumber;
  final float tooClose = 43;          // only pay attention to vehicles closer than this

  Animal(float x, float y, float vx, float vy, int sn) {


    dict = new Hashtable<Integer, int[]>();   //initiate a dictionary as integers
    desiredseparation = 50;


    // internal variables from arguments
    location = new PVector(x, y);
    serialNumber = sn;

    // other internal variables
    acceleration = new PVector(0, 0);
    velocity = new PVector(vx, vy);
    maxforce = 1.5;
    maxspeed = 3;

    alive = true;

    
    //two sizes randomly
    if (round(random(1))== 1) {
      r = 3;
    } else {
      r = 6;
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

  //void noticeOtherAnimals(ArrayList<Animal> animals) {
  //  for (Animal other : animals) {
  //    noticeAnAnimal(other);
  //  }
  //}

  //void noticeAnAnimal(Animal other) {
  //  ArrayList<Integer> anim = new ArrayList<Integer>();
  //  anim.add((serialNumber));
  //  otherAnimals.add(anim);
  //} 


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

//function to define the relationship between various animals randomly depending on their sizes
  int defineRelations(ArrayList<Animal> animals) {
    //println("Me: " + serialNumber);
    int count = 0;
    for (Animal animal : animals) {
      // What is the distance between me and another Vehicle?
      float d = PVector.dist(location, animal.location);

      // If the distance is zero we are looking at ourselves so skip over ourselves
      if (d == 0) {
        continue;
      }

      // If the distance is greater than tooClose skip this vehicle
      if (d > tooClose) {
        continue;
      }

      //calls functiont that randomly defines the relationships
      if ( animal.serialNumber != this.serialNumber) {
        int[] codes = new int[3];
        int num= relation(animal);
        codes[0] = num;

        //println("code:" + num);
        //println("num" + num);
        int[] nCodes = new int[3];
        if (num == 1) {
          nCodes[0] =0;
          count++;


          //println("here");
        } else if (num == 0) {
          nCodes[0] =1;
        } else {
          nCodes[0] =2;
          nCodes[1] =40;
          codes[1] = 40;
        }
        this.dict.put(animal.serialNumber, codes);
        animal.dict.put(this.serialNumber, nCodes);
      }
    }
    //println("c " + count);
    return count;
  }



//randomly defines relations between animals
  int relation(Animal other) {
    float chance = random(100);

    if (other.r > r) {
      // if size is bigger, high chance of being a predator
      if (chance > 20) {
        return 1;     //relation is a predator
      }
    } else {
      // chance is lower to be a predator
      if (chance > 80) {
        return 1;
      }
    }

    return 2;  // netural relation ship
  }


//associate a list of animals with relation to teh current animal depends on the size
  void association(ArrayList<Animal> animals) {
    for (Animal animal : animals) {
      // What is the distance between me and another Vehicle?
      float d = PVector.dist(location, animal.location);

      // If the distance is zero we are looking at ourselves so skip over ourselves
      if (d == 0) {
        continue;
      }

      // If the distance is greater than tooClose skip this vehicle
      if (d > tooClose) {
        continue;
      }
      
//create dictionary with animals serial as the key
      if ( animal.serialNumber != this.serialNumber) {
        int[] codes = new int[3];
        int num = relationAssociate(animal);    //receive code from the association funnction below
        codes[0] = num;

        //println("code:" + num);
        //println("num" + num);
        int[] nCodes = new int[3];
        if (num == 1) {
          nCodes[0] =0;



          //println("here");
        } else if (num == 0) {
          nCodes[0] =1;
        } else {
          nCodes[0] =2;
          nCodes[1] =40;
          codes[1] = 40;
        }
        this.dict.put(animal.serialNumber, codes);
        animal.dict.put(this.serialNumber, nCodes);
      }
    }
  }


 //when association happens, use this function to associate larger animals as predator
  int relationAssociate(Animal other) {
    //float chance = random(100);

    if (other.r > r) {
      //larger size means predator

      return 1;     //relation is a predator
    } else if ( other.r == r) {
      //same size means friends

      return 2;
    } else {

      return 0;  //means prey
    }
  }

  //update location
  void update() {
    velocity.add(acceleration);
    velocity.limit(maxspeed);
    location.add(velocity);
    acceleration.mult(0); // clear the acceleration for the next frame
  }

  //apply forces (alignment, cohesion, separation, and seeking) in comparision to other animals
  void applyForce(ArrayList<Animal> animals) {
    PVector force = align(animals);
    force.add(cohesion(animals));
    force.add(separate(animals));

    //keep changing target location, so the bug seems to move randomly
    //if (millis() %30 == 0) {
    //  nLocation = new PVector(random(width/2), random(height/2));
    //}
    //force.add(seek(nLocation));
    force.div(3);  //average the forces

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

  //check this bug's location in comparision to other animals' in order to align with other animals
  PVector align (ArrayList<Animal> animals) {
    // This is an arbitrary value and could
    // vary from boid to boid.
    float neighbordist = 50;
    PVector sum = new PVector(0, 0);
    int count = 0;
    for (Animal other : animals) {
      float d = PVector.dist(location, other.location);
      if (dict.get(other.serialNumber) != null &&  dict.get(other.serialNumber)[0] == other.dict.get(serialNumber)[0] && (d > 10) && (d < neighbordist)) {

        //println(serialNumber + " : " + dict.get(other.serialNumber)[0]);
        desiredseparation = dict.get(other.serialNumber)[1];
        //println(" :" + 
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

  //check with other animals,so they will stay together in a group 
  PVector cohesion (ArrayList<Animal> animals) {
    float neighbordist = 50;
    PVector sum = new PVector(0, 0);
    int count = 0;
    for (Animal other : animals) {
      float d = PVector.dist(location, other.location);
      if (dict.get(other.serialNumber) != null &&  dict.get(other.serialNumber)[0] == other.dict.get(serialNumber)[0] && (d > 10) && (d < neighbordist)) {  //check whehter animals are preys or predaotr
        desiredseparation = dict.get(other.serialNumber)[1];                 //not predator then their distance is closer                                                          
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

  //check its location with other animals, so they won't get too close to each other
  PVector separate (ArrayList<Animal> animals) {
    // float desiredseparation = 100; // how close is too close.
    PVector sum = new PVector();  // Start with an empty PVector.
    int count = 0;  // We have to keep track of how many Vehicles are too close.

    for (Animal other : animals) {
      float d = PVector.dist(location, other.location);
      if ((d > 10) && (d < desiredseparation)) {
        // println("here:");
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
      steer.limit(5);

      // Apply the force to the Vehicle’s
      // acceleration.
      return steer;
    } else {

      return new PVector(0, 0);
    }
  }


  //void separateOverlap(ArrayList<Animal> animals) {
  //  for (Animal animal : animals) {
  //    if (animal.serialNumber != serialNumber) {
  //      if (abs(animal.location.x - location.x) < 5) {
  //        if (animal.location.x >= location.x ) {
  //          animal.location.x += 2;
  //          location.x -= 2;
  //        } else if (animal.location.x <= location.x) {
  //          animal.location.x -= 2;
  //          location.x += 2;
  //        }

  //        if (abs(animal.location.y - location.y) < 5) {
  //          if (animal.location.y >= location.y ) {
  //            animal.location.y += 2;
  //            location.y -= 2;
  //          } else if (animal.location.y <= location.y) {
  //            animal.location.y -= 2;
  //            location.y += 2;
  //          }
  //        }
  //      }
  //    }
  //  }
  //}



  // Given the desired velocity, return the maximum steering force
  // given limits of speed and steering force
  PVector applyLimits(PVector desiredVelocity) {
    desiredVelocity.normalize();
    desiredVelocity.mult(maxspeed);
    PVector steerForce = PVector.sub(desiredVelocity, velocity);
    steerForce.limit(maxforce);
    return(steerForce);
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
    // fill(0);
    // text(serialNumber, 0, 0);


    //fill(249, 211, 0, 70);

    beginShape();
    vertex(0, -r*2);
    vertex(-r, r*2);
    vertex(r, r*2);
    endShape(CLOSE);

    popMatrix();
  }  

  //check when animals go off screen, so they reappear
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
