//
//  LocationManager.swift
//  Gaudiya Calendar
//
//  Created by Madhav Gharmalkar on 10/20/22.
//

import CoreLocation
import Foundation
import MapKit

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()

    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 27.5650, longitude: 77.6593),
        span: MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3)
    )

    private var location: CLLocation?
    @Published var locationCoordinate: CLLocationCoordinate2D?
    @Published var placemark: CLPlacemark?
    @Published var hasPlacemark: Bool = false

    override init() {
        super.init()
        manager.delegate = self
    }

    func requestLocation() {
        manager.requestLocation()
    }

    func locationManager(_: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }

        self.location = location
        region.center = location.coordinate
        locationCoordinate = location.coordinate
        lookUpCurrentLocation { placemark in
            self.placemark = placemark
            self.hasPlacemark = true
        }
    }

    func locationManager(_: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }

    func lookUpCurrentLocation(completionHandler: @escaping (CLPlacemark?)
        -> Void)
    {
        // Use the last reported location.
        if let lastLocation = location {
            let geocoder = CLGeocoder()

            // Look up the location and pass it to the completion handler
            geocoder.reverseGeocodeLocation(lastLocation,
                                            completionHandler: { placemarks, error in
                                                if error == nil {
                                                    let firstLocation = placemarks?[0]
                                                    completionHandler(firstLocation)
                                                } else {
                                                    // An error occurred during geocoding.
                                                    completionHandler(nil)
                                                }
                                            })
        } else {
            // No location was available.
            completionHandler(nil)
        }
    }
}
