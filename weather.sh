#!/bin/bash

# Define variables
API_KEY="f750e5d21b5d7c2414fac20f3183071f"  
CITY="lucknow"   
URL="http://api.openweathermap.org/data/2.5/weather?q=$CITY&appid=$API_KEY&units=metric"

# Fetch weather data
response=$(curl -s $URL)


if [[ $(echo $response | jq -r '.cod') -ne 200 ]]; then
    echo "Failed to retrieve weather data lokesh."
    exit 
fi

# Parse the JSON response
temperature=$(echo $response | jq -r '.main.temp')
weather_description=$(echo $response | jq -r '.weather[0].description')
humidity=$(echo $response | jq -r '.main.humidity')
wind_speed=$(echo $response | jq -r '.wind.speed')

# Output the weather information
echo "Weather update for $CITY:"
echo "Temperature: $temperature°C"
echo "Condition: $weather_description"
echo "Humidity: $humidity%"
echo "Wind Speed: $wind_speed m/s"
