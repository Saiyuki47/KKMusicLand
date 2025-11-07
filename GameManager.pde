
class GameManager {
  ArrayList<Note> notes = new ArrayList<Note>();
  ArrayList<Bird> birds = new ArrayList<Bird>();
  ArrayList<Flower> flowers = new ArrayList<Flower>();
  ArrayList<Grave> graves = new ArrayList<Grave>();
  boolean gameOver = false;
  boolean paused = false;
  boolean enteringName = false;
  String playerName = "";
  Button retryBtn = new Button(width/2 - 210, height/2 + 150, 200, 50, "Retry");
  Button menuBtn = new Button(width/2 + 10, height/2 + 150, 200, 50, "Main Menu");
  Button resumeBtn = new Button(width/2 - 100, height/2 - 20, 200, 50, "Resume");
  Button pauseMenuBtn = new Button(width/2 - 100, height/2 + 50, 200, 50, "Main Menu");
  Button submitNameBtn = new Button(width/2 - 100, height/2 + 140, 200, 50, "Submit");
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
    if (gameOver || paused) return;
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
    
    if (paused) drawPauseUI();
    if (gameOver) drawGameOverUI();
  }

  void mousePressed() {
    if (paused) {
      if (resumeBtn.isClicked(mouseX, mouseY)) togglePause();
      else if (pauseMenuBtn.isClicked(mouseX, mouseY)) returnToMenu();
      return;
    }
    if (gameOver) {
      if (enteringName) {
        if (submitNameBtn.isClicked(mouseX, mouseY)) {
          submitHighscore();
        }
      } else {
        if (retryBtn.isClicked(mouseX, mouseY)) restart();
        else if (menuBtn.isClicked(mouseX, mouseY)) returnToMenu();
      }
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
    if (musicManager != null) musicManager.stopMusic();
    triggerGameOver();
  }

  void drawHUD() {
    fill(0);
    textAlign(LEFT);
    text("Score: " + player.score, 20, 30);
  }

  void drawGameOverUI() {
    if (enteringName) {
      // Halbtransparenter Hintergrund
      noStroke();
      fill(0, 0, 0, 200);
      rect(0, 0, width, height);
      
      // Name eingeben mit mehr Abstand
      textAlign(CENTER);
      textSize(56);
      fill(255, 200, 0);
      text("New Highscore!", width/2, height/2 - 140);
      
      textSize(36);
      fill(255);
      text("Your Score: " + player.score, width/2, height/2 - 80);
      
      textSize(28);
      text("Enter your name:", width/2, height/2 - 20);
      
      // Name Eingabefeld - heller Hintergrund, größer und tiefer
      noStroke();
      fill(255, 255, 255);
      rect(width/2 - 180, height/2 + 20, 360, 60, 5);
      
      // Rahmen um das Feld
      noFill();
      stroke(100, 150, 255);
      strokeWeight(3);
      rect(width/2 - 180, height/2 + 20, 360, 60, 5);
      
      // Name Text - schwarz statt rot
      noStroke();
      fill(0);
      textSize(32);
      textAlign(CENTER, CENTER);
      String displayText = playerName;
      if (displayText.length() == 0) displayText = ""; 
      // Zeichne direkt in der Mitte des weißen Rechtecks
      text(displayText + "_", width/2, height/2 + 50);
      
      textAlign(CENTER);
      submitNameBtn.display();
    } else {
      // Normaler Game Over Screen
      textAlign(CENTER);
      textSize(40);
      fill(255, 0, 0);
      text("Game Over!", width/2, height/2 - 50);
      
      textSize(32);
      fill(255);
      text("Score: " + player.score, width/2, height/2 + 10);
      
      retryBtn.display();
      menuBtn.display();
    }
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
        menu.menuMusic = new MusicManager();
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
    paused = false;
    player.score = 0;
    lastBirdScore = 0;
    lastFlowerScore = 0;
  }
  
  void togglePause() {
    paused = !paused;
    if (musicManager != null && musicManager.music != null) {
      if (paused) {
        musicManager.music.pause();
      } else {
        musicManager.music.play();
      }
    }
  }
  
  void drawPauseUI() {
    // Halbtransparenter Overlay
    noStroke();
    fill(0, 0, 0, 180);
    rect(0, 0, width, height);
    
    // Pause Text
    textAlign(CENTER, CENTER);
    textSize(72);
    fill(255);
    text("PAUSED", width/2, height/2 - 100);
    
    // Buttons
    resumeBtn.display();
    pauseMenuBtn.display();
  }
  
  void triggerGameOver() {
    gameOver = true;
    // Prüfe ob es ein Highscore ist
    if (isHighscore(player.score)) {
      enteringName = true;
      playerName = "";
      loop(); // Draw loop weiterlaufen lassen für Name-Eingabe
    } else {
      enteringName = false;
      noLoop();
    }
  }
  
  boolean isHighscore(int score) {
    ArrayList<HighscoreEntry> scores = loadHighscores();
    if (scores.size() < 10) return true; // Top 10, weniger als 10 Einträge
    // Prüfe ob Score höher ist als der niedrigste
    for (HighscoreEntry entry : scores) {
      if (score > entry.score) return true;
    }
    return false;
  }
  
  void submitHighscore() {
    if (playerName.trim().length() == 0) return; // Leere Namen nicht erlaubt
    
    ArrayList<HighscoreEntry> scores = loadHighscores();
    scores.add(new HighscoreEntry(playerName.trim(), player.score));
    
    // Sortiere nach Score absteigend
    scores.sort((a, b) -> b.score - a.score);
    
    // Behalte nur Top 10
    if (scores.size() > 10) {
      scores = new ArrayList<HighscoreEntry>(scores.subList(0, 10));
    }
    
    saveHighscores(scores);
    enteringName = false;
    
    // Zurück ins Hauptmenü
    returnToMenu();
  }
  
  ArrayList<HighscoreEntry> loadHighscores() {
    ArrayList<HighscoreEntry> scores = new ArrayList<HighscoreEntry>();
    File file = new File(sketchPath("highscores.txt"));
    if (!file.exists()) return scores;
    
    String[] lines = loadStrings("highscores.txt");
    if (lines != null) {
      for (String line : lines) {
        String[] parts = line.split("\\|");
        if (parts.length == 2) {
          try {
            String name = parts[0];
            int score = Integer.parseInt(parts[1]);
            scores.add(new HighscoreEntry(name, score));
          } catch (Exception e) {
            println("Fehler beim Laden einer Highscore-Zeile: " + line);
          }
        }
      }
    }
    return scores;
  }
  
  void saveHighscores(ArrayList<HighscoreEntry> scores) {
    String[] lines = new String[scores.size()];
    for (int i = 0; i < scores.size(); i++) {
      HighscoreEntry entry = scores.get(i);
      lines[i] = entry.name + "|" + entry.score;
    }
    saveStrings(sketchPath("highscores.txt"), lines);
  }

}

class HighscoreEntry {
  String name;
  int score;
  
  HighscoreEntry(String name, int score) {
    this.name = name;
    this.score = score;
  }
}