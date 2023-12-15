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

        region.center = location.coordinate
    }

    func locationManager(_: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }

    func lookUpCurrentLocation() async -> CLPlacemark? {
        let geocoder = CLGeocoder()
        let lastLocation = CLLocation(latitude: region.center.latitude, longitude: region.center.longitude)

        do {
            let placemarks = try await geocoder.reverseGeocodeLocation(lastLocation)
            return placemarks.first
        } catch {
            return nil
        }
    }

    func setLocation(location: CLLocation) {
        locationManager(manager, didUpdateLocations: [location])
    }
}
