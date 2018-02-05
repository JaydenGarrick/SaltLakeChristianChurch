//
//  AnnouncementsViewController.swift
//  SaltLakeChristianChurch
//
//  Created by Jayden Garrick on 1/30/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit

class AnnouncementsViewController: UIViewController {

    
    // MARK: - IBOutlets and constants / variables
    @IBOutlet weak var addEventBarButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // HandleNavBar and Keyboard
        self.hideKeyboardWhenTappedAroundAndSetNavBar()
        
        // Check to see if logged in member is admin
        if MemberController.shared.loggedInMember?.isAdmin == false {
            self.navigationItem.rightBarButtonItem = nil
        }
        
    }
    
    


}
