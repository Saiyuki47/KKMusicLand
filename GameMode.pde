// Enum für Spielmodi
static class GameMode {
  static final int RHYTHM = 0;
  static final int BIRD_DODGE = 1;
  
  static String getName(int mode) {
    switch(mode) {
      case RHYTHM: return "Rhythm Mode";
      case BIRD_DODGE: return "Bird Dodge";
      default: return "Unknown";
    }
  }
}

class GameModeManager {
  int currentMode = GameMode.RHYTHM;
  
  void setMode(int mode) {
    currentMode = mode;
  }
  
  int getMode() {
    return currentMode;
  }
  
  String getCurrentModeName() {
    return GameMode.getName(currentMode);
  }
}

GameModeManager gameModeManager = new GameModeManager();
