void setup(){
  size(800,800);
  background(255);
  PVector p1 = new PVector(100,100);
  PVector p2 = new PVector (100,600);
  PVector p3 = new PVector (500, 300);
  
  PVector vm = Vm(p1,p2,p3);
  strokeWeight(10);
  point(p1.x,p1.y);
  point(p2.x,p2.y);
  point(p3.x,p3.y);
  //println(vm.x);
  //println(vm.y);
  point(vm.x + p1.x,vm.y + p1.y);
  //point(100,100);
  
}

void draw(){

}

PVector Vm(PVector p1, PVector p2, PVector p3 ){
  PVector v = PVector.sub(p3,p1);
  PVector p1_to_p2 = PVector.sub(p2,p1);
  p1_to_p2.normalize();
  PVector vm = p1_to_p2.mult(v.dot(p1_to_p2));
  
  return vm;
}
