class Flock {
  ArrayList<Boid> boids;

  Flock() {
    boids = new ArrayList<Boid>();
  }

  void run() {
    for (Boid b : boids) {
      // Each Boid object must know about
      // all the other Boids.
      b.applyForce(boids);
    }
  }

  void addBoid(Boid b) {
    boids.add(b);
  }
}
