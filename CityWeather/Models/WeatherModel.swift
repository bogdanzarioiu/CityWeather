//
//  WeatherModel.swift
//  CityWeather
//
//  Created by Bogdan on 3/15/21.
//

import Foundation

struct Weather: Decodable {
    let name: String
    let main: Main
    let sys: Sys
    let weather: [WeatherIcon]
    
}

struct Main: Decodable {
    let temp: Double
    let temp_min: Double
    let temp_max: Double
    let feels_like: Double
    
}

struct WeatherIcon: Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Sys: Decodable {
    let country: String
    let sunrise: Date
    let sunset: Date
    
}


// Model for 7 day forecast

struct Forecast: Codable {
    let daily: [Daily]
}

struct Daily: Codable {
    let dt: Date
    let temp: Temp
    let humidity: Int
    let weather: [WeatherData]
    let clouds: Int
    let pop: Double
    
    
}

struct Temp: Codable {
    let day: Double
    let min: Double
    let max: Double
}

struct WeatherData: Codable {
    let id: Int
    let description: String
    let icon: String
    var weatherIconUrl: URL {
        let urlString = "http://openweathermap.org/img/wn/\(icon)@2x.png"
        return URL(string: urlString)!
    }
        
}

