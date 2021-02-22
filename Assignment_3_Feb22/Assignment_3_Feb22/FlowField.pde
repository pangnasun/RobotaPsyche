
class FlowField {
  PVector[] randVectors; //store random vectors for arrows to point to
  PVector[][] field;  //storing arrows in an array
  ArrayList<ArrayList<PVector>> fields = new ArrayList<ArrayList<PVector>>(); //storing arrow vectors in arraylist to be used later
  ArrayList<ArrayList<PVector>> locations = new ArrayList<ArrayList<PVector>>();//storing the locations where the arrows will be displayed
  int cols, rows;
  int resolution; // Size of each square in the grid, in pixels
  int fSize;


  // Constructor takes the desired resolution
  FlowField(int _res) {
    resolution = _res;
    cols = width/resolution;
    rows = height/resolution;

    // Declare the array of PVectors which will hold the field
    field = new PVector[cols][rows];
    fSize = cols * rows;
    randVectors = new PVector[int(width/15)]; //initaliz random number of vectors 


    //create radom vectors
    for (int i = 0; i < randVectors.length; i++) {
      randVectors[i] = new PVector(random(width), random(height));
      //println(randVectors[i].x + " " + randVectors[i].y);
      //println("i:" + i);
    }

    // println("size: " + cols * rows);
    //println("size: "+  fSize);

    // Initialize the field using one of the three options below
    // or make up your own initialization function
    // uniformFlowField();
    // randomFlowField();
    //perlinFlowField();
    //centeringFlowField();
    //cList();
    //createFlowField();
    //createCircles();
    mouseFlowField();
  }

  // Pretty boring; all vectors point to the right
  void uniformFlowField() {
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        field[i][j] = new PVector(1, 0); // pointing to the right
      }
    }
  }

  void randomFlowField() {
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        field[i][j] = PVector.random2D();
      }
    }
  }

  // Use perlin noise to determine the angle of each vector
  void perlinFlowField() {

    float xoff = 0;
    for (int i = 0; i < cols; i++) {
      float yoff = 0;
      for (int j = 0; j < rows; j++) {

        // Moving through the noise() space in two dimensions
        // and mapping the result to an angle between 0 and 360
        float theta = map(noise(xoff, yoff), 0, 1, 0, TWO_PI);

        // Convert the angle (polar coordinate) to Cartesian coordinates
        field[i][j] = new PVector(cos(theta), sin(theta));

        // Move to neighboring noise in Y axis
        yoff += 0.1;
      }

      // Move to neighboring noise in X axis
      xoff += 0.1;
    }
  }

  //flow field points to the center
  void centeringFlowField() {
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        // PVector tar = new PVector(width/2,height/2);
        PVector v = new PVector((width/2)- i * resolution, ( height/2)- j * resolution);  //create vector points to the center       
        //PVector u = PVector.sub(tar,v);
        v.normalize();
        field[i][j] = v;
      }
    }
  }


