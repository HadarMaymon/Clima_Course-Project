//
//  WeatherData.swift
//  Clima
//
//  Created by hadar maymon on 13/12/2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Decodable { // makes the site from web readable
    let name: String
    let main: Main // if theres subs to main create another struct
    let weather: [Weather]
    
}

struct Main: Decodable {
    let temp: Double
    
}

struct Weather: Decodable {
    let description: String
    let id: Int
}
