//
//  SearchViewController.swift
//  Weather
//
//  Created by Nikki L on 5/30/23.
// This ViewController is responsible for accepting the city from the user. T

import UIKit
import CoreLocation
import CoreLocationUI // Find My button

class SearchViewController: UIViewController,  UINavigationControllerDelegate, CLLocationManagerDelegate {
    
    let weatherAPI = WeatherAPI()
    
    // Share location
    let locationManager = CLLocationManager()
    
    // UI - 2 buttons , 1 textfield
    @IBOutlet weak var cityTextField: UITextField!
    // if I had the time, I would implement UITextFieldDelegate methods to track and respond to changes in the cityTextField - such as when user enter anything other than letter, there should be a line underneath the textfield in red alerting user "Please only enter letter, and no special characters/ number"

    // MARK: - Update lastCity for share location
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cityTextField.text = getLastSearchedCity()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // If I had more time, I would have implement the keyboard with UITapGestureRecognizer, dismiss the keyboard when user taps outside of the keyboard.
        
        navigationController?.delegate = self
        
        // MARK: - Display last searched city - 1st time only
        cityTextField.text = getLastSearchedCity()
        
    }
    
    // MARK: - Find My Location Button
    @IBAction func getLocation(_ sender: Any) {
        print("getLocation is tapped")
        // MARK: - Ask for user permission to share location
        let authStatus = locationManager.authorizationStatus
        if authStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        // less battery drainage
        
        // begin receiving coordinates
        self.locationManager.startUpdatingLocation()
        
    }
    
   // MARK: - Handles permission errors:
    // If I had the time, I would have written the func to handle a case when the user clicks "don't allow" by accident
    // we should pop up an alert letting the user know that they must allow location sharing in order to use the feature when the authStatus is either denied or restricted
    
   // MARK: - submit City
    @IBAction func submitCityButtonPressed(_ sender: UIButton) {
        // check if textfield has anything
        guard let city = cityTextField.text, !city.isEmpty else {
            showAlert()
            return
        }
        
        // when someone pressed submit City - we trigger getWeatherInfo
        // here we assume cityTextField consists all letter, no special character/ number
        weatherAPI.getWeatherInfo(city: city) { weatherData, error in
            self.handleWeatherDataResponse(weatherData, error)
        }
    }
    
    // MARK: - Handle Weather API JSON Data Response
    private func handleWeatherDataResponse(_ weatherData: WeatherData?, _ error: Error?) {
        if let error = error {
            showAlert()
            // print("Error - alert user \(error.localizedDescription)")
            
        } else if let weatherData = weatherData {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "ShowWeather", sender: weatherData)
            }
        }
    }
    
    // MARK: - Handle Invalid City Alert to User
    func showAlert() {
        let alertController = UIAlertController(title: "Invalid City", message: "The City that you entered is not valid, please enter a valid City", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(confirmAction)
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - render lastSearchedCity
    func getLastSearchedCity() -> String {
        print("getLastSearchedCity() get triggered")
        return UserDefaults.standard.string(forKey: "LastSearchedCity") ?? "Unknown City"
        
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowWeather" {
            // send it to the destination "WeatherVC"
            if let weatherVC = segue.destination as? WeatherViewController, let weatherData = sender as? WeatherData {
                weatherVC.weatherData = weatherData
            }
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension SearchViewController {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }
        print("didUpdateLocations - \(newLocation)")
        
        // Get lon and lat
        let latitude = newLocation.coordinate.latitude
        let longitude = newLocation.coordinate.longitude
        
        // MARK: - Trigger the API to get weatherData from openWeather
        self.weatherAPI.getCityFromCoordinates(latitude: latitude, longitude: longitude) { weatherData, error in
            self.handleWeatherDataResponse(weatherData, error)
        }
        // when it's done, stopupdating location
        locationManager.stopUpdatingLocation()
    }
    
    
    // MARK: - handle error
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError \(error.localizedDescription)")
    }
}
