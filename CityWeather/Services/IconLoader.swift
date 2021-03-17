//
//  IconLoader.swift
//  CityWeather
//
//  Created by Bogdan on 3/17/21.
//

import Foundation

class IconLoader: ObservableObject {
    
    @Published var downloadedData: Data?
    
    func downloadImage(url: String) {
        
        guard let imageURL = URL(string: url) else {
            return
        }
        
        URLSession.shared.dataTask(with: imageURL) { data, _, error in
            
            guard let data = data, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                self.downloadedData = data
            }
            
        }.resume()
        
    }
    
}
