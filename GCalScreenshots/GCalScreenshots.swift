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
        snapshot("01HomeScreen")
    }
    
}
