
//
//  WeatherAPI.swift
//  Weather
//
//  Created by Nikki L on 5/30/23.
// This file contains func to handle 2 openWeather API request/ response. Response completion handler returned to Search VC where they are called.

import Foundation

class WeatherAPI {
    // Get Weather By CITY or Coordinate - same base URL
    private static let baseURL = "https://api.openweathermap.org/data/2.5/"
    private static let apiKey = "b86136c3d60999452b8b88b84e2a169a"
    
    // MARK: - Get Weather By CITY
    func getWeatherInfo(city: String, completion: @escaping (WeatherData?, Error?) -> Void) {
        let cityEncoded = city.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? city
        // it replaces certain characters with percent-encoded characters - %20 (=space)
        let weatherURLString = "\(WeatherAPI.baseURL)weather?q=\(cityEncoded)&appid=\(WeatherAPI.apiKey)"
        
        guard let weatherURL = URL(string: weatherURLString) else {
            // handle error
            print("Invalid URL")
            completion(nil, nil)
            return
        }
        performRequest(with: weatherURL, completion: completion)
    }
    
    
    // MARK: - Get Weather by user's LOCATION (lat, Lon)
    func getCityFromCoordinates(latitude: Double, longitude: Double, completion: @escaping (WeatherData?, Error?) -> Void) {
        let weatherURLString = "\(WeatherAPI.baseURL)weather?lat=\(latitude)&lon=\(longitude)&appid=\(WeatherAPI.apiKey)"
        
        guard let weatherURL = URL(string: weatherURLString) else {
            print("Invalid URL")
            completion(nil, nil)
            return
        }
        performRequest(with: weatherURL, completion: completion)
    }
    
    // MARK: - Reusable func
    private func performRequest(with url: URL, completion: @escaping (WeatherData?, Error?) -> Void) {
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            } else if let data = data {
                print("data before JSON decoding is \(data)")
                let decoder = JSONDecoder()
                do {
                    let weatherData = try decoder.decode(WeatherData.self, from: data)
                    DispatchQueue.main.async {
                        completion(weatherData, nil)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
    }
}
    
    /*
     By City
     https://api.openweathermap.org/data/2.5/weather?q=london&appid=b86136c3d60999452b8b88b84e2a169a
     By Coordinate
     "https://api.openweathermap.org/data/2.5/weather?lat=44.34&lon=10.99&appid=b86136c3d60999452b8b88b84e2a169a"
     Get IconImage
     https://openweathermap.org/img/wn/10d@2x.png
     
     
     */
