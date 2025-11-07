class Grave {
  float x, y;
  float alpha = 0;   // sanftes Einblenden
  float targetAlpha = 200;
  float w = 24;
  float h = 30;
  Grave(float x, float y) {
    this.x = x;
    this.y = y;
  }
  void update() {
    // sanft einblenden
    if (alpha < targetAlpha) alpha = min(targetAlpha, alpha + 10);
  }
  void display() {
    pushMatrix();
    translate(x, y);
    noStroke();
    // kleiner Schatten auf Boden
    fill(0, 50);
    ellipse(0, 6, w * 0.9, 6);
    // Grabstein
    fill(120, 120, 130, alpha);
    rectMode(CENTER);
    // runder Kopf
    rect(0, -h*0.25, w, h*0.8, 6);
    // Inschrift (kleines Kreuz)
    stroke(80, alpha);
    strokeWeight(2);
    line(-2, -h*0.25 - 4, 2, -h*0.25 - 4);
    line(0, -h*0.25 - 8, 0, -h*0.25);
    noStroke();
    rectMode(CORNER);
    popMatrix();
  }
}