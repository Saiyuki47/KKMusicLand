# KK Music Land

An interactive music game built with Processing featuring two game modes (Rhythm and Bird Dodge), dynamic backgrounds, settings, highscores, and music beat detection.

## Overview

KK Music Land is a Processing sketch that visualizes and gamifies music:
- Rhythm Mode: Click falling notes to the beat, score points, keep your combo.
- Bird Dodge: Dodge incoming birds and survive as long as possible to claim a highscore.

Key Features:
- Music playback with FFT beat detection
- Settings menu (e.g. volume, debug mode)
- Separate highscores with name entry per mode
- Dynamic sky/background influenced by weather
- Separate menu and gameplay music (random or selected track)

## Installation & Setup
Requirements:
-OpenJDK 17 is required https://adoptium.net/

Steps:
1. Download the latest Release.
2. Unzip the Folder.
3. Put your music into the data/gamemusic folder
4. Run the Game
   
///////////////////////////////////////////////
OR
///////////////////////////////////////////////
Requirements:
- Processing 3.x or 4.x
- Libraries: Sound, ControlP5 (see Dependencies & APIs)

Steps:
1. Open the project folder in Processing (File → Open → select folder `sketch_251023a`).
2. Install libraries:
  - Sketch → Import Library… → Add Library… → install "Sound"
  - Sketch → Import Library… → Add Library… → install "ControlP5"
3. Add music files:
  - Place your audio files inside `data/gamemusic/` (create the folder manually if it does not exist).
  - Supported formats: `.wav`, `.aiff`, `.aif`, `.mp3`.
4. Run the sketch (▶ button in Processing).

Note: If no audio file is found the game may fall back to a default bundled track (if present). For the best experience add your own tracks to `data/gamemusic/`.

## Game Modes

### Rhythm Mode
- Click falling notes in rhythm before they reach the bottom.
- Beat detection drives spawn timing and density.
- Highscore entry appears after Game Over.

### Bird Dodge
- Dodge randomly spawned birds.
- Each bird's initial direction aims at the mouse at spawn (no continuous homing).
- Survive as long as possible; separate highscore list.

## Controls

- Mouse: Clicking (Rhythm), menu navigation
- ENTER: Start game from menu; confirm highscore name
- ESC or P (Rhythm Mode): Pause/Resume
- R: Restart current mode

## Settings & Data

- Settings (e.g. volume, debug) are persisted to disk.
- Highscores are stored per mode (e.g. `highscores.txt`, `highscores_birddodge.txt`).
- Music files live in `data/gamemusic/`.

## Dependencies & APIs

Libraries:
- processing.sound (SoundFile, FFT)
- ControlP5 (UI components: slider, toggle, buttons)
- Processing built-in JSON for API parsing

API:
- Open-Meteo API – Weather data (temperature, cloud cover, codes) influencing background mood.

## Folder Structure (condensed)

```
sketch_251023a/
  Main.pde
  GameManager.pde
  BirdDodgeGame.pde
  MusicManager.pde
  SettingsManager.pde
  SettingsView.pde
  MenuManager.pde
  Background.pde
  Bird.pde, Flower.pde, Player.pde, Note.pde, Button.pde, ...
  WeatherAPI.pde, WeatherManager.pde
  data/
   gamemusic/            # audio files (wav/aiff/aif/mp3)
```

## Contributing

Pull requests and improvement suggestions are welcome. Please include a short description of the change.

## License (MIT)

Copyright (c) 2025

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

