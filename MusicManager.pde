class MusicManager {
  SoundFile music;
  FFT fft;
  float[] spectrum;
  static final int FFT_SIZE = 512;
  static final float BASE_BEAT_THRESHOLD = 0.000003;
  static final int BEAT_INTERVAL = 800;
  float volume = 0.5;
  int lastBeatTime = 0;

  MusicManager() {
    volume = settingsManager.volume;
    music = new SoundFile(Main.this, "gamemusic/Grand-Opening-PM-Music.wav");
    fft = new FFT(Main.this, FFT_SIZE);
    spectrum = new float[FFT_SIZE];
    fft.input(music);
    music.amp(volume * volume);
    music.loop();
    if (settingsManager.debugMode) {
      println("Musik gestartet mit Volumen: " + volume);
    }
  }

  void stopMusic() {
    if (music != null) music.stop();
  }

  void setVolume(float v) {
    volume = constrain(v, 0, 1);
    if (music != null) music.amp(volume * volume);
  }

  boolean detectBeat() {
    if (fft == null || spectrum == null) return false;
    if (music == null || !music.isPlaying()) {
      if (settingsManager.debugMode) {
        println("WARNUNG: Musik spielt nicht!");
      }
      return false;
    }
    fft.analyze(spectrum);
    float sum = 0;
    for (int i = 0; i < spectrum.length; i++) sum += spectrum[i];
    float avg = sum / spectrum.length;
    float dynamicThreshold = BASE_BEAT_THRESHOLD * (volume * volume);
    if (settingsManager.debugMode && frameCount % 120 == 0) {
      println("FFT avg: " + avg + " (Dynamic Threshold: " + dynamicThreshold + ", Volume: " + volume + ")");
    }
    if (avg > dynamicThreshold && millis() - lastBeatTime > BEAT_INTERVAL) {
      lastBeatTime = millis();
      return true;
    }
    return false;
  }
}