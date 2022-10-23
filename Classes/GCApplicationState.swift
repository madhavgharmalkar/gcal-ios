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
    @objc public var gcEngine: GCEngine

    // the current date information,idk if we'll switch this to native SwiftUI Dates
    private var gcDate: GCGregorianTime
    @Published @objc public var date = Date() {
        didSet {
            if oldValue != date {
                let calendar = Calendar.current
                let day = calendar.component(.day, from: date)
                let month = calendar.component(.month, from: date)
                let year = calendar.component(.year, from: date)

                let gct = GCGregorianTime()
                gct.year = Int32(year)
                gct.month = Int32(month)
                gct.day = Int32(day)
                gcDate = gct

                appDelegate.showDate(gct)
            }
        }
    }

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

        gcEngine = GCEngine()
        gcEngine.theSettings = displaySettings
        gcEngine.myStrings = gcStrings
        gcEngine.myLocation = gcLocation

        gcDate = GCGregorianTime.today()

        super.init()

//        $date.sink { receivedDate in
//            print(receivedDate)
//        }
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

        displaySettings.locCity = city
        displaySettings.locCountry = country
        displaySettings.locLatitude = location.coordinate.latitude
        displaySettings.locLongitude = location.coordinate.longitude
        displaySettings.locTimeZone = timezone.identifier

        gcEngine.reset()

        appDelegate.setGPS()
    }
}
