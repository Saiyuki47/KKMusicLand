class MenuManager {
  Button startButton;
  Button exitButton;
  Button settingsButton;
  Button modeRhythmBtn;
  Button modeDodgeBtn;
  boolean isInMenu = true;
  MusicManager menuMusic; // eigene Musikinstanz fürs Hauptmenü

  MenuManager() {
    float centerX = width/2 - 100;
    startButton = new Button(centerX, height/2 + 60, 200, 50, "Start Game");
    settingsButton = new Button(centerX, height/2 + 140, 200, 50, "Settings");
    exitButton = new Button(centerX, height/2 + 220, 200, 50, "Exit");
    
    // Mode Buttons
    float modeX = width/2 - 210;
    float modeY = height/2 - 40;
    modeRhythmBtn = new Button(modeX, modeY, 200, 50, "Rhythm Mode");
    modeDodgeBtn = new Button(modeX + 220, modeY, 200, 50, "Bird Dodge");

    // Lade Menü-Musik (Datei muss im data/gamemusic Ordner liegen)
    // Falls du eine andere Datei nutzen willst, einfach den Dateinamen austauschen.
    try {
      //"gamemusic/Grand-Opening-PM-Music.wav"
      menuMusic = new MusicManager();
      menuMusic.setVolume(settingsManager.volume);
    } catch (Exception e) {
      println("Fehler beim Laden der Menü-Musik: " + e.getMessage());
    }
  }

  void display() {
    // Halte Lautstärke synchron mit Einstellungen
    if (menuMusic != null) {
      menuMusic.setVolume(settingsManager.volume);
    }
    textAlign(CENTER);
    textSize(48);
    fill(0);
    text("KK Music Land", width/2, height/3);
    
    // Mode Selection Label
    textSize(24);
    text("Game Mode:", width/2, height/2 - 80);
    
    // Mode Buttons mit Markierung
    pushStyle();
    if (gameModeManager.getMode() == GameMode.RHYTHM) {
      modeRhythmBtn.label = "● Rhythm Mode";
    } else {
      modeRhythmBtn.label = "Rhythm Mode";
    }
    if (gameModeManager.getMode() == GameMode.BIRD_DODGE) {
      modeDodgeBtn.label = "● Bird Dodge";
    } else {
      modeDodgeBtn.label = "Bird Dodge";
    }
    modeRhythmBtn.display();
    modeDodgeBtn.display();
    popStyle();
    
    startButton.display();
    settingsButton.display();
    exitButton.display();
  }

  boolean mousePressed() {
    try {
      // Mode Selection
      if (modeRhythmBtn.isClicked(mouseX, mouseY)) {
        gameModeManager.setMode(GameMode.RHYTHM);
        return false;
      } else if (modeDodgeBtn.isClicked(mouseX, mouseY)) {
        gameModeManager.setMode(GameMode.BIRD_DODGE);
        return false;
      }
      
      if (startButton.isClicked(mouseX, mouseY)) {
        isInMenu = false;
        // Stoppe Menü-Musik bevor Spiel startet
        if (menuMusic != null) {
          menuMusic.stopMusic();
          menuMusic = null;
        }
        return true;
      } else if (settingsButton.isClicked(mouseX, mouseY)) {
        settingsView.show();
      } else if (exitButton.isClicked(mouseX, mouseY)) {
        exit();
      }
    } catch (Exception e) {
      println("MenuManager.mousePressed error: " + e);
      e.printStackTrace();
    }
    return false;
  }
}