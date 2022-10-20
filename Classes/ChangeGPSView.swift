//
//  ChangeGPSView.swift
//  Gaudiya Calendar
//
//  Created by Madhav Gharmalkar on 10/20/22.
//

import SwiftUI
import MapKit
import CoreLocation
import CoreLocationUI

struct ChangeGPSView: View {
    @Binding var isPresented: Bool
    @StateObject var locationManager = LocationManager()

    var body: some View {
        ZStack {
            Map(coordinateRegion: $locationManager.region)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
                .disabled(true)

            VStack {
                HStack(alignment: .top) {
                    if let location = locationManager.region.center {
                        Text("**Current location:**\n \(location.latitude), \(location.longitude)")
                                           .font(.callout)
                                           .foregroundColor(.white)
                                           .padding()
                                           .background(.gray)
                                           .clipShape(RoundedRectangle(cornerRadius: 10))
                                   }
                    Spacer()
                    LocationButton(.currentLocation) {
                        locationManager.requestLocation()
                    }
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .labelStyle(.iconOnly)
                }
                .padding(.horizontal)
                Spacer()
                HStack(alignment: .bottom) {
                    Button {
                        isPresented.toggle()
                    } label: {
                        Text("Cancel")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    
                    Button {
                        isPresented.toggle()
                    } label: {
                        Text("Use")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)

             
                }.padding(.horizontal)
            }
            .padding([.top], 20)
        }

    }
}

struct ChangeGPSView_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello world")
            .sheet(isPresented: .constant(true)) {
                ChangeGPSView(isPresented: .constant(true))
                    .presentationDetents([.medium, .large])
            }
    }
}
