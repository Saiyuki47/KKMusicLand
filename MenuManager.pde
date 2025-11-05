class MenuManager {
  Button startButton;
  Button exitButton;
  Button settingsButton;
  boolean isInMenu = true;
  MenuManager() {
    float centerX = width/2 - 100;
    startButton = new Button(centerX, height/2 - 60, 200, 50, "Start Game");
    settingsButton = new Button(centerX, height/2 + 20, 200, 50, "Settings");
    exitButton = new Button(centerX, height/2 + 100, 200, 50, "Exit");
  }
  void display() {
    textAlign(CENTER);
    textSize(48);
    fill(0);
    text("KK Music Land", width/2, height/3);
    startButton.display();
    settingsButton.display();
    exitButton.display();
  }
  boolean mousePressed() {
    try {
      if (startButton.isClicked(mouseX, mouseY)) {
        isInMenu = false;
        return true;
      } else if (settingsButton.isClicked(mouseX, mouseY)) {
        settingsView.show();
      } else if (exitButton.isClicked(mouseX, mouseY)) {
        exit();
      }
    } catch (Exception e) {
      println("MenuManager.mousePressed error: " + e);
      e.printStackTrace();
    }
    return false;
  }
}