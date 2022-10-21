//
//  WelcomeScreenView.swift
//  Gaudiya Calendar
//
//  Created by Madhav Gharmalkar on 10/17/22.
//

import CoreLocationUI
import SwiftUI

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
                    .foregroundColor(.secondary)
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
        VStack(spacing: 20) {
            if let location = locationManager.location {
                Text("Your location: \(location.latitude), \(location.longitude)")
            }

            Image("stars")
                .resizable()
                .scaledToFit()
                .padding(.horizontal, 20)
            Text("Grant access to your location*").font(.title2)
            Text("*The vedic calendar is based on the position of the moon, and we use your location to determine the position of the moon relative to where you are. Don't worry, you can change this later.")
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .font(.caption)

            LocationButton(.shareCurrentLocation) {
                locationManager.requestLocation()
            }
            .foregroundColor(.white)
            .cornerRadius(10)
            .font(.body)
        }
        .padding(.horizontal, 20)
    }
}
