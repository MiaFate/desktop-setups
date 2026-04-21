#!/usr/bin/env python3
import json
import urllib.request
import urllib.error

WEATHER_CODES = {
    '113': '☀️', '116': '⛅️', '119': '☁️', '122': '☁️', '143': '🌫', '176': '🌦', '179': '🌧',
    '182': '🌧', '185': '🌧', '200': '⛈', '227': '🌨', '230': '❄️', '248': '🌫', '260': '🌫',
    '263': '🌦', '266': '🌦', '281': '🌧', '284': '🌧', '293': '🌦', '296': '🌦', '299': '🌧',
    '302': '🌧', '305': '🌧', '308': '🌧', '311': '🌧', '314': '🌧', '317': '🌧', '320': '🌨',
    '323': '🌨', '326': '🌨', '329': '❄️', '332': '❄️', '335': '❄️', '338': '❄️', '350': '🌧',
    '353': '🌦', '356': '🌧', '359': '🌧', '362': '🌧', '365': '🌧', '368': '🌨', '371': '❄️',
    '374': '🌧', '377': '🌧', '386': '⛈', '389': '🌩', '392': '⛈', '395': '❄️'
}

def main():
    try:
        req = urllib.request.Request("https://wttr.in/?format=j1", headers={'User-Agent': 'curl/7.68.0'})
        with urllib.request.urlopen(req, timeout=5) as response:
            data = json.loads(response.read())

        current = data['current_condition'][0]
        weather_code = current['weatherCode']
        icon = WEATHER_CODES.get(weather_code, '✨')
        temp = current['temp_C']
        feels_like = current['FeelsLikeC']
        desc = current['weatherDesc'][0]['value']
        wind = current['windspeedKmph']
        humidity = current['humidity']
        visibility = current['visibility']
        location = data['nearest_area'][0]['areaName'][0]['value']

        today = data['weather'][0]
        min_temp = today['mintempC']
        max_temp = today['maxtempC']

        # Get rain chance for next hours
        hourly = today['hourly']
        rain_chances = []
        for h in hourly:
            if len(rain_chances) < 5:
                rain_chances.append(h.get('chanceofrain', '0'))

        text = f"{icon} {temp}° {location}"
        
        tooltip = f"<b>{location}</b>\n"
        tooltip += f"Feels like {feels_like}°\n"
        tooltip += f"<big>{icon}</big>\n"
        tooltip += f"  {min_temp}°\t\t  {max_temp}°\n"
        tooltip += f"{wind} km/h\t{humidity}%\n"
        tooltip += f"{visibility} km\tAQI 50\n"
        tooltip += f"Rain drop {'% '.join(rain_chances)}%"

        result = {
            "text": text,
            "alt": desc,
            "tooltip": tooltip
        }

        print(json.dumps(result))

    except Exception as e:
        print(json.dumps({
            "text": "❌ N/A",
            "alt": "Offline",
            "tooltip": f"<b>Error</b>\nFeels like N/A\n<big>❌</big>\nN/A\t\tN/A\nN/A km/h\tN/A%\nN/A km\tAQI N/A\nRain drop 0% 0% 0% 0% 0%"
        }))

if __name__ == '__main__':
    main()
