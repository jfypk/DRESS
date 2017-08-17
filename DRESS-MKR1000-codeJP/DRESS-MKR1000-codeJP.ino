#include <WiFi101.h>
#include <WiFiClient.h>
#include <WiFiServer.h>
#include <WiFiSSLClient.h>
#include <WiFiUdp.h>
 
#include <SPI.h>
#include <WiFi101.h>
 
char ssid[] = "02mini";      //  your network SSID (name)
char pass[] = "yourNetworkPassword";   // your network password
int keyIndex = 0;                 // your network key Index number (needed only for WEP)
int ledpin = 6;
bool val = true;

int LEDpin1 = 5;
int LEDpin2 = 4;
int LEDpin3 = 3;
int LEDpin4 = 2;

 
int status = WL_IDLE_STATUS;
WiFiServer server(80);
 
void setup() {
  Serial.begin(9600);      // initialize serial communication
  Serial.print("Start Serial ");
  pinMode(ledpin, OUTPUT);      // set the LED pin mode
  // Check for the presence of the shield
  Serial.print("WiFi101 shield: ");
  if (WiFi.status() == WL_NO_SHIELD) {
    Serial.println("NOT PRESENT");
    return; // don't continue
  }
  Serial.println("DETECTED");
  // attempt to connect to Wifi network:
  while ( status != WL_CONNECTED) {
    digitalWrite(ledpin, LOW);
    Serial.print("Attempting to connect to Network named: ");
    Serial.println(ssid);                   // print the network name (SSID);
    digitalWrite(ledpin, HIGH);
    // Connect to WPA/WPA2 network. Change this line if using open or WEP network:
    status = WiFi.begin(ssid);
    // wait 10 seconds for connection:
    delay(10000);
  }
  server.begin();                           // start the web server on port 80
  printWifiStatus();                        // you're connected now, so print out the status
  digitalWrite(ledpin, HIGH);
}
void loop() {
  WiFiClient client = server.available();   // listen for incoming clients
 
  if (client) {                             // if you get a client,
    Serial.println("new client");           // print a message out the serial port
    String currentLine = "";                // make a String to hold incoming data from the client
    while (client.connected()) {            // loop while the client's connected
      if (client.available()) {             // if there's bytes to read from the client,
        char c = client.read();             // read a byte, then
        Serial.write(c);                    // print it out the serial monitor
        if (c == '\n') {                    // if the byte is a newline character
 
          // if the current line is blank, you got two newline characters in a row.
          // that's the end of the client HTTP request, so send a response:
          if (currentLine.length() == 0) {
            // HTTP headers always start with a response code (e.g. HTTP/1.1 200 OK)
            // and a content-type so the client knows what's coming, then a blank line:
            client.println("HTTP/1.1 200 OK");
            client.println("Content-type:text/html");
            client.println();
 
            // the content of the HTTP response follows the header:
            client.print("Click <a href=\"/H\">here</a> turn the LED on pin 6 on<br>");
            client.print("Click <a href=\"/L\">here</a> turn the LED on pin 6 off<br>");
 
            // The HTTP response ends with another blank line:
            client.println();
            // break out of the while loop:
            break;
          }
          else {      // if you got a newline, then clear currentLine:
            currentLine = "";
          }
        }
        else if (c != '\r') {    // if you got anything else but a carriage return character,
          currentLine += c;      // add it to the end of the currentLine
        }
 
        // Check to see if the client request was "GET /H" or "GET /L":
        if (currentLine.endsWith("GET /SHIRT")) {
          // GET /SHIRT turns the top shelf LEDs green. All others red. 
          //PSEUDOCODE:
          //turn top shelf iPixels green
          //turn the rest off
          Serial.println("SHIRT BUTTON PRESSED");
        }
        if (currentLine.endsWith("GET /PANTS")) {
          // GET /PANTS turns the 2nd shelf LEDs green. All others red. 
          //PSEUDOCODE:
          //turn 2nd shelf iPixels green
          //turn the rest off
          Serial.println("PANTS BUTTON PRESSED");
        }
        if (currentLine.endsWith("GET /SOCKS")) {
          // GET /SOCKS turns the 3rd shelf LEDs green. All others red.
          //PSEUDOCODE:
          //turn 3rd shelf iPixels green
          //turn the rest off 
          Serial.println("SOCKS BUTTON PRESSED");
        }
        if (currentLine.endsWith("GET /SHOES")) {
          // GET /SHOES turns the 4th shelf LEDs green. All others red. 
          //PSEUDOCODE:
          //turn 4th shelf iPixels green
          //turn the rest off
          Serial.println("SHOES BUTTON PRESSED");
        }
      }
    }
    // close the connection:
    client.stop();
    Serial.println("client disonnected");
  }
}
 
void printWifiStatus() {
  // print the SSID of the network you're attached to:
  Serial.print("SSID: ");
  Serial.println(WiFi.SSID());
 
  // print your WiFi shield's IP address:
  IPAddress ip = WiFi.localIP();
  Serial.print("IP Address: ");
  Serial.println(ip);
 
  // print the received signal strength:
  long rssi = WiFi.RSSI();
  Serial.print("signal strength (RSSI):");
  Serial.print(rssi);
  Serial.println(" dBm");
  // print where to go in a browser:
  Serial.print("To see this page in action, open a browser to http://");
  Serial.println(ip);
}
