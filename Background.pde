class Background {
  color skyColor;      // Farbe für den Himmel
  color grassColor;    // Farbe für die Wiese
  float horizonHeight; // Höhe des Horizonts
  WeatherManager weather; // Reale Wetterdaten (Open-Meteo)
  
  // Debug-UI: Wetter manuell umstellen
  boolean showWeatherDebug = false;
  boolean manualWeather = false; // true = manuell gesetztes Wetter aktiv
  Button btnLive, btnSunny, btnCloudy, btnRain, btnSnow, btnFog, btnStorm;
  
  Background() {
    skyColor = color(135, 206, 235);    // Hellblau für den Himmel
    grassColor = color(34, 139, 34);    // Sattes Grün für die Wiese
    horizonHeight = height * 0.7;        // Horizont bei 70% der Bildschirmhöhe
    weather = new WeatherManager();

    // Debug Buttons anlegen (oben links)
    float bx = 10;
    float by = 10;
    float bw = 120;
    float bh = 32;
    float gap = 8;
    btnLive   = new Button(bx, by + 0*(bh+gap), bw, bh, "Live");
    btnSunny  = new Button(bx, by + 1*(bh+gap), bw, bh, "Sunny");
    btnCloudy = new Button(bx, by + 2*(bh+gap), bw, bh, "Cloudy");
    btnRain   = new Button(bx, by + 3*(bh+gap), bw, bh, "Rain");
    btnSnow   = new Button(bx, by + 4*(bh+gap), bw, bh, "Snow");
    btnFog    = new Button(bx, by + 5*(bh+gap), bw, bh, "Fog");
    btnStorm  = new Button(bx, by + 6*(bh+gap), bw, bh, "Storm");
  }
  
  void display() {
    // Keine periodischen Wetter-Updates mehr (nur beim Start geholt)

    // Himmelsfarbe ggf. durch Wetter abtönen/aufhellen
    color effectiveSky = skyColor;
    if (weather != null) {
      // mehr Wolken -> kühler/dunklerer Himmel
      color overcast = color(120, 140, 155);
      effectiveSky = lerpColor(effectiveSky, overcast, constrain(weather.cloudCover, 0, 1));

      // Regen/Schnee/Thunder justieren
      if (weather.condition.equals("rain") || weather.condition.equals("drizzle")) {
        effectiveSky = lerpColor(effectiveSky, color(100, 115, 130), 0.25);
      } else if (weather.condition.equals("snow")) {
        effectiveSky = lerpColor(effectiveSky, color(200, 210, 220), 0.30);
      } else if (weather.condition.equals("thunderstorm")) {
        effectiveSky = lerpColor(effectiveSky, color(80, 90, 110), 0.35);
      }
    }

    // Himmel zeichnen (Farbverlauf von oben nach unten)
    for (int y = 0; y < horizonHeight; y++) {
      float inter = map(y, 0, horizonHeight, 0, 1);
      color lineColor = lerpColor(effectiveSky, color(200), inter);
      stroke(lineColor);
      line(0, y, width, y);
    }
    
    // Wiese zeichnen
    noStroke();
    fill(grassColor);
    rect(0, horizonHeight, width, height - horizonHeight);
    
  // Bäume im stilisierten, freundlichen Look (vor dem Hund, hinter den Wolken)
  drawTrees();

    // Stylisierte Musiker-Hund-Figur (original, keine markenrechtlich geschützte Kopie)
    drawMusicianDog();

    // Wettereffekte (Regen/Schnee/Nebel)
    drawWeatherOverlay();

    // Optional: Ein paar dekorative Wolken
    drawClouds();

    // Debug-Buttons zuletzt zeichnen (UI oben drauf)
    drawWeatherDebugControls();
  }
  
  // Mehrere Bäume platzieren (einfache Parallaxe/Sway)
  void drawTrees() {
    // Feste Positionen, abhängig von der Fensterbreite
    float[] xs = { width*0.10, width*0.26, width*0.42, width*0.60, width*0.78 };
    float[] sc = { 0.95, 1.15, 1.0, 1.2, 1.05 };
    // Leichte Tiefenfärbung: weiter hinten = dunkler
    color[] leaf = {
      color(76, 160, 70),
      color(84, 175, 78),
      color(90, 180, 85),
      color(84, 175, 78),
      color(76, 160, 70)
    };
    color trunkCol = color(130, 90, 55);
    for (int i = 0; i < xs.length; i++) {
      drawTree(xs[i], horizonHeight, sc[i], leaf[i], trunkCol);
    }
  }

  // Einzelnen Baum zeichnen
  void drawTree(float x, float groundY, float s, color leafBase, color trunkCol) {
    pushMatrix();
    pushStyle();
    translate(x, groundY);
    scale(s);

    // Wind-Sway für Blätterkrone
    float phase = x * 0.01;
    float sway = sin(frameCount * 0.02 + phase) * 2.0;

    // Schatten auf dem Boden
    noStroke();
    fill(0, 60);
    ellipse(0, 6, 60, 10);

    // Stamm
    fill(trunkCol);
    stroke(0, 40);
    strokeWeight(1);
    float trunkH = 70;
    float trunkW = 18;
    rect(-trunkW/2, -trunkH, trunkW, trunkH, 4);
    // Rindenstreifen
    stroke(110, 75, 45, 120);
    for (int i = -6; i <= 6; i += 3) {
      line(i, -trunkH + 8, i, -8);
    }

    // Blätter-Krone: mehrere weiche, überlappende Ellipsen
    noStroke();
    color leafDark = lerpColor(leafBase, color(30, 90, 40), 0.35);
    color leafLight = lerpColor(leafBase, color(210, 255, 210), 0.25);

    // Untere breite Lage
    fill(leafDark);
    ellipse(-20 + sway*0.4, -trunkH - 10, 70, 45);
    ellipse( 20 + sway*0.4, -trunkH - 10, 70, 45);
    ellipse(  0 + sway*0.4, -trunkH -  2, 80, 50);

    // Mittlere Lage
    fill(leafBase);
    ellipse(-15 + sway*0.6, -trunkH - 28, 60, 40);
    ellipse( 15 + sway*0.6, -trunkH - 28, 60, 40);
    ellipse(  0 + sway*0.6, -trunkH - 22, 70, 44);

    // Obere Lichtkante
    fill(leafLight);
    ellipse(  0 + sway*0.8, -trunkH - 40, 56, 34);

    popStyle();
    popMatrix();
  }

  void drawClouds() {
    fill(255, 255, 255, 180);
    noStroke();
    
    // Mehrere Wolken an verschiedenen Positionen
    for (int i = 0; i < 5; i++) {
      float cloudX = (width * i / 4 + frameCount * 0.2) % (width + 200) - 100;
      float cloudY = height * 0.2 + sin(frameCount * 0.02 + i) * 20;
      
      // Eine Wolke aus mehreren überlappenden Kreisen
      ellipse(cloudX, cloudY, 80, 50);
      ellipse(cloudX - 30, cloudY + 10, 60, 40);
      ellipse(cloudX + 30, cloudY + 10, 60, 40);
    }
  }
  
  // Tageszeit-basierte Himmelsfarbe
  void updateSkyColor() {
    int h = hour();
    if (h >= 6 && h < 10) {
      // Sonnenaufgang: Orange-Blau
      skyColor = color(135, 206, 235);
    } else if (h >= 10 && h < 17) {
      // Tag: Hellblau
      skyColor = color(135, 206, 235);
    } else if (h >= 17 && h < 20) {
      // Sonnenuntergang: Orange-Rot
      skyColor = color(255, 140, 0);
    } else {
      // Nacht: Dunkelblau
      skyColor = color(25, 25, 112);
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
    // Saiten
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

  // Wettereffekte überlagern
  void drawWeatherOverlay() {
    if (weather == null) return;
    if (weather.condition.equals("rain") || weather.condition.equals("drizzle") || weather.condition.equals("thunderstorm")) {
      drawRainOverlay(weather.condition.equals("thunderstorm"));
    } else if (weather.condition.equals("snow")) {
      drawSnowOverlay();
    } else if (weather.condition.equals("fog")) {
      drawFogOverlay();
    }
  }

  void drawRainOverlay(boolean storm) {
    stroke(200, 210, 255, 150);
    strokeWeight(2);
    float density = storm ? 240 : 140;
    for (int i = 0; i < density; i++) {
      float rx = random(width);
      float ry = random(horizonHeight, height);
      line(rx, ry, rx+6, ry+12);
    }
    if (storm && frameCount % 120 < 4) {
      // gelegentlicher Blitz-Effekt
      noStroke();
      fill(255, 255, 255, 60);
      rect(0, 0, width, horizonHeight);
    }
  }

  void drawSnowOverlay() {
    noStroke();
    fill(255, 255, 255, 200);
    for (int i = 0; i < 120; i++) {
      float sx = random(width);
      float sy = random(horizonHeight-40, height);
      ellipse(sx, sy + 3*sin(frameCount*0.05 + sx*0.02), 3, 3);
    }
  }

  void drawFogOverlay() {
    noStroke();
    for (int i = 0; i < 4; i++) {
      fill(230, 235, 240, 40);
      rect(0, horizonHeight - 80 + i*30, width, 40);
    }
  }

  // --- Debug Wettersteuerung ---
  void drawWeatherDebugControls() {
    if (!showWeatherDebug) return;
    // Hintergrundpanel
    pushStyle();
    noStroke();
    fill(0, 0, 0, 80);
    rect(6, 6, 128, 7*(32+8)+8);

    // Buttons rendern
    btnLive.display();
    btnSunny.display();
    btnCloudy.display();
    btnRain.display();
    btnSnow.display();
    btnFog.display();
    btnStorm.display();

    // Statusanzeige
    fill(255);
    textSize(12);
    textAlign(LEFT, TOP);
  String mode = manualWeather ? "Manual" : "Live";
    String cond = (weather != null) ? weather.condition : "-";
    float temp = (weather != null) ? weather.temperature : 0;
    text(mode + ": " + cond + "  " + nf(temp,0,1) + "°C", 10, 6 + 7*(32+8) + 10);
    popStyle();
  }

  // Gibt true zurück, wenn ein Debug-Button geklickt wurde (Event verbraucht)
  boolean mousePressed() {
    if (!showWeatherDebug) return false;
    // hover/pressed Zustand erneuern (optional)
    // Die Button.display nutzt mousePressed bereits visuell.
    if (btnLive.isClicked(mouseX, mouseY)) {
      manualWeather = false; // zurück zu Live
      if (weather != null) weather.updateWeather(); // API-Daten neu abrufen
      return true;
    }
    if (btnSunny.isClicked(mouseX, mouseY)) {
      setManualWeather("sunny", 0.1);
      return true;
    }
    if (btnCloudy.isClicked(mouseX, mouseY)) {
      setManualWeather("partly_cloudy", 0.7);
      return true;
    }
    if (btnRain.isClicked(mouseX, mouseY)) {
      setManualWeather("rain", 0.9);
      return true;
    }
    if (btnSnow.isClicked(mouseX, mouseY)) {
      setManualWeather("snow", 0.7);
      return true;
    }
    if (btnFog.isClicked(mouseX, mouseY)) {
      setManualWeather("fog", 0.7);
      return true;
    }
    if (btnStorm.isClicked(mouseX, mouseY)) {
      setManualWeather("thunderstorm", 0.95);
      return true;
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