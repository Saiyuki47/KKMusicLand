
class GameManager {
  ArrayList<Note> notes = new ArrayList<Note>();
  ArrayList<Bird> birds = new ArrayList<Bird>();
  ArrayList<Flower> flowers = new ArrayList<Flower>();
  ArrayList<Grave> graves = new ArrayList<Grave>();
  boolean gameOver = false;
  Button retryBtn = new Button(width/2 - 210, height/2 + 50, 200, 50, "Retry");
  Button menuBtn = new Button(width/2 + 10, height/2 + 50, 200, 50, "Main Menu");
  MusicManager musicManager;
  Player player = new Player();
  int lastBirdScore = 0;
  int lastFlowerScore = 0;
  
  // Miss-Effekte
  int missFlashTimer = 0;
  int consecutiveMisses = 0;
  float screenShake = 0;

  GameManager() {}

  void update() {
    if (gameOver) return;
    if (musicManager != null) musicManager.setVolume(settingsManager.volume);
    if (musicManager != null && musicManager.detectBeat()) spawnNoteAt(random(width), -50);
    updateNotes();
    updateVisuals();
    
    // Reduziere Effekt-Timer
    if (missFlashTimer > 0) missFlashTimer--;
    if (screenShake > 0) screenShake *= 0.85;
  }

  void display() {
    pushMatrix();
    
    // Screen Shake bei Miss
    if (screenShake > 0) {
      translate(random(-screenShake, screenShake), random(-screenShake, screenShake));
    }
    
  //display every flower, grave, bird, note
    for (Flower f : flowers) f.display();
  for (Grave g : graves) g.display();
    for (Bird b : birds) b.display();
    for (Note n : notes) n.display();
    player.display();
    
    popMatrix();
    
    drawHUD();
    
    // Roter Flash bei Miss
    if (missFlashTimer > 0) {
      noStroke();
      fill(255, 0, 0, map(missFlashTimer, 0, 30, 0, 100));
      rect(0, 0, width, height);
    }
    
    if (gameOver) drawGameOverUI();
  }

  void mousePressed() {
    if (gameOver) {
      if (retryBtn.isClicked(mouseX, mouseY)) restart();
      else if (menuBtn.isClicked(mouseX, mouseY)) returnToMenu();
      return;
    }
    checkNoteHits();
    checkBirdHits();
  }

  void spawnNoteAt(float x, float y) {
    notes.add(new Note(x, y));
  }

  void updateNotes() {
    for (int i = notes.size() - 1; i >= 0; i--) {
      Note n = notes.get(i);
      n.update();
      if (n.y > height) {
        noteMissed();
        notes.remove(i);
      }
    }
  }
  
  void noteMissed() {
    // Visuelle Effekte
    missFlashTimer = 30;
    screenShake = 8 + (consecutiveMisses * 2); // Stärkerer Shake bei mehreren Misses
    consecutiveMisses++;

    if(consecutiveMisses >= 5){
      gameOver();
      return;
    }

    // Entferne eine Blume wenn vorhanden
    if (flowers.size() > 0) {
      flowers.remove(flowers.size() - 1);
    }
    
    // Entferne auch Vögel bei vielen Misses
    if (consecutiveMisses > 2 && birds.size() > 0) {
      birds.remove(birds.size() - 1);
    }
    
    // Reduziere Score stärker bei Combo-Misses
    int scorePenalty = 1 + (consecutiveMisses / 3);
    player.score = max(0, player.score - scorePenalty);
    
    // Game Over wenn alle Blumen weg sind
    if (flowers.size() == 0) {
      gameOver();
    }
  }

  void gameOver() {
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
    retryBtn.display();
    menuBtn.display();
  }

  void checkNoteHits() {
    for (int i = notes.size() - 1; i >= 0; i--) {
      Note n = notes.get(i);
      if (n.isHit(mouseX, mouseY)) {
        player.score++;
        notes.remove(i);
        consecutiveMisses = 0; // Reset Miss-Combo
        checkEffects();
      }
    }
  }

  void updateVisuals() {
    for (int i = birds.size() - 1; i >= 0; i--) {
      Bird b = birds.get(i);
      b.update();
      // Entferne Vogel wenn außerhalb oder Blutung beendet, und setze Grab
      if (b.isOffScreen()) {
        birds.remove(i);
      } else if (b.isDone()) {
        graves.add(new Grave(b.x, b.y));
        birds.remove(i);
      }
    }
    for (Grave g : graves) g.update();
    for (Flower f : flowers) f.update();
  }

  void checkEffects() {
    if (player.score > 0 && player.score % 5 == 0 && player.score != lastBirdScore) {
      birds.add(new Bird(random(50, height/2)));
      lastBirdScore = player.score;
    }
    if (player.score > 0 && player.score % 3 == 0 && player.score != lastFlowerScore) {
      flowers.add(new Flower(random(50, width - 50), height - 20));
      lastFlowerScore = player.score;
    }
  }

  void checkBirdHits() {
    for (int i = birds.size() - 1; i >= 0; i--) {
      Bird b = birds.get(i);
      if (b.isClicked(mouseX, mouseY)) {
        b.explode();
        // Punkte für Klick auf Vogel (optional leicht höher)
        player.score += 2;
      }
    }
  }

  void restart() {
    if (musicManager != null) musicManager.stopMusic();
    notes.clear();
    birds.clear();
    flowers.clear();
    graves.clear();
    gameOver = false;
    lastBirdScore = 0;
    lastFlowerScore = 0;
    missFlashTimer = 0;
    consecutiveMisses = 0;
    screenShake = 0;
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
    graves.clear();
    player.score = 0;
    gameOver = false;
    lastBirdScore = 0;
    lastFlowerScore = 0;
    menu.isInMenu = true;
    // Spiele wieder die Menü-Musik
    if (menu != null) {
      try {
        if (menu.menuMusic != null) {
          menu.menuMusic.stopMusic();
          menu.menuMusic = null;
        }
        menu.menuMusic = new MusicManager("gamemusic/Grand-Opening-PM-Music.wav");
        menu.menuMusic.setVolume(settingsManager.volume);
      } catch (Exception e) {
        println("Fehler beim Starten der Menü-Musik: " + e.getMessage());
      }
    }
    loop();
  }

  void startGame() {
    // Stelle sicher, dass die Menü-Musik gestoppt ist
    if (menu != null && menu.menuMusic != null) {
      menu.menuMusic.stopMusic();
      menu.menuMusic = null;
    }
    if (musicManager == null) musicManager = new MusicManager();
    musicManager.setVolume(settingsManager.volume);
    notes.clear();
    birds.clear();
    flowers.clear();
    gameOver = false;
    player.score = 0;
    lastBirdScore = 0;
    lastFlowerScore = 0;
  }

}