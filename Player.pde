class Player {
  int score = 0;
  Player() {
  }
  void display() {
    pushStyle();
    // Crosshair zeichnen
    float size = 22;
    float gap = 6;
    float strokeW = 2;
    int strokeCol = color(255);
    int shadowCol = color(0, 100);
    strokeWeight(strokeW + 2);
    stroke(shadowCol);
    line(mouseX - size, mouseY, mouseX - gap, mouseY);
    line(mouseX + gap, mouseY, mouseX + size, mouseY);
    line(mouseX, mouseY - size, mouseX, mouseY - gap);
    line(mouseX, mouseY + gap, mouseX, mouseY + size);
    strokeWeight(strokeW);
    stroke(strokeCol);
    line(mouseX - size, mouseY, mouseX - gap, mouseY);
    line(mouseX + gap, mouseY, mouseX + size, mouseY);
    line(mouseX, mouseY - size, mouseX, mouseY - gap);
    line(mouseX, mouseY + gap, mouseX, mouseY + size);
    noStroke();
    fill(255);
    ellipse(mouseX, mouseY, 3, 3);
    popStyle();
  }
}
