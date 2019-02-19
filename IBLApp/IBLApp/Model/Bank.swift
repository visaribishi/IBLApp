//
//  Bank.swift
//  IBLApp
//
//  Created by Visar on 2/19/19.
//  Copyright © 2019 Visar. All rights reserved.
//

import Foundation

struct Bank: Codable {
    let id: Int
    let name, address: String
    let phone: String?
    let email: String
    let website: String
    let type: String
    let location: Location
    let workingHours: [WorkingHour]?
    
    enum CodingKeys: String, CodingKey {
        case id, name, address, phone, email, website, type, location
        case workingHours = "working_hours"
    }
}
