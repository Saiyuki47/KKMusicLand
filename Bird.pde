class Bird {
  float x, y;
  float speed;
  int c;
  float wingAngle;
  
  Bird(float y) {
    this.x = -50;
    this.y = y;
    this.speed = random(3, 6);
    this.wingAngle = 0;
    // Vogel Farben
    this.c = color(random(50, 150), random(50, 100), random(20, 80));
  }
  
  void update() {
    x += speed;
    wingAngle += 0.2;
  }
  
  void display() {
    pushMatrix();
    translate(x, y);
    
    // Körper
    fill(c);
    noStroke();
    ellipse(0, 0, 30, 20);
    
    // Kopf
    ellipse(15, -5, 15, 15);
    
    // Schnabel
    fill(255, 150, 0);
    triangle(22, -5, 28, -3, 22, -1);
    
    // Flügel (animiert)
    fill(c);
    pushMatrix();
    rotate(sin(wingAngle) * 0.3);
    ellipse(-8, 0, 20, 10);
    popMatrix();
    
    popMatrix();
  }
  
  boolean isOffScreen() {
    return x > width + 50;
  }
}
