//
//  WeatherListView.swift
//  CityWeather
//
//  Created by Bogdan on 3/15/21.
//


import Combine
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
    
    @State private var refreshState = false
    @State private var currentCity = "Bucharest"
    @State private var currentTemp: Double = 0.0
    @State private var currentCountry = ""
    @State private var sunrise = Date()
    @State private var sunset = Date()
    let timer = Timer.publish(every: 300, on: .current, in: .common)
        .autoconnect()
    

    init() {
        
    }
    
    var body: some View {
        NavigationView {
            VStack {
                VStack(alignment: .leading) {
                    Text(refreshState ? "Refreshing..." : "")
                        .font(.footnote)
                        //.padding(.all, 5)
                        
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
                }
                .padding()
                .frame(width: UIScreen.main.bounds.width)
                .background(Color(#colorLiteral(red: 0.9450980392, green: 0.9450980392, blue: 1, alpha: 1)))
                
                List {
                    ForEach(globalState.weatherList, id: \.id) { weather in
                        NavigationLink(destination: CityWeatherChartView(cityName: weather.cityName)) {
                            VStack {
                                WeatherCityView(weather: weather)
                                    
        
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                        
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
        .background(Color(#colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 1, alpha: 1)))
        .onAppear {
            UITableViewCell.appearance().selectionStyle = .none
            UITableView.appearance().separatorStyle = .none
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
        .onReceive(timer){ _ in
            print("Timer published a value")
            withAnimation(.easeIn(duration: 0.2)) {
                self.refreshState.toggle()
            }
            print(self.refreshState)
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
        .onDisappear {
        
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



