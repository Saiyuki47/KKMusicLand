class Background {
  color skyColor;      // Farbe für den Himmel
  color grassColor;    // Farbe für die Wiese
  float horizonHeight; // Höhe des Horizonts
  
  Background() {
    skyColor = color(135, 206, 235);    // Hellblau für den Himmel
    grassColor = color(34, 139, 34);    // Sattes Grün für die Wiese
    horizonHeight = height * 0.7;        // Horizont bei 70% der Bildschirmhöhe
  }
  
  void display() {
    // Himmel zeichnen (Farbverlauf von oben nach unten)
    for (int y = 0; y < horizonHeight; y++) {
      float inter = map(y, 0, horizonHeight, 0, 1);
      color lineColor = lerpColor(skyColor, color(200), inter);
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

    // Optional: Ein paar dekorative Wolken
    drawClouds();
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

  // Zeichnet eine freundliche, stilisierte Musiker-Hund-Figur mit Gitarre
  // (eigene Illustration; bewusst generisch gehalten)
  void drawMusicianDog() {
    pushMatrix();
    pushStyle();

    // Position relativ zum Horizont, rechts unten
    float baseX = width * 0.18;
    float baseY = horizonHeight - 10;
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
}