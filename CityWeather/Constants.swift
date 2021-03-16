//
//  Constants.swift
//  CityWeather
//
//  Created by Bogdan on 3/15/21.
//

import CoreLocation
import Foundation

//https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}
struct Constants {
    
    struct URLs {
        static func weatherByCity(city: String) -> URL? {
            URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=28ff23ca85384c074202ea8bccf807dc&units=metric")
        }
        
        static func weatherByCoordinates(coordinates: CLLocationCoordinate2D) -> URL? {
            URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(coordinates.latitude)&lon=\(coordinates.longitude)&appid=28ff23ca85384c074202ea8bccf807dc&units=metric")
        }
        
        static func weatherForecastByCoordinates(coordinates: CLLocationCoordinate2D) -> URL? {
            URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=\(coordinates.latitude)&lon=\(coordinates.longitude)&exclude=current,minutely,hourly,alerts&appid=28ff23ca85384c074202ea8bccf807dc&units=metric")
        }
    }
    
   
}


