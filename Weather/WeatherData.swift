//
//  WeatherData.swift
//  Weather
//
//  Created by Nikki L on 5/30/23.
// This holds weather data that I decided to show from the API response.
// add icon as well


import Foundation

// MARK: - For storing user's location if they choose
struct Coordinate: Codable {
    let lon: Double?
    let lat: Double?
}

// Weather each has its property - 1 city can have >1 Weather Object
struct Weather: Codable {
    let id: Int?
    let main: String?   // yes
    let description: String?  // yes
    let icon: String?   // yes
    
    // depends on response on what icon we need to retrive with API
    // unwrap icon, otherwise, it has optional(03d) instead of "03d"
    var iconURL: URL? {
        guard let iconValue = icon, let url = URL(string: "https://openweathermap.org/img/wn/\(iconValue)@2x.png") else {
        return nil
        }
    return url
    }
}

struct Main: Codable {
    let temp: Double?      // yes
    let feelsLike: Double? // yes
    let tempMin: Double? // yes
    let tempMax: Double? // yes
    let pressure: Int?
    let humidity: Int?     // yes
    
    
    // follow Swift's naming convention
    enum CodingKeys: String, CodingKey {
       case temp
       case feelsLike = "feels_like"
       case tempMin = "temp_min"
       case tempMax = "temp_max"
       case pressure
       case humidity
   }
}

struct Clouds: Codable {
    let all: Int?
}

struct Sys: Codable {
    let type: Int?
    let id: Int?
    let country: String?
    let sunrise: Int?
    let sunset: Int?
}

struct Wind: Codable {
    let speed: Double? // yes
    let deg: Int?
}

// API response
struct WeatherData: Codable {
    let weather: [Weather] // 1 city can have >1 weather info - place them all in an array -> @weatherVC -> let firstWeather = weatherData.weather.first
    let coord: Coordinate
    let base: String?
    let main: Main
    let visibility: Int?
    let wind: Wind
    let clouds: Clouds // as cloud has >1 attributes, so we create a struct called Cloud to hold its attributes
    let dt: Int?
    let sys: Sys?      // yes -> no change my mind
    let timezone: Int?
    let id: Int?
    let name: String?
    let cod: Int?
}
    

// ultilize Postman API console, to help construct the data model
// Postman API console:
// WEATHER :
/*
https://api.openweathermap.org/data/2.5/weather?q=truckee&appid=b86136c3d60999452b8b88b84e2a169a
sample response:
list > weather > two sections
"weather": [
{
"id": 701,
"main": "Mist",
"description": "mist",
"icon": "50d"
},
{
"id": 300,
"main": "Drizzle",
"description": "light intensity drizzle",
"icon": "09d"
}
]

*/

// ICONS: get icon: read "weather" array, and for loop, get icon's value from the array.
/* "50d", "09d"
call this API to download and cache the icon
https://openweathermap.org/img/wn/10d@2x.png
https://openweathermap.org/img/wn/<value>@2x.png
*/
