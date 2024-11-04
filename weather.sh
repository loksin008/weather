#!/bin/bash

# Define variables
API_KEY="your_api_key"  # Replace with your OpenWeatherMap API key
CITY="your_city"         # Replace with your desired city
URL="http://api.openweathermap.org/data/2.5/weather?q=$CITY&appid=$API_KEY&units=metric"

# Fetch weather data
response=$(curl -s $URL)

# Check if the response is successful
if [[ $(echo $response | jq -r '.cod') -ne 200 ]]; then
    echo "Failed to retrieve weather data."
    exit 1
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
