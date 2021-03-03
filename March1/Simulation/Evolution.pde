class Evolution {
  ArrayList<Bug> bugs;  //an arraylist of Bugs
  ArrayList<Bug> dyingBugs;  //an arraylist of dying Bugs removed from Bugs arraylist

  Evolution() {
    bugs = new ArrayList<Bug>();
    dyingBugs = new ArrayList<Bug>();
  }


  ///run the simulation
  void run() {

    //loop through all the Bugs to apply forces, updates, display them
    for (Bug b : bugs) {
      b.applyForce(bugs); 
      b.update();
      b.mDisplay();
      b.checkEdges();
    }

    //when only three Bugs left, check their average survivablity status
    if (bugs.size() < 4) {
      float sum = 0;
      float x= 0;
      float y = 0;
      for (Bug b : bugs) {
        sum += b.bDNA.bSurv;
        x += b.location.x;
        y += b.location.y;
      }

      //if their average survivablity status is greater or equal to 1, add a Bug of the same DNA to the simulation
      if (sum/bugs.size() >= 1) {
        bugs.add(new Bug(x/bugs.size(), y/bugs.size(), bugs.get(0).getDNA()));
      }
    }
  }
  //add Bugs to arraylist
  void addBoid(Bug b) {
    bugs.add(b);
  }

 ////compare the color of each bug to the color of the environment to determine their survivability status
  void compColor(color e_color) {

    for (Bug b : bugs) {
      float avg = avgCompColor(e_color, b); //calls function to compare their colors

      //if the average difference between a bug <= 50, the bug's survability number increases
      if (avg <= 50) {
        if (b.bDNA.bSurv < 1) {
          b.bDNA.bSurv += 0.01;
        }
      } else if (avg > 50 && avg <= 65) {  //average difference > 50, their survability number decreases
        b.bDNA.bSurv -= 0.001;
      } else if (avg > 65 && avg <= 80) {
        b.bDNA.bSurv -= 0.002;
      } else if (avg > 80 && avg <= 95) {
        b.bDNA.bSurv -= 0.003;
      } else if (avg > 95 && avg <= 110) {
        b.bDNA.bSurv -= 0.004;
      } else if (avg > 110 && avg <= 125) {
        b.bDNA.bSurv -= 0.005;
      } else if (avg > 125 && avg <= 140) {
        b.bDNA.bSurv -= 0.006;
      } else if (avg > 140 && avg <= 155) {
        b.bDNA.bSurv -= 0.007;
      } else if (avg > 155 && avg <= 170) {
        b.bDNA.bSurv -= 0.008;
      } else if (avg > 170 && avg <= 185) {
        b.bDNA.bSurv -= 0.009;
      } else if (avg > 185 ) {
        b.bDNA.bSurv -= 0.01;
      }
      
      
         //bugs with survivability status < 0 are added to dying bugs arraylist
      if (b.bDNA.bSurv <= 0) {
        dyingBugs.add(b);
      } else if (b.bDNA.bSurv > 0.5) {
        b.desiredseparation--;
      }
     // println(b.bDNA.bSurv);
    }

    collide( bugs, e_color);  //check if better bugs can be produced

    //remove dying bugs from main bugs list
    for (Bug b : dyingBugs) {
      bugs.remove(b);
    }
  }
  
  
  //taking 2 bugs to produce one bug with a color closer to the color of the environment
  DNA reprd(color e_color, Bug a, Bug b) {

    //get the RGB of the environment color
    float e_green = green(e_color);
    float e_red = red(e_color);
    float e_blue = blue(e_color);
    
    //make a copy of one of the bugs' DNAs
    DNA nDNA = a.getDNA(); 
    //get an average survability status
    nDNA.bSurv = (a.getDNA().bSurv + b.getDNA().bSurv)/2;
    
    //get the RGBs of the bugs
    float a_green = green(a.bDNA.bColor);
    float a_red = red(a.bDNA.bColor);
    float a_blue = blue(a.bDNA.bColor);

    float b_green = green(b.bDNA.bColor);
    float b_red = red(b.bDNA.bColor);
    float b_blue = blue(b.bDNA.bColor);

    //average the colors 
    float avg_green = (a_green + b_green) /2;
    float avg_red = (a_red + b_red) /2;
    float avg_blue = (a_blue + b_blue) /2;   

    //improve the colors to better match the environment
    if (avg_green - e_green < 0) {
      nDNA.bColor = color(avg_red, avg_green+1, avg_blue);
    } else if (avg_green - e_green > 0) {
      nDNA.bColor = color(avg_red, avg_green-1, avg_blue);
    }

    if (avg_red - e_red < 0) {
      nDNA.bColor = color(avg_red + 1, avg_green, avg_blue);
    } else if (avg_red - e_red > 0) {
      nDNA.bColor = color(avg_red-1, avg_green, avg_blue);
    }

    if (avg_blue - e_blue < 0) {
      nDNA.bColor = color(avg_red, avg_green, avg_blue + 1);
    } else if (avg_blue - e_blue > 0) {
      nDNA.bColor = color(avg_red, avg_green, avg_blue - 1);
    }    
  
    return nDNA;
  }

//check if 2 bugs can create a new bug
  void collide(ArrayList<Bug> Bugs, color e_color) {
    boolean collide = false;  // keep track of whether 2 bugs contact each other
    int i = 0;

    //go through the arraylist of bugs while bugs are not in contact yet
    while (!collide && i < Bugs.size()) {
      Bug b = Bugs.get(i);  //get one bug
      int j = i + 1;       
      while (!collide && j < Bugs.size()) {
        Bug other = Bugs.get(j);    //get another bug
        float d = PVector.dist(b.location, other.location);  //compare the distance between them
        if (d < 10) {  //if they are very cose
          //if their colors are not the same and both their survabilities are above 0.5
          if (avgCompColor(b.bDNA.bColor, other)  > 12 && b.bDNA.bSurv > 0.5 && other.bDNA.bSurv > 0.5) {
            DNA dna = reprd(e_color, b, other);  //get dna from reprd functin
            Bug nB = new Bug(b.location.x, b.location.y, dna);  //create a new bug at one of the bugs' locations

            nB.desiredseparation = 100; //set separate distance to 100
            //remove their parents
            Bugs.add(nB);
            Bugs.remove(b);
            Bugs.remove(other);
            collide = true; //set collide true to leave the loop
          } else {
            //this means that they are not suitable of producing new bugs,so separate them
            b.desiredseparation = 100;
            other.desiredseparation = 100;
          }
        }
        j++;
      }
      i++;
    }
  }
  
  //finding the average difference between 2 colors
  float avgCompColor(color e_color, Bug b) {
    //get the RGBs of the environment's and bug's colors
    float e_green = green(e_color);
    float e_red = red(e_color);
    float e_blue = blue(e_color);

    float b_green = green(b.bDNA.bColor);
    float b_red = red(b.bDNA.bColor);
    float b_blue = blue(b.bDNA.bColor);
    
    //add the differences and divide by 3 to find the average
    float sum = abs(e_green - b_green) + abs(e_red - b_red) + abs(e_blue - b_blue);
    float avg = sum / 3;

    return avg;
  }
}
