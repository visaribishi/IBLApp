//
//  WorkingHour.swift
//  IBLApp
//
//  Created by Visar on 2/19/19.
//  Copyright © 2019 Visar. All rights reserved.
//

import Foundation

struct WorkingHour: Codable {
    let day, startHours, startMinutes, endHours, endMinutes: Int
    
    enum CodingKeys: String, CodingKey {
        case day
        case startHours = "start_hours"
        case startMinutes = "start_minutes"
        case endHours = "end_hours"
        case endMinutes = "end_minutes"
    }
}

extension WorkingHour {
    var dayName: String {
        let weekDays = Calendar.current.weekdaySymbols
        let index = (day >= 0 && day < 6) ? day + 1 : 0
        return weekDays[index]
    }
    
    var workHours: String {
        return "\(startHours):\(startMinutes) - \(endHours):\(endMinutes)"
    }
}
