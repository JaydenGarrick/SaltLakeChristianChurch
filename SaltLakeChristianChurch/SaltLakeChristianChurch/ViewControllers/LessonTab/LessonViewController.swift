//
//  SermonViewController.swift
//  SaltLakeChristianChurch
//
//  Created by Jayden Garrick on 1/30/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit

class LessonViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // HandleNavBar and Keyboard
        self.hideKeyboardWhenTappedAroundAndSetNavBar()
        
        LessonController.shared.parseFeedWith(urlString: "https://www.saltlakechristianchurch.com/lessons-on-audio/?format=rss") { (lessons) in
          // RELOAD TABLEVIEW
        }
    }

}


