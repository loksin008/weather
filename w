#!/bin/bash

# API Key from OpenWeatherMap
API_KEY="f750e5d21b5d7c2414fac20f3183071f"

# API URL
API_URL="https://openweathermap.org/api/one-call-3"

# List of cities in Uttar Pradesh (you can add more cities if needed)
CITIES=("Agra" "Aligarh" "Allahabad" "Ambedkar Nagar" "Amroha" "Auraiya" "Azamgarh" "Baghpat" "Bahraich" "Balia" "Balrampur" "Banda" "Barabanki" "Bareilly" "Bijnor" "Budaun" "Bulandshahr" "Chandauli" "Chitrakoot" "Deoria" "Etah" "Etawah" "Farrukhabad" "Fatehpur" "Firozabad" "Gautam Buddh Nagar" "Ghazipur" "Gonda" "Hamirpur" "Hapur" "Hardoi" "Hathras" "Jalaun" "Jaunpur" "Jhansi" "Kannauj" "Kanpur" "Kushinagar" "Lakhimpur Kheri" "Lalitpur" "Lucknow" "Mau" "Meerut" "Mirzapur" "Moradabad" "Muzaffarnagar" "Pratapgarh" "Raebareli" "Rampur" "Saharanpur" "Sant Kabir Nagar" "Shahjahanpur" "Shravasti" "Sultanpur" "Unnao" "Varanasi")

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
