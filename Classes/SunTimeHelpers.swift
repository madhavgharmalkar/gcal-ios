//
//  SunTimeHelpers.swift
//  Gaudiya Calendar
//
//  Created by Madhav Gharmalkar on 11/5/22.
//

import Foundation

func calculateBramhaMahurta(gc_daytime: gc_daytime) -> String {
    var day1 = gc_daytime
    var day2 = gc_daytime
    
    gc_daytime_sub_minutes(&day1, 96);
    gc_daytime_sub_minutes(&day2, 48);
    
    let start = String(format: "%02d:%02d", day1.hour, day1.minute)
    let end = String(format: "%02d:%02d", day2.hour, day2.minute)
    
    return "\(start) - \(end)"
}

func calculateSunTimes(gc_daytime: gc_daytime) -> String {
    var day1 = gc_daytime
    var day2 = gc_daytime
    
    gc_daytime_sub_minutes(&day1, 24);
    gc_daytime_add_minutes(&day2, 24);
    
    let start = String(format: "%02d:%02d", day1.hour, day1.minute)
    let end = String(format: "%02d:%02d", day2.hour, day2.minute)
    
    return "\(start) - \(end)"
}
