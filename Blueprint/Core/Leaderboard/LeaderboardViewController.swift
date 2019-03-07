//
//  LeaderboardViewController.swift
//  Blueprint
//
//  Created by Jay Lees on 07/03/2019.
//  Copyright © 2019 Manhattan. All rights reserved.
//

import UIKit

class LeaderboardViewController: UIViewController {
    @IBOutlet weak var topPlayerTableView: UITableView!
    @IBOutlet weak var allPlayerTableView: UITableView!
    private let maxTopPlayers = 9
    
    typealias Progress = (username: String, progression: Float)
    
    var dataManager: LeaderboardDataManager!
    var progress = [Progress]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataManager = LeaderboardDataManager()
        self.dataManager.delegate = self

        topPlayerTableView.delegate = self
        topPlayerTableView.dataSource = self
        topPlayerTableView.clipsToBounds = false
        
        allPlayerTableView.delegate = self
        allPlayerTableView.dataSource = self
        allPlayerTableView.clipsToBounds = false
        
        topPlayerTableView.register(UINib(nibName: "TopPlayerTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        allPlayerTableView.register(UINib(nibName: "TopPlayerTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
}

extension LeaderboardViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        switch tableView {
        case topPlayerTableView:
            // Return at most top 9 players
            return min(maxTopPlayers, progress.count)
        case allPlayerTableView:
            return progress.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch tableView {
        case topPlayerTableView:
            return 20
        case allPlayerTableView:
            return 15
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TopPlayerTableViewCell
        cell.populate(username: progress[indexPath.section].username,
                      progress: progress[indexPath.section].progression)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tableView {
        case topPlayerTableView:
            return 60
        case allPlayerTableView:
            return 50
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension LeaderboardViewController: LeaderboardDelegate {
    func didUpdateProgress(_ progress: [String : Float]) {
        self.progress = progress.sorted(by: { (pairA, pairB) -> Bool in
            pairA.value > pairB.value
        }).map { $0 }
        topPlayerTableView.reloadData()
        allPlayerTableView.reloadData()
    }
    
    func didReceiveError(_ error: String) {
        let alert = UIAlertController(title: "Something went wrong", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
}
