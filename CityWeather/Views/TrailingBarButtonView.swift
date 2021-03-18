//
//  TrailingBarButtonView.swift
//  CityWeather
//
//  Created by Bogdan on 3/15/21.
//

import SwiftUI

struct TrailingBarButtonView: View {
    //@Binding var showSheet: Bool
    @Binding var activeSheet: SheetType?
    var body: some View {
        Button(action: {
            //showSheet.toggle()
            activeSheet = .addCity
        }, label: {
            Text("Add city")
                .font(.system(size: 14, weight: .heavy))
                .padding(.all, 6)
                .foregroundColor(Color(.label))
                .background(Color(.systemBackground))
                .cornerRadius(3)
        })
    }
}

struct TrailingBarButtonView_Previews: PreviewProvider {
    static var previews: some View {
        TrailingBarButtonView(activeSheet: .constant(.addCity))
    }
}
