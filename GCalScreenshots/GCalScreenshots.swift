//
//  GCalScreenshots.swift
//  GCalScreenshots
//
//  Created by Madhav Gharmalkar on 10/21/22.
//

import XCTest

final class GCalScreenshots: XCTestCase {
    override class func setUp() {
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
    }

    func testHomeScreen() {
        addUIInterruptionMonitor(withDescription: "notifications alert") { alert in
            let btnAllow = alert.buttons["Allow"]
            let btnAllowAlways = alert.buttons["Always Allow"]
            if btnAllow.exists {
                btnAllow.tap()
                return true
            }
            if btnAllowAlways.exists {
                btnAllowAlways.tap()
                return true
            }
            XCTFail("Unexpected System Alert")
            return false
        }

        let app = XCUIApplication()
        app.tap()
        snapshot("01HomeScreen")
    }
}
