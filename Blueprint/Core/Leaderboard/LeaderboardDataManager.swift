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
    private var numberOfBlueprints = 1
    public typealias Progress = (username: String, completed: Int)
    
    public init() {
        BlueprintAPI.itemSchema { (result) in
            switch(result) {
            case .success(let schema):
                // Compute number of items which have type 2, 3, 5
                self.numberOfBlueprints = schema.items
                    .filter {
                        $0.type == Item.ItemType.blueprintPlaceable ||
                        $0.type == Item.ItemType.blueprintUnplaceable
                    }.count
                print(self.numberOfBlueprints)
                
                self.fetchProgress()
            case .failure(let error):
                self.delegate?.didReceiveError(error)
            }
        }
    }
    
    private func fetchProgress() {
        // Mock the data
        let leaderboard = Leaderboard(leaderboard: [
            CompletedBlueprint(username: "Jay", blueprint: 1),
            CompletedBlueprint(username: "Jay", blueprint: 2),
            CompletedBlueprint(username: "Jay", blueprint: 3),
            CompletedBlueprint(username: "Jay", blueprint: 4),
            CompletedBlueprint(username: "Jay", blueprint: 2),
            CompletedBlueprint(username: "Jay", blueprint: 3),
            CompletedBlueprint(username: "Jay", blueprint: 4)]
            )
        let leaderboard2 = Leaderboard(leaderboard: [
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
            CompletedBlueprint(username: "TheLegend27", blueprint: 7),
            CompletedBlueprint(username: "Jay2", blueprint: 1),
            CompletedBlueprint(username: "Jay2", blueprint: 2),
            CompletedBlueprint(username: "Jay2", blueprint: 3),
            CompletedBlueprint(username: "Jay2", blueprint: 4),
            CompletedBlueprint(username: "Jay2", blueprint: 2),
            CompletedBlueprint(username: "Jay2", blueprint: 3),
            CompletedBlueprint(username: "Jay2", blueprint: 4),
            CompletedBlueprint(username: "Will2", blueprint: 7),
            CompletedBlueprint(username: "Will2", blueprint: 7),
            CompletedBlueprint(username: "Will2", blueprint: 7),
            CompletedBlueprint(username: "Will2", blueprint: 7),
            CompletedBlueprint(username: "Will2", blueprint: 7),
            CompletedBlueprint(username: "Will2", blueprint: 7),
            CompletedBlueprint(username: "Andrei2", blueprint: 7),
            CompletedBlueprint(username: "Andrei2", blueprint: 7),
            CompletedBlueprint(username: "Andrei2", blueprint: 7),
            CompletedBlueprint(username: "Andrei2", blueprint: 7),
            CompletedBlueprint(username: "Andrei2", blueprint: 7),
            CompletedBlueprint(username: "Ben2", blueprint: 7),
            CompletedBlueprint(username: "Ben2", blueprint: 7),
            CompletedBlueprint(username: "Ben2", blueprint: 7),
            CompletedBlueprint(username: "Ben2", blueprint: 7),
            CompletedBlueprint(username: "Eli2", blueprint: 7),
            CompletedBlueprint(username: "Eli2", blueprint: 7),
            CompletedBlueprint(username: "Eli2", blueprint: 7),
            CompletedBlueprint(username: "Adam2", blueprint: 7),
            CompletedBlueprint(username: "Adam2", blueprint: 7),
            CompletedBlueprint(username: "TheLegend272", blueprint: 7)
        ])
        
        // Build up a dictionary of username -> number completed
        let progression: [String: Int] = leaderboard.leaderboard.reduce(into: [:]) { dict, blueprint in
            let current = dict[blueprint.username] ?? 0
            dict[blueprint.username] = current + 1
        }
        
        let progression2: [String: Int] = leaderboard2.leaderboard.reduce(into: [:]) { dict, blueprint in
            let current = dict[blueprint.username] ?? 0
            dict[blueprint.username] = current + 1
        }
      
        delegate?.didUpdateProgress(progression)
        
        Timer.scheduledTimer(withTimeInterval: 10, repeats: false) { (timer) in
            self.delegate?.didUpdateProgress(progression2)
        }
    }
}
