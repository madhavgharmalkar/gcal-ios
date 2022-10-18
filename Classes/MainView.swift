//
//  MainView.swift
//  Gaudiya Calendar
//
//  Created by Madhav Gharmalkar on 10/17/22.
//

import SwiftUI
import MapKit

struct MainView: View {
    @StateObject var gcalData = GCalDataBinder()

    var body: some View {
        NavigationView {
            DayView()
        }.environmentObject(gcalData)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

struct DayView: View {
    @EnvironmentObject var gcalData: GCalDataBinder

    var body: some View {
        VStack(alignment: .leading) {
        }
        .navigationTitle(
            gcalData.date.formatted(
                .dateTime.day()
                .month()
                .year()
            )
        )
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                HStack {
                    NavigationLink {
                        MapView()
                    } label: {
                        Label("Map", systemImage: "location")
                            .labelStyle(.iconOnly)
                    }

                    NavigationLink {
                        CalendarView()
                    } label: {
                        Label("Calendar", systemImage: "calendar")
                            .labelStyle(.iconOnly)
                    }
                }
            }
        }
    }
}

struct CalendarView: View {
    @State private var date = Date()

    var body: some View {
        DatePicker(
            "Date",
            selection: $date,
            displayedComponents: [.date]
        )
        .datePickerStyle(.graphical)
        .navigationTitle("Select Date")
    }
}

struct MapView: View {

    var body: some View {
        Text("temp holder for map")
    }
}
