//
//  LeaderboardViewController.swift
//  Blueprint
//
//  Created by Jay Lees on 07/03/2019.
//  Copyright © 2019 Manhattan. All rights reserved.
//

import UIKit

class LeaderboardViewController: UIViewController {
    
    @IBOutlet weak var leaderboardCollectionView: UICollectionView!
    @IBOutlet weak var firstPlaceUsername: UILabel!
    @IBOutlet weak var secondPlaceUsername: UILabel!
    @IBOutlet weak var thirdPlaceUsername: UILabel!
    @IBOutlet weak var firstPlaceTopStackView: UIStackView!
    @IBOutlet weak var firstPlaceBottomStackView: UIStackView!
    @IBOutlet weak var secondPlaceTopStackView: UIStackView!
    @IBOutlet weak var secondPlaceBottomStackView: UIStackView!
    @IBOutlet weak var thirdPlaceTopStackView: UIStackView!
    @IBOutlet weak var thirdPlaceBottomStackView: UIStackView!
    
    private var dataManager: LeaderboardDataManager!
    private var progress = [LeaderboardDataManager.Progress]()
    private let outlineImage = UIImage(named: "outlineHexagonDark")
    private let filledImage = UIImage(named: "fillHexagonDark")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataManager = LeaderboardDataManager()
        self.dataManager.delegate = self
        
        self.leaderboardCollectionView.delegate = self
        self.leaderboardCollectionView.dataSource = self
        self.leaderboardCollectionView.register(UINib(nibName: "LeaderboardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
    }
    
    private func reloadTopThree() {
        if let first = progress.first {
            firstPlaceUsername.text = first.username
            set(stackView: firstPlaceTopStackView, to: progressTop(first.completed))
            set(stackView: firstPlaceBottomStackView, to: progressBottom(first.completed))
        } else {
            firstPlaceUsername.text = ""
            set(stackView: firstPlaceTopStackView, to: 0, hide: true)
            set(stackView: firstPlaceBottomStackView, to: 0, hide: true)
        }
        
        if let second = progress.dropFirst().first {
            secondPlaceUsername.text = second.username
            set(stackView: secondPlaceTopStackView, to: progressTop(second.completed))
            set(stackView: secondPlaceBottomStackView, to: progressBottom(second.completed))
        } else {
            secondPlaceUsername.text = ""
            set(stackView: secondPlaceTopStackView, to: 0, hide: true)
            set(stackView: secondPlaceBottomStackView, to: 0, hide: true)
        }
        
        if let third = progress.dropFirst(2).first {
            thirdPlaceUsername.text = third.username
            set(stackView: thirdPlaceTopStackView, to: progressTop(third.completed))
            set(stackView: thirdPlaceBottomStackView, to: progressBottom(third.completed))
        } else {
            thirdPlaceUsername.text = ""
            set(stackView: thirdPlaceTopStackView, to: 0, hide: true)
            set(stackView: thirdPlaceBottomStackView, to: 0, hide: true)
        }
    }
    
    private func set(stackView: UIStackView, to progress: Int, hide: Bool = false) {
        stackView.isHidden = hide
        let imageViews = stackView.subviews.filter { $0 is UIImageView } as! [UIImageView]
        imageViews.forEach { $0.image = outlineImage }
        imageViews.prefix(upTo: progress).forEach { $0.image = filledImage }
    }
    
    private func progressTop(_ completed: Int) -> Int {
        return Int(ceil(Double(completed) / 2))
    }
    
    private func progressBottom(_ completed: Int) -> Int {
        return Int(floor(Double(completed) / 2))
    }
}

extension LeaderboardViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return progress.count - 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! LeaderboardCollectionViewCell
        // +4 since we store stop 3 separately, and row is 0 indexed
        cell.configure(position: indexPath.row + 4, progress: progress[indexPath.row + 3])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 3 - 30, height: 150)
    }
}


extension LeaderboardViewController: LeaderboardDelegate {
    func didUpdateProgress(_ progress: [String : Int]) {
        self.progress = []
        for i in (0...12).reversed() {
            // Get all users with that index
            let sortedAtIndex: [LeaderboardDataManager.Progress] = progress
                .filter { $0.value == i }
                .sorted(by: { (pairA, pairB) -> Bool in
                    pairA.key.uppercased() < pairB.key.uppercased()
                })
                .map{ $0 }
            self.progress.append(contentsOf: sortedAtIndex)
        }
        
        leaderboardCollectionView.reloadData()
        reloadTopThree()
    }
    
    func didReceiveError(_ error: String) {
        let alert = UIAlertController(title: "Something went wrong", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
