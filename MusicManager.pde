class MusicManager {
  // Playback and simple FFT-based beat detection
  SoundFile music;
  FFT fft;
  float[] spectrum;

  // Settings
  static final int FFT_SIZE = 512;
  static final float BEAT_THRESHOLD = 0.007;
  static final int BEAT_INTERVAL = 800; // ms debounce between beats

  // State
  float volume = 0.1; // 0..1
  int lastBeatTime = 0;

  // Start music immediately
  MusicManager() {
    music = new SoundFile(Main.this, "gamemusic/Grand-Opening-PM-Music.wav");
    fft = new FFT(Main.this, FFT_SIZE);
    spectrum = new float[FFT_SIZE];

    fft.input(music);
    music.amp(volume * volume); // simple perceptual curve
    music.play();
  }

  // Stop playback
  void stopMusic() {
    if (music != null) music.stop();
  }

  // Adjust volume (0..1)
  void setVolume(float v) {
    volume = constrain(v, 0, 1);
    if (music != null) music.amp(volume * volume);
  }

  // Very simple beat detection using average spectrum energy
  boolean detectBeat() {
    if (fft == null || spectrum == null) return false;

    fft.analyze(spectrum);
    float sum = 0;
    for (int i = 0; i < spectrum.length; i++) sum += spectrum[i];
    float avg = sum / spectrum.length;

    if (avg > BEAT_THRESHOLD && millis() - lastBeatTime > BEAT_INTERVAL) {
      lastBeatTime = millis();
      return true;
    }
    return false;
  }
}