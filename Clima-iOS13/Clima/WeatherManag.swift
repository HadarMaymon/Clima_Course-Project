//
//  WeatherManag.swift
//  Clima
//
//  Created by hadar maymon on 13/12/2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

// Declare WeatherManagDelegate outside WeatherManag
protocol WeatherManagDelegate: AnyObject {
    func didUpdateWeather(weatherManag: WeatherManag, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManag {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=40afd896b87195230f44dc1dac2e2218&units=metric"
    
    var delegate: WeatherManagDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
        
    }
    
    func performRequest(with urlString: String) {
        //1. Create url
        if let url = URL(string: urlString) {
            
            // 2. Create url session
            let session = URLSession(configuration: .default)
            
            // 3. Give the session a task
            let task = session.dataTask(with: url) { data, response, error in
                // Handle the data, response, and error here
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    self.parseJson(weatherData: safeData)
                }
            }
            
            //4. Start the task
            task.resume()
        }
    }
    
    func parseJson(weatherData: Data) {
        // decode the provided 'weatherData' (in Data format) into a Swift object of type WeatherData. The decoded data is then printed, specifically accessing and printing the 'name' property of the WeatherData object.
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = (decodedData.weather[0].id)
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            
            print(weather.conditionName, String(format: "%.1f", temp))
            self.delegate?.didUpdateWeather(weatherManag: self, weather: weather)
            
        } catch {
            delegate?.didFailWithError(error: error)
            
        }
    }
}
