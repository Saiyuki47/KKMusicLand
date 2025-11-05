class Player {
  int score = 0;
  Player() {
  }
  void display() {
    pushStyle();
    noStroke();
    fill(30, 144, 255, 150);
    float size = 24;
    rectMode(CENTER);
    rect(mouseX, mouseY, size, size);
    rectMode(CORNER);
    popStyle();
  }
}
