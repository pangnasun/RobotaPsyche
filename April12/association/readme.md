
### April 12th Assignment
#### Implementing `void avoidRedVehicles(ArrayList<Vehicle> vehicles)'


````
void avoidRedVehicles(ArrayList<Vehicle> vehicles) {
    // to accumilate all the individual avoidance vectors
    int count = 0; // how
    PVector sum = new PVector(0, 0);

    // Now look at each vehicle and if it is aggressive calculate the desired vector to avoid it
    for (Vehicle other : vehicles) {

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

````
