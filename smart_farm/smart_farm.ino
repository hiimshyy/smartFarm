/*
  Title: Control your Arduino IoT projects with a MongoDB database
  Author: donsky (www.donskytech.com)
*/
#include <Arduino.h>
#include <HTTPClient.h>
#include <ArduinoJson.h>
#include "DHT.h"
//#include <Wifi.h>

// SSID and Password
const char *ssid = "vivo Y21";
const char *password = "1111aaaa";

/**** NEED TO CHANGE THIS ACCORDING TO YOUR SETUP *****/
// The REST API endpoint - Change the IP Address
const char *base_rest_url = "http://192.168.96.41:5000/";

//const char *base_rest_url = "http://10.132.7.48:5000/";

WiFiClient client;
HTTPClient http;

// Read interval
unsigned long previousMillis = 0;
const long readInterval = 5000;
// LED Pin
const int pump = 0;
const int light = 19;
// button pin
const int bt_pump = 2 ;
const int bt_light = 16;

struct LED
{
  char sensor_id[10];
  char status[10];
};

// DHT Object ID
char dhtObjectId[30];
#define DHTPIN 32 // Digital pin connected to the DHT sensor
#define DHTTYPE DHT11 
DHT dht(DHTPIN, DHTTYPE);
struct DHT11Readings
{
  float temperature;
  float humidity;
};

// mq2 Object ID & data
char mq2ObjectId[30];
float readingGas;

// Size of the JSON document. Use the ArduinoJSON JSONAssistant
const int JSON_DOC_SIZE = 384;
// HTTP GET Call
StaticJsonDocument<JSON_DOC_SIZE> callHTTPGet(const char *sensor_id)
{
  char rest_api_url[200];
  // Calling our API server
  sprintf(rest_api_url, "%sapi/sensor?sensor_id=%s", base_rest_url, sensor_id);
  Serial.println(rest_api_url);

  http.useHTTP10(true);
  http.begin(client, rest_api_url);
  http.addHeader("Content-Type", "application/json");
  http.GET();

  StaticJsonDocument<JSON_DOC_SIZE> doc;
  // Parse response
  DeserializationError error = deserializeJson(doc, http.getStream());

  if (error)
  {
    Serial.print("deserializeJson() failed: ");
    Serial.println(error.c_str());
    return doc;
  }

  http.end();
  return doc;
}
// Extract LED records
LED extractLEDConfiguration(const char *sensor_id)
{
  StaticJsonDocument<JSON_DOC_SIZE> doc = callHTTPGet(sensor_id);
  if (doc.isNull() || doc.size() > 1)
    return {}; // or LED{}
  for (JsonObject item : doc.as<JsonArray>())
  {

    const char *sensorId = item["sensor_id"];      // "led_1"
    const char *status = item["status"];           // "HIGH"

    LED ledTemp = {};
    strcpy(ledTemp.sensor_id, sensorId);
    strcpy(ledTemp.status, status);

    return ledTemp;
  }
  return {}; // or LED{}
}

// Send DHT11 readings using HTTP PUT
void sendDHT11Readings(const char *objectId, DHT11Readings dhtReadings)
{
  char rest_api_url[200];
  // Calling our API server
  sprintf(rest_api_url, "%sapi/sensor/%s", base_rest_url, objectId);
  Serial.println(rest_api_url);

  // Prepare our JSON data
  String jsondata = "";
  StaticJsonDocument<JSON_DOC_SIZE> doc;
  JsonObject readings = doc.createNestedObject("readings");
  readings["temperature"] = dhtReadings.temperature;
  readings["humidity"] = dhtReadings.humidity;

  serializeJson(doc, jsondata);
  Serial.println("JSON Data...");
  Serial.println(jsondata);

  http.begin(client, rest_api_url);
  http.addHeader("Content-Type", "application/json");

  // Send the PUT request
  int httpResponseCode = http.PUT(jsondata);
  if (httpResponseCode > 0)
  {
    String response = http.getString();
    Serial.println(httpResponseCode);
    Serial.println(response);
  }
  else
  {
    Serial.print("Error on sending POST: ");
    Serial.println(httpResponseCode);
    http.end();
  }
}

// Get DHT11 ObjectId
void getDHT11ObjectId(const char *sensor_id)
{
  StaticJsonDocument<JSON_DOC_SIZE> doc = callHTTPGet(sensor_id);
  if (doc.isNull() || doc.size() > 1)
    return;
  for (JsonObject item : doc.as<JsonArray>())
  {
    Serial.println(item);
    const char *objectId = item["_id"]["$oid"]; // "dht11_1"
    strcpy(dhtObjectId, objectId);

    return;
  }
  return;
}

