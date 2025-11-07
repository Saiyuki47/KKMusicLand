import processing.sound.*;
import controlP5.*;

ControlP5 cp5;
GameManager game;
BirdDodgeGame birdDodgeGame;
MenuManager menu;
Background bg;
void setup() {
  size(1200, 800);
  textSize(24);
  cp5 = new ControlP5(this);
  menu = new MenuManager();
  game = new GameManager();
  birdDodgeGame = new BirdDodgeGame();
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
    // Wähle Spielmodus
    if (gameModeManager.getMode() == GameMode.RHYTHM) {
      game.update();
      game.display();
    } else if (gameModeManager.getMode() == GameMode.BIRD_DODGE) {
      birdDodgeGame.update();
      birdDodgeGame.display();
    }
  }
  // Cursor abhängig vom Zustand zeigen/verstecken
  boolean showCursor = settingsView.visible || menu.isInMenu;
  if (gameModeManager.getMode() == GameMode.RHYTHM) {
    showCursor = showCursor || game.gameOver || game.paused;
  } else if (gameModeManager.getMode() == GameMode.BIRD_DODGE) {
    showCursor = showCursor || birdDodgeGame.gameOver;
  }
  
  if (showCursor) {
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
      if (gameModeManager.getMode() == GameMode.RHYTHM) {
        game.startGame();
      } else if (gameModeManager.getMode() == GameMode.BIRD_DODGE) {
        birdDodgeGame.startGame();
      }
    }
  } else {
    if (gameModeManager.getMode() == GameMode.RHYTHM) {
      game.mousePressed();
    } else if (gameModeManager.getMode() == GameMode.BIRD_DODGE) {
      birdDodgeGame.mousePressed();
    }
  }
}
void keyPressed() {
  // Debug output
  println("Key pressed: " + key + " (code: " + keyCode + ")");
  
  // Name eingeben bei Game Over - prüfe beide Modi
  if (gameModeManager.getMode() == GameMode.RHYTHM && game.gameOver && game.enteringName) {
    println("In name entry mode (Rhythm)!");
    if (key == ENTER || key == RETURN) {
      println("Submit pressed");
      game.submitHighscore();
    } else if (key == BACKSPACE) {
      println("Backspace pressed");
      if (game.playerName.length() > 0) {
        game.playerName = game.playerName.substring(0, game.playerName.length() - 1);
      }
    } else if (key >= 32 && key <= 126 && game.playerName.length() < 20) {
      println("Adding char: " + key);
      game.playerName += key;
      println("Player name is now: " + game.playerName);
    } else {
      println("Key not accepted. key value: " + ((int)key));
    }
    return;
  }
  
  if (gameModeManager.getMode() == GameMode.BIRD_DODGE && birdDodgeGame.gameOver && birdDodgeGame.enteringName) {
    println("In name entry mode (Bird Dodge)!");
    if (key == ENTER || key == RETURN) {
      println("Submit pressed");
      birdDodgeGame.submitHighscore();
    } else if (key == BACKSPACE) {
      println("Backspace pressed");
      if (birdDodgeGame.playerName.length() > 0) {
        birdDodgeGame.playerName = birdDodgeGame.playerName.substring(0, birdDodgeGame.playerName.length() - 1);
      }
    } else if (key >= 32 && key <= 126 && birdDodgeGame.playerName.length() < 20) {
      println("Adding char: " + key);
      birdDodgeGame.playerName += key;
      println("Player name is now: " + birdDodgeGame.playerName);
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
    if (gameModeManager.getMode() == GameMode.RHYTHM) {
      game.startGame();
    } else if (gameModeManager.getMode() == GameMode.BIRD_DODGE) {
      birdDodgeGame.startGame();
    }
    return;
  }
  if (!menu.isInMenu && !game.gameOver && (key == 'p' || key == 'P' || key == ESC)) {
    if (gameModeManager.getMode() == GameMode.RHYTHM) {
      key = 0; // Verhindert ESC-Standard-Verhalten
      game.togglePause();
    }
    return;
  }
  if (!menu.isInMenu && (key == 'r' || key == 'R')) {
    if (gameModeManager.getMode() == GameMode.RHYTHM) {
      game.restart();
    } else if (gameModeManager.getMode() == GameMode.BIRD_DODGE) {
      birdDodgeGame.restart();
    }
    return;
  }
  // (kein Crosshair-Toggle nötig; Crosshair wird im Player gezeichnet)
}
// Mausrad weiterleiten an SettingsView für Scroll der Trackliste
void mouseWheel(processing.event.MouseEvent event) {
  float e = event.getCount();
  settingsView.onMouseWheel(e);
}