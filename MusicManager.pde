class MusicManager {
  SoundFile music;
  FFT fft;
  float[] spectrum;
  static final int FFT_SIZE = 512;
  static final float BASE_BEAT_THRESHOLD = 0.000003;
  static final int BEAT_INTERVAL = 800;
  float volume = 0.5;
  int lastBeatTime = 0;

  // Standard-Konstruktor wählt zufällige Spielmusik aus dem gamemusic-Ordner
  // Unterstützte Formate: wav, aiff, aif, mp3
  MusicManager() {
    String randomFile = pickRandomMusicFile();
    if (randomFile == null) {
      // Fallback falls nichts gefunden
      randomFile = "gamemusic/Grand-Opening-PM-Music.wav";
      if (settingsManager.debugMode) println("Kein zufälliges Musikfile gefunden. Fallback genutzt.");
    }
    initWithFile(randomFile);
  }

  // Erweiterter Konstruktor erlaubt eigene Musikdatei (z.B. fürs Hauptmenü)
  MusicManager(String filename) {
    initWithFile(filename);
  }

  void initWithFile(String filename) {
    volume = settingsManager.volume;
    try {
      music = new SoundFile(Main.this, filename);
      fft = new FFT(Main.this, FFT_SIZE);
      spectrum = new float[FFT_SIZE];
      fft.input(music);
      music.amp(volume * volume);
      music.loop();
      if (settingsManager.debugMode) println("Musik gestartet (" + filename + ") mit Volumen: " + volume);
    } catch (Exception e) {
      println("Fehler beim Laden der Musikdatei: " + filename + " -> " + e.getMessage());
    }
  }

  String pickRandomMusicFile() {
    // Hole alle Dateien im data/gamemusic Verzeichnis
    // In Processing kann man mit sketchPath arbeiten
    File dir = new File(sketchPath("data/gamemusic"));
    if (!dir.exists() || !dir.isDirectory()) {
      if (settingsManager.debugMode) println("gamemusic Verzeichnis nicht gefunden.");
      return null;
    }
    String[] candidates = dir.list();
    if (candidates == null || candidates.length == 0) return null;
    // Filtere nur unterstützte Audioformate (wav/aiff/aif/mp3)
    ArrayList<String> audioFiles = new ArrayList<String>();
    for (String f : candidates) {
      String lower = f.toLowerCase();
      if (lower.endsWith(".wav") || lower.endsWith(".aiff") || lower.endsWith(".aif") || lower.endsWith(".mp3")) {
        audioFiles.add("gamemusic/" + f);
      }
    }
    if (audioFiles.size() == 0) return null;
    int idx = int(random(audioFiles.size()));
    return audioFiles.get(idx);
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