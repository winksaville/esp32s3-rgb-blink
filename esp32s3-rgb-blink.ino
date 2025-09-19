// ***************
// Author Wink Saville <wink@saville.com> and ChatGPT
// ***************

#include <Arduino.h>
#include <Adafruit_NeoPixel.h>

#define RGB_PIN   38    // GPIO for onboard RGB LED
#define NUM_LEDS  1     // only one onboard

Adafruit_NeoPixel pixels(NUM_LEDS, RGB_PIN, NEO_GRB + NEO_KHZ800);

const uint32_t FIRST_COLOR = 0xff0000;

unsigned long current_secs;
unsigned long color_change_time_ms;
unsigned long color_duration_ms = 500;
uint32_t color;

void setup() {
  current_secs = 0;
  color_change_time_ms = millis();
  color = FIRST_COLOR;
  Serial.println("current_secs=0");
  Serial.begin(115200);
  pixels.begin();
  pixels.setBrightness(32);  // lower brightness for testing
}

void loop() {
  if (millis() >= ((current_secs + 1)) * 1000) {
    // Print current second so we see time pass
    current_secs = millis() / 1000;
    Serial.print("current_secs=");
    Serial.println(current_secs);
  }

  if (millis() > (color_change_time_ms + color_duration_ms)) {
    // Time to change the color
    color_change_time_ms += color_duration_ms;
    pixels.setPixelColor(0, color);
    pixels.show();

    // Print the color
    Serial.print("color=0x");
    char buf[9]; // 8 hex digits plus `\0`
    snprintf(buf, sizeof(buf), "%06X", color); // use snprintf for safety
    Serial.println(buf);

    // Wrap around to FIRST COLOR
    if (color == 0) {
      color = FIRST_COLOR;
    } else {
      color >>= 8;
    }
  }
}