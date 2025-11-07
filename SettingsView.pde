
class SettingsView {
  boolean visible = false;
  Button btnDebug;
  Button btnBack;
  Slider volumeSlider;
  Toggle debugToggle;
  // Track Auswahl
  ArrayList<String> trackFiles = new ArrayList<String>();
  int trackScroll = 0; // zukünftiges Scrollen
  int maxVisible = 3; // genau 3 Einträge sichtbar, Rest via Scroll
  Button[] trackButtons;
  Button btnScrollUp;
  Button btnScrollDown;
  
  void setup() {
    btnDebug = new Button(width/2-100, height/2-80, 200, 50, "Debug: " + (settingsManager.debugMode ? "On" : "Off"));
    btnBack = new Button(width/2-100, height/2+100, 200, 50, "Back");
    
    // ControlP5 Volume Slider - Schöner gestylt
    volumeSlider = cp5.addSlider("volume")
      .setPosition(width/2-130, height/2+10)
      .setSize(260, 25)
      .setRange(0.0, 1.0)
      .setValue(settingsManager.volume)
      .setNumberOfTickMarks(11)
      .setSliderMode(Slider.FLEXIBLE)
      .setColorForeground(color(100, 150, 255))
      .setColorBackground(color(220, 230, 245))
      .setColorActive(color(50, 100, 220))
      .setColorLabel(color(40, 60, 120))
      .setColorValue(color(40, 60, 120))
      .hide();
    
    volumeSlider.getCaptionLabel().align(ControlP5.LEFT, ControlP5.TOP_OUTSIDE).setText("Volume");
    volumeSlider.getValueLabel().align(ControlP5.RIGHT, ControlP5.TOP_OUTSIDE);
    
    // ControlP5 Debug Toggle - Moderner Switch-Style
    debugToggle = cp5.addToggle("debugMode")
      .setPosition(width/2-130, height/2-65)
      .setSize(60, 25)
      .setValue(settingsManager.debugMode)
      .setMode(ControlP5.SWITCH)
      .setColorForeground(color(100, 150, 255))
      .setColorBackground(color(220, 230, 245))
      .setColorActive(color(50, 200, 100))
      .setColorLabel(color(40, 60, 120))
      .hide();
    
    debugToggle.getCaptionLabel().align(ControlP5.LEFT, ControlP5.CENTER).setPaddingX(70).setText("Debug Mode");

    loadTrackFiles();
    buildTrackButtons();
    // Scroll-Buttons für Trackliste
    int listX = width/2-220;
    int listY = int(height/2 + 80);
    btnScrollUp = new Button(listX + 450, listY, 30, 30, "▲");
    btnScrollDown = new Button(listX + 450, listY + maxVisible*42 - 30, 30, 30, "▼");
  }
  void display() {
    if (!visible) return;
    
    // Hintergrund - größer für mehr Platz
    noStroke();
    fill(50, 80, 120, 230);
    rect(width/2-300, height/2-260, 600, 520, 30);
    fill(255, 255, 255, 240);
    rect(width/2-290, height/2-250, 580, 500, 20);
    
    // Titel
    textAlign(CENTER);
  textSize(44);
    fill(40, 60, 120);
    text("⚙ Settings", width/2, height/2-95);
    
    // Trennlinie
    stroke(200, 210, 230);
    strokeWeight(2);
  line(width/2-220, height/2-70, width/2+220, height/2-70);
    noStroke();
    
    // Labels für bessere Orientierung
    textAlign(LEFT);
    textSize(18);
    fill(80, 100, 140);
  text("Audio", width/2-220, height/2-5);
  text("Display", width/2-220, height/2-80);

    // Track-Auswahl Titel
    fill(80, 100, 140);
  text("Track Auswahl", width/2-220, height/2+60);

    // Buttons für Tracks anzeigen
    int startY = int(height/2 + 80);
    int idx = 0;
    for (int i = trackScroll; i < trackFiles.size() && i < trackScroll + maxVisible; i++) {
      Button b = trackButtons[i];
      // Markierung falls ausgewählt
      if (settingsManager.selectedTrack != null && settingsManager.selectedTrack.equals(trackFiles.get(i))) {
        b.label = "▶ " + fileBase(trackFiles.get(i));
      } else {
        b.label = fileBase(trackFiles.get(i));
      }
      b.y = startY + idx * 42;
      b.display();
      idx++;
    }

    // Scroll Buttons zeichnen (deaktiviert aussehen, wenn nicht scrollbar)
    pushStyle();
    if (canScrollUp()) {
      btnScrollUp.label = "▲";
    } else {
      btnScrollUp.label = "·";
    }
    if (canScrollDown()) {
      btnScrollDown.label = "▼";
    } else {
      btnScrollDown.label = "·";
    }
    btnScrollUp.display();
    btnScrollDown.display();
    popStyle();
    
    // Back Button oben links positionieren
    btnBack.x = width/2 - 290 + 20; // Panel linke Innenkante + Padding
    btnBack.y = height/2 - 250 + 20; // Panel obere Innenkante + Padding

    // ControlP5 Elemente anzeigen
    if (visible) {
      volumeSlider.show();
      debugToggle.show();
    }
    
    // Back Button
  btnBack.label = "Back";
  btnBack.display();
  }
  void mousePressed() {
    if (!visible) return;
    
    // Update Settings basierend auf ControlP5 Werten
    settingsManager.setVolume(volumeSlider.getValue());
    settingsManager.debugMode = (debugToggle.getValue() == 1.0);
    if (settingsManager.debugMode && bg != null) {
      bg.showWeatherDebug = true;
    } else if (bg != null) {
      bg.showWeatherDebug = false;
    }
    
    // Back Button prüfen
    if (btnBack.isClicked(mouseX, mouseY)) {
      hide();
      return;
    }
    // Track Buttons Klick
    for (int i = trackScroll; i < trackFiles.size() && i < trackScroll + maxVisible; i++) {
      Button b = trackButtons[i];
      if (b.isClicked(mouseX, mouseY)) {
        settingsManager.setSelectedTrack(trackFiles.get(i));
        // Musik sofort wechseln falls im Spiel
        if (!menu.isInMenu && game.musicManager != null) {
          game.musicManager.stopMusic();
          game.musicManager = new MusicManager();
        }
        break;
      }
    }
    // Scroll Buttons Aktion
    if (btnScrollUp.isClicked(mouseX, mouseY)) {
      scrollUp();
    }
    if (btnScrollDown.isClicked(mouseX, mouseY)) {
      scrollDown();
    }
    if (settingsManager.debugMode && bg != null) {
      bg.mousePressed();
    }
  }
  
