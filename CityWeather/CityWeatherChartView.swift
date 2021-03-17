//
//  CityWeatherChartView.swift
//  CityWeather
//
//  Created by Bogdan on 3/16/21.
//

import CoreLocation
import SwiftUI

struct CityWeatherChartView: View {
    var cityName: String = "Paris"
    @State private var temp: Double = 0.0
    @State private var minTemp: Double = 0.0
    @State private var maxTemp: Double = 0.0
    @State private var description = "---"
    @State private var probOfPrecc: Double = 0.0
    @State private var days: [String] = []
    @State private var dayTemperatures: [Double] = []
    @State private var descriptions: [String] = []
    
    
    var body: some View {
        VStack {
            Text(cityName)
                .font(.system(size: 40, weight: .black))
            Text("\(Int(temp))℃")
                .font(.headline)
            Text(description)
                .font(.headline)
            Text("\(probOfPrecc, specifier: "%.2f")%")
                .font(.headline)
                .padding()
            Spacer()
                .frame(width: 100, height: 100)
            HStack {
                Text("Min today: \(Int(minTemp))℃")
                    .font(.headline)
                Spacer()
                    .frame(width: 100, height: 20)
                Text("Max today: \(Int(maxTemp))℃")
                    .font(.headline)
               
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(0..<(days.count) , id: \.self) { index  in
                        VStack {
                            Text("\(days[index])")
                                .font(.headline)
                                .padding(.bottom, 5)
                            Text("\(dayTemperatures[index])℃")
                                .font(.headline)
                                .padding(.bottom, 5)
                            Text(descriptions[index])
                                .font(.headline)
                                .padding(.bottom, 5)
                        }
                        .padding()
                        .overlay(
                            Rectangle()
                                .stroke(lineWidth: 2)
                        )
                        
                    }
                }
            }
            .padding()
            
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
                        
                        DispatchQueue.main.async {
                            self.minTemp = forecast.daily.first?.temp.min ?? 0.0
                            self.maxTemp = forecast.daily.first?.temp.max ?? 0.0
                            self.temp = forecast.daily.first?.temp.day ?? 0.0
                            self.probOfPrecc = forecast.daily.first?.pop ?? 0.0
                            self.description = forecast.daily.first?.weather.first?.description ?? "---"
                            
                            for i in 0..<forecast.daily.count {
                                self.days.append(forecast.daily[i].dt.formatAsString())
                                self.dayTemperatures.append(forecast.daily[i].temp.day)
                                self.descriptions.append(forecast.daily[i].weather.first?.description ?? "---")
                            }
                        }
                        
//                        print("=================>", forecast.daily.first?.temp ?? "No data")

                    case .failure(.noData):
                        print("Error encountered") // to show an alert in this case
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
