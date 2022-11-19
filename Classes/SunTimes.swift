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
                VStack() {
                    Image(systemName: "sunrise")
                        .font(.title2)
                    Text(calendarDay.shortSunriseTime())
                        .font(.callout)
                        .padding([.vertical], 1)

                    Text("Gayatri")
                        .font(.headline)
                    
                    Text(calculateSunTimes(gc_daytime: calendarDay.astrodata.sun.rise))
                }
                Spacer()
                VStack() {
                    Image(systemName: "sun.max")
                        .font(.title2)
                    Text(calendarDay.shortNoonTime())
                        .font(.callout)
                        .padding([.vertical], 1)

                    Text("Savitri")
                        .font(.headline)

                    Text(calculateSunTimes(gc_daytime: calendarDay.astrodata.sun.noon))

                    
                }
                Spacer()
                VStack() {
                    Image(systemName: "sunset")
                        .font(.title2)
                    
                    Text(calendarDay.shortSunsetTime())
                        .font(.callout)
                        .padding([.vertical], 1)

                    Text("Sarasvati")
                        .font(.headline)
                    
                    Text(calculateSunTimes(gc_daytime: calendarDay.astrodata.sun.set))
                }
            }
            .padding()
            
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
            .font(.callout)
            .padding()
        }
        .frame(maxWidth: .infinity)
    }
}
