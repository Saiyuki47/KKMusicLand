
class SettingsManager {
  boolean debugMode = false;
  float volume = 0.5;
  String selectedTrack = null; // z.B. "gamemusic/datei.wav"
  String settingsFile = "settings.txt";
  int difficulty = 1; // 0=Leicht, 1=Mittel, 2=Schwer
  
  SettingsManager() {
    loadSettings();
  }
  
  void toggleDebug() {
    debugMode = !debugMode;
    if (bg != null) {
      bg.showWeatherDebug = debugMode;
    }
    saveSettings();
  }
  
  void setVolume(float v) {
    volume = constrain(v, 0.0, 1.0);
    saveSettings();
  }
  
  void setSelectedTrack(String path) {
    selectedTrack = path;
    if (debugMode) println("Ausgewählter Track: " + selectedTrack);
  }
  
  void setDifficulty(int d) {
    difficulty = constrain(d, 0, 2);
    saveSettings();
    if (debugMode) println("Schwierigkeitsgrad gesetzt: " + difficulty);
  }
  
  float getNoteSpeed() {
    // Leicht: 1.0-1.8, Mittel: 1.5-2.5, Schwer: 2.5-4.0
    switch(difficulty) {
      case 0: return random(1.0, 1.8);
      case 1: return random(1.5, 2.5);
      case 2: return random(2.5, 4.0);
      default: return random(1.5, 2.5);
    }
  }
  
  void saveSettings() {
    String[] lines = new String[3];
    lines[0] = "volume=" + volume;
    lines[1] = "debugMode=" + debugMode;
    lines[2] = "difficulty=" + difficulty;
    saveStrings(settingsFile, lines);
    if (debugMode) println("Einstellungen gespeichert: Volume=" + volume + ", DebugMode=" + debugMode + ", Difficulty=" + difficulty);
  }
  
  void loadSettings() {
    File f = new File(sketchPath(settingsFile));
    if (!f.exists()) {
      if (debugMode) println("Keine gespeicherten Einstellungen gefunden, nutze Standardwerte.");
      return;
    }
    String[] lines = loadStrings(settingsFile);
    if (lines == null || lines.length == 0) return;
    for (String line : lines) {
      if (line.startsWith("volume=")) {
        try {
          volume = Float.parseFloat(line.substring(7));
          volume = constrain(volume, 0.0, 1.0);
          if (debugMode) println("Lautstärke geladen: " + volume);
        } catch (Exception e) {
          println("Fehler beim Laden der Lautstärke: " + e.getMessage());
        }
      } else if (line.startsWith("debugMode=")) {
        try {
          debugMode = Boolean.parseBoolean(line.substring(10));
          if (debugMode) println("Debug-Modus geladen: " + debugMode);
        } catch (Exception e) {
          println("Fehler beim Laden des Debug-Modus: " + e.getMessage());
        }
      } else if (line.startsWith("difficulty=")) {
        try {
          difficulty = Integer.parseInt(line.substring(11));
          difficulty = constrain(difficulty, 0, 2);
          if (debugMode) println("Schwierigkeitsgrad geladen: " + difficulty);
        } catch (Exception e) {
          println("Fehler beim Laden des Schwierigkeitsgrads: " + e.getMessage());
        }
      }
    }
  }
}
SettingsManager settingsManager = new SettingsManager();
