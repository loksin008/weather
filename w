#!/bin/bash

# API Key from OpenWeatherMap
API_KEY="f750e5d21b5d7c2414fac20f3183071f"

# API URL
API_URL="https://home.openweathermap.org/api_keys"

# List of popular cities in India
CITIES=("Bahraich" "Mumbai" "Delhi" "Bangalore" "Chennai" "Kolkata" "Hyderabad" "Ahmedabad" "Pune" "Jaipur" "Surat" "Lucknow" "Kanpur" "Nagpur" "Indore" "Patna" "Vadodara")

# Display list of cities for the user to select
echo "Select a city from the list:"
for i in "${!CITIES[@]}"; do
  echo "$((i+1)). ${CITIES[i]}"
done

# Get user input for city selection
read -p "Enter the number corresponding to your city: " CITY_INDEX

# Validate city index
if [[ "$CITY_INDEX" -lt 1 || "$CITY_INDEX" -gt ${#CITIES[@]} ]]; then
  echo "Invalid selection. Exiting."
  exit 1
fi

# Get the selected city
CITY="${CITIES[$((CITY_INDEX-1))]}"

# Fetch weather data using curl
RESPONSE=$(curl -s "$API_URL?q=$CITY,IN&appid=$API_KEY&units=metric")

# Check if the city exists in the response (error handling)
CITY_NAME=$(echo $RESPONSE | jq -r '.name')
if [ "$CITY_NAME" == "null" ]; then
  echo "Error: Could not fetch weather data for $CITY. Please check the city name and try again."
  exit 1
fi

# Extract relevant data using jq
TEMP=$(echo $RESPONSE | jq '.main.temp')
DESCRIPTION=$(echo $RESPONSE | jq -r '.weather[0].description')
HUMIDITY=$(echo $RESPONSE | jq '.main.humidity')
WIND_SPEED=$(echo $RESPONSE | jq '.wind.speed')
COUNTRY=$(echo $RESPONSE | jq -r '.sys.country')

# Display weather information
echo "Weather in $CITY_NAME, $COUNTRY:"
echo "Temperature: $TEMP°C"
echo "Description: $DESCRIPTION"
echo "Humidity: $HUMIDITY%"
echo "Wind Speed: $WIND_SPEED m/s"
