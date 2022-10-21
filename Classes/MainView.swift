//
//  MainView.swift
//  Gaudiya Calendar
//
//  Created by Madhav Gharmalkar on 10/17/22.
//

import SwiftUI

struct MainView: View {
    @StateObject var applicationState = (UIApplication.shared.delegate as! BalaCalAppDelegate).applicationState

    var body: some View {
        NavigationStack {
            DayView()
        }
        .environmentObject(applicationState)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

func getMainViewController() -> MainViewController? {
    guard let appDelegate = UIApplication.shared.delegate as? BalaCalAppDelegate else {
        return nil
    }

    return appDelegate.mainViewCtrl
}
