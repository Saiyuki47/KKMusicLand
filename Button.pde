class Button {
  // Simple rectangular button used by menus and game-over screen
  float x, y, w, h;
  String label;
  
  // position, size and label
  Button(float x, float y, float w, float h, String label) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.label = label;
  }
  
  // Draw the button with a simple hover/pressed effect
  void display() {
    boolean over = (mouseX >= x && mouseX <= x + w && mouseY >= y && mouseY <= y + h);
    if (over && mousePressed) {
      // pressed visual
      fill(0, 120, 0);
    } else if (over) {
      // hover visual
      fill(0, 200, 0);
    } else {
      fill(0, 160, 0);
    }
    rect(x, y, w, h, 10);

    // label text
    fill(255);
    textSize(24);
    textAlign(CENTER, CENTER);
    text(label, x + w/2, y + h/2);
  }
  
  // Simple hit test for clicks
  boolean isClicked(float mx, float my) {
    return mx >= x && mx <= x + w && my >= y && my <= y + h;
  }
}