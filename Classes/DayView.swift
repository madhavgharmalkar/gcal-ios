//
//  DayView.swift
//  Gaudiya Calendar
//
//  Created by Madhav Gharmalkar on 10/20/22.
//

import SwiftUI

struct DayView: View {
    // state
    @State private var showingActions = false
    @State private var showDateSheet = false

    @EnvironmentObject private var applicationState: GCApplicationState

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(applicationState.date.formatted(.dateTime.weekday(.wide).day().month().year()))
                .font(.title)
                .padding(.horizontal)
            LegacyMainView()
                .toolbar {
                    ToolbarItemGroup(placement: .bottomBar) {
                        Button("Today") {
                            applicationState.date = Date()
                        }
                        Spacer()
                        Button("Action") {
                            showingActions = true
                        }.confirmationDialog("Choose Option", isPresented: $showingActions) {
                            Button("Go to date") {
                                showDateSheet.toggle()
                            }
                            NavigationLink("Change location (GPS)") {
                                ChangeGPSView()
                            }
                        }
                        .sheet(isPresented: $showDateSheet) {
                            ChangeDateView(isPresented: $showDateSheet)
                                .presentationDetents([.medium])
                        }
                        Spacer()
                        NavigationLink("Settings") {
                            LegacySettingsView()
                                .navigationTitle("Settings")
                        }
                    }
                }
                .gesture(DragGesture(minimumDistance: 3.0, coordinateSpace: .local)
                    .onEnded { value in
                        switch (value.translation.width, value.translation.height) {
                        case (...0, -30 ... 30):
                            applicationState.date = Calendar.current.date(byAdding: .day, value: 1, to: applicationState.date) ?? Date()
                        case (0..., -30 ... 30):
                            applicationState.date = Calendar.current.date(byAdding: .day, value: -1, to: applicationState.date) ?? Date()
                        default:
                            print("no swipe that we care about")
                        }
                    })
        }
        .frame(maxWidth: .infinity)
    }
}

struct DayView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DayView()
        }
    }
}
