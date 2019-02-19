//
//  Bank.swift
//  IBLApp
//
//  Created by Visar on 2/19/19.
//  Copyright © 2019 Visar. All rights reserved.
//

import Foundation

enum Type: String, Codable {
    case branch
    case atm
}

struct Bank: Codable {
    let id: Int
    let name, address: String
    let phone: String?
    let email: String
    let website: String
    let type: Type
    let location: Location
    let workingHours: [WorkingHour]?
    
    enum CodingKeys: String, CodingKey {
        case id, name, address, phone, email, website, type, location
        case workingHours = "working_hours"
    }
}
