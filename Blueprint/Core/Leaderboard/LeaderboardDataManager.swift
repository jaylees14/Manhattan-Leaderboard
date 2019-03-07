//
//  LeaderboardViewModel.swift
//  Blueprint
//
//  Created by Jay Lees on 07/03/2019.
//  Copyright © 2019 Manhattan. All rights reserved.
//

import Foundation

public protocol LeaderboardDelegate {
    func didUpdateProgress(_ progress: [String: Float])
    func didReceiveError(_ error: String)
}

class LeaderboardDataManager {
    
    
    var delegate: LeaderboardDelegate?
    
    var numberOfBlueprints = 1
    
    public init() {
        BlueprintAPI.itemSchema { (result) in
            switch(result) {
            case .success(let schema):
                // Compute number of items which have type 2, 3, 5
                self.numberOfBlueprints = schema.items
                    .filter {
                        $0.type == Item.ItemType.blueprintPlaceable ||
                        $0.type == Item.ItemType.blueprintUnplaceable ||
                        $0.type == Item.ItemType.blueprintGoal
                    }.count
                
                self.fetchProgress()
            case .failure(let error):
                self.delegate?.didReceiveError(error)
            }
        }
    }
    
    private func fetchProgress() {
        var progression = [String: Float]()
        
        // Mock the data
        let leaderboard = Leaderboard(leaderboard: [
            CompletedBlueprint(username: "Jay", blueprint: 1),
            CompletedBlueprint(username: "Jay", blueprint: 2),
            CompletedBlueprint(username: "Jay", blueprint: 3),
            CompletedBlueprint(username: "Jay", blueprint: 4),
            CompletedBlueprint(username: "Jay", blueprint: 2),
            CompletedBlueprint(username: "Jay", blueprint: 3),
            CompletedBlueprint(username: "Jay", blueprint: 4),
            CompletedBlueprint(username: "Will", blueprint: 7),
            CompletedBlueprint(username: "Will", blueprint: 7),
            CompletedBlueprint(username: "Will", blueprint: 7),
            CompletedBlueprint(username: "Will", blueprint: 7),
            CompletedBlueprint(username: "Will", blueprint: 7),
            CompletedBlueprint(username: "Will", blueprint: 7),
            CompletedBlueprint(username: "Andrei", blueprint: 7),
            CompletedBlueprint(username: "Andrei", blueprint: 7),
            CompletedBlueprint(username: "Andrei", blueprint: 7),
            CompletedBlueprint(username: "Andrei", blueprint: 7),
            CompletedBlueprint(username: "Andrei", blueprint: 7),
            CompletedBlueprint(username: "Ben", blueprint: 7),
            CompletedBlueprint(username: "Ben", blueprint: 7),
            CompletedBlueprint(username: "Ben", blueprint: 7),
            CompletedBlueprint(username: "Ben", blueprint: 7),
            CompletedBlueprint(username: "Eli", blueprint: 7),
            CompletedBlueprint(username: "Eli", blueprint: 7),
            CompletedBlueprint(username: "Eli", blueprint: 7),
            CompletedBlueprint(username: "Adam", blueprint: 7),
            CompletedBlueprint(username: "Adam", blueprint: 7),
            CompletedBlueprint(username: "TheLegend27", blueprint: 7)
        ])
        
        // Build up a dictionary of username -> progression
        leaderboard.leaderboard.forEach { (completed) in
            let current = progression[completed.username] ?? 0
            progression[completed.username] = current + (1.0 / Float(numberOfBlueprints))
        }
        delegate?.didUpdateProgress(progression)
    }
}
