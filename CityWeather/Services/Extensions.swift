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
        formatter.dateFormat = "MMM dd"
        return formatter.string(from: self)
    }
    
    func formatAsStringForTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter.string(from: self)
    }
    
}


//"E, MMM, d"
//"hh:mm a"
//"MMM dd,yyyy"
