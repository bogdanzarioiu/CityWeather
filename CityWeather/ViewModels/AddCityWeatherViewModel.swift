//
//  AddCityWeatherViewModel.swift
//  CityWeather
//
//  Created by Bogdan on 3/15/21.
//

import Foundation

class AddCityWeatherViewModel: ObservableObject {
    var city: String = ""
    
    
    func saveCity(completion: @escaping (WeatherViewModel) -> Void) {
        NetworkManager.shared.getWeatherData(city: city) { (result) -> (Void) in
            switch result {
            case .success(let weather):
                print(weather.name)
                DispatchQueue.main.async {
                    completion(WeatherViewModel(weather: weather))
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
