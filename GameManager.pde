class GameManager {
  ArrayList<Note> notes;
  boolean gameOver;

  Button retryButton;
  Button menuButton;

  MusicManager musicManager;
  Player player;

  GameManager() {
    notes = new ArrayList<Note>();
    gameOver = false;
    retryButton = new Button(width/2 - 210, height/2 + 50, 200, 50, "Retry");
    menuButton = new Button(width/2 + 10, height/2 + 50, 200, 50, "Main Menu");
    player = new Player();
  }

  void update() {
    if (gameOver) return;

    // Beat -> neue Note
    if (musicManager != null && musicManager.detectBeat()) {
      spawnNoteAt(random(width), -50);
    }

    // Noten aktualisieren und auf Game Over prüfen
    updateNotes();
  }

  void display() {
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
      }
    }
  }

  void restart() {
    if (musicManager != null) musicManager.stopMusic();
    notes.clear();
    gameOver = false;
    delay(100);
    musicManager = new MusicManager();
    player.score = 0;
    loop();
  }

  void returnToMenu() {
    if (musicManager != null) musicManager.stopMusic();
    notes.clear();
    player.score = 0;
    gameOver = false;
    menu.isInMenu = true;
    loop();
  }

  void startGame() {
    if (musicManager == null) musicManager = new MusicManager();
    notes.clear();
    gameOver = false;
    player.score = 0;
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