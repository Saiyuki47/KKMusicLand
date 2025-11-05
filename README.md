# KK Music Land

**Student Name:** David  
**Title of Product:** KK Music Land - Interactive Rhythm Game  
**Module:** Programming (Minor CDT)

## Description
An interactive rhythm game in Processing where colorful musical notes fall to the beat of music. Players click on notes before they reach the bottom to score points. The virtual world features weather-influenced dynamic backgrounds, a main menu system, settings and restart functionality.

## How to Use
1. **Start the Game:** Open the sketch in Processing and run it
2. **Main Menu:** Click "Start" button or press ENTER to begin playing
3. **Gameplay:** Click on falling notes before they reach the bottom
4. **Settings:** Access settings from the main menu to adjust preferences
5. **Game Over:** When notes are missed, you'll see the game over screen with restart option
6. **Music:** Background music plays automatically with visual beat analysis

## Minimum Requirements Implementation

### ✓ Consistent Graphics with Own Look and Feel
- Custom-designed colorful note graphics
- Consistent UI elements (buttons, backgrounds, text styling)
- Weather-based dynamic backgrounds with particles (flowers, birds)
- Unique visual theme combining music and nature

### ✓ Automatic Movement
- Notes automatically fall from top to bottom with gravity simulation
- Background particles (birds, flowers) move automatically
- Weather effects animate continuously

### ✓ Own Code (All Details Explainable)
- Custom classes: `Note`, `Player`, `Bird`, `Flower`, `Button`, `GameManager`, `MenuManager`, `SettingsManager`, `MusicManager`, `WeatherManager`, `WeatherAPI`
- Original algorithms for beat detection and note spawning

### ✓ Object-Oriented Design
- **Creatures:** `Bird` and `Flower` classes represent animated background creatures
- **Player:** `Player` class manages player display and score
- Multiple other classes: `Note`, `Button`, `GameManager`, `MenuManager`, etc.
- Proper encapsulation and object management

### ✓ Interactive Virtual World
- **Movement:** Navigate through menu screens (Main Menu → Game → Game Over → Settings)
- **Click Interaction:** Click on falling notes to score points
- **Button Interaction:** Click menu buttons to navigate
- **Collision Detection:** Notes detect when they reach the bottom or are clicked
- **Multiple hotspots:** Interactive buttons and clickable notes

### ✓ Multiple Input Types (2+ Required)
1. **Mouse:** Click notes, click menu buttons, hover effects
2. **Keyboard:** ENTER to start game, ESC for settings, keyboard shortcuts
3. **Sound:** Music playback with FFT analysis affects game behavior
   *(3 inputs implemented)*

### ✓ Array/List for Multiple Objects (10+ Required)
- `ArrayList<Note>` stores all falling notes
- `ArrayList<Bird>` stores multiple bird creatures in background
- `ArrayList<Flower>` stores multiple flower objects
- Dynamic addition and removal of objects during runtime

### ✓ API Integration
- **Weather API** (`WeatherAPI` class) fetches real-time weather data from Open-Meteo
- Weather conditions influence the virtual world:
  - Temperature, cloud cover, and weather codes are retrieved
  - Background atmosphere changes based on weather conditions
  - Weather data is displayed and monitored in the console
- API data provides environmental context for the game world
- You can test the different Weather Types by enabling the debug mode in the settings ang going back to the main Menu. 

### ✓ Multiple Libraries (2+ Required)
1. **Sound Library:** Music playback and FFT audio analysis
2. **ControlP5 Library:** Professional UI controls (slider for volume, toggle for debug mode)

## Extra Features (Beyond Minimum Requirements)

### Professional Polish
- Start screen with clear instructions
- Settings screen with ControlP5 UI controls (volume slider, debug toggle)
- Game over screen with restart option
- Score display (HUD element)
- Smooth transitions between screens

### Additional Functionality
- Beat detection algorithm syncs note spawning with music
- Visual feedback on note clicks
- Button hover effects
- Dynamic difficulty (note speed varies)
- Persistent settings management

### Visual Enhancements
- Gradient color system for notes
- Weather-responsive particle effects
- Animated background creatures
- Professional menu design
- Color-coded UI elements

## Technical Details

### Libraries Used
- **Processing Sound Library** - Audio playback and FFT analysis
- **ControlP5 Library** - Professional UI controls (sliders, toggles, buttons)
- **Processing's built-in JSON** - Weather API data parsing

### Classes Overview
- `GameManager` - Main game state and logic controller
- `MenuManager` - Menu navigation and UI management
- `SettingsManager` - User settings persistence
- `MusicManager` - Audio playback and beat detection
- `WeatherManager` - Weather effects coordination
- `WeatherAPI` - API calls and data parsing
- `Player` - Player state and scoring
- `Note` - Falling note objects
- `Bird` - Animated bird creatures
- `Flower` - Animated flower objects
- `Button` - Interactive menu buttons
- `Background` - Dynamic background rendering

### API Information
- **Service:** Open-Meteo API
- **Purpose:** Fetch real-time weather data
- **Impact:** Changes background atmosphere and sky colors based on weather conditions

## Installation & Setup
1. Open Processing IDE
2. Install required libraries:
   - Sketch → Import Library → Add Library → "Sound"
   - Sketch → Import Library → Add Library → "ControlP5"
3. Place music file in `data/gamemusic/` folder
4. Run `Main.pde`

## Controls
- **Mouse:** Click notes and buttons
- **ENTER:** Start game from menu
- **Click:** All menu interactions