void mouseFlowField() {
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        // PVector tar = new PVector(width/2,height/2);
        PVector v = new PVector(mouseX- i * resolution, mouseY- j * resolution);  //create vector points to the center       
        //PVector u = PVector.sub(tar,v);
        v.normalize();
        field[i][j] = v;
      }
    }
  }
  //create a bullseye feature for the flow field
  void bullsEye() {
    for (int i = width; i > 0; i-=50) {
      if (i%100==0) {
        fill (255);
      } else {
        fill(255, 0, 0);
      }
      circle(width/2, height/2, i);
    }
  }

  //create flow field where arrows point to random vectors 
  void createFlowField() {

    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        //PVector v = new PVector(i * resolution, j * resolution);
        PVector v = checkClosest(new PVector(i * resolution, j * resolution)); //call a function that checks the closest point and then make a vector point to that vector
        //println("V" + v.x + " " + v.y);        

        v.normalize();
        field[i][j] = v;
      }
    }
  }

  //use an inpust vecotr and check for the closest random vector to that input vector
  PVector checkClosest(PVector u) {
    float dist = randVectors[0].dist(u);
    PVector closest = randVectors[0];

    for (int i = 1; i < randVectors.length -1; i++) { //go through random vectors to check for the closest one
      if (dist > randVectors[i].dist(u)) {
        dist = randVectors[i].dist(u);
        closest = randVectors[i];
      }
    }
    //println(closest.x + " " + closest.y);


    u = new PVector(closest.x - u.x, closest.y - u.y);  //create a vector that point to the closest random vector
    //println("U" + u.x + " " + u.y);

    return u;
  }

  //goal: create vectors that follow the arch of circles
  //current state: create vectors according to angles
  void createCircles() {
    float init = 0;
    //float init2 = 2*PI;
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        //if(init >2*PI){
        //  init = 0;
        //}
        //PVector u = new PVector(i, j );
        //PVector w = new PVector(width/2, width/2);
        //float dis = dist(width/2, height/2,i * resolution, j *resolution);
        //float ang = atan(resolution/dis);
        PVector v = new PVector(cos(init), sin(init)); //create vector depends on the angle
        //v.normalize();
        field[i][j] = v;
        init += 0.01;
        //init2 -= 0.01;
      }
    }
  }

  // Given a PVector which defines a location in the flow field,
  // return a copy of the value of the flow field at that location
  PVector lookup(PVector lookup) {

    // Convert x and y values to row and column, and constrain
    // to stay within the field
    int column = int(constrain(lookup.x/resolution, 0, cols-1));
    int row = int(constrain(lookup.y/resolution, 0, rows-1));

    return field[column][row].copy();
  }

  // Display the flow field with a bullseye
  void cDisplay() {
    bullsEye();
    for (int i = 0; i < cols; i++) {
      stroke(random(255), random(255), random(255));
      for (int j = 0; j < rows; j++) {
        //print("col " + i + " row " + j + "  ");
        //println(i*resolution, j*resolution, field[i][j].x, field[i][j].y);
        pushMatrix();

        // This translates to the top left corner of the grid, but really
        // it should center the vector in the middle of the grid
        translate(i*resolution, j*resolution);
        PVector f = field[i][j].copy();
        // f.mult(resolution);

        //if (f.x > 0) {
        //  rotate(f.heading());
        //  line(0, 0, resolution, 0);
        //  //ellipse(f.x, f.y, 5, 5); // circle instead of arrow head
        //  line(resolution, 0, resolution - 4, 3);
        //  line(resolution, 0, resolution -4, -3);
        //}else{
        //  //f.set(-f.x,-f.y);
        //  f.mult(-1);
        //  rotate(f.heading());
        //  line(resolution, 0, 0, 0);
        //  //ellipse(f.x, f.y, 5, 5); // circle instead of arrow head
        //  line(0, 0,  4, 3);
        //  line(0, 0,  4, -3);
        //}

        rotate(f.heading());

        line(0, 0, resolution, 0);
        //ellipse(f.x, f.y, 5, 5); // circle instead of arrow head
        line(resolution, 0, resolution - 4, 3);
        line(resolution, 0, resolution -4, -3);

        popMatrix();
      }
    }
  }

  //displa the flowfield 
  void display() {

    for (int i = 0; i < cols; i++) {
      //stroke(random(255), random(255), random(255));
      for (int j = 0; j < rows; j++) {
        //print("col " + i + " row " + j + "  ");
        //println(i*resolution, j*resolution, field[i][j].x, field[i][j].y);
        pushMatrix();

        // This translates to the top left corner of the grid, but really
        // it should center the vector in the middle of the grid
        translate(i*resolution, j*resolution);
        PVector f = field[i][j].copy();
        // f.mult(resolution);

        //if (f.x > 0) {
        //  rotate(f.heading());
        //  line(0, 0, resolution, 0);
        //  //ellipse(f.x, f.y, 5, 5); // circle instead of arrow head
        //  line(resolution, 0, resolution - 4, 3);
        //  line(resolution, 0, resolution -4, -3);
        //}else{
        //  //f.set(-f.x,-f.y);
        //  f.mult(-1);
        //  rotate(f.heading());
        //  line(resolution, 0, 0, 0);
        //  //ellipse(f.x, f.y, 5, 5); // circle instead of arrow head
        //  line(0, 0,  4, 3);
        //  line(0, 0,  4, -3);
        //}

        rotate(f.heading());

        line(0, 0, resolution, 0);
        //ellipse(f.x, f.y, 5, 5); // circle instead of arrow head
        line(resolution, 0, resolution - 4, 3);
        line(resolution, 0, resolution -4, -3);

        popMatrix();
      }
    }
  }

