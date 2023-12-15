//
//  ChangeGPSView.swift
//  Gaudiya Calendar
//
//  Created by Madhav Gharmalkar on 10/20/22.
//

import CoreLocation
import CoreLocationUI
import MapKit
import SwiftUI

struct ChangeGPSView: View {
    @StateObject var locationManager = LocationManager()
    @EnvironmentObject var applicationState: GCApplicationState
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            Map(coordinateRegion: $locationManager.region)
                .disabled(true)
                .frame(maxHeight: .infinity)
                .ignoresSafeArea(edges: .bottom)

            VStack(alignment: .trailing) {
                Spacer()

                HStack {
                    Spacer()
                    LocationButton(.currentLocation) {
                        locationManager.requestLocation()
                    }
                    .symbolVariant(.fill)
                    .labelStyle(.iconOnly)
                    .foregroundColor(Color.white)
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                }
                .padding(.trailing, 16)

                HStack {
                    Spacer()
                    Button {
                        guard let placemark = locationManager.placemark else {
                            dismiss()
                            return
                        }

                        applicationState.placemark = placemark
                        dismiss()
                    } label: {
                        Image(systemName: "checkmark.circle.fill")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundStyle(locationManager.placemark == nil ? .gray : .white)
                            .padding(7.5)
                    }
                    .background(Color.blue)
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    .disabled(locationManager.placemark == nil)

                }.padding(.trailing, 16)
            }.frame(maxWidth: .infinity)
        }
        .navigationTitle("Change Location")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            let location = applicationState.gcLocation
            self.locationManager.setLocation(location: CLLocation(latitude: location.latitude, longitude: location.longitude))
        }
    }
}

struct ChangeGPSView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ChangeGPSView()
        }
    }
}
