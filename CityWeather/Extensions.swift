//
//  Extensions.swift
//  CityWeather
//
//  Created by Bogdan on 3/16/21.
//

import Foundation


extension Date {
    
    func formatAsString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter.string(from: self)
    }
    
}
