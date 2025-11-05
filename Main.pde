import processing.sound.*;

ArrayList<Note> notes = new ArrayList<Note>();
int score = 0;
boolean gameOver = false;
SoundFile music;
FFT fft;
float[] spectrum;
// Button-Eigenschaften
float buttonX, buttonY, buttonWidth = 200, buttonHeight = 50;
float beatThreshold = 0.007;
int lastBeatTime = 0;
int beatInterval = 800;
boolean debug = true;
float visualizationScale = 5000;

void setup() {
  size(800, 600);
  textSize(24);
  
  // Button Position berechnen
  buttonX = width/2 - buttonWidth/2;
  buttonY = height/2 + 50;
  
  // Spiel initialisieren
  initGame();
}

void draw() {
  background(255); // Hintergrund weiß machen
  
  // Musikanalyse durchführen
  fft.analyze(spectrum);
  
  // Beat erkennen und Note hinzufügen
  float sum = 0;
  for (int i = 0; i < spectrum.length; i++) {
    sum += spectrum[i];
  }
  float average = sum / spectrum.length;
  
  if (debug) {
    // Debug-Informationen anzeigen
    fill(0);
    text("Audio Level: " + nf(average, 0, 6), 20, 60);
    text("Threshold: " + nf(beatThreshold, 0, 6), 20, 90);
    // Visualisierung des Audio-Levels
    fill(255, 0, 0);
    rect(20, 100, average * visualizationScale, 10);
    fill(0, 255, 0);
    rect(20, 120, beatThreshold * visualizationScale, 10);
  }
  
  if (average > beatThreshold && millis() - lastBeatTime > beatInterval) {
    notes.add(new Note(random(width), -50));
    lastBeatTime = millis();
    if (debug) {
      println("Beat detected! Level: " + average);
    }
  }
  
  for (int i = notes.size() - 1; i >= 0; i--) {
    Note n = notes.get(i);
    n.update();
    n.display();

    if (n.y > height) {
      gameOver = true;
    }
  }

  fill(0);
  textAlign(LEFT);
  text("Score: " + score, 20, 30);

  if (gameOver) {
    // Game Over Text
    textAlign(CENTER);
    textSize(40);
    fill(255, 0, 0);
    text("Game Over!", width/2, height/2);
    
    // Retry Button
    drawRetryButton();
    
    // Spiel und Musik stoppen
    noLoop();
    if (music != null && music.isPlaying()) {
      music.stop();
    }
  }
}

void mousePressed() {
  if (gameOver) {
    // Prüfen ob der Retry Button geklickt wurde
    if (mouseX >= buttonX && mouseX <= buttonX + buttonWidth &&
        mouseY >= buttonY && mouseY <= buttonY + buttonHeight) {
      restartGame();
    }
  } else {
    // Normales Spielverhalten
    for (int i = notes.size() - 1; i >= 0; i--) {
      Note n = notes.get(i);
      if (n.isHit(mouseX, mouseY)) {
        score++;
        notes.remove(i);
        notes.add(new Note(random(width), -50));
      }
    }
  }
}

// Zeichnet den Retry Button
void drawRetryButton() {
  // Button Hintergrund
  fill(0, 255, 0);
  rect(buttonX, buttonY, buttonWidth, buttonHeight, 10);
  
  // Button Text
  fill(255);
  textSize(24);
  textAlign(CENTER, CENTER);
  text("Retry", buttonX + buttonWidth/2, buttonY + buttonHeight/2);
}

// Initialisiert das Spiel
void initGame() {
  try {
    // Neue Musik-Instanz erstellen
    music = new SoundFile(this, "Grand-Opening-PM-Music.wav");
    
    // Neue FFT-Instanz erstellen
    fft = new FFT(this, 512);
    spectrum = new float[512];
    
    // FFT mit Musik verbinden und Musik starten
    fft.input(music);
    music.play();
  } catch (Exception e) {
    println("Fehler beim Initialisieren der Musik: " + e.toString());
  }
}

// Stoppt die aktuelle Musik
void stopCurrentMusic() {
  try {
    if (music != null && music.isPlaying()) {
      music.stop();
    }
    // FFT und Musik-Referenzen löschen
    fft = null;
    music = null;
  } catch (Exception e) {
    println("Fehler beim Stoppen der Musik: " + e.toString());
  }
}

// Startet das Spiel neu
void restartGame() {
  // Alte Musik stoppen
  stopCurrentMusic();
  
  // Spiel-Variablen zurücksetzen
  notes.clear();
  score = 0;
  gameOver = false;
  lastBeatTime = 0;
  
  // Warten, um sicherzustellen, dass die alte Musik gestoppt ist
  delay(100);
  
  // Neues Spiel initialisieren
  initGame();
  
  // Animation wieder starten
  loop();
}
