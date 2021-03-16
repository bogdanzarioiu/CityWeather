//
//  WeatherViewModel.swift
//  CityWeather
//
//  Created by Bogdan on 3/15/21.
//

import Foundation


struct WeatherViewModel {
    var weather: Weather
    
    let id = UUID()
    //what we want to show on the view, here we format all the necessary properties and add methods
    
    var currentTemperature: Double {
        return weather.main.temp
    }
    var minTemperature: Double {
        return weather.main.temp_min
    }
    
    var maxTemperature: Double {
       return weather.main.temp_max
    }
    
    var cityName: String {
        return weather.name
    }
    
    
    
    func getCityName(from string: String) -> String {
        var cityName = ""
        
        if let range = string.range(of: "/") {
            let city = string[range.upperBound...]
            print(city) // prints ""
            cityName = String(city)
        }
        return cityName
        
    }
    
   
    
    
    
}
