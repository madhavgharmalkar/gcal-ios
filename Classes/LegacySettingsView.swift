//
//  LegacySettingsView.swift
//  Gaudiya Calendar
//
//  Created by Madhav Gharmalkar on 10/20/22.
//

import Foundation
import SwiftUI

struct LegacySettingsView: UIViewControllerRepresentable {
    typealias UIViewControllerType = SettingsViewTableController

    func makeUIViewController(context: Context) -> SettingsViewTableController {

        let vc = SettingsViewTableController()
        let mainVc = getMainViewController()
        vc.appDispSettings = mainVc?.theSettings

        return vc
    }

    func updateUIViewController(_ uiViewController: SettingsViewTableController, context: Context) {
    }
}
