//
//  NetworkManager.swift
//  CityWeather
//
//  Created by Bogdan on 3/15/21.
//

import Combine
import CoreLocation
import Foundation

class NetworkManager: NSObject, ObservableObject {
    
    
    var urlString = "https://api.openweathermap.org/data/2.5/onecall?lat=49.26&lon=-123.13&exclude=current,minutely,hourly,alerts&appid=28ff23ca85384c074202ea8bccf807dc&units=metric"
    
    @Published var locationStatus: CLAuthorizationStatus? {
           willSet {
               objectWillChange.send()
           }
       }
    
    var statusString: String {
           guard let status = locationStatus else {
               return "unknown"
           }

           switch status {
           case .notDetermined: return "notDetermined"
           case .authorizedWhenInUse: return "authorizedWhenInUse"
           case .authorizedAlways: return "authorizedAlways"
           case .restricted: return "restricted"
           case .denied: return "denied"
           default: return "unknown"
           }

       }
    
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    //var completion: ((Bool) -> Void)?
    
    private let locationManager = CLLocationManager()
    static let shared = NetworkManager()
    private var completionHandler: ((Weather) -> Void)?
    
     override public init(){
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
    }
    
    
    enum NetworkError: Error {
        case badURL
        case noData
    }
    
    func getCurrentLocationWeather(completion: @escaping(Weather) -> (Void)) {
        self.completionHandler = completion
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    private func makeDataRequest(withCoordinates coordinates: CLLocationCoordinate2D) {
        guard let currentWeatherURL = Constants.URLs.weatherByCoordinates(coordinates: coordinates) else {
            return
        }
            
        let request = URLRequest(url: currentWeatherURL)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                //completion(.failure(.noData))
                return
            }
            guard let data = data else {
                //completion(.failure(.noData))
                return
            }
            let decoder = JSONDecoder()
            //decoder.dateDecodingStrategy = dateDecodingStrategy
            //decoder.keyDecodingStrategy = keyDecodingStrategy
            do {
                
                let decodedData = try decoder.decode(Weather.self, from: data)
                self.completionHandler?(decodedData)
                
                
                
                
            } catch {
                //completion(.failure(.noData))
            }
            
        }.resume()
    }
    
    func getWeatherData(city: String,
                        dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
                        keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys,
                        completion: @escaping(Result<Weather, NetworkError>) -> (Void)) {
        
        guard let weatherURL = Constants.URLs.weatherByCity(city: city) else {
            completion(.failure(.badURL))
            return
        }
        let request = URLRequest(url: weatherURL)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                completion(.failure(.noData))
                return
            }
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = dateDecodingStrategy
            decoder.keyDecodingStrategy = keyDecodingStrategy
            do {
                
                let decodedData = try decoder.decode(Weather.self, from: data)
                completion(.success(decodedData))
                
                
                
                
            } catch {
                completion(.failure(.noData))
            }
            
        }.resume()
    }
    
    
    func getCityForecastData(coordinates: CLLocationCoordinate2D,
                            dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
                            keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys,
                        completion: @escaping(Result<Forecast, NetworkError>) -> (Void)) {
        
        guard let currentWeatherURL = Constants.URLs.weatherForecastByCoordinates(coordinates: coordinates) else {
            completion(.failure(.badURL))
            return
        }
            
        
        let request = URLRequest(url: currentWeatherURL)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                completion(.failure(.noData))
                return
            }
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = dateDecodingStrategy
            decoder.keyDecodingStrategy = keyDecodingStrategy
            do {
                
                let forecast = try decoder.decode(Forecast.self, from: data)
                completion(.success(forecast))
                
                
                
                
            } catch( _) {
                completion(.failure(.noData))
            }
            
            
            
            
        }.resume()
    }
    
    
    
    
}

extension NetworkManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        makeDataRequest(withCoordinates: location.coordinate)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Something went wrong: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
                    self.locationStatus = status
                    print(#function, statusString)
//        switch status {
//        case .authorizedAlways:
//            completion?(true)
//        case .authorizedWhenInUse:
//            completion?(true)
//        case .denied:
//            completion?(false)
//        case .notDetermined:
//            completion?(false)
//        case .restricted:
//            completion?(false)
//        @unknown default:
//            completion?(false)
//        }
    }
    
}
