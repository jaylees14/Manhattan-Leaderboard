//
//  LeaderboardCollectionViewCell.swift
//  Blueprint
//
//  Created by Jay Lees on 19/03/2019.
//  Copyright © 2019 Manhattan. All rights reserved.
//

import UIKit

class LeaderboardCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var topBlueprintStackView: UIStackView!
    @IBOutlet weak var bottomBlueprintStackView: UIStackView!
    
    private var outlineImage: UIImage?
    private var filledImage: UIImage?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.outlineImage = UIImage(named: "outlineHexagon")
        self.filledImage = UIImage(named: "fillHexagon")
        
        self.layer.cornerRadius = 12
    }
    
    public func configure(position: Int, progress: LeaderboardDataManager.Progress) {
        positionLabel.text = "\(position)"
        usernameLabel.text = progress.username
        
        let topImageViews = topBlueprintStackView.subviews.filter { $0 is UIImageView } as! [UIImageView]
        let bottomImageViews = bottomBlueprintStackView.subviews.filter { $0 is UIImageView } as! [UIImageView]
        
        // Firstly clear the views
        topImageViews.forEach { $0.image =  outlineImage }
        bottomImageViews.forEach { $0.image = outlineImage }
        
        // Now fill from left to right, starting with the top. If the number is odd, will always fill top more
        let progressTop = Int(ceil(Double(progress.completed) / 2))
        let progressBottom = Int(floor(Double(progress.completed) / 2))
        
        guard progressTop <= topImageViews.count && progressBottom <= bottomImageViews.count else {
            fatalError("Progressed more than image have allocated")
        }
        
        topImageViews.prefix(upTo: progressTop).forEach { $0.image = filledImage }
        bottomImageViews.prefix(upTo: progressBottom).forEach { $0.image = filledImage }
        
        self.layoutIfNeeded()
    }
}
