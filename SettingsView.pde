
class SettingsView {
  boolean visible = false;
  Button btnDebug;
  Button btnBack;
  Slider volumeSlider;
  Toggle debugToggle;
  
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
  }
  void display() {
    if (!visible) return;
    
    // Hintergrund - größer für mehr Platz
    noStroke();
    fill(50, 80, 120, 230);
    rect(width/2-180, height/2-150, 360, 360, 30);
    fill(255, 255, 255, 240);
    rect(width/2-170, height/2-140, 340, 340, 20);
    
    // Titel
    textAlign(CENTER);
    textSize(40);
    fill(40, 60, 120);
    text("⚙ Settings", width/2, height/2-95);
    
    // Trennlinie
    stroke(200, 210, 230);
    strokeWeight(2);
    line(width/2-140, height/2-70, width/2+140, height/2-70);
    noStroke();
    
    // Labels für bessere Orientierung
    textAlign(LEFT);
    textSize(18);
    fill(80, 100, 140);
    text("Audio", width/2-140, height/2-5);
    text("Display", width/2-140, height/2-80);
    
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
    if (settingsManager.debugMode && bg != null) {
      bg.mousePressed();
    }
  }
  
  void show() {
    visible = true;
    volumeSlider.show();
    debugToggle.show();
  }
  
  void hide() {
    visible = false;
    volumeSlider.hide();
    debugToggle.hide();
  }
}
SettingsView settingsView = new SettingsView();
