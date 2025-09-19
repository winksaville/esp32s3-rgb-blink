# rgb_blink

Authors: [Wink Saville <wink@saville.com>, ChatGPT]

Blink the RGB LED on an ESP32 S3 DevKitC.

## Install and Run

* Install Arduino IDE from https://www.arduino.cc/en/software
* Install the ESP32 board support in Arduino IDE:
   - Open Arduino IDE
   - Go to File > Preferences
   - In the "Additional Board Manager URLs" field, add the following URL:
     ```
     https://raw.githubusercontent.com/espressif/arduino-esp32/gh-pages/package_esp32_index.json
     ```
   - Click "OK"
   - Go to Tools > Board > Boards Manager
   - Search for "esp32" and install the "esp32" package by Espressif Systems
* Connect your ESP32 S3 DevKitC to your computer via the UART USB port.
* Add the Adafruit NeoPixel library to Arduino IDE:
   - Go to Sketch > Include Library > Manage Libraries
   - Search for "Adafruit NeoPixel"
   - Install the latest version of the library by Adafruit
* Download or clone this repository to your computer and navigate into the directory.
```
 git clone https://github.com/winksaville/esp32s3-rgb-blink.git rgb_blink
 cd rgb_blink
```
* Open this sketch in Arduino IDE, from the command line you pass the
  directory containing the rgb_blink.ino file. For example:
  ```
  arduino-ide_2.3.6_Linux_64bit.AppImage rgb_blink
  ```
* Select the correct board and port in Arduino IDE:
   - Go to Tools > Board and select "ESP32S3 Dev Module"
   - Go to Tools > Port and select the port corresponding to your ESP32 S3 DevKit on my computer it is /dev/ttyUSB0.
 * Upload the sketch by clicking the upload button (right arrow icon) in Arduino IDE or `Menu -> Tools -> Upload` or `Ctrl+U`.
 * Open the Serial Monitor in Arduino IDE by clicking the magnifying glass icon in the top right corner or `Menu -> Tools -> Serial Monitor` or `Ctrl+Shift+M`.
 * Set the baud rate to 115200 in the Serial Monitor.
 * You should see the RGB LED on the ESP32 S3 DevKitC blinking red, green, blue, off in sequence.
   and on the serial monitor you should see the messages indicating the LED color changes and the
   time.

## arduion-cli

Added support for arduino-cli via a Makefile and you can init, compile, upload, list, monitor and
clean from the command line.

## License

Licensed under either of

- Apache License, Version 2.0 ([LICENSE-APACHE](LICENSE-APACHE) or http://apache.org/licenses/LICENSE-2.0)
- MIT license ([LICENSE-MIT](LICENSE-MIT) or http://opensource.org/licenses/MIT)

### Contribution

Unless you explicitly state otherwise, any contribution intentionally submitted
for inclusion in the work by you, as defined in the Apache-2.0 license, shall
be dual licensed as above, without any additional terms or conditions.
