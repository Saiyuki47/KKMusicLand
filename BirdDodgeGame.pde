
class BirdDodgeGame {
  ArrayList<Bird> birds = new ArrayList<Bird>();
  boolean gameOver = false;
  boolean enteringName = false;
  String playerName = "";
  int score = 0;
  int survivalTime = 0;
  int lastSpawnTime = 0;
  int spawnInterval = 400; // Millisekunden zwischen Bird-Spawns - REDUZIERT für mehr Vögel
  Button retryBtn = new Button(width/2 - 210, height/2 + 150, 200, 50, "Retry");
  Button menuBtn = new Button(width/2 + 10, height/2 + 150, 200, 50, "Main Menu");
  Button submitNameBtn = new Button(width/2 - 100, height/2 + 140, 200, 50, "Submit");
  MusicManager musicManager;
  Player player = new Player();
  int lastScoreUpdate = 0;
  
  BirdDodgeGame() {}
  
  void update() {
    if (gameOver) return;
    
    if (musicManager != null) musicManager.setVolume(settingsManager.volume);
    
    // Score erhöhen basierend auf Überlebenszeit (1 Punkt pro Sekunde)
    if (millis() - lastScoreUpdate > 1000) {
      score++;
      survivalTime++;
      lastScoreUpdate = millis();
      
      // Erhöhe Schwierigkeit mit der Zeit
      if (survivalTime % 10 == 0) {
        spawnInterval = max(200, spawnInterval - 50);
      }
    }
    
    // Spawn neue Vögel - manchmal mehrere gleichzeitig
    if (millis() - lastSpawnTime > spawnInterval) {
      int numBirds = int(random(1, 4)); // 1-3 Vögel gleichzeitig
      for (int i = 0; i < numBirds; i++) {
        spawnBird();
      }
      lastSpawnTime = millis();
    }
    
    // Update Vögel - keine Homing-Logik mehr!
    for (int i = birds.size() - 1; i >= 0; i--) {
      Bird b = birds.get(i);
      b.update();
      
      // Entferne Vögel die außerhalb sind
      if (b.isOffScreen()) {
        birds.remove(i);
      } 
      // Prüfe Kollision mit Maus
      else if (!b.exploding && !b.falling && dist(mouseX, mouseY, b.x, b.y) < 30) {
        triggerGameOver();
      }
    }
  }
  
  void display() {
    // Vögel zeichnen
    for (Bird b : birds) b.display();
    
    // Cursor/Player
    player.display();
    
    // HUD
    drawHUD();
    
    if (gameOver) drawGameOverUI();
  }
  
  void spawnBird() {
    float y = random(50, height - 50);
    // Verwende den neuen Konstruktor mit aktueller Mausposition als Ziel
    Bird b = new Bird(y, mouseX, mouseY);
    // 20% Chance auf schnellen Vogel (doppelte Geschwindigkeit)
    if (random(1) < 0.2) {
      b.speedX *= 2.0;
      b.speedY *= 2.0;
      // Visueller Hinweis: wärmere Farbe
      b.c = color(255, 120, 80);
    }
    birds.add(b);
  }
  
  void drawHUD() {
    fill(0);
    textAlign(LEFT);
    textSize(24);
    text("Score: " + score, 20, 40);
    text("Time: " + survivalTime + "s", 20, 70);
    
    textAlign(RIGHT);
    text("Mode: Bird Dodge", width - 20, 40);
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
      text("Your Score: " + score + " (" + survivalTime + "s)", width/2, height/2 - 80);
      
      textSize(28);
      text("Enter your name:", width/2, height/2 - 20);
      
      // Name Eingabefeld
      noStroke();
      fill(255, 255, 255);
      rect(width/2 - 180, height/2 + 20, 360, 60, 5);
      
      // Rahmen
      noFill();
      stroke(100, 150, 255);
      strokeWeight(3);
      rect(width/2 - 180, height/2 + 20, 360, 60, 5);
      
      // Name Text
      noStroke();
      fill(0);
      textSize(32);
      textAlign(CENTER, CENTER);
      String displayText = playerName;
      if (displayText.length() == 0) displayText = ""; 
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
      text("Score: " + score, width/2, height/2 + 10);
      text("Survived: " + survivalTime + " seconds", width/2, height/2 + 50);
      
      retryBtn.display();
      menuBtn.display();
    }
  }
  
  void mousePressed() {
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
  }
  
  void restart() {
    if (musicManager != null) musicManager.stopMusic();
    birds.clear();
    gameOver = false;
    enteringName = false;
    score = 0;
    survivalTime = 0;
    lastSpawnTime = millis();
    lastScoreUpdate = millis();
    spawnInterval = 400; // Reset auf Startwert
    delay(100);
    musicManager = new MusicManager();
    loop();
  }
  
  void returnToMenu() {
    if (musicManager != null) musicManager.stopMusic();
    birds.clear();
    score = 0;
    survivalTime = 0;
    gameOver = false;
    enteringName = false;
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
    birds.clear();
    gameOver = false;
    enteringName = false;
    score = 0;
    survivalTime = 0;
    lastSpawnTime = millis();
    lastScoreUpdate = millis();
    spawnInterval = 400; // Reset auf Startwert
  }
  
  void triggerGameOver() {
    gameOver = true;
    if (musicManager != null) musicManager.stopMusic();
    
    // Prüfe ob es ein Highscore ist (für Bird Dodge Modus)
    if (isHighscore(score)) {
      enteringName = true;
      playerName = "";
      loop();
    } else {
      enteringName = false;
      noLoop();
    }
  }
  
  boolean isHighscore(int score) {
    ArrayList<HighscoreEntry> scores = loadHighscores();
    if (scores.size() < 10) return true;
    for (HighscoreEntry entry : scores) {
      if (score > entry.score) return true;
    }
    return false;
  }
  
  void submitHighscore() {
    if (playerName.trim().length() == 0) return;
    
    ArrayList<HighscoreEntry> scores = loadHighscores();
    scores.add(new HighscoreEntry(playerName.trim(), score));
    
    scores.sort((a, b) -> b.score - a.score);
    
    if (scores.size() > 10) {
      scores = new ArrayList<HighscoreEntry>(scores.subList(0, 10));
    }
    
    saveHighscores(scores);
    enteringName = false;
    returnToMenu();
  }
  
  ArrayList<HighscoreEntry> loadHighscores() {
    ArrayList<HighscoreEntry> scores = new ArrayList<HighscoreEntry>();
    File file = new File(sketchPath("highscores_birddodge.txt"));
    if (!file.exists()) return scores;
    
    String[] lines = loadStrings("highscores_birddodge.txt");
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
    saveStrings(sketchPath("highscores_birddodge.txt"), lines);
  }
}