  void show() {
    visible = true;
    volumeSlider.show();
    debugToggle.show();
    // Liste aktualisieren bei Öffnen
    loadTrackFiles();
    buildTrackButtons();
    clampTrackScroll();
  }
  
  void hide() {
    visible = false;
    volumeSlider.hide();
    debugToggle.hide();
  }

  void loadTrackFiles() {
    trackFiles.clear();
    File dir = new File(sketchPath("data/gamemusic"));
    if (!dir.exists() || !dir.isDirectory()) return;
    String[] list = dir.list();
    if (list == null) return;
    for (String f : list) {
      String lower = f.toLowerCase();
      if (lower.endsWith(".wav") || lower.endsWith(".aiff") || lower.endsWith(".aif") || lower.endsWith(".mp3")) {
        trackFiles.add("gamemusic/" + f);
      }
    }
  }

  void buildTrackButtons() {
    trackButtons = new Button[ max(1, trackFiles.size()) ];
    int baseY = height/2 + 80;
    for (int i = 0; i < trackFiles.size(); i++) {
      trackButtons[i] = new Button(width/2-220, baseY + i*42, 440, 36, fileBase(trackFiles.get(i)));
    }
  }

  String fileBase(String path) {
    // Entferne Verzeichnis und Extension für Anzeige
    String name = path;
    int slash = name.lastIndexOf('/');
    if (slash >= 0) name = name.substring(slash+1);
    int dot = name.lastIndexOf('.');
    if (dot > 0) name = name.substring(0, dot);
    return name;
  }

  // Scroll-Logik
  void onMouseWheel(float amt) {
    if (!visible) return;
    if (amt > 0) scrollDown();
    else if (amt < 0) scrollUp();
  }
  void scrollUp() {
    trackScroll = max(0, trackScroll - 1);
  }
  void scrollDown() {
    int maxScroll = max(0, trackFiles.size() - maxVisible);
    trackScroll = min(maxScroll, trackScroll + 1);
  }
  boolean canScrollUp() {
    return trackScroll > 0;
  }
  boolean canScrollDown() {
    return trackScroll < max(0, trackFiles.size() - maxVisible);
  }
  void clampTrackScroll() {
    trackScroll = constrain(trackScroll, 0, max(0, trackFiles.size() - maxVisible));
  }
}
SettingsView settingsView = new SettingsView();
