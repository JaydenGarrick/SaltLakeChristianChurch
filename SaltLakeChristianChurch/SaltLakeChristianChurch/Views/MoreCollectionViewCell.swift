//
//  MoreCollectionViewCell.swift
//  SaltLakeChristianChurch
//
//  Created by Jayden Garrick on 4/2/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit

class MoreCollectionViewCell: UICollectionViewCell {
    var imageView = UIImageView(image: #imageLiteral(resourceName: "church"))
    var nameLabel = UILabel() {
        didSet {
            nameLabel.ambience = true
            nameLabel.invertColor = .white
            nameLabel.textColorInvert = .white
        }
    }
    let artistNameLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        nameLabel.textColorInvert = .white
        stylizeUI()
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func stylizeUI() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        
        nameLabel.text = ""
        nameLabel.font = UIFont(name: "Avenir Next", size: 16)
        nameLabel.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
    }
    
    fileprivate func setupViews() {
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        let stackView = UIStackView(arrangedSubviews: [imageView, nameLabel])
        stackView.axis = .vertical
        
        // Enables Autolayout
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
}









