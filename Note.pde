class Note {
  // Simple falling note used by the gameplay
  float x, y;   // position
  float speed;  // vertical speed
  int c;        // color

  Note(float x, float y) {
    this.x = x;
    this.y = y;
    // randomized falling speed for variety
    this.speed = random(2, 4);
    // vibrant random color
    this.c = color(random(100,255), random(100,255), random(100,255));
  }

  // Move the note downwards
  void update() {
    y += speed;
  }

  // Draw the note as a colored circle
  void display() {
    fill(c);
    noStroke();
    ellipse(x, y, 40, 40);
  }

  // Simple hit test: returns true when the given point is close enough
  boolean isHit(float mx, float my) {
    return dist(mx, my, x, y) < 30;
  }
}
