//
//  MainView.swift
//  Gaudiya Calendar
//
//  Created by Madhav Gharmalkar on 10/17/22.
//

import SwiftUI
import MapKit

struct MainView: View {
    var body: some View {
        NavigationView {
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
    var body: some View {
        VStack {

        }
        .navigationTitle("Monday, October 17")
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
