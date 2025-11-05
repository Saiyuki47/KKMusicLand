class WeatherAPI {
  // Default location (Berlin)
  private float latitude = 52.52;
  private float longitude = 13.41;

  // Cache
  private JSONObject cached;
  private int lastUpdate = 0;
  private int cacheMs = 10 * 60 * 1000; // 10 minutes

  JSONObject getWeatherData() {
    if (cached == null || millis() - lastUpdate > cacheMs) {
      updateWeatherData();
    }
    return cached;
  }

  void setLocation(float lat, float lon) {
    latitude = lat;
    longitude = lon;
    invalidate();
  }

  void setCacheMinutes(int minutes) {
    cacheMs = max(1, minutes) * 60 * 1000;
  }

  float getTemperature() {
    JSONObject current = getCurrent();
    if (current == null) return 20.0;
    if (current.hasKey("temperature")) return current.getFloat("temperature");
    return 20.0;
  }

  float getCloudCover() {
    JSONObject hourly = getHourly();
    if (hourly == null) return 0.0;
    if (!hourly.hasKey("cloudcover") || !hourly.hasKey("time")) return 0.0;
    JSONArray cover = hourly.getJSONArray("cloudcover");
    JSONArray times = hourly.getJSONArray("time");
    int idx = findCurrentHourIndex(times);
    return constrain(cover.getFloat(idx) / 100.0, 0.0, 1.0);
  }

  int getWeatherCode() {
    JSONObject current = getCurrent();
    if (current == null) return -1;
    if (current.hasKey("weathercode")) return current.getInt("weathercode");
    return -1;
  }

  // --- internals ---
  private void updateWeatherData() {
    String url = String.format(
      "https://api.open-meteo.com/v1/forecast?latitude=%.2f&longitude=%.2f&current_weather=true&hourly=temperature_2m,precipitation_probability,cloudcover",
      latitude, longitude
    );
    try {
      // Try to load as JSON object first
      JSONObject data = null;
      try {
        data = loadJSONObject(url);
      } catch (Exception eObj) {
        // If fails, try to load as array
        JSONArray arr = null;
        try {
          arr = loadJSONArray(url);
        } catch (Exception eArr) {
          arr = null;
        }
        if (arr != null && arr.size() > 0) {
          data = arr.getJSONObject(0);
        }
      }
      if (data != null) {
        cached = data;
        lastUpdate = millis();
      } else {
        println("WeatherAPI error: No valid JSON object returned from API.");
        // Print raw response for debugging
        try {
          String raw = loadStrings(url) != null ? join(loadStrings(url), "\n") : "";
          println("WeatherAPI raw response: " + raw);
        } catch (Exception e2) {
          println("WeatherAPI error loading raw response: " + e2.getMessage());
        }
      }
    } catch (Exception e) {
      println("WeatherAPI error: " + e.getMessage());
    }
  }

  private JSONObject getCurrent() {
    JSONObject data = getWeatherData();
    if (data != null && data.hasKey("current_weather")) {
      return data.getJSONObject("current_weather");
    }
    return null;
  }

  private JSONObject getHourly() {
    JSONObject data = getWeatherData();
    if (data != null && data.hasKey("hourly")) {
      return data.getJSONObject("hourly");
    }
    return null;
  }

  private int findCurrentHourIndex(JSONArray times) {
    String target = String.format("%04d-%02d-%02dT%02d:00", year(), month(), day(), hour());
    for (int i = 0; i < times.size(); i++) {
      if (times.getString(i).startsWith(target)) return i;
    }
    return constrain(hour(), 0, times.size()-1);
  }

  private void invalidate() {
    cached = null;
    lastUpdate = 0;
  }
}
