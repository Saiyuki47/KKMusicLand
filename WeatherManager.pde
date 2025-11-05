class WeatherManager {
  private WeatherAPI api;
  String condition = "sunny";
  float temperature = 20.0;
  float cloudCover = 0.0;
  WeatherManager() {
    api = new WeatherAPI();
    updateWeather();
  }
  void setLocation(float lat, float lon) {
    api.setLocation(lat, lon);
  }
  void updateWeather() {
    try {
      int code = api.getWeatherCode();
      temperature = api.getTemperature();
      cloudCover = api.getCloudCover();
      condition = mapWeatherCode(code);
      println("Weather: " + condition + ", " + nf(temperature,0,1) + "C, cloud=" + int(cloudCover*100) + "%");
    } catch (Exception e) {
      println("WeatherManager update error: " + e.getMessage());
    }
  }
  String mapWeatherCode(int code) {
    if (code == 0) return "sunny";
    if (code >= 95) return "thunderstorm";
    if (code >= 80) return "rain";
    if (code >= 71) return "snow";
    if (code >= 61) return "rain";
    if (code >= 51) return "drizzle";
    if (code >= 45) return "fog";
    if (code >= 1) return "partly_cloudy";
    return "unknown";
  }
}
