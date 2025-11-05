class Flower {
  float x, y;
  int petalColor;
  int centerColor;
  float size;
  float growProgress;
  float maxSize;
  
  Flower(float x, float y) {
    this.x = x;
    this.y = y;
    this.maxSize = random(20, 40);
    this.size = 0;
    this.growProgress = 0;
    // Bunte Blütenblätter
    this.petalColor = color(random(150, 255), random(100, 255), random(150, 255));
    this.centerColor = color(random(200, 255), random(150, 200), 0);
  }
  
  void update() {
    if (growProgress < 1) {
      growProgress += 0.02;
      size = maxSize * growProgress;
    }
  }
  
  void display() {
    pushMatrix();
    translate(x, y);
    
    // Stiel
    stroke(50, 150, 50);
    strokeWeight(3);
    line(0, 0, 0, -size * 1.5);
    
    // Blatt
    noStroke();
    fill(50, 200, 50);
    ellipse(-size * 0.3, -size * 0.7, size * 0.4, size * 0.6);
    
    // Blüte oben am Stiel positionieren
    pushMatrix();
    translate(0, -size * 1.5);
    
    // Blütenblätter
    fill(petalColor);
    for (int i = 0; i < 6; i++) {
      pushMatrix();
      rotate(radians(i * 60));
      ellipse(0, -size * 0.5, size * 0.8, size * 1.2);
      popMatrix();
    }
    
    // Mitte der Blume
    fill(centerColor);
    ellipse(0, 0, size * 0.6, size * 0.6);
    
    popMatrix(); // Ende der Blüten-Translation
    
    popMatrix();
  }
  
  boolean isFullyGrown() {
    return growProgress >= 1;
  }
}
