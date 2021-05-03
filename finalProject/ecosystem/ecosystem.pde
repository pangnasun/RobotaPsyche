
ArrayList<Animal> animals = new ArrayList<Animal>();

int numberOfAnimals = 100; 
int average = 0;           //keep track of the average number of predators who are large
boolean associate = false;  //associate is false at first
final int THRESHOLD = 65;

void setup() {
  size (1200, 700); 

  // initiate a list of animals
  for (int i = 0; i < numberOfAnimals; i++) {
    //  float x = random(width);
    //  float y = random(height);
    //  for (int j = 0; j < animals.size(); j++) {
    //    while (abs(animals.get(j).location.x - x) < 15) {
    //      x = random(width);
    //      j = 0;
    //    }

    //    while (abs(animals.get(j).location.y - y) < 15) {
    //      y = random(height);
    //      j = 0;
    //    }
    //  }

    //  animals.add(new Animal(
    //    x, y, // location
    //    random(-10, 10), random(-10, 10), // velocity
    //    i )); // serial number is the index number
    //}

    animals.add(new Animal(
      random(width), random(height), // location
      random(-10, 10), random(-10, 10), // velocity
      i )); // serial number is the index number
  }
}

void draw() {
  background(41,40,38);
  int sum = 0;    //sum of predators who are larger than 
  
  // create relations between animals
  for (Animal a : animals) {
    
    if (associate) {   //check association is possible
      a.association(animals);  
      //println("true");
    } else {
      sum += a.defineRelations(animals);   //define relationship between animals
    } 
    a.applyForce(animals);   //apply forces

    a.update();
    a.checkEdges();
    a.display(); // display the vehicle
  }
  //println(sum);
  //noLoop();

  average = (average + sum)/2;     //average the number of predators of all the runs


  if (average > THRESHOLD && !associate) {   //if average of predators who are large go over the threshold, associate them as predator
    associate = true;
  }

}
