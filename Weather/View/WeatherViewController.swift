//
//  WeatherViewController.swift
//  Weather
//
//  Created by Nikki L on 5/30/23.
//: This ViewController is responsible for displaying the weather data fetched from the API. This shows the weather data such as temperature, humidity, wind speed etc. AND ICON!! using Kinsgker


import UIKit
import Kingfisher // to fetch and cache image

class WeatherViewController: UIViewController {
    // data passed from SearchViewController
    var weatherData: WeatherData? // type of WeatherData (data Model)
    
    // MARK: - outlets
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var tempMinLabel: UILabel!
    @IBOutlet weak var tempMaxLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    
    @IBOutlet weak var mainWeatherLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var weatherIconImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // nav bar title"
        self.title = "Weather Info"
        print("WeatherVC is loaded")
        print("weatherData is \(weatherData) at WeatherVC")
        
        // MARK: - Parse optional weatherData
        if let weatherData = weatherData {
           parseWeatherData(weatherData)
        }
    }
    
    
    // MARK: - Convert KelvinTemperature to F
    func convertKelvinTempToF(kelvinTemp: Double) -> Double {
        return round((kelvinTemp - 273.15) * 9/5 + 32)
    }
    
    // MARK: - Numberic Formatting
    // if i had more time, I would have created this for the temp conversion
    
    // MARK: - Parse weatherData
    private func parseWeatherData(_ weatherData: WeatherData) {
        if let firstWeather = weatherData.weather.first {
            // I want main, description and icon from firstWeather"
           
            let main = firstWeather.main ?? "No data"
            // let main = firstWeather?.main ?? ""  -> firstWeather can bt nil, that's why we have "?", when you don't safele wrap it, it would cause it to crash, so you add ?? "" -> to catch the failure.
            let description = firstWeather.description ?? "No data"
            let icon = firstWeather.icon ?? "" // not needed on updateUI
            let iconURL = firstWeather.iconURL
            
            // parse the rest - only convert if temp is not nil
            // WeatherDataModel -> let temp: Double?
            // let temp = convertKelvinTempToF(kelvinTemp: weatherData.main.temp)
            // If I had the time, I will change them with guard let
            let temp = weatherData.main.temp != nil ? convertKelvinTempToF(kelvinTemp: weatherData.main.temp!) : 0
            let tempMin = weatherData.main.tempMin != nil ? convertKelvinTempToF(kelvinTemp: weatherData.main.tempMin!) : 0
            let tempMax = weatherData.main.tempMax != nil ? convertKelvinTempToF(kelvinTemp: weatherData.main.tempMax!) : 0
            let feelsLike = weatherData.main.feelsLike != nil ? convertKelvinTempToF(kelvinTemp: weatherData.main.feelsLike!) : 0
            let windSpeed = weatherData.wind.speed != nil ? round(weatherData.wind.speed! * 2.23694) : 0
            let humidity = weatherData.main.humidity ?? 0
            let cityName = weatherData.name ?? "Unknown City"
            
            // save last searched city
            saveLastSearchedCity(city: cityName)
            
            // put dispatch here .. then call updateUI
            updateUI(cityName, temp, feelsLike, tempMin, tempMax, humidity, windSpeed, main, description, iconURL)
        }
    }
    
    // MARK: - save lastSearchedCity
    func saveLastSearchedCity(city: String) {
        UserDefaults.standard.set(city, forKey: "LastSearchedCity")
        return
    }
    
    // MARK: - Update UI
    private func updateUI(_ cityName: String, _ temp: Double, _ feelsLike: Double, _ tempMin: Double, _ tempMax: Double, _ humidity: Int, _ windSpeed: Double, _ main: String, _ description: String, _ iconURL: URL?){
    
        DispatchQueue.main.async {
            // Update UI - main thread
            self.cityNameLabel.text = "\(cityName)"
            self.tempLabel.text = "\(temp) F"
            self.feelsLikeLabel.text = "\(feelsLike) F"
            self.tempMinLabel.text = "\(tempMin) F"
            self.tempMaxLabel.text = "\(tempMax) F"
            self.humidityLabel.text = "\(humidity) %"
            self.windSpeedLabel.text = "\(windSpeed) km/h"
            
            self.mainWeatherLabel.text = main
            self.descriptionLabel.text = description
            
            // in case icon URL is nil
            if let iconURL = iconURL {
                // MARK: - Kingfisher's method - download and cache image
                 self.weatherIconImage.kf.setImage(with: iconURL)
                // load the image from the url and set it as the image of an UIImageView.
            }
        }
    }
}
