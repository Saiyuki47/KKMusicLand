class Background {
  // Konstanten
  static final float HORIZON_RATIO = 0.7;
  static final int NUM_CLOUDS = 5;
  static final int NUM_TREES = 5;
  
  color skyColor, grassColor;
  float horizonHeight;
  WeatherManager weather;
  boolean showWeatherDebug = false;
  boolean manualWeather = false;
  Button[] weatherButtons;
  String[] buttonLabels = {"Live", "Sunny", "Cloudy", "Rain", "Snow", "Fog", "Storm"};
  
  Background() {
    skyColor = color(135, 206, 235);
    grassColor = color(34, 139, 34);
    horizonHeight = height * HORIZON_RATIO;
    weather = new WeatherManager();
    initButtons();
  }
  
  void initButtons() {
    weatherButtons = new Button[7];
    float bx = 10, by = 10, bw = 120, bh = 32, gap = 8;
    for (int i = 0; i < weatherButtons.length; i++) {
      weatherButtons[i] = new Button(bx, by + i*(bh+gap), bw, bh, buttonLabels[i]);
    }
  }
  
  void display() {
    drawSky();
    drawGrass();
    drawTrees();
    drawMusicianDog();
    drawWeatherOverlay();
    drawClouds();
    drawWeatherDebugControls();
  }
  
  void drawSky() {
    color effectiveSky = calculateEffectiveSkyColor();
    for (int y = 0; y < horizonHeight; y++) {
      float inter = map(y, 0, horizonHeight, 0, 1);
      stroke(lerpColor(effectiveSky, color(200), inter));
      line(0, y, width, y);
    }
  }
  
  color calculateEffectiveSkyColor() {
    if (weather == null) return skyColor;
    
    color result = lerpColor(skyColor, color(120, 140, 155), constrain(weather.cloudCover, 0, 1));
    
    switch(weather.condition) {
      case "rain":
      case "drizzle":
        return lerpColor(result, color(100, 115, 130), 0.25);
      case "snow":
        return lerpColor(result, color(200, 210, 220), 0.30);
      case "thunderstorm":
        return lerpColor(result, color(80, 90, 110), 0.35);
      default:
        return result;
    }
  }
  
  void drawGrass() {
    noStroke();
    fill(grassColor);
    rect(0, horizonHeight, width, height - horizonHeight);
  }
  
  void drawTrees() {
    float[] positions = {0.10, 0.26, 0.42, 0.60, 0.78};
    float[] scales = {0.95, 1.15, 1.0, 1.2, 1.05};
    color[] leaves = {
      color(76, 160, 70), color(84, 175, 78), color(90, 180, 85),
      color(84, 175, 78), color(76, 160, 70)
    };
    
    for (int i = 0; i < NUM_TREES; i++) {
      drawTree(width * positions[i], horizonHeight, scales[i], leaves[i], color(130, 90, 55));
    }
  }
  
  void drawTree(float x, float groundY, float s, color leafBase, color trunkCol) {
    pushMatrix();
    pushStyle();
    translate(x, groundY);
    scale(s);
    
    float sway = sin(frameCount * 0.02 + x * 0.01) * 2.0;
    
    // Schatten
    noStroke();
    fill(0, 60);
    ellipse(0, 6, 60, 10);
    
    // Stamm
    fill(trunkCol);
    stroke(0, 40);
    strokeWeight(1);
    rect(-9, -70, 18, 70, 4);
    
    // Rinde-Textur
    stroke(110, 75, 45, 120);
    for (int i = -6; i <= 6; i += 3) line(i, -62, i, -8);
    
    // Blätter - 3 Ebenen
    noStroke();
    color[] leafColors = {
      lerpColor(leafBase, color(30, 90, 40), 0.35),
      leafBase,
      lerpColor(leafBase, color(210, 255, 210), 0.25)
    };
    
    fill(leafColors[0]);
    ellipse(-20 + sway*0.4, -80, 70, 45);
    ellipse(20 + sway*0.4, -80, 70, 45);
    ellipse(sway*0.4, -72, 80, 50);
    
    fill(leafColors[1]);
    ellipse(-15 + sway*0.6, -98, 60, 40);
    ellipse(15 + sway*0.6, -98, 60, 40);
    ellipse(sway*0.6, -92, 70, 44);
    
    fill(leafColors[2]);
    ellipse(sway*0.8, -110, 56, 34);
    
    popStyle();
    popMatrix();
  }
  
  void drawClouds() {
    fill(255, 180);
    noStroke();
    for (int i = 0; i < NUM_CLOUDS; i++) {
      float cloudX = (width * i / 4 + frameCount * 0.2) % (width + 200) - 100;
      float cloudY = height * 0.2 + sin(frameCount * 0.02 + i) * 20;
      ellipse(cloudX, cloudY, 80, 50);
      ellipse(cloudX - 30, cloudY + 10, 60, 40);
      ellipse(cloudX + 30, cloudY + 10, 60, 40);
    }
  }
  
  void updateSkyColor() {
    int h = hour();
    skyColor = (h >= 6 && h < 17) ? color(135, 206, 235) :
               (h >= 17 && h < 20) ? color(255, 140, 0) :
               color(25, 25, 112);
    
    // Aktualisiere Wetter-Daten von API (nur wenn nicht manuell gesetzt)
    if (!manualWeather && weather != null && frameCount % 3600 == 0) {
      weather.updateWeather();
    }
  }
  
  void drawMusicianDog() {
    pushMatrix();
    pushStyle();

    // Position relativ zum Horizont, rechts unten
    float baseX = width * 0.18;
    float baseY = horizonHeight + 30;
    translate(baseX, baseY);

    // Sanftes Wippen zur Musik/Bewegung
    float bob = sin(frameCount * 0.03) * 2;
    translate(0, bob);

    // Schatten auf der Wiese
    noStroke();
    fill(0, 80);
    ellipse(0, 18, 110, 18);

    // Farben definieren
    color fur = color(245);
    color earInside = color(220);
    color noseCol = color(40);
    color eyeCol = color(30);
    color browCol = color(30);
    color guitarBody = color(170, 110, 40);
    color guitarTop = color(195, 140, 70);
    color neckCol = color(180, 140, 90);

    // Körper
    fill(fur);
    stroke(0, 30);
    strokeWeight(1);
    // Rumpf
    ellipse(0, -10, 60, 70);
    // Pfoten
    noStroke();
    ellipse(-18, 18, 18, 12);
    ellipse( 18, 18, 18, 12);

    // Kopf
    stroke(0, 30);
    strokeWeight(1);
    fill(fur);
    ellipse(0, -55, 72, 60);
    // Ohren
    noStroke();
    fill(fur);
    ellipse(-28, -66, 18, 26);
    ellipse( 28, -66, 18, 26);
    fill(earInside);
    ellipse(-28, -66, 10, 16);
    ellipse( 28, -66, 10, 16);

    // Augen
    fill(eyeCol);
    noStroke();
    ellipse(-12, -56, 6, 8);
    ellipse( 12, -56, 6, 8);

    // Augenbrauen
    stroke(browCol);
    strokeWeight(3);
    line(-18, -64, -8, -62);
    line( 18, -64,  8, -62);

    // Nase und Mund
    noStroke();
    fill(noseCol);
    ellipse(0, -47, 8, 6);
    stroke(noseCol);
    strokeWeight(2);
    line(-4, -42, 4, -42);

    // Gitarre (vor dem Körper)
    pushMatrix();
    rotate(-0.15);
    // Korpus
    noStroke();
    fill(guitarBody);
    ellipse(22, -16, 78, 58);
    fill(guitarTop);
    ellipse(22, -18, 60, 42);
    // Schallloch
    fill(40, 30, 20);
    ellipse(22, -18, 14, 14);
    // Hals
    fill(neckCol);
    rect(52, -23, 62, 10, 3);
    // Kopfplatte
    rect(114, -25, 14, 14, 2);
    // Seiten
    stroke(230);
    strokeWeight(1);
    for (int i = -2; i <= 2; i++) {
      line(22, -18 + i*2, 122, -18 + i*2);
    }
    popMatrix();

    // Vorderpfote auf der Gitarre
    noStroke();
    fill(fur);
    ellipse(14, -16, 18, 12);

    popStyle();
    popMatrix();
  }
  
  void drawWeatherOverlay() {
    if (weather == null) return;
    
    switch(weather.condition) {
      case "rain":
      case "drizzle":
        drawRainOverlay(false);
        break;
      case "thunderstorm":
        drawRainOverlay(true);
        break;
      case "snow":
        drawSnowOverlay();
        break;
      case "fog":
        drawFogOverlay();
        break;
    }
  }
  
  void drawRainOverlay(boolean storm) {
    stroke(200, 210, 255, 150);
    strokeWeight(2);
    int drops = storm ? 240 : 140;
    for (int i = 0; i < drops; i++) {
      float rx = random(width), ry = random(horizonHeight, height);
      line(rx, ry, rx+6, ry+12);
    }
    if (storm && frameCount % 120 < 4) {
      noStroke();
      fill(255, 60);
      rect(0, 0, width, horizonHeight);
    }
  }
  
  void drawSnowOverlay() {
    noStroke();
    fill(255, 200);
    for (int i = 0; i < 120; i++) {
      float sx = random(width);
      float sy = random(horizonHeight-40, height) + 3*sin(frameCount*0.05 + sx*0.02);
      ellipse(sx, sy, 3, 3);
    }
  }
  
  void drawFogOverlay() {
    noStroke();
    fill(230, 235, 240, 40);
    for (int i = 0; i < 4; i++) {
      rect(0, horizonHeight - 80 + i*30, width, 40);
    }
  }
  
  void drawWeatherDebugControls() {
    if (!showWeatherDebug) return;
    
    pushStyle();
    noStroke();
    fill(0, 80);
    rect(6, 6, 128, weatherButtons.length*(32+8)+8);
    
    for (Button btn : weatherButtons) btn.display();
    
    fill(255);
    textSize(12);
    textAlign(LEFT, TOP);
    String info = (manualWeather ? "Manual" : "Live") + ": " + 
                  (weather != null ? weather.condition : "-") + "  " + 
                  (weather != null ? nf(weather.temperature,0,1) : "0") + "°C";
    text(info, 10, 6 + weatherButtons.length*(32+8) + 10);
    popStyle();
  }
  
  boolean mousePressed() {
    if (!showWeatherDebug) return false;
    
    String[] conditions = {"", "sunny", "partly_cloudy", "rain", "snow", "fog", "thunderstorm"};
    float[] cloudValues = {0, 0.1, 0.7, 0.9, 0.7, 0.7, 0.95};
    
    for (int i = 0; i < weatherButtons.length; i++) {
      if (weatherButtons[i].isClicked(mouseX, mouseY)) {
        if (i == 0) {
          manualWeather = false;
          if (weather != null) weather.updateWeather();
        } else {
          setManualWeather(conditions[i], cloudValues[i]);
        }
        return true;
      }
    }
    return false;
  }
  
  void setManualWeather(String cond, float clouds) {
    if (weather == null) return;
    manualWeather = true;
    weather.condition = cond;
    weather.cloudCover = constrain(clouds, 0, 1);
  }
}
