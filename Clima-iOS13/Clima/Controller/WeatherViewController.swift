//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    // let us manage the text field

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    
    var weatherManag = WeatherManag()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self // Must be before the Location Manager functions
        
        locationManager.requestWhenInUseAuthorization() // Request user agreement to share location
        locationManager.requestLocation()
        
        searchTextField.delegate = self
        weatherManag.delegate = self
    }

}

// MARK: - UITextFieldDelegate


extension WeatherViewController: UITextFieldDelegate {
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true) // Tells the code when you click go it means you done writing
        print(searchTextField.text!)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool { // Reminds to write something if you click go before writing
        if textField.text != "" {
            return true
        }
        else {
            textField.placeholder = "Type something"
            return false
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) { // clears the text field
        
        if let city = searchTextField.text {
            weatherManag.fetchWeather(cityName: city)
        }
        
        searchTextField.text = ""
    }
}

// MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagDelegate {
    func didUpdateWeather(weatherManag: WeatherManag, weather: WeatherModel) {
        DispatchQueue.main.sync {
            temperatureLabel.text = String(format: "%.0f", weather.temperature) // in weatherData
            cityLabel.text = weather.cityName
            conditionImageView.image = UIImage(systemName: weather.conditionName)
        }
    }
    
    
    func didFailWithError(error: Error) { // Prints the error
        print(error)
    }

}

// MARK: - CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate {
    
    @IBAction func locationButtonPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last { // Last item in the array (most accourate location)
            let lat = location.coordinate.latitude // קו רוחב, שמות פרמטרים מהאתר
            let lon = location.coordinate.longitude // קו אורך, שמות פרמטרים מהאתר
            weatherManag.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    
}

