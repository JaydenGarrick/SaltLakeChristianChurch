//
//  CollectionViewCell.swift
//  SaltLakeChristianChurch
//
//  Created by Jayden Garrick on 2/9/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var lessonImageView: UIImageView!
    @IBOutlet weak var lessonTitle: UILabel!
    @IBOutlet weak var backgroundShadowView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundShadowView.layer.cornerRadius = 3.0
        backgroundShadowView.layer.masksToBounds = false
        backgroundShadowView.layer.shadowColor = UIColor.black.withAlphaComponent(0.5).cgColor
        backgroundShadowView.layer.shadowOffset = CGSize(width: 0, height: 0)
        backgroundShadowView.layer.shadowOpacity = 0.8
    }
    
}
