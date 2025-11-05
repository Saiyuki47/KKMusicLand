class GameManager {
  ArrayList<Note> notes;
  ArrayList<Bird> birds;
  ArrayList<Flower> flowers;
  boolean gameOver;

  Button retryButton;
  Button menuButton;

  MusicManager musicManager;
  Player player;
  
  int lastBirdScore;
  int lastFlowerScore;

  GameManager() {
    notes = new ArrayList<Note>();
    birds = new ArrayList<Bird>();
    flowers = new ArrayList<Flower>();
    gameOver = false;
    retryButton = new Button(width/2 - 210, height/2 + 50, 200, 50, "Retry");
    menuButton = new Button(width/2 + 10, height/2 + 50, 200, 50, "Main Menu");
    player = new Player();
    lastBirdScore = 0;
    lastFlowerScore = 0;
  }

  void update() {
    if (gameOver) return;

    // Beat -> neue Note
    if (musicManager != null && musicManager.detectBeat()) {
      spawnNoteAt(random(width), -50);
    }

    // Noten aktualisieren und auf Game Over prüfen
    updateNotes();
    
    // Visuelle Effekte basierend auf Score
    updateVisualEffects();
  }

  void display() {
    // Blumen zuerst (im Hintergrund)
    for (Flower flower : flowers) flower.display();
    
    // Vögel
    for (Bird bird : birds) bird.display();
    
    for (Note note : notes) note.display();
    player.display();
    drawHUD();
    if (gameOver) drawGameOverUI();
  }

  void mousePressed() {
    if (gameOver) {
      if (retryButton.isClicked(mouseX, mouseY)) restart();
      else if (menuButton.isClicked(mouseX, mouseY)) returnToMenu();
      return;
    }
    checkNoteHits();
  }

  // --- Helpers ---
  void spawnNoteAt(float x, float y) {
    notes.add(new Note(x, y));
  }

  void updateNotes() {
    for (int i = notes.size() - 1; i >= 0; i--) {
      Note n = notes.get(i);
      n.update();
      if (n.y > height) {
        handleGameOver();
        break;
      }
    }
  }

  void handleGameOver() {
    gameOver = true;
    if (musicManager != null) musicManager.stopMusic();
    noLoop();
  }

  void drawHUD() {
    fill(0);
    textAlign(LEFT);
    text("Score: " + player.score, 20, 30);
  }

  void drawGameOverUI() {
    textAlign(CENTER);
    textSize(40);
    fill(255, 0, 0);
    text("Game Over!", width/2, height/2);
    retryButton.display();
    menuButton.display();
  }

  void checkNoteHits() {
    for (int i = notes.size() - 1; i >= 0; i--) {
      Note n = notes.get(i);
      if (n.isHit(mouseX, mouseY)) {
        player.score++;
        notes.remove(i);
        spawnNoteAt(random(width), -50);
        checkForNewEffects();
      }
    }
  }
  
  void updateVisualEffects() {
    // Vögel aktualisieren
    for (int i = birds.size() - 1; i >= 0; i--) {
      Bird b = birds.get(i);
      b.update();
      if (b.isOffScreen()) {
        birds.remove(i);
      }
    }
    
    // Blumen aktualisieren
    for (Flower f : flowers) {
      f.update();
    }
  }
  
  void checkForNewEffects() {
    // Alle 5 Punkte: Vogel fliegt vorbei
    if (player.score > 0 && player.score % 5 == 0 && player.score != lastBirdScore) {
      spawnBird();
      lastBirdScore = player.score;
    }
    
    // Alle 3 Punkte: Blume wächst
    if (player.score > 0 && player.score % 3 == 0 && player.score != lastFlowerScore) {
      spawnFlower();
      lastFlowerScore = player.score;
    }
  }
  
  void spawnBird() {
    float yPos = random(50, height/2);
    birds.add(new Bird(yPos));
  }
  
  void spawnFlower() {
    // Blumen am unteren Rand
    float xPos = random(50, width - 50);
    flowers.add(new Flower(xPos, height - 20));
  }

  void restart() {
    if (musicManager != null) musicManager.stopMusic();
    notes.clear();
    birds.clear();
    flowers.clear();
    gameOver = false;
    lastBirdScore = 0;
    lastFlowerScore = 0;
    delay(100);
    musicManager = new MusicManager();
    player.score = 0;
    loop();
  }

  void returnToMenu() {
    if (musicManager != null) musicManager.stopMusic();
    notes.clear();
    birds.clear();
    flowers.clear();
    player.score = 0;
    gameOver = false;
    lastBirdScore = 0;
    lastFlowerScore = 0;
    menu.isInMenu = true;
    loop();
  }

  void startGame() {
    if (musicManager == null) musicManager = new MusicManager();
    notes.clear();
    birds.clear();
    flowers.clear();
    gameOver = false;
    player.score = 0;
    lastBirdScore = 0;
    lastFlowerScore = 0;
  }

  // Optional: behalte diese Methode, falls du später Space/Timing-Hits nutzen willst
  void playerHit() {
    if (notes.size() == 0) return;
    int bestIdx = -1;
    float bestY = -1;
    float thresholdY = height - 120;
    for (int i = 0; i < notes.size(); i++) {
      Note n = notes.get(i);
      if (n.y >= thresholdY && n.y > bestY) {
        bestY = n.y;
        bestIdx = i;
      }
    }
    if (bestIdx >= 0) {
      player.score++;
      notes.remove(bestIdx);
      spawnNoteAt(random(width), -50);
    }
  }
}