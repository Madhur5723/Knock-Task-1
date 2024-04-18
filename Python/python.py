import requests
from bs4 import BeautifulSoup
import csv
 
def scrape_weather(url):
    # Send a GET request to the URL
    response = requests.get(url)
    
    # Parse the HTML content using BeautifulSoup
    soup = BeautifulSoup(response.text, 'html.parser')

    weather_data = []
    for forecast in soup.find_all('div', class_='DetailsSummary--DetailsSummary--1DqhO DetailsSummary--fadeOnOpen--KnNyF'):
        date = forecast.find('h3', class_='DetailsSummary--daypartName--kbngc').text.strip()
        temperature = forecast.find('span', class_='DetailsSummary--highTempValue--3PjlX').text.strip()
        condition = forecast.find('span', class_='DetailsSummary--extendedData--307Ax').text.strip()
        
        # Store the data in a dictionary
        weather_data.append({'Date': date, 'Temperature': temperature, 'Condition': condition})
 
    return weather_data
 
def save_to_csv(data, filename):
    
    field_names = ['Date', 'Temperature', 'Condition']
    
    # Write the data to a CSV file
    with open(filename, 'w', newline='') as csvfile:
        writer = csv.DictWriter(csvfile, fieldnames=field_names)
        writer.writeheader()
        for item in data:
            writer.writerow(item)
 
if __name__ == "__main__":
    # below url of the website
    weather_url = "https://weather.com/en-IN/weather/tenday/l/INKA0344:1:IN"
    
    # Scrape weather data
    weather_data = scrape_weather(weather_url)
    
    # Saveing the data of websiTe to the CSV file
    save_to_csv(weather_data, 'weather_forecast.csv')