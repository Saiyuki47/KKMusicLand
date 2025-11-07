class Note {
  float x, y;
  float speed;
  int c;
  int noteType;
  Note(float x, float y) {
    this.x = x;
    this.y = y;
    this.speed = settingsManager.getNoteSpeed();
    this.c = color(random(100,255), random(100,255), random(100,255));
    this.noteType = int(random(4));
  }
  void update() {
    y += speed;
  }
  void display() {
    fill(c);
    stroke(c);
    strokeWeight(2);
    pushMatrix();
    translate(x, y);
    switch(noteType) {
      case 0:
        noFill();
        strokeWeight(4);
        ellipse(0, 0, 35, 25);
        break;
      case 1:
        noFill();
        strokeWeight(4);
        ellipse(0, 0, 35, 25);
        fill(c);
        strokeWeight(3);
        line(17, 0, 17, -50);
        break;
      case 2:
        fill(c);
        strokeWeight(3);
        ellipse(0, 0, 35, 25);
        line(17, 0, 17, -50);
        break;
      case 3:
        fill(c);
        strokeWeight(3);
        ellipse(0, 0, 35, 25);
        line(17, 0, 17, -50);
        noFill();
        strokeWeight(3);
        bezier(17, -50, 30, -42, 25, -35, 17, -25);
        break;
    }
    popMatrix();
    strokeWeight(1);
  }
  boolean isHit(float mx, float my) {
    return dist(mx, my, x, y) < 45;
  }
}
