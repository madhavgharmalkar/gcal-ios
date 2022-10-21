//
//  SwiftUIViewFactory.swift
//  Gaudiya Calendar
//
//  Created by Madhav Gharmalkar on 10/17/22.
//

import Foundation
import SwiftUI

class SwiftUIViewFactory: NSObject {
    @objc static func makeSwiftUIView() -> UIViewController {
        return UIHostingController(rootView: MainView())
    }
}
