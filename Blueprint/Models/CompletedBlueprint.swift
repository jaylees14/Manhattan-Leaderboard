//
//  CompletedBlueprint.swift
//  Blueprint
//
//  Created by Jay Lees on 07/03/2019.
//  Copyright © 2019 Manhattan. All rights reserved.
//

import Foundation

public struct CompletedBlueprint: Decodable {
    enum CodingKeys: String, CodingKey {
        case username = "username"
        case blueprint = "item_id"
    }
    
    let username: String
    let blueprint: Int
}
