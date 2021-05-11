
ArrayList<Animal> animals; 
int numberOfAnimals = 250;  //number of bots/animals in the environemnt
int average = 0;           //keep track of the average number of predators who are large
int showAverage=0;
boolean associate = false;  //associate is false at first
final int THRESHOLD = (int) (numberOfAnimals * 0.6);  //threshold is 72% of total animals; 

//size of display box
float boxWidth;
float boxHeight;

//start location of box where state of association is shown
float asBoxStartX;
float asBoxStartY;

//start location of box where threshold/number of bots is shown
float botBoxStartX;
float botBoxStartY;

//start location of box where number of larger bots who are predators
float curBoxStartX;
float curBoxStartY;

//start location of box where the runtime is shown
float countBoxStartX;
float countBoxStartY;

//offset to set the start location of text in each box
float textOffSetX;
float textOffSetY;

void setup() {
 size (1920, 1080); 
 // fullScreen();
  animals = new ArrayList<Animal>();   //initiate aniaml arraylist

  //size of the box is the percentage of width and height
  boxWidth = width * 0.2;
  boxHeight = boxWidth * 0.15;

  //initiate the start location of box where state of association is shown
  asBoxStartX = width * 0.025;
  asBoxStartY = height * 0.01;

  //initiate the start location of box where number of bots is shown
  botBoxStartX = width * 0.28;
  botBoxStartY = height * 0.01;

  //initiate location of box where number of larger bots who are predators
  curBoxStartX = width * 0.53;
  curBoxStartY = height * 0.01;

  //initiate the start location of box where state of runtime is shown
  countBoxStartX = width * 0.78;
  countBoxStartY = height * 0.01;

  //offset is percentage of height and width of box
  textOffSetX = boxWidth * 0.05;
  textOffSetY = boxHeight * 0.7;

  //fullScreen();

  // initiate a list of animals
  for (int i = 0; i < numberOfAnimals; i++) {

    //trying to initiate animals without having their locations overlap each other
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

    //randomly provide locations to animals
    animals.add(new Animal(
      random(width), random(height), // location
      random(-10, 10), random(-10, 10), // velocity
      i )); // serial number is the index number
  }
}

void draw() {
  background(157, 179, 182);

  int sum = 0;    //sum of predators whose size is also large

  //text size and color for displaying text
  textSize(width *.0141);
  fill(249, 211, 0, 70);

  //displays number of total bots
  rect(botBoxStartX, botBoxStartY, boxWidth, boxHeight); 
  fill(0, 100, 0);
  text("Threshold/Bots: " + THRESHOLD + "/" + numberOfAnimals, botBoxStartX + textOffSetX, botBoxStartY + textOffSetY);


  //display runtime
  textSize(width *.018);
  fill(249, 211, 0, 70);
  rect(countBoxStartX, countBoxStartY, boxWidth, boxHeight);   
  fill(0, 100, 0);
  text("Runtime: " + MsConversion(millis()), countBoxStartX + textOffSetX, countBoxStartY + textOffSetY);


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
  //println(average);
  if (average > showAverage) {
    showAverage = average;
  }

  if (average > THRESHOLD && !associate) {   //if average of predators who are large go over the threshold, associate them as predator
    associate = true;
  }

  //display the state of association--whether true or false

  textSize(width *.02);

  if (!associate) {
    //textSize(32);
    // text("Association: False", 35, 40); 
    fill(100, 0, 0, 70);
    rect(asBoxStartX, asBoxStartY, boxWidth, boxHeight);
    fill(0, 100, 0);
    text("Association: False", asBoxStartX + textOffSetX, asBoxStartY + textOffSetY);

    //displays number of total bots
    textSize(width *.0141);
    //fill(249, 211, 0, 70);
    fill(100, 0, 0, 70);
    rect(curBoxStartX, curBoxStartY, boxWidth, boxHeight); 
    fill(0, 100, 0);
    text("Current Status: " + showAverage + "/" + numberOfAnimals, curBoxStartX + textOffSetX, curBoxStartY + textOffSetY);
  } else {
    //textSize(32);
    fill(249, 211, 0, 70);
    rect(asBoxStartX, asBoxStartY, boxWidth, boxHeight);
    fill(0, 100, 0);
    text("Association: True", asBoxStartX + textOffSetX, asBoxStartY + textOffSetY);

    //displays number of total bots
    textSize(width *.0141);
    fill(249, 211, 0, 70);
    rect(curBoxStartX, curBoxStartY, boxWidth, boxHeight); 
    fill(0, 100, 0);
    text("Associated at: " + showAverage + "/" + numberOfAnimals, curBoxStartX + textOffSetX, curBoxStartY + textOffSetY);
  }
}

//converst milliseconds to hour, min, sec
String MsConversion(int MS) {
  int totalSec= (MS / 1000);
  int seconds = (MS / 1000) % 60;
  int minutes = (MS / (1000*60)) % 60;
  int hours = ((MS/(1000*60*60)) % 24);                      

  return hours+" : " +minutes+ " : "+ seconds;
}
