//
//  Result.swift
//  IBLApp
//
//  Created by Visar on 2/19/19.
//  Copyright © 2019 Visar. All rights reserved.
//

import Foundation

public enum Result<Value> {
    case success(Value)
    case failure(Error)
}
