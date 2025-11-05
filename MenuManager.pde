class MenuManager {
  // Buttons used on the main menu
  Button startButton;
  Button exitButton;
  boolean isInMenu = true; // whether the main menu is currently visible
  
  // Create menu layout and buttons
  MenuManager() {
    float centerX = width/2 - 100;
    startButton = new Button(centerX, height/2 - 60, 200, 50, "Start Game");
    exitButton = new Button(centerX, height/2 + 20, 200, 50, "Exit");
  }
  
  // Render the menu title and buttons
  void display() {
    textAlign(CENTER);
    textSize(48);
    fill(0);
    text("KK Music Land", width/2, height/3);
    
    // Buttons
    startButton.display();
    exitButton.display();

  }
  
  // Handle mouse presses on menu buttons. Returns true when Start
  // was clicked so the caller can transition into the game.
  boolean mousePressed() {
    try {
      if (startButton.isClicked(mouseX, mouseY)) {
        isInMenu = false;
        return true;
      } else if (exitButton.isClicked(mouseX, mouseY)) {
        exit();
      }
    } catch (Exception e) {
      // Defensive logging to aid debugging without crashing
      println("MenuManager.mousePressed error: " + e);
      e.printStackTrace();
    }
    return false;
  }
 
}