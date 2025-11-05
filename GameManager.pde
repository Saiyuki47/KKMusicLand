class GameManager {
  // Core game state
  ArrayList<Note> notes; // active falling notes
  boolean gameOver;      // whether the game ended

  // UI buttons shown on Game Over
  Button retryButton;
  Button menuButton;

  // Music/beat detection helper (created when the game actually starts)
  MusicManager musicManager;
  // The player avatar (now an explicit object)
  Player player;

  GameManager() {
    // initialize basic state
    notes = new ArrayList<Note>();
    gameOver = false;
    // do NOT create MusicManager here — wait until the player actually starts
    retryButton = new Button(width/2 - 210, height/2 + 50, 200, 50, "Retry");
    menuButton = new Button(width/2 + 10, height/2 + 50, 200, 50, "Main Menu");
    // create a minimal player object (score holder)
    player = new Player();
  }
  
  // Called once per frame to update game objects and state
  void update() {
    if (!gameOver) {
      // update player (no-op currently beyond bounds enforcement)
      if (player != null) {
        // player doesn't need per-frame velocity logic yet
      }
      // If the music manager exists, use beat detection to spawn notes
      if (musicManager != null && musicManager.detectBeat()) {
        notes.add(new Note(random(width), -50));
      }

      // Update all notes and check for game-over condition
      for (int i = notes.size() - 1; i >= 0; i--) {
        Note n = notes.get(i);
        n.update();
        if (n.y > height) {
          // A note reached the bottom — game over
          gameOver = true;
          if (musicManager != null) musicManager.stopMusic();
          noLoop(); // stop draw loop until restart or menu
        }
      }
    }
  }
  
  // Render game objects and UI
  void display() {
    // draw every active note
    for (Note note : notes) {
      note.display();
    }

    // draw player's hitbox marker (follows the mouse)
    if (player != null) player.display();

    // draw score stored in the player object
  fill(0);
  textAlign(LEFT);
  int displayScore = (player != null) ? player.score : 0;
  text("Score: " + displayScore, 20, 30);

    // If game over, draw the big message and the two buttons
    if (gameOver) {
      textAlign(CENTER);
      textSize(40);
      fill(255, 0, 0);
      text("Game Over!", width/2, height/2);
      retryButton.display();
      menuButton.display();
    }
  }
  
  // Mouse handling: clicks on notes or game-over buttons
  void mousePressed() {
    if (gameOver) {
      if (retryButton.isClicked(mouseX, mouseY)) {
        restart();
      } else if (menuButton.isClicked(mouseX, mouseY)) {
        returnToMenu();
      }
    } else {
      checkNoteHits();
    }
  }
  
  // Check for user clicks on notes; increment score and respawn
  void checkNoteHits() {
    for (int i = notes.size() - 1; i >= 0; i--) {
      Note n = notes.get(i);
      // Only mouse clicks count here; player proximity/hit logic removed
      if (n.isHit(mouseX, mouseY)) {
        if (player != null) player.score++;
        notes.remove(i);
        // keep a constant flow by immediately adding a new note above the screen
        notes.add(new Note(random(width), -50));
      }
    }
  }
  
  // Reset game state and restart music/beat detection
  void restart() {
    if (musicManager != null) musicManager.stopMusic();
  notes.clear();
    gameOver = false;
    delay(100);
    // recreate music manager with default settings
    musicManager = new MusicManager();
    // ensure player exists and reset score
    if (player == null) player = new Player();
    else player.score = 0;
    loop();
  }
  
  // Stop the game and return to the main menu
  void returnToMenu() {
    if (musicManager != null) musicManager.stopMusic();
    notes.clear();
    if (player != null) player.score = 0;
    gameOver = false;
    menu.isInMenu = true;
    loop();
  }

  // Called from Main when the player starts the game
  // Creates the MusicManager (which loads and plays the audio and provides FFT)
  void startGame() {
    if (musicManager == null) {
      musicManager = new MusicManager();
    }
  // prepare empty level
  notes.clear();
    gameOver = false;
    // ensure player exists and reset score
    if (player == null) player = new Player();
    else player.score = 0;
  }

  // Called when the player uses the action (space) to hit nearby notes
  void playerHit() {
    // Remove the lowest visible note near the bottom (player has no position)
    if (notes.size() == 0) return;
    int bestIdx = -1;
    float bestY = -1;
    float thresholdY = height - 120; // only consider notes near the bottom
    for (int i = 0; i < notes.size(); i++) {
      Note n = notes.get(i);
      if (n.y >= thresholdY && n.y > bestY) {
        bestY = n.y;
        bestIdx = i;
      }
    }
    if (bestIdx >= 0) {
      if (player != null) player.score++;
      notes.remove(bestIdx);
      notes.add(new Note(random(width), -50));
    }
  }

  
}