class DNA {
  color bColor;
  int bSize;
  float bSurv; //survivabilty
  //a way to keep track of dying bugs in the arraylist before removing them
  //purpose: animation of dying bugs
  int lastBreath;  

  DNA (int c, int _size, float surv ) {
    bColor = c;
    bSize = _size;
    bSurv = surv;
    lastBreath = 100;
  }


  color getColor() {
    return bColor;
  }

  int getSize() {
    return bSize;
  }

  float getSurv() {
    return bSurv;
  }
}
