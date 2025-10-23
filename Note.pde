class Note {
  float x, y;
  float speed;
  int c; // <--- geändert von color auf int

  Note(float x, float y) {
    this.x = x;
    this.y = y;
    this.speed = random(2, 4);
    this.c = color(random(100,255), random(100,255), random(100,255));
  }

  void update() {
    y += speed;
  }

  void display() {
    fill(c);
    noStroke();
    ellipse(x, y, 40, 40);
  }

  boolean isHit(float mx, float my) {
    return dist(mx, my, x, y) < 30;
  }
}
