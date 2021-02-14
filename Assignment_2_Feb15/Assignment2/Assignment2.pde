
ArrayList<ArrayList<PVector>> arrFields; //create an array list to store vectors from flow field in order to do some "cool" animation later
FlowField f;
//Vehicle v;
int count;
ArrayList<Vehicle> vehicles;  //arraylist to store vehicles

void setup() {
  size (800, 600);
  background(10, 150, 150);
  f = new FlowField(15);
  vehicles = new ArrayList<Vehicle>();
  count = 0;
  arrFields = f.fields;
  f.aDisplay();
  //f.display();
   //f.cDisplay();



  // put the vehicle in the middle
  //v = new Vehicle(width/2, height/2);
}


void draw() {
  //background(10, 150, 150);
  //if (count > arrFields.size() - 1){
  //  count = 0;
  //  background(10,150,150);
  //}else{
  //  f.bDisplay(arrFields.get(count), count);
  //  count++;

  //}
  //delay(200);
  //stroke(200, 70, 150);
  //f.aDisplay();
  
  //go through vehicles and check if the current vehcile is still in the field; if in, display else remove
  for (Vehicle v : vehicles) {
    if (v.location.x > width || v.location.x < 0 || v.location.y > height || v.location.y < 0){
      vehicles.remove(v);
    }else{
      v.follow(f); // Apply the steering force to follow the flow field
      v.update(); // Update the velocity and location, based on the acceleration generated by the steering force
      v.display(); // display the vehicle
    }
  }
  //f.aDisplay(); // display the flow field
}

void mousePressed() {
  vehicles.add(new Vehicle(mouseX, mouseY)); //when mouse is pressed, create a vehicle at the mouse's location
}
