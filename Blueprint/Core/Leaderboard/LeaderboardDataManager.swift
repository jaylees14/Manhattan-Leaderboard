//
//  LeaderboardViewModel.swift
//  Blueprint
//
//  Created by Jay Lees on 07/03/2019.
//  Copyright © 2019 Manhattan. All rights reserved.
//

import Foundation

public protocol LeaderboardDelegate {
    func didUpdateProgress(_ progress: [String: Int])
    func didReceiveError(_ error: String)
}

class LeaderboardDataManager {
    public var delegate: LeaderboardDelegate?
    private let repeatTime = 15.0
    public typealias Progress = (username: String, completed: Int)
    
    public init() {
        self.fetchProgress()
        Timer.scheduledTimer(withTimeInterval: self.repeatTime, repeats: true) { _ in
             self.fetchProgress()
        }
    }
    
    private func fetchProgress() {
        BlueprintAPI.leaderboard { (result) in
            switch(result){
            case .success(let leaderboard):
                let progression: [String: Int] = leaderboard.leaderboard.reduce(into: [:]) { dict, blueprint in
                    let current = dict[blueprint.username] ?? 0
                    dict[blueprint.username] = current + 1
                }
                self.delegate?.didUpdateProgress(progression)
            case .failure(let error):
                self.delegate?.didReceiveError(error)
            }
        }
    }
}
