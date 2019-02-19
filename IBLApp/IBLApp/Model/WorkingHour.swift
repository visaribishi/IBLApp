//
//  WorkingHour.swift
//  IBLApp
//
//  Created by Visar on 2/19/19.
//  Copyright © 2019 Visar. All rights reserved.
//

import Foundation

struct WorkingHour: Codable {
    let day, startHours, startMinutes, endHours: Int
    let endMinutes: Int
    
    enum CodingKeys: String, CodingKey {
        case day
        case startHours = "start_hours"
        case startMinutes = "start_minutes"
        case endHours = "end_hours"
        case endMinutes = "end_minutes"
    }
}
