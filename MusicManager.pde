class MusicManager {
  // SoundFile for playback and FFT for frequency analysis
  SoundFile music;
  FFT fft;
  float[] spectrum;

  // Beat detection tuning: lower threshold -> more beats detected
  float beatThreshold = 0.007;
  int lastBeatTime = 0;
  int beatInterval = 800; // ms between consecutive beats to debounce
  
  // Current volume (0..1). Kept here for future usage; the menu slider
  // was removed but the setter remains useful if you reintroduce controls.
  float volume = 1.0;

  // Default constructor: use current volume
  MusicManager() {
    initMusic(volume);
  }

  // Constructor with explicit starting volume
  MusicManager(float initialVolume) {
    this.volume = constrain(initialVolume, 0, 1);
    initMusic(this.volume);
  }

  // Initialize music playback and FFT. Defensive: exceptions are caught
  // and printed so the sketch doesn't crash when audio fails.
  void initMusic(float vol) {
    try {
      // Load the file from the gamemusic folder inside data/
      music = new SoundFile(Main.this, "gamemusic/Grand-Opening-PM-Music.wav");
      fft = new FFT(Main.this, 512);
      // keep a fixed-size spectrum buffer
      spectrum = new float[512];
      if (music == null) {
        println("MusicManager: SoundFile failed to create");
        return;
      }
      if (fft == null) {
        println("MusicManager: FFT failed to create");
        return;
      }
      // route the FFT input to the playing SoundFile
      fft.input(music);
      // apply perceptual volume curve (square) so changes are more audible
      float a = amplitudeFromVolume(vol);
      music.amp(a);
      music.play();
    } catch (Exception e) {
      // Log initialization errors but keep the sketch alive
      println("Fehler beim Initialisieren der Musik: " + e.toString());
      music = null;
      fft = null;
      spectrum = null;
    }
  }
  
  // Stop and release music resources safely
  void stopMusic() {
    if (music != null && music.isPlaying()) {
      try {
        music.stop();
      } catch (Exception e) {
        // ignore stop() errors
      }
    }
    // clear references so future restarts create fresh objects
    fft = null;
    music = null;
    spectrum = null;
  }

  // change volume while playing (0..1)
  void setVolume(float vol) {
    this.volume = constrain(vol, 0, 1);
    if (music != null) {
      float a = amplitudeFromVolume(this.volume);
      music.amp(a);
    }
  }

  // convert 0..1 slider to linear amplitude with perceptual curve
  float amplitudeFromVolume(float v) {
    // square the slider to give more control at low volumes
    return v * v;
  }
  
  // Analyze the spectrum and detect a beat. This uses a very simple
  // energy-average approach: compute the mean spectrum and compare to a
  // threshold. The function is defensive and returns false on any error.
  boolean detectBeat() {
    if (fft == null || spectrum == null) return false;
    try {
      fft.analyze(spectrum);
    } catch (Exception e) {
      // if analyze fails, skip detection
      return false;
    }
    float sum = 0;
    for (int i = 0; i < spectrum.length; i++) {
      sum += spectrum[i];
    }
    float average = sum / spectrum.length;
    
    // Debounce by time and compare against threshold
    if (average > beatThreshold && millis() - lastBeatTime > beatInterval) {
      lastBeatTime = millis();
      return true;
    }
    return false;
  }
}