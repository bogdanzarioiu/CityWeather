//
//  LeadingBarButtonView.swift
//  CityWeather
//
//  Created by Bogdan on 3/15/21.
//

import SwiftUI



struct LeadingBarButtonView: View {
    //@Binding var showSheet: Bool
    @Binding var activeSheet: SheetType?
    var body: some View {
        Button(action: {
            //showSheet.toggle()
            activeSheet = .settings
        }, label: {
            Image(systemName: "gearshape")
                .foregroundColor(.black)
        })
    }
}

struct LeadingBarButtonView_Previews: PreviewProvider {
    static var previews: some View {
        LeadingBarButtonView(activeSheet: .constant(.settings))
    }
}
