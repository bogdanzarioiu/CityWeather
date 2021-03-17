//
//  AddCityView.swift
//  CityWeather
//
//  Created by Bogdan on 3/16/21.
//

import SwiftUI

struct AddCityView: View {
    
    @EnvironmentObject var globalState: GlobalState
    @Environment(\.presentationMode) private var presentationMode
    @StateObject private var addWeatherVM = AddCityWeatherViewModel()
    
    var body: some View {
        
        NavigationView {
            VStack {
                VStack(spacing: 20) {
                    TextField("Enter city", text: $addWeatherVM.city)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.asciiCapable)
                        //.padding()
                    Button(action: {
                        addWeatherVM.saveCity { weather in
                            globalState.addWeather(weather: weather)
                            presentationMode.wrappedValue.dismiss()
                        }
                    }, label: {
                        Text("Save")
                            .padding(10)
                            .frame(maxWidth: UIScreen.main.bounds.width/4)
                            .foregroundColor(.white)
                            .font(.system(size: 14, weight: .black))
                            .background(Color(.systemBlue))
                            //.clipShape(Rectangle())
                            
                    })

                }.padding()
                .frame(maxWidth: .infinity, maxHeight: 200)
                .background(Color(#colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 1, alpha: 1)))
                //.clipShape(RoundedRectangle(cornerRadius: 25.0, style: .continuous))
             Spacer()
            }//.padding()
            .navigationTitle("Add City")
        }
    }
}

struct AddCityView_Previews: PreviewProvider {
    static var previews: some View {
        AddCityView().environmentObject(GlobalState())
    }
}
