//
//  MainView.swift
//  Gaudiya Calendar
//
//  Created by Madhav Gharmalkar on 10/17/22.
//

import SwiftUI
import MapKit

struct MainView: View {
    @AppStorage("onboarded") private var onboarded = false

    var body: some View {
        if onboarded {
            Text("Hello, World!")
        } else {
            WelcomeScreenView()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
