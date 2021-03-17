//
//  URLImageView.swift
//  CityWeather
//
//  Created by Bogdan on 3/17/21.
//

import SwiftUI

struct URLImageView: View {
    let url: String
       let placeholder: String
       
       @ObservedObject var imageLoader = IconLoader()
       
       init(url: String, placeholder: String = "placeholder") {
           self.url = url
           self.placeholder = placeholder
           self.imageLoader.downloadImage(url: self.url)
       }
    
    var body: some View {
        if let data = self.imageLoader.downloadedData {
                   return Image(uiImage: UIImage(data: data)!).resizable()
               } else {
                   return Image("placeholder").resizable()
               }
    }
}

struct URLImageView_Previews: PreviewProvider {
    static var previews: some View {
        URLImageView(url: "https://openweathermap.org/img/w/04n.png")
    }
}
