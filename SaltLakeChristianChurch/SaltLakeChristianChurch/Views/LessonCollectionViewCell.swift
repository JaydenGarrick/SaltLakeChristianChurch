//
//  CollectionViewCell.swift
//  SaltLakeChristianChurch
//
//  Created by Jayden Garrick on 2/9/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit

class LessonCollectionViewCell: UICollectionViewCell {
    
    var lesson: Lesson? {
        didSet {
            guard let lesson = lesson else { return }
            if lesson.imageURL == "http://static1.squarespace.com/static/58b1f2c003596e617b2a55ad/t/5a09269a9140b7f3b7b8b654/1510549154825/1500w/SLCC+Logo+iTunes.png" {
                lessonImageView.image = #imageLiteral(resourceName: "CollectionViewHolder")
            } else {
                lessonImageView.loadImage(urlString: lesson.imageURL)
            }
            lessonTitle.text = lesson.title
        }
    }
    
    @IBOutlet weak var lessonImageView: CustomImageView!
    @IBOutlet weak var lessonTitle: UILabel!
    @IBOutlet weak var backgroundShadowView: UIView!
    
    let activityIndicatorView: UIActivityIndicatorView = {
       let activityIndicator = UIActivityIndicatorView()
        activityIndicator.startAnimating()
        activityIndicator.style = .whiteLarge
        activityIndicator.color = UIColor(named: "Tint")
        return activityIndicator
    }()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupShadowBackground()
        setupActivityIndicator()
        checkForImageBeingSet()
    }
    
    // MARK: - Setup Functions
    fileprivate func setupShadowBackground() {
        backgroundShadowView.layer.cornerRadius = 3.0
        backgroundShadowView.layer.masksToBounds = false
        backgroundShadowView.layer.shadowColor = UIColor.black.withAlphaComponent(0.5).cgColor
        backgroundShadowView.layer.shadowOffset = CGSize(width: 0, height: 0)
        backgroundShadowView.layer.shadowOpacity = 0.8

    }
    
    fileprivate func checkForImageBeingSet() {
        Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { [weak self](_) in
            if self?.lessonImageView.image != nil {
                self?.activityIndicatorView.isHidden = true
            } else {
                self?.activityIndicatorView.isHidden = false
            }
        }
    }
    
    fileprivate func setupActivityIndicator() {
        lessonImageView.addSubview(activityIndicatorView)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.centerXAnchor.constraint(equalTo: lessonImageView.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: lessonImageView.centerYAnchor).isActive = true
    }
    
}
