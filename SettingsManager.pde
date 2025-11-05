
class SettingsManager {
  boolean debugMode = false;
  float volume = 0.5;
  void toggleDebug() {
    debugMode = !debugMode;
    if (bg != null) {
      bg.showWeatherDebug = debugMode;
    }
  }
  void setVolume(float v) {
    volume = constrain(v, 0.0, 1.0);
  }
}
SettingsManager settingsManager = new SettingsManager();
