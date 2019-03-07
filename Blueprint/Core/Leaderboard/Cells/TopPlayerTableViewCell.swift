//
//  TopPlayerTableViewCell.swift
//  Blueprint
//
//  Created by Jay Lees on 07/03/2019.
//  Copyright © 2019 Manhattan. All rights reserved.
//

import UIKit

class TopPlayerTableViewCell: UITableViewCell {
    @IBOutlet private weak var usernameBackgroundView: UIView!
    @IBOutlet private weak var usernameLabel: UILabel!
    
    public func populate(username: String, progress: Float) {
        usernameLabel.text = username

        // Add progression view
        let progressView = UIView(frame: CGRect(
            x: usernameBackgroundView.frame.width - 10,
            y: 0,
            width: max(5, (self.frame.width - usernameBackgroundView.frame.width) * CGFloat(progress)),
            height: self.frame.height))
        
        progressView.backgroundColor = UIColor.brandPrimaryDark
        self.addSubview(progressView)
        
        
        // Create hexagon
        let hexagonView = UIView(frame: CGRect(x: progressView.frame.width - ((self.frame.height * 1.5) / 2),
                                               y: -self.frame.height/4,
                                               width: self.frame.height * 1.5, height: self.frame.height * 1.5))
        hexagonView.backgroundColor = .clear
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = UIBezierPath(roundedRegularPolygon: hexagonView.frame, numberOfSides: 6, cornerRadius: 10).cgPath
        shapeLayer.fillColor = UIColor.brandAccent.cgColor
        shapeLayer.strokeColor = UIColor.brandAccent.cgColor
        shapeLayer.lineWidth = 1.0
        hexagonView.layer.addSublayer(shapeLayer)
        
        let progressLabel = UILabel(frame: CGRect(origin: .zero, size: hexagonView.frame.size))
        progressLabel.text = String(format:"%.1f", progress * 100) + "%"
        progressLabel.textColor = .white
        progressLabel.textAlignment = .center
        hexagonView.addSubview(progressLabel)
        
        progressView.addSubview(hexagonView)
        
        self.layer.cornerRadius = 10
        self.usernameBackgroundView.layer.cornerRadius = 10
        self.bringSubviewToFront(usernameBackgroundView)
    }
}
