"""
Location Validator
Checks if the provided location is valid using geopy geocoding service
"""
import os
import sys
from geopy.geocoders import Nominatim

def validate_location(location):
    """
    Validate location using Nominatim geocoder
    
    Args:
        location: String with city name or address
        
    Returns:
        Boolean indicating if location is valid
    """
    print(f"🌍 Validating location: {location}")
    
    # Initialize geocoder with a custom user agent
    geolocator = Nominatim(user_agent="gitlab-weather-app")
    
    try:
        # Try to geocode the location
        result = geolocator.geocode(location, timeout=10)
        
        if result:
            print(f"✅ Valid location found!")
            print(f"   Full name: {result.address}")
            print(f"   Coordinates: {result.latitude}, {result.longitude}")
            
            # Save validated location data for next stage
            with open('validated_location.txt', 'w') as f:
                f.write(f"{result.latitude},{result.longitude},{result.address}\n")
            
            return True
        else:
            print(f"❌ Invalid location: '{location}' could not be found")
            print(f"   Try using format: 'City, Country' (e.g., 'London, UK')")
            return False
            
    except Exception as e:
        print(f"❌ Error validating location: {str(e)}")
        return False

if __name__ == "__main__":
    location = os.environ.get('LOCATION', '')
    
    if not location:
        print("ERROR: LOCATION variable not set")
        sys.exit(1)
    
    if validate_location(location):
        print("\n✅ Location validation passed!")
        sys.exit(0)
    else:
        print("\n❌ Location validation failed!")
        sys.exit(1)
