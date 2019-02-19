//
//  DataManager.swift
//  IBLApp
//
//  Created by Visar on 2/19/19.
//  Copyright © 2019 Visar. All rights reserved.
//

import Foundation

public final class DataManager {

    public static let shared = DataManager()

    private var localJsonName = "IBL_data"
    
    func getBankList(completion: @escaping(Result<[Bank]>) -> Void) {
        if let url = Bundle.main.url(forResource: localJsonName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(ResponseObject.self, from: data)
                completion(Result.success(jsonData.data))
            } catch {
                completion(Result.failure(error))
            }
        } else {
            completion(Result.success([]))
        }
    }
}
