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
        VStack {
            Map(coordinateRegion: $locationManager.region)
                .disabled(true)
                .frame(maxHeight: .infinity)
                .ignoresSafeArea()

            VStack {
                if locationManager.placemark == nil {
                    LocationButton(.currentLocation) {
                        locationManager.requestLocation()
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .foregroundColor(.white)
                }

                if let placemark = locationManager.placemark {
                    Text("Your location").bold()
                    Text("\(placemark.locality ?? ""), \(placemark.country ?? "")")
                    Text("\(placemark.timeZone?.identifier ?? "")")
                    Text("\(placemark.location?.coordinate.longitude ?? 0), \(placemark.location?.coordinate.latitude ?? 0)")

                    Spacer()

                    HStack(alignment: .center) {
                        Button {
                            dismiss()
                        } label: {
                            Text("Cancel")
                                .frame(maxWidth: .infinity)
                        }

                        Button {
                            guard let placemark = locationManager.placemark else {
                                dismiss()
                                return
                            }

                            applicationState.placemark = placemark
                            dismiss()
                        } label: {
                            Text("Set")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding(.horizontal)
                }
            }.frame(maxHeight: .infinity)
        }
        .navigationTitle("Set location")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ChangeGPSView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ChangeGPSView()
        }
    }
}
