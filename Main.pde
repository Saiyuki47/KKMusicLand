import processing.sound.*;
import controlP5.*;

ControlP5 cp5;
GameManager game;
MenuManager menu;
Background bg;
void setup() {
  size(1200, 800);
  textSize(24);
  cp5 = new ControlP5(this);
  menu = new MenuManager();
  game = new GameManager();
  bg = new Background();
  settingsView.setup();
}
void draw() {
  bg.updateSkyColor();
  bg.display();
  if (settingsView.visible) {
    settingsView.display();
  } else if (menu.isInMenu) {
    menu.display();
  } else {
    game.update();
    game.display();
  }
  // Cursor abhängig vom Zustand zeigen/verstecken
  if (settingsView.visible || menu.isInMenu || game.gameOver) {
    cursor();
  } else {
    noCursor();
  }
}
void mousePressed() {
  if (settingsView.visible) {
    settingsView.mousePressed();
    return;
  }
  if (bg != null && bg.mousePressed()) {
    return;
  }
  if (menu.isInMenu) {
    boolean started = menu.mousePressed();
    if (started) {
      game.startGame();
    }
  } else {
    game.mousePressed();
  }
}
void keyPressed() {
  if (menu.isInMenu && (key == ENTER || key == RETURN)) {
    // Stoppe Menü-Musik bei Start per Enter
    if (menu != null && menu.menuMusic != null) {
      menu.menuMusic.stopMusic();
      menu.menuMusic = null;
    }
    menu.isInMenu = false;
    game.startGame();
    return;
  }
  if (!menu.isInMenu && (key == 'r' || key == 'R')) {
    game.restart();
    return;
  }
  // (kein Crosshair-Toggle nötig; Crosshair wird im Player gezeichnet)
}
// Mausrad weiterleiten an SettingsView für Scroll der Trackliste
void mouseWheel(processing.event.MouseEvent event) {
  float e = event.getCount();
  settingsView.onMouseWheel(e);
}