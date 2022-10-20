//
//  LocationManager.swift
//  Gaudiya Calendar
//
//  Created by Madhav Gharmalkar on 10/20/22.
//

import Foundation
import CoreLocation
import MapKit

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()

    @Published var region = MKCoordinateRegion(
           center: CLLocationCoordinate2D(latitude: 42.0422448, longitude: -102.0079053),
           span: MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3)
    )


    override init() {
        super.init()
        manager.delegate = self
    }

    func requestLocation() {
        manager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coord = locations.first?.coordinate else {
            return
        }
        
        self.region.center = coord    
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
