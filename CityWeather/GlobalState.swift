//
//  GlobalState.swift
//  CityWeather
//
//  Created by Bogdan on 3/16/21.
//

import Foundation


//this object is injected in the environment and will be ised in the city list view
class GlobalState: ObservableObject {
    @Published var weatherList: [WeatherViewModel] = [WeatherViewModel]()
    //@Published var currentWeather: Weather
    
    
//    init(weather: Weather) {
//        self.currentWeather = weather
//    }
    func addWeather(weather: WeatherViewModel) {
        weatherList.append(weather)
    }
    
//    func refresh() {
//        NetworkManager.shared.getCurrentLocationWeather { (weather) -> (Void) in
//            self.currentWeather = weather
//        }
//    }
}
