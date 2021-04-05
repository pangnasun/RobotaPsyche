void setup(){

}

void draw(){

}

PVector Vm(PVector p1, PVector p2, PVector p3 ){
  PVector v = PVector.sub(p1,p3);
  PVector p1_to_p2 = PVector.sub(p1,p2);
  p1_to_p2.normalize();
  PVector vm = p1_to_p2.mult(v.dot(p1_to_p2));
  
  return vm;
}
