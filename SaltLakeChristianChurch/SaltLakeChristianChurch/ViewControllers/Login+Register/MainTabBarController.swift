//
//  MainTabBarController.swift
//  SaltLakeChristianChurch
//
//  Created by Jayden Garrick on 3/21/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    let lessonDetailView = LessonDetailView.initFromNib()
    var maximizedTopAnchorConstraint: NSLayoutConstraint!
    var minimizedTopAnchorConstraint: NSLayoutConstraint!
    var bottomAnchorConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPlayerDetailsView()
    }
    
    @objc func minimizePlayerDetails() {
        maximizedTopAnchorConstraint.isActive = false
        bottomAnchorConstraint.constant = view.frame.height
        minimizedTopAnchorConstraint.isActive = true
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.tabBar.transform = .identity
            self.lessonDetailView.normalPlayerView.alpha = 0
            self.lessonDetailView.miniPlayerView.alpha = 1
        })
    }
    
    func maximizePlayerDetails(lesson: Lesson?) {
        minimizedTopAnchorConstraint.isActive = false
        maximizedTopAnchorConstraint.isActive = true
        maximizedTopAnchorConstraint.constant = 0
        bottomAnchorConstraint.constant = 0
        
        if lesson != nil {
            lessonDetailView.lesson = lesson
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.tabBar.transform = CGAffineTransform(translationX: 0, y: 100)
            self.lessonDetailView.normalPlayerView.alpha = 1
            self.lessonDetailView.miniPlayerView.alpha = 0
        })
    }
    
    fileprivate func setupPlayerDetailsView() {
        print("Setting up PlayerDetailsView")
        
        // use auto layout
        view.insertSubview(lessonDetailView, belowSubview: tabBar)
        
        // enables auto layout
        lessonDetailView.translatesAutoresizingMaskIntoConstraints = false
        maximizedTopAnchorConstraint = lessonDetailView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        maximizedTopAnchorConstraint.isActive = true
        bottomAnchorConstraint = lessonDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.height)
        bottomAnchorConstraint.isActive = true
        minimizedTopAnchorConstraint = lessonDetailView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
        lessonDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        lessonDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }

}
