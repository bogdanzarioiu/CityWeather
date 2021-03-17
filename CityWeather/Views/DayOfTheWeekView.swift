//
//  DayOfTheWeekView.swift
//  CityWeather
//
//  Created by Bogdan on 3/17/21.
//

import SwiftUI

struct DayOfTheWeekView: View {
//    @Binding var dayOfTheWeek: String
//    @Binding var temperature: Int
//    @Binding var description: String
    var body: some View {
        VStack {
            Text("Monday")
                .font(.headline)
                .padding(.bottom, 5)
            Text("8℃")
                .font(.headline)
                .padding(.bottom, 5)
            Text("light rain")
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

struct DayOfTheWeekView_Previews: PreviewProvider {
    static var previews: some View {
        DayOfTheWeekView()
    }
}
