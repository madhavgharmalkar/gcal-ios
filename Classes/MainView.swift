//
//  MainView.swift
//  Gaudiya Calendar
//
//  Created by Madhav Gharmalkar on 10/17/22.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationStack {
            DayView()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

struct DayView: View {
    @State private var showingActions = false

    // state
    @State private var showDateSheet = false
    @State private var showGpsSheet = false

    var body: some View {
        LegacyMainView()
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
                        showingActions = true
                    }.confirmationDialog("Choose Option", isPresented: $showingActions) {
                        Button("Go to date") {
                            showDateSheet.toggle()
                        }
                        Button("Change location (select)") {
                            getMainViewController()?.onShowLocationDlg()
                        }
                        Button("Change location (GPS)") {
                            showGpsSheet.toggle()
                        }
                    }
                    .sheet(isPresented: $showDateSheet) {
                        ChangeDateView(isPresented: $showDateSheet)
                            .presentationDetents([.medium])
                    }
                    .sheet(isPresented: $showGpsSheet) {
                        ChangeGPSView(isPresented: $showGpsSheet)
                            .presentationDetents([.medium, .large])
                    }
                    Spacer()
                    NavigationLink("Settings") {
                        LegacySettingsView()
                            .navigationTitle("Settings")
                    }
                }
            }
    }
}

func getMainViewController() -> MainViewController? {
    guard let appDelegate = UIApplication.shared.delegate as? BalaCalAppDelegate else {
        return nil
    }

    return appDelegate.mainViewCtrl
}
