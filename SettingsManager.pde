
class SettingsManager {
  boolean debugMode = false;
  float volume = 0.5;
  String selectedTrack = null; // z.B. "gamemusic/datei.wav"
  void toggleDebug() {
    debugMode = !debugMode;
    if (bg != null) {
      bg.showWeatherDebug = debugMode;
    }
  }
  void setVolume(float v) {
    volume = constrain(v, 0.0, 1.0);
  }
  void setSelectedTrack(String path) {
    selectedTrack = path;
    if (debugMode) println("Ausgewählter Track: " + selectedTrack);
  }
}
SettingsManager settingsManager = new SettingsManager();
