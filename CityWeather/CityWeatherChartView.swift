//
//  CityWeatherChartView.swift
//  CityWeather
//
//  Created by Bogdan on 3/16/21.
//

import CoreLocation
import SwiftUI

struct CityWeatherChartView: View {
    //@State var location = "Bucharest"
    var cityName: String = ""
    @State private var temp: Double = 0.0
    @State private var minTemp: Double = 0.0
    @State private var maxTemp: Double = 0.0
    
    
    var body: some View {
        VStack {
            Text(cityName)
            HStack {
                Text("\(Int(minTemp))℃")
                Text("\(Int(maxTemp))℃")
            }
            Text("\(Int(temp))")
        }
        .onAppear {
            getCityForecast()
        }
    }
    
    func getCityForecast() {
        CLGeocoder().geocodeAddressString(cityName) { (placemarks, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            if let latitude = placemarks?.first?.location?.coordinate.latitude,
               let longitude = placemarks?.first?.location?.coordinate.longitude {
                let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                
                NetworkManager.shared.getCityForecastData(coordinates: coordinates) { (result) -> (Void) in
                    switch result {
                    case .success(let forecast):
                        self.minTemp = forecast.daily.first?.temp.min ?? 0.0
                        self.maxTemp = forecast.daily.first?.temp.max ?? 0.0
                        self.temp = forecast.daily.first?.temp.day ?? 0.0

                        print("=================>", forecast.daily.first?.temp ?? "No data")
                    case .failure(.noData):
                        print("Error encountered")
                    case .failure(_):
                        print("Another error")

                    }
                }
                
            }
            
        }
    }
    
    
}


struct CityWeatherChartView_Previews: PreviewProvider {
    static var previews: some View {
        CityWeatherChartView()
    }
}
