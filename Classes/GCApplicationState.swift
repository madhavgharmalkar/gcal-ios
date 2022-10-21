//
//  ApplicationState.swift
//  Gaudiya Calendar
//
//  Created by Madhav Gharmalkar on 10/20/22.
//

import Foundation

@objc public final class GCApplicationState: NSObject {
    private var appDelegate: BalaCalAppDelegate

    // current public variables
    @objc public var displaySettings: GCDisplaySettings
    @objc public var gcStrings: GCStrings

    @objc public init(appDelegate: BalaCalAppDelegate) {
        self.appDelegate = appDelegate
        
        self.displaySettings = GCDisplaySettings()
        self.displaySettings.readFromFile()
        
        self.gcStrings = GCStrings()
        self.gcStrings.prepare()

        super.init()
    }
}
