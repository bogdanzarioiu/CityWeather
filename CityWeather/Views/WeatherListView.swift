//
//  WeatherListView.swift
//  CityWeather
//
//  Created by Bogdan on 3/15/21.
//


import Combine
import SDWebImageSwiftUI
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
    @State private var description = ""
    @State private var iconString = ""
    
    //using a timer publisher that will update the current location weather every 60 seconds
    let timer = Timer.publish(every: 60, on: .current, in: .common)
        .autoconnect()
   

    
    
    var body: some View {
        NavigationView {
            VStack {
                //HStack {
                    VStack(alignment: .center) {
//                        Text(refreshState ? "Refreshing..." : "")
//                            .font(.footnote)
//                            //.padding(.all, 5)
                            
                        Text("\(currentCity), \(currentCountry)")
                            .font(.system(size: 20, weight: .black))
                        Text("\(Int(currentTemp))℃ , \(description)")
                            .font(.headline)
                        HStack {
                            Image(systemName: "sunrise")
                                .foregroundColor(Color(.systemYellow))
                            Text("\(sunrise.formatAsStringForTime())")
                                .font(.footnote)
                        }
                        HStack {
                            Image(systemName: "sunset")
                                .foregroundColor(Color(.systemOrange))
                            Text("\(sunset.formatAsStringForTime())")
                                .font(.footnote)
                            
                        }
                        
                        AnimatedImage(url: URL(string: Constants.URLs.weatherUrlAsStringByIcon(icon: iconString)))
                            .resizable()
                            .frame(width: 65, height: 65)
                            .padding()
                    }
                    .padding()
                    .frame(width: UIScreen.main.bounds.width)
                    .background(Color(.systemGray5))
                    //.background(Color(#colorLiteral(red: 0.9450980392, green: 0.9450980392, blue: 1, alpha: 1)))
                    
                    
                    
                    

                    

               // }
                //.padding()
                
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
        //.background(Color(#colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 1, alpha: 1)))
        .background(Color(.systemGray6))
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
                    self.description = weather.weather.first?.description ?? "---"
                    self.iconString = weather.weather.first?.icon ?? "04n"
                }
                
                
            }
            
            
           
        }//here we use the values received from the timer to perform the refresh
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
            //UITableViewCell.appearance().selectionStyle = .none
            //UITableView.appearance().separatorStyle = .none
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
        HStack {
            VStack(alignment: .leading, spacing: 15) {
                Text("\(weather.weather.name), \(weather.weather.sys.country)")
                    .font(.system(size: 16, weight: .black))
                Text("\(Int(weather.currentTemperature))℃, \(weather.weather.weather.first?.description ?? "---")")
                    .font(.headline)

                HStack {
                    Image(systemName: "sunrise")
                        .foregroundColor(Color(.systemYellow))
                    Text("\(weather.weather.sys.sunrise.formatAsStringForTime())")
                        .font(.headline)
                }
                HStack {
                    Image(systemName: "sunset")
                        .foregroundColor(Color(.systemOrange))
                    Text("\(weather.weather.sys.sunset.formatAsStringForTime())")
                        .font(.headline)
                    
                }
                Text("min: \(weather.minTemperature, specifier: "%.0f")℃ max: \(weather.maxTemperature, specifier: "%.0f")℃")
                    .font(.headline)
            }
            
            Spacer()
            AnimatedImage(url: URL(string: Constants.URLs.weatherUrlAsStringByIcon(icon: weather.weather.weather.first?.icon ?? "04n")))
                .resizable()
                .frame(width: 50, height: 50)

        }
    }
    
   
}

struct WeatherListView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherListView().environmentObject(GlobalState())
    }
}



