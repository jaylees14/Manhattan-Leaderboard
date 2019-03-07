//
//  Result.swift
//  Blueprint
//
//  Created by Jay Lees on 26/02/2019.
//  Copyright © 2019 Manhattan. All rights reserved.
//

import Foundation

public enum Result<S,T> {
    case success(S)
    case failure(T)
}