// Read DHT11 sensor
DHT11Readings readDHT11()
{
  // Reading temperature or humidity takes about 250 milliseconds!
  // Sensor readings may also be up to 2 seconds 'old' (its a very slow sensor)
  float humidity = dht.readHumidity();
  // Read temperature as Celsius (the default)
  float temperatureInC = dht.readTemperature();
  // // Read temperature as Fahrenheit (isFahrenheit = true)
  // float temperatureInF = dht.readTemperature(true);

  return {temperatureInC, humidity};
}
// Convert HIGH and LOW to Arduino compatible values
int convertStatus(const char *value)
{
  if (strcmp(value, "HIGH") == 0)
  {
    Serial.println("Setting LED to HIGH");
    return HIGH;
  }
  else
  {
    Serial.println("Setting LED to LOW");
    return LOW;
  }
}
// Set our LED status
void setLEDStatus(int pin, int status)
{
  Serial.printf("Setting LED status to : %d", status);
  Serial.println("");
  digitalWrite(pin, status);
}

// Get Gas ObjectId
void getGasObjectId(const char *sensor_id)
{
  StaticJsonDocument<JSON_DOC_SIZE> doc = callHTTPGet(sensor_id);
  if (doc.isNull() || doc.size() > 1)
    return;
  for (JsonObject item : doc.as<JsonArray>())
  {
    Serial.println(item);
    const char *objectId = item["_id"]["$oid"]; // ObjectId of the gas document in MongoDB
    strcpy(mq2ObjectId, objectId);

    return;
  }
  return;
}

// Send Gas readings using HTTP PUT
void sendGasReadings(const char *objectId, int gasReading)
{
  char rest_api_url[200];
  // Calling our API server
  sprintf(rest_api_url, "%sapi/sensor/%s", base_rest_url, objectId);
  Serial.println(rest_api_url);

  // Prepare our JSON data
  String jsondata = "";
  StaticJsonDocument<JSON_DOC_SIZE> doc;
  doc["readingGas"] = gasReading;

  serializeJson(doc, jsondata);
  Serial.println("JSON Data for Gas...");
  Serial.println(jsondata);

  http.begin(client, rest_api_url);
  http.addHeader("Content-Type", "application/json");

  // Send the PUT request
  int httpResponseCode = http.PUT(jsondata);
  if (httpResponseCode > 0)
  {
    String response = http.getString();
    Serial.println(httpResponseCode);
    Serial.println(response);
  }
  else
  {
    Serial.print("Error on sending POST: ");
    Serial.println(httpResponseCode);
    http.end();
  }
}

void setup()
{
  Serial.begin(115200);
  for (uint8_t t = 2; t > 0; t--)
  {
    Serial.printf("[SETUP] WAIT %d...\n", t);
    Serial.flush();
    delay(1000);
  }

  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED)
  {
    delay(100);
    Serial.print(".");
  }

  Serial.println("");
  Serial.println("WiFi connected");
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());
  //  Start DHT Sensor readings
  dht.begin();
  //  Get the ObjectId of the DHT22 sensor
  getDHT11ObjectId("dht22_1");
  // Setup LED
  pinMode(pump, OUTPUT);
  pinMode(light, OUTPUT);
  //setup button
  pinMode(bt_pump, INPUT);
  pinMode(bt_light, INPUT);

  getGasObjectId("mq2");

}

void loop()
{
  //value from mq-2
  int val_gas = analogRead(39);
  int percentage = map(val_gas, 0, 4095, 0, 100);

  unsigned long currentMillis = millis();

  if (currentMillis - previousMillis >= readInterval)
  {
    // save the last time
    previousMillis = currentMillis;

    Serial.println("---------------");
    // Read our configuration for our LED
    LED pump1Setup = extractLEDConfiguration("pump1");
    Serial.println(pump1Setup.sensor_id);
    Serial.println(pump1Setup.status);
    setLEDStatus(pump,convertStatus(pump1Setup.status)); // Set pump value

    LED light1Setup = extractLEDConfiguration("light1");
    Serial.println(light1Setup.sensor_id);
    Serial.println(light1Setup.status);
    setLEDStatus(light,convertStatus(light1Setup.status)); // Set light value

    Serial.println("---------------");
    // Send our DHT11 sensor readings
    // Locate the ObjectId of our DHT11 document in MongoDB
    Serial.println("Sending latest DHT11 readings");
    DHT11Readings readings = readDHT11();
    // Check if any reads failed and exit early (to try again).
    if (isnan(readings.humidity) || isnan(readings.temperature))
    {
      Serial.println(F("Failed to read from DHT sensor!"));
      return;
    }

    Serial.print("Temperature :: ");
    Serial.println(readings.temperature);
    Serial.print("Humidity :: ");
    Serial.println(readings.humidity);
    sendDHT11Readings(dhtObjectId, readings);

    Serial.print("Gas: ");
    Serial.println(percentage);

    sendGasReadings(mq2ObjectId, percentage);
  }
}
