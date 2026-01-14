"""
Weather Fetcher
Gets current temperature and weather conditions for validated location
using OpenWeatherMap API
"""
import os
import sys
import requests
from datetime import datetime

def fetch_weather():
    """
    Fetch weather data from OpenWeatherMap API
    
    Returns:
        Boolean indicating success
    """
    
    # Read validated location from previous stage
    try:
        with open('validated_location.txt', 'r') as f:
            location_data = f.read().strip().split(',')
            lat, lon = location_data[0], location_data[1]
            location_name = ','.join(location_data[2:])
    except FileNotFoundError:
        print("❌ ERROR: validated_location.txt not found")
        print("   Make sure the validate_location job ran successfully")
        sys.exit(1)
    
    # Get API key and units from environment
    api_key = os.environ.get('WEATHER_API_KEY')
    units = os.environ.get('WEATHER_UNITS', 'metric')
    
    if not api_key:
        print("❌ ERROR: WEATHER_API_KEY not set")
        print("   Add it in Settings → CI/CD → Variables")
        sys.exit(1)
    
    # Prepare API request
    url = f"https://api.openweathermap.org/data/2.5/weather"
    params = {
        'lat': lat,
        'lon': lon,
        'appid': api_key,
        'units': units
    }
    
    print(f"🌤️  Fetching weather for: {location_name}")
    print(f"   Coordinates: {lat}, {lon}")
    print(f"   Units: {units}")
    
    try:
        response = requests.get(url, params=params, timeout=10)
        response.raise_for_status()
        data = response.json()
        
        # Extract weather information
        temp = data['main']['temp']
        feels_like = data['main']['feels_like']
        humidity = data['main']['humidity']
        description = data['weather'][0]['description']
        wind_speed = data['wind']['speed']
        
        # Determine unit symbol
        if units == 'metric':
            temp_unit = '°C'
            speed_unit = 'm/s'
        elif units == 'imperial':
            temp_unit = '°F'
            speed_unit = 'mph'
        else:  # kelvin
            temp_unit = 'K'
            speed_unit = 'm/s'
        
        print(f"\n✅ Weather data retrieved successfully!")
        print(f"   Temperature: {temp}{temp_unit}")
        print(f"   Feels like: {feels_like}{temp_unit}")
        print(f"   Conditions: {description}")
        print(f"   Humidity: {humidity}%")
        print(f"   Wind: {wind_speed} {speed_unit}")
        
        # Save weather data for next stage
        timestamp = datetime.utcnow().strftime('%Y-%m-%d %H:%M:%S UTC')
        with open('weather_data.txt', 'w') as f:
            f.write(f"{location_name}\n")
            f.write(f"{temp}\n")
            f.write(f"{feels_like}\n")
            f.write(f"{description}\n")
            f.write(f"{humidity}\n")
            f.write(f"{wind_speed}\n")
            f.write(f"{temp_unit}\n")
            f.write(f"{speed_unit}\n")
            f.write(f"{timestamp}\n")
        
        return True
        
    except requests.exceptions.RequestException as e:
        print(f"❌ Error fetching weather: {str(e)}")
        if response.status_code == 401:
            print("   Check if your WEATHER_API_KEY is valid")
        sys.exit(1)

if __name__ == "__main__":
    fetch_weather()
