//
//  ApplicationState.swift
//  Gaudiya Calendar
//
//  Created by Madhav Gharmalkar on 10/20/22.
//

import CoreLocation
import Foundation
import MapKit
import SwiftUI

@objc public final class GCApplicationState: NSObject, ObservableObject {
    private var appDelegate: BalaCalAppDelegate

    // current public variables
    @objc public var displaySettings: GCDisplaySettings
    @objc public var gcStrings: GCStrings
    @objc public var gcLocation: GcLocation

    @objc public init(appDelegate: BalaCalAppDelegate) {
        self.appDelegate = appDelegate

        displaySettings = GCDisplaySettings()
        displaySettings.readFromFile()

        gcStrings = GCStrings()
        gcStrings.prepare()

        gcLocation = GcLocation()
        gcLocation.city = displaySettings.locCity
        gcLocation.country = displaySettings.locCountry
        gcLocation.latitude = displaySettings.locLatitude
        gcLocation.longitude = displaySettings.locLongitude
        gcLocation.timeZone = TimeZone(identifier: displaySettings.locTimeZone)
        if gcLocation.timeZone == nil {
            gcLocation.timeZone = TimeZone.current
        }

        super.init()
    }

    func setLocation(placemark: CLPlacemark) {
        guard let location = placemark.location else {
            return
        }

        gcLocation.longitude = location.coordinate.longitude
        gcLocation.latitude = location.coordinate.latitude

        guard let city = placemark.locality, let country = placemark.country, let timezone = placemark.timeZone else {
            return
        }

        gcLocation.city = city
        gcLocation.country = country
        gcLocation.timeZone = timezone

        appDelegate.setGPS()
    }
}
