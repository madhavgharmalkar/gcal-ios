//
//  LegacyMainView.swift
//  Gaudiya Calendar
//
//  Created by Madhav Gharmalkar on 10/19/22.
//

import Foundation
import SwiftUI

struct LegacyMainView: UIViewControllerRepresentable {
    func makeUIViewController(context _: Context) -> MainViewController {
        guard let rootDelegate = UIApplication.shared.delegate as? BalaCalAppDelegate else {
            return MainViewController()
        }

        let vc = rootDelegate.mainViewCtrl as MainViewController
        return vc
    }

    func updateUIViewController(_: MainViewController, context _: Context) {}

    typealias UIViewControllerType = MainViewController
}
