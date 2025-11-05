class Button {
  float x, y, w, h;
  String label;
  Button(float x, float y, float w, float h, String label) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.label = label;
  }
  void display() {
    boolean over = (mouseX >= x && mouseX <= x + w && mouseY >= y && mouseY <= y + h);
    if (over && mousePressed) {
      fill(0, 120, 0);
    } else if (over) {
      fill(0, 200, 0);
    } else {
      fill(0, 160, 0);
    }
    rect(x, y, w, h, 10);
    fill(255);
    textSize(24);
    textAlign(CENTER, CENTER);
    text(label, x + w/2, y + h/2);
  }
  boolean isClicked(float mx, float my) {
    return mx >= x && mx <= x + w && my >= y && my <= y + h;
  }
}