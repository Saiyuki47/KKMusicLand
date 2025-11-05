class Note {
  // Musical note with different note types
  float x, y;   // position
  float speed;  // vertical speed
  int c;        // color
  int noteType; // 0=whole, 1=half, 2=quarter, 3=eighth

  Note(float x, float y) {
    this.x = x;
    this.y = y;
    // randomized falling speed for variety
    this.speed = random(2, 4);
    // vibrant random color
    this.c = color(random(100,255), random(100,255), random(100,255));
    // random note type
    this.noteType = int(random(4));
  }

  // Move the note downwards
  void update() {
    y += speed;
  }

  // Draw the note as a musical note
  void display() {
    fill(c);
    stroke(c);
    strokeWeight(2);
    
    pushMatrix();
    translate(x, y);
    
    // Draw note head (oval)
    if (noteType == 0) {
      // Whole note - hollow oval
      noFill();
      strokeWeight(3);
      ellipse(0, 0, 20, 15);
    } else if (noteType == 1) {
      // Half note - hollow oval with stem
      noFill();
      strokeWeight(3);
      ellipse(0, 0, 20, 15);
      fill(c);
      line(10, 0, 10, -30); // stem
    } else if (noteType == 2) {
      // Quarter note - filled oval with stem
      fill(c);
      ellipse(0, 0, 20, 15);
      line(10, 0, 10, -30); // stem
    } else if (noteType == 3) {
      // Eighth note - filled oval with stem and flag
      fill(c);
      ellipse(0, 0, 20, 15);
      line(10, 0, 10, -30); // stem
      // Flag
      noFill();
      strokeWeight(2);
      bezier(10, -30, 20, -25, 15, -20, 10, -15);
    }
    
    popMatrix();
    
    // Reset stroke
    strokeWeight(1);
  }

  // Simple hit test: returns true when the given point is close enough
  boolean isHit(float mx, float my) {
    return dist(mx, my, x, y) < 30;
  }
}
