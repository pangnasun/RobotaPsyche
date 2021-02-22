class DNA{
  color bColor;
  int bSize;
  float Bsurv = 1; //survivabilty
  
  DNA (int c, int _size ){
    bColor = c;
    bSize = _size;
    
  }

  color getColor(){
    return bColor;    
  }
  
  int getSize(){
    return bSize;
  }
}