//get the vectors from the field array and put them in an array list
//vectors are taken from outer layer to innter layer
  void cList() {
    int curCols = cols -1;
    int curRows = rows -1;
    //int j =0;
    for (int i = 0; i < curCols; i++) {
      ArrayList<PVector> nField = new ArrayList<PVector>(); //temptorary vector arraylist to store vecotrs
      ArrayList<PVector> nLoc = new ArrayList<PVector>(); //temptorary locations arraylist to store vecotrs

      for (int k = i + 1; k <= curCols; k++) { //get all the vectors in that row
        nField.add(field[k][i]);  //top row
        nLoc.add(new PVector(k, i));  //location of that vector
        nField.add(field[k][curRows]); //bottom row
        nLoc.add(new PVector(k, curRows));  //location of that vector
      }

      for (int j=i; j <= curRows; j++) {  //get all vecotors in that column 
        nField.add(field[i][j]);  //left column
        nLoc.add(new PVector(i, j));
        nField.add(field[curCols][j]);  //right column
        nLoc.add(new PVector(curCols, j));
      }
      fields.add(nField); //add the arraylist to the main array list
      locations.add(nLoc); //--
      //int size = 0;

      //for (ArrayList<PVector> vField: fields){
      //  for (PVector f: vField){
      //    size++;
      //  }
      //}
      //println("size: " + fSize);
      //println("size2: " + size);
      //if (size > fSize) {
      //  fields.remove(nField);
      //  locations.remove(nLoc);
      //}
      curCols--;
      curRows--;
    }

    //aDisplay();
  }

  //display flow field with random colors for arrows
  void aDisplay() {
    int n = 0;
    bullsEye();
    //int count =0;
    for (ArrayList<PVector> rField : fields ) {
      stroke(random(255), random(255), random(255));
      for (int k = 0; k < rField.size() - 1; k++) {
        float i = locations.get(n).get(k).x;
        float j = locations.get(n).get(k).y;
        PVector f = rField.get(k);

        pushMatrix();
        //println(f.x + "  " + f.y);
        // This translates to the top left corner of the grid, but really
        // it should center the vector in the middle of the grid
        translate(i*resolution, j*resolution);
        //PVector f = field[i][j].copy();
        // f.mult(resolution);

        //if (f.x > 0) {
        //  rotate(f.heading());
        //  line(0, 0, resolution, 0);
        //  //ellipse(f.x, f.y, 5, 5); // circle instead of arrow head
        //  line(resolution, 0, resolution - 4, 3);
        //  line(resolution, 0, resolution -4, -3);
        //}else{
        //  //f.set(-f.x,-f.y);
        //  f.mult(-1);
        //  rotate(f.heading());
        //  line(resolution, 0, 0, 0);
        //  //ellipse(f.x, f.y, 5, 5); // circle instead of arrow head
        //  line(0, 0,  4, 3);
        //  line(0, 0,  4, -3);
        //}

        rotate(f.heading());

        line(0, 0, resolution, 0);
        //ellipse(f.x, f.y, 5, 5); // circle instead of arrow head
        line(resolution, 0, resolution - 4, 3);
        line(resolution, 0, resolution -4, -3);

        popMatrix();
        count++;
      }
      n++;
    }
    //println("count " + count);
  }

  //display flow fields from arraylist to create moving effect
  void bDisplay(ArrayList<PVector> rField, int n) {
    //int count =0;
    stroke(random(255), random(255), random(255));
    for (int k = 0; k < rField.size() - 1; k++) {
      float i = locations.get(n).get(k).x; //get the x location to display the arrow
      float j = locations.get(n).get(k).y; //get the y location to display the arrow
      PVector f = rField.get(k); 

      pushMatrix();
      //println(f.x + "  " + f.y);
      // This translates to the top left corner of the grid, but really
      // it should center the vector in the middle of the grid
      translate(i*resolution, j*resolution);
      //PVector f = field[i][j].copy();
      // f.mult(resolution);

      //if (f.x > 0) {
      //  rotate(f.heading());
      //  line(0, 0, resolution, 0);
      //  //ellipse(f.x, f.y, 5, 5); // circle instead of arrow head
      //  line(resolution, 0, resolution - 4, 3);
      //  line(resolution, 0, resolution -4, -3);
      //}else{
      //  //f.set(-f.x,-f.y);
      //  f.mult(-1);
      //  rotate(f.heading());
      //  line(resolution, 0, 0, 0);
      //  //ellipse(f.x, f.y, 5, 5); // circle instead of arrow head
      //  line(0, 0,  4, 3);
      //  line(0, 0,  4, -3);
      //}

      rotate(f.heading());

      line(0, 0, resolution, 0);
      //ellipse(f.x, f.y, 5, 5); // circle instead of arrow head
      line(resolution, 0, resolution - 4, 3);
      line(resolution, 0, resolution -4, -3);

      popMatrix();
      count++;
    }
  }
}
