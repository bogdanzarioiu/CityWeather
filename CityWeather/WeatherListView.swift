//
//  WeatherListView.swift
//  CityWeather
//
//  Created by Bogdan on 3/15/21.
//

import SwiftUI


enum SheetType: Identifiable {
    var id: UUID {
           return UUID()
       }
    case settings
    case addCity
}


struct WeatherListView: View {
    @ObservedObject var manager = NetworkManager()
    @EnvironmentObject var globalState: GlobalState
    @State private var activeSheet: SheetType?
    @State private var showSheet = false
    @State private var currentCity = "Bucharest"
    @State private var currentTemp: Double = 0.0
    @State private var currentCountry = ""
    @State private var sunrise = Date()
    @State private var sunset = Date()
    
    init() {
        
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text(currentCity)
                    .fontWeight(.bold)
                Text("\(Int(currentTemp))")
                Text(currentCountry)
                HStack {
                    Image(systemName: "sunrise")
                    Text("\(sunrise.formatAsString())")
                }
                HStack {
                    Image(systemName: "sunset")
                    Text("\(sunset.formatAsString())")            }
                List {
                    ForEach(globalState.weatherList, id: \.id) { weather in
                        NavigationLink(destination: CityWeatherChartView(cityName: weather.cityName)) {
                            VStack {
                                WeatherCityView(weather: weather)
        
                            }
                        }
                        
                    }
                }
                
                .listStyle(PlainListStyle())
                .sheet(item: $activeSheet, content: { (item) in
                           switch item {
                               case .addCity:
                                   AddCityView().environmentObject(globalState)
                               case .settings:
                                   SettingsView().environmentObject(globalState)
                           }
                       })
                .navigationBarTitle("Cities")
                .navigationBarItems(leading: LeadingBarButtonView(activeSheet: $activeSheet), trailing: TrailingBarButtonView(activeSheet: $activeSheet))
            }
            .redacted(reason: getStatus() ? [] : .placeholder)
        
        }
        .onAppear {
            //print(manager.locationStatus, "TEST AUTHORIZATION STATUS")
            NetworkManager.shared.getCurrentLocationWeather { (weather) -> (Void) in
                DispatchQueue.main.async {
                    self.currentCity = weather.name
                    self.currentTemp = weather.main.temp
                    self.currentCountry = weather.sys.country
                    self.sunrise = weather.sys.sunrise
                    self.sunset = weather.sys.sunset
                }
                
                
            }
           
        }
    }
    
    func getStatus() -> Bool{
        switch manager.locationStatus {
            case .authorizedAlways: return true
            case .authorizedWhenInUse: return true
            case .denied: return false
            case .none: return false
            case .notDetermined: return false
            case .restricted: return false
            case .some(_): return false
            
        }
    }
    
}

struct WeatherCityView: View {
    let weather: WeatherViewModel
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(weather.weather.name)
                .fontWeight(.bold)
            Text("\(Int(weather.currentTemperature))℃")
            Text("\(weather.weather.sys.country)")
            HStack {
                Image(systemName: "sunrise")
                Text("\(weather.weather.sys.sunrise.formatAsString())")
            }
            HStack {
                Image(systemName: "sunset")
                Text("\(weather.weather.sys.sunset.formatAsString())")            }
        }
    }
    
   
}

struct WeatherListView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherListView().environmentObject(GlobalState())
    }
}



