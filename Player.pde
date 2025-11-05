class Player {
  // Minimal player object: only stores the player's score.
  int score = 0;

  // No-argument constructor
  Player() {
  }
  
  // Draw a small square at the mouse position to represent the hitbox
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
