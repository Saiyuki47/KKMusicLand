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
  if (settingsView.visible || menu.isInMenu || game.gameOver || game.paused) {
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
  // Debug output
  println("Key pressed: " + key + " (code: " + keyCode + ")");
  println("Game Over: " + game.gameOver + ", Entering Name: " + game.enteringName);
  
  // Name eingeben bei Game Over
  if (game.gameOver && game.enteringName) {
    println("In name entry mode!");
    if (key == ENTER || key == RETURN) {
      println("Submit pressed");
      game.submitHighscore();
    } else if (key == BACKSPACE) {
      println("Backspace pressed");
      if (game.playerName.length() > 0) {
        game.playerName = game.playerName.substring(0, game.playerName.length() - 1);
      }
    } else if (key >= 32 && key <= 126 && game.playerName.length() < 20) {
      // Normale Zeichen (Buchstaben, Zahlen, Sonderzeichen)
      println("Adding char: " + key);
      game.playerName += key;
      println("Player name is now: " + game.playerName);
    } else {
      println("Key not accepted. key value: " + ((int)key));
    }
    return;
  }
  
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
  if (!menu.isInMenu && !game.gameOver && (key == 'p' || key == 'P' || key == ESC)) {
    key = 0; // Verhindert ESC-Standard-Verhalten
    game.togglePause();
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