//
//  SunTimes.swift
//  Gaudiya Calendar
//
//  Created by Madhav Gharmalkar on 11/5/22.
//

import SwiftUI

struct SunTimes: View {
    var calendarDay: GCCalendarDay
    
    @EnvironmentObject private var applicationState: GCApplicationState
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
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
            .font(.subheadline)
            
            VStack {
                Text("Brahma Mahurta")
                    .font(.headline)
                Text(calculateBramhaMahurta(gc_daytime: calendarDay.astrodata.sun.rise))
                    .multilineTextAlignment(.center)
                    .font(.caption)
            }
            .frame(maxWidth: .infinity)
            
            VStack(alignment: .leading) {
                Text("Sunrise Info")
                    .font(.headline)
                Text("Moon in the \(applicationState.gcStrings.getNaksatraName(calendarDay.astrodata.nNaksatra)) Naksatra")
                Text("\(applicationState.gcStrings.getYogaName(calendarDay.astrodata.nYoga)) Yoga")
                Text("Sun in \(applicationState.gcStrings.getSankrantiName(calendarDay.astrodata.nRasi)) Rasi")
            }
            .font(.subheadline)
            .font(.callout)
        }
        .padding()
        .frame(maxWidth: .infinity)
    }
}
