import processing.sound.*;


GameManager game;
MenuManager menu; 
Background bg;
void setup() {
  // Sketch window and basic text sizing
  size(800, 600);
  textSize(24);

  // Create menu and game manager instances
  menu = new MenuManager();
  game = new GameManager();
  bg = new Background();
}

void draw() {
  // Clear frame and draw either the menu or the active game
  bg.updateSkyColor();
  bg.display();
  if (menu.isInMenu) {
    menu.display();
  } else {
    game.update();
    game.display();
  }
}

// Mouse pressed events are forwarded to either the menu
// (when the menu is visible) or the game while playing.
void mousePressed() {
  if (menu.isInMenu) {
    boolean started = menu.mousePressed();
    if (started) {
      // Player pressed Start: switch to game and start music/logic
      game.startGame();
    }
  } else {
    game.mousePressed();
  }
}

// Keyboard shortcuts:
// - Enter: start game when in menu
// - R: restart while in game
void keyPressed() {
  if (menu.isInMenu && (key == ENTER || key == RETURN)) {
    // Start the game from keyboard
    menu.isInMenu = false;
    game.startGame();
    return;
  }

  if (!menu.isInMenu && (key == 'r' || key == 'R')) {
    // Restart the game
    game.restart();
    return;
  }
}