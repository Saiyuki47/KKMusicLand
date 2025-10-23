# 🎸 K.K. Music Game

Ein kleines Rhythmus-Spiel inspiriert von *Animal Crossing*, erstellt in **Processing (Java Mode)**.  
Hilf K.K. dabei, die Noten im richtigen Moment zu treffen, während sich die Welt um dich herum verändert! 🌞🌙🎵

---

## 🕹️ Gameplay

- **Ziel:** Klicke auf die herunterfallenden Noten, bevor sie den Boden erreichen.  
- **Jede getroffene Note** bringt Punkte.  
- **Verpasst du eine Note**, ist das Spiel vorbei.  
- Die **Tageszeit** wechselt automatisch zwischen Tag und Nacht.  
- Die **Welt verändert sich** dynamisch mit Himmel, Sonne, Mond, Bäumen und Blumen – alles direkt in Processing gezeichnet.

---

## 🧠 Features

✅ Handgezeichneter Hintergrund (Sonne, Mond, Wolken, Blumen, Bäume)  
✅ Dynamischer Tag-Nacht-Wechsel  
✅ Klickbare Noten mit zufälligen Farben  
✅ Punktesystem  
✅ Game-Over-Bildschirm  
✅ Komplett **ohne externe Bilder**  

---

## ⚙️ Installation & Start

1. Lade **Processing** herunter und öffne es:  
   👉 [https://processing.org/download/](https://processing.org/download/)

2. Erstelle einen neuen Sketch-Ordner, z. B.:  
   ```
   KkMusicGame/
   ```

3. Erstelle **zwei Tabs**:
   - `KkMusicGame.pde` → Hauptcode  
   - `Note.pde` → Noten-Klasse  

4. Füge den Code aus der Anleitung hier ein.  
5. Stelle sicher, dass oben rechts in der IDE **„Java“** ausgewählt ist.  
6. Klicke auf ▶️ **Run**.

---

## 🪄 Steuerung

| Aktion             | Beschreibung                    |
|--------------------|----------------------------------|
| 🖱️ Mausklick        | Triff eine Note                 |
| ⏰ Automatisch      | Tag/Nacht wechselt alle 10 Sek. |
| ❌ Verpass Note     | Spiel endet                     |

---

## 🧩 Fehlerbehebung

| Problem | Lösung |
|----------|---------|
| `color` wird nicht erkannt | Stelle sicher, dass du im **Java Mode** bist. Falls nötig, ersetze `color` durch `int`. |
| „The class Note does not exist“ | Überprüfe, dass dein zweiter Tab **Note.pde** heißt und im selben Ordner ist. |
| „Cannot find a class or type named intr“ | Wahrscheinlich Tippfehler. Achte auf korrekte Schreibweise von `int`. |

---

## 🌈 Erweiterungsideen

- 🎵 **Soundeffekte** mit der `Minim`-Library  
- 🌦️ **Echtzeit-Wetter & Tageszeit** per `hour()` und `minute()`  
- 🌳 **Animierte Natur** (bewegte Wolken, Vögel)  
- 🎶 **Mehrere Level** mit unterschiedlicher Notengeschwindigkeit  
- 💥 **Effekte** beim Treffen/Verpassen einer Note  

---

## 👨‍💻 Autor

Projekt erstellt von **David**  
Mit Unterstützung von ChatGPT (Prompt Engineering & Processing Code).  

---

## 📜 Lizenz

Dieses Projekt ist frei zu Lernzwecken verwendbar.  
Bitte nenne den Urheber, wenn du es weiterverwendest oder veröffentlichst.
