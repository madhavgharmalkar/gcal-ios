//
//  MainView.swift
//  Gaudiya Calendar
//
//  Created by Madhav Gharmalkar on 10/17/22.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationView {
            LegacyMainView()
                .navigationTitle("Today")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItemGroup(placement: .bottomBar) {
                        Button("Today") {
                            guard let appDelegate = UIApplication.shared.delegate as? BalaCalAppDelegate else {
                                return
                            }

                            appDelegate.onTodayButton()
                        }
                        Spacer()
                        Button("Action") {
                            guard let appDelegate = UIApplication.shared.delegate as? BalaCalAppDelegate else {
                                return
                            }

                            appDelegate.onFindButton()
                        }
                        Spacer()
                        Button("Settings") {
                            guard let appDelegate = UIApplication.shared.delegate as? BalaCalAppDelegate else {
                                return
                            }
                            appDelegate.onSettingsButton()
                        }
                    }
                }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
