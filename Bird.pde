class Bird {
  float x, y;
  float speed;
  float speedX, speedY; // Für Bird Dodge Modus
  int c;
  float wingAngle;
  // Klick-/Explosions-Logik
  float hitRadius = 18;
  boolean exploding = false;
  int explodeTimer = 0; // Dauer der Explosion in Frames
  float explosionR = 0;
  float explosionMaxR = 60;
  float explosionAlpha = 220;
  // Fallen/Bluten-Logik
  boolean falling = false;
  boolean onGround = false;
  boolean bleedingComplete = false;
  float vy = 0;
  float ay = 0.7; // Schwerkraft
  float rot = 0; // Rotation während des Fallens/Aufpralls
  float rotSpeed = 0.15;
  float bloodRadius = 0;
  float bloodMaxRadius = 40;
  float bloodAlpha = 180;
  int bleedTimer = 0;
  Bird(float y) {
    this.x = -50;
    this.y = y;
    this.speed = random(3, 6);
    this.speedX = this.speed; // Initialize speedX
    this.speedY = 0; // Initialize speedY
    this.wingAngle = 0;
    this.c = color(random(50, 150), random(50, 100), random(20, 80));
  }
  
  // Konstruktor mit Zielposition für Bird Dodge Modus
  Bird(float y, float targetX, float targetY) {
    this.x = -50;
    this.y = y;
    this.speed = random(3, 6);
    this.wingAngle = 0;
    this.c = color(random(50, 150), random(50, 100), random(20, 80));
    
    // Berechne Richtung zur Zielposition
    float dx = targetX - this.x;
    float dy = targetY - this.y;
    float angle = atan2(dy, dx);
    
    // Setze Geschwindigkeit in Richtung Ziel
    this.speedX = cos(angle) * this.speed;
    this.speedY = sin(angle) * this.speed;
  }
  void update() {
    if (exploding) {
      // Explosion wächst und fadet
      explosionR = min(explosionR + 6, explosionMaxR);
      explosionAlpha *= 0.88;
      explodeTimer--;
      if (explodeTimer <= 0) {
        startFall();
      }
    } else {
      if (falling) {
        vy += ay;
        y += vy;
        x += speed * 0.3; // leichter seitlicher Drift
        rot += rotSpeed;
        float groundY = height - 20; // Bodenhöhe an Flowers angepasst
        if (y >= groundY) {
          y = groundY;
          falling = false;
          onGround = true;
          // Start Bluten
          bleedTimer = 90; // ~1.5s bei 60 FPS
          bloodRadius = 8;
          bloodAlpha = 180;
          // Beim Aufprall leichte Rotation fixieren
          rot = PI * 0.5; // auf der Seite liegend
        }
      } else if (onGround) {
        if (bleedTimer > 0) {
          bleedTimer--;
          bloodRadius = min(bloodMaxRadius, bloodRadius + 0.8);
          bloodAlpha = max(80, bloodAlpha - 0.8);
        } else {
          bleedingComplete = true;
        }
      } else {
        // normaler Flug - verwende speedX und speedY für Bird Dodge Modus
        x += speedX;
        y += speedY;
        wingAngle += 0.2;
      }
    }
  }
  void display() {
    pushMatrix();
    translate(x, y);
    noStroke();
    if (exploding) {
      // einfacher Explosionseffekt: expandierender Kreis + Splitter
      fill(255, 120, 0, explosionAlpha);
      ellipse(0, 0, explosionR, explosionR);
      fill(255, 200, 80, max(0, explosionAlpha - 40));
      ellipse(0, 0, explosionR * 0.6, explosionR * 0.6);
      // Splitter in vier Richtungen
      fill(red(c), green(c), blue(c), max(0, explosionAlpha - 60));
      rectMode(CENTER);
      pushMatrix(); translate(explosionR*0.35, 0); rotate(0.2); rect(0, 0, 8, 3); popMatrix();
      pushMatrix(); translate(-explosionR*0.35, 0); rotate(-0.2); rect(0, 0, 8, 3); popMatrix();
      pushMatrix(); translate(0, explosionR*0.35); rotate(0.6); rect(0, 0, 8, 3); popMatrix();
      pushMatrix(); translate(0, -explosionR*0.35); rotate(-0.6); rect(0, 0, 8, 3); popMatrix();
      rectMode(CORNER);
    } else if (falling || onGround) {
      // Blutlache unter dem Vogel
      if (onGround || bleedTimer > 0) {
        pushMatrix();
        // Zeichne Lache unter dem Vogel; leichte Ellipse
        fill(180, 0, 0, bloodAlpha);
        ellipse(0, 6, bloodRadius * 1.5, bloodRadius);
        popMatrix();
      }
      // Vogel-Kadaver (rotiert)
      pushMatrix();
      rotate(rot);
      fill(c);
      ellipse(0, 0, 30, 20);
      ellipse(15, -5, 15, 15);
      fill(255, 80, 0);
      triangle(22, -5, 28, -3, 22, -1);
      // Flügel schlaff nach unten
      fill(c);
      pushMatrix();
      rotate(-0.6);
      ellipse(-8, 0, 20, 10);
      popMatrix();
      popMatrix();
    } else {
      // normaler Vogel (Flug)
      fill(c);
      ellipse(0, 0, 30, 20);
      ellipse(15, -5, 15, 15);
      fill(255, 150, 0);
      triangle(22, -5, 28, -3, 22, -1);
      fill(c);
      pushMatrix();
      rotate(sin(wingAngle) * 0.3);
      ellipse(-8, 0, 20, 10);
      popMatrix();
    }
    popMatrix();
  }
  boolean isOffScreen() {
    return x > width + 50;
  }
  boolean isClicked(float mx, float my) {
    if (exploding) return false;
    // Distanz zum Mittelpunkt des Vogels prüfen
    return dist(mx, my, x, y) <= hitRadius;
  }
  void explode() {
    if (exploding) return;
    exploding = true;
    explodeTimer = 20; // ~1/3 Sekunde bei 60 FPS
    speed = 0;
    explosionR = 10;
    explosionAlpha = 220;
  }
  void startFall() {
    exploding = false;
    falling = true;
    vy = 2;
    rotSpeed = random(0.08, 0.2);
  }
  boolean isDone() {
    return onGround && bleedingComplete;
  }
}
