//
//  WelcomeScreenView.swift
//  Gaudiya Calendar
//
//  Created by Madhav Gharmalkar on 10/17/22.
//

import SwiftUI
import CoreLocationUI

struct WelcomeScreenView: View {
    @State private var tabSelection = 1

    var body: some View {
        TabView(selection: $tabSelection) {
            WelcomeView(tabSelection: $tabSelection)
                .tag(1)
            RequestLocationView()
                .tag(2)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .indexViewStyle(.page(backgroundDisplayMode: .never))
        .animation(.easeInOut, value: tabSelection)
    }
}

struct WelcomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeScreenView()
    }
}

struct WelcomeView: View {
    @Binding var tabSelection: Int

    var body: some View {
        VStack {
            VStack(spacing: 10) {
                Spacer()
                Text("Better GCal").font(.title).bold()
                Text("Gaurabda Calendar that's better than GCal 😊")
                    .font(.caption).foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                Spacer()
                Spacer()
            }
            Spacer()
            Button {
                self.tabSelection = 2
            } label: {
                HStack {
                    Label("Get Started", systemImage: "arrow.right")
                        .frame(maxWidth: .infinity)
                        .labelStyle(.titleOnly)
                }
            }.buttonStyle(.borderedProminent)
        }.padding(.horizontal, 40)
    }
}

struct RequestLocationView: View {
    @StateObject var locationManager = LocationManager()
    var body: some View {
        VStack {
            LocationButton {
                locationManager.requestLocation()
            }
            .foregroundColor(.white)
            .cornerRadius(10)
                
        }
    }
}
