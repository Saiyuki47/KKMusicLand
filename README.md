# KK Music Land — Module Programming (Minor CDT)

Student Name: David

Product title: KK Music Land

Short description:
Small Processing sketch: colorful "notes" appear to the beat of a local audio file. The player clicks notes before they reach the bottom. The sketch includes a main menu (Start/Exit) and a Retry button on Game Over.

---

Checklist mapping (how each requirement is satisfied)

1) Graphics consistent and own design

   - Implemented: Yes — consistent simple vector style (notes and rounded buttons).
   - Files: `Note.pde`, `Button.pde`, `MenuManager.pde`, `Main.pde`.

2) Automatic movement in the virtual world

   - Implemented: Yes — notes fall automatically (`Note.update()`), driven by `GameManager.update()`.

3) Own code (student can explain)

   - Implemented: Yes — code is split into multiple `.pde` files (`GameManager`, `MusicManager`, `MenuManager`, `Note`, `Button`) and includes comments.

4) Creatures and player are objects of a class

   - Implemented: Creatures are `Note` objects. The player is represented by interaction (mouse clicks). If a separate `Player` class is required, it can be added easily.

5) Virtual world is interactive

   - Implemented: Yes — clicking notes (`Note.isHit()`), buttons, and keyboard input (Enter to start, R to restart).

6) At least two inputs used

   - Implemented: Yes — Mouse and Keyboard. Sound (SoundFile + FFT) is also used to drive note spawning.

7) Use of an Array/List to store multiple objects

   - Implemented: Yes — `ArrayList<Note> notes` in `GameManager.pde` stores active notes; gameplay produces more than 10 notes during play.

8) Use of an API so internet data influences the world

   - Not implemented: No internet/API calls are present. I can add a simple API integration (e.g., OpenWeatherMap for background color or tempo) on request.

9) Apart from the API library, another library is used

   - Implemented partially: The sketch uses Processing's Sound library (`processing.sound.*`). If an external API is added, a second library (e.g., ControlP5 for GUI or an HTTP client) can fulfill this requirement.

---

How to run

1. Open the `KKMusicLand` folder in Processing.
2. Install the Sound library (Sketch → Import Library → Add Library → Sound).
3. Ensure `data/gamemusic/Grand-Opening-PM-Music.wav` exists.
4. Run the sketch. Use Start (or Enter) to begin; click notes to score.

If you want, I can:
- initialize exactly 10 notes at game start, and/or
- add a quick API example (OpenWeatherMap) and a second library to meet requirement 8/9.

Tell me which addition you prefer and I will implement it and update the README.

