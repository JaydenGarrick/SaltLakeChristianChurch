//
//  CollectionViewCell.swift
//  SaltLakeChristianChurch
//
//  Created by Jayden Garrick on 2/9/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit

class LessonCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var lessonImageView: UIImageView! 
    @IBOutlet weak var lessonTitle: UILabel!
    @IBOutlet weak var backgroundShadowView: UIView!
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.startAnimating()
        indicator.activityIndicatorViewStyle = .whiteLarge
        indicator.tintColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        indicator.color = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        
        return indicator
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupShadowBackground()
        lessonImageView.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: lessonImageView.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: lessonImageView.centerYAnchor).isActive = true

    }
    
    // MARK: - Setup Functions
    fileprivate func setupShadowBackground() {
        backgroundShadowView.layer.cornerRadius = 3.0
        backgroundShadowView.layer.masksToBounds = false
        backgroundShadowView.layer.shadowColor = UIColor.black.withAlphaComponent(0.5).cgColor
        backgroundShadowView.layer.shadowOffset = CGSize(width: 0, height: 0)
        backgroundShadowView.layer.shadowOpacity = 0.8

    }
    
}
