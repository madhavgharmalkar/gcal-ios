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
        let calendarDay = applicationState.appDelegate.mainViewCtrl.dayView.data.calendarDay as GCCalendarDay

        let monthName = applicationState.gcStrings.getMasaName(calendarDay.astrodata.nMasa) ?? ""
        let vedicMonthAndYear = "\(monthName), \(calendarDay.astrodata.nGaurabdaYear) Gaurabda"

        let tithiName = applicationState.gcStrings.getTithiName(calendarDay.astrodata.nTithi) ?? ""
        let paksaName = applicationState.gcStrings.getPaksaName(calendarDay.astrodata.nPaksa) ?? ""

        VStack(alignment: .leading, spacing: 0) {
            Text(applicationState.date.formatted(.dateTime.weekday(.wide).day().month().year()))
                .font(.title)
                .padding(.horizontal)
            HStack(spacing: 3) {
                Image(systemName: "location.fill")
                Text("\(applicationState.displaySettings.locCity) / \(applicationState.displaySettings.locCountry)")
            }.padding(.horizontal)
                .font(.caption)

            Spacer()
                .frame(height: 10)

            Text("\(tithiName), \(paksaName) Paksa")
                .padding(.horizontal)
                .font(.callout)

            Text(vedicMonthAndYear)
                .padding(.horizontal)
                .font(.caption)

            HStack {
                Spacer()
                VStack {
                    Image(systemName: "sunrise")
                    Text(calendarDay.shortSunriseTime())
                }
                Spacer()
                VStack {
                    Image(systemName: "sun.max")
                    Text(calendarDay.shortNoonTime())
                }
                Spacer()
                VStack {
                    Image(systemName: "sunset")
                    Text(calendarDay.shortSunsetTime())
                }
                Spacer()
            }
            .padding(.vertical)
            .font(.subheadline)
            LegacyMainView()
        }
        .frame(maxWidth: .infinity)
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
}

struct DayView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DayView()
        }
    }
}
