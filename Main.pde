PFont font;
ArrayList<Note> notes = new ArrayList<Note>();
int score = 0;
boolean gameOver = false;
boolean isDay = true;

void setup() {
  size(800, 600);
  font = createFont("Arial", 24);
  textFont(font);
  
  for (int i = 0; i < 5; i++) {
    notes.add(new Note(random(width), random(-400, -50)));
  }
}

void draw() {
  drawBackground();
  
  // Wechsel zwischen Tag und Nacht alle 10 Sekunden
  if (frameCount % (60 * 10) == 0) {
    isDay = !isDay;
  }

  // K.K.-Figur (vereinfacht)
  drawKK(100, height - 180);

  for (int i = notes.size() - 1; i >= 0; i--) {
    Note n = notes.get(i);
    n.update();
    n.display();

    if (n.y > height) {
      gameOver = true;
    }
  }

  fill(0);
  textAlign(LEFT);
  text("Score: " + score, 20, 30);

  if (gameOver) {
    textAlign(CENTER);
    textSize(40);
    fill(255, 0, 0);
    text("Game Over!", width/2, height/2);
    noLoop();
  }
}

void mousePressed() {
  for (int i = notes.size() - 1; i >= 0; i--) {
    Note n = notes.get(i);
    if (n.isHit(mouseX, mouseY)) {
      score++;
      notes.remove(i);
      notes.add(new Note(random(width), random(-400, -50)));
    }
  }
}

void drawBackground() {
  if (isDay) {
    background(135, 206, 250); // Himmel blau
    drawSun();
  } else {
    background(20, 24, 60); // Nachthimmel
    drawStars();
    drawMoon();
  }
  
  drawClouds();
  drawGrass();
  drawFlowers();
  drawTrees();
}

void drawSun() {
  fill(255, 204, 0);
  noStroke();
  ellipse(700, 100, 100, 100);
}

void drawMoon() {
  fill(240, 240, 200);
  noStroke();
  ellipse(700, 100, 80, 80);
}

void drawStars() {
  fill(255, 255, 200);
  noStroke();
  for (int i = 0; i < 50; i++) {
    ellipse(random(width), random(200), random(1, 3), random(1, 3));
  }
}


void drawClouds() {
  fill(255);
  noStroke();
  ellipse(200, 100, 120, 60);
  ellipse(250, 100, 100, 50);
  ellipse(150, 100, 90, 50);
}

void drawGrass() {
  fill(60, 180, 75);
  rect(0, height - 150, width, 150);
}

void drawFlowers() {
  for (int i = 0; i < 6; i++) {
    float x = 150 + i * 100;
    float y = height - 50;
    drawFlower(x, y);
  }
}

void drawFlower(float x, float y) {
  stroke(0);
  strokeWeight(2);
  line(x, y, x, y - 40);
  fill(random(200, 255), random(100, 255), random(100, 255));
  noStroke();
  ellipse(x - 10, y - 45, 15, 15);
  ellipse(x + 10, y - 45, 15, 15);
  ellipse(x, y - 55, 15, 15);
  fill(255, 255, 0);
  ellipse(x, y - 45, 10, 10);
}

void drawTrees() {
  drawTree(600, height - 150);
  drawTree(700, height - 150);
}

void drawTree(float x, float y) {
  fill(101, 67, 33);
  rect(x, y - 80, 20, 80);
  fill(34, 139, 34);
  ellipse(x + 10, y - 100, 80, 80);
}

// 🐶 K.K. einfach gezeichnet
void drawKK(float x, float y) {
  // Körper
  fill(255);
  ellipse(x, y, 60, 80);
  
  // Kopf
  ellipse(x, y - 60, 70, 70);
  
  // Augen
  fill(0);
  ellipse(x - 15, y - 65, 10, 15);
  ellipse(x + 15, y - 65, 10, 15);
  
  // Gitarre (einfach)
  fill(150, 100, 50);
  ellipse(x + 40, y - 20, 60, 40);
  rect(x + 60, y - 25, 40, 10);
}
