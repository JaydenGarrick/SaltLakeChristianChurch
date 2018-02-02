//
//  LaunchScreenCopyViewController.swift
//  SaltLakeChristianChurch
//
//  Created by Jayden Garrick on 2/1/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit
import Firebase

class LaunchScreenCopyViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchLoggedInUser()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func fetchLoggedInUser() {
        
        if Auth.auth().currentUser?.uid != nil {
            guard let uuid = Auth.auth().currentUser?.uid else { self.performSegue(withIdentifier: "LaunchSegue", sender: self) ; return }
            let reference = Database.database().reference().child("members").child(uuid)
            reference.observeSingleEvent(of: .value, with: { (snapshot) in
                guard let memberDictionary = snapshot.value as? [String : Any] else {
                    print("Error retrieving Snapshot")
                    self.performSegue(withIdentifier: "LaunchSegue", sender: self)
                    return
                }
                MemberController.shared.loggedInMember = Member(memberID: snapshot.key, memberDictionary: memberDictionary)
                MemberController.shared.isLoggedIn = true
                print("Successfully Fetched logged in user!")
                self.performSegue(withIdentifier: "LaunchSegue", sender: self)
            })
        } else {
            print("User isn't logged in")
            self.performSegue(withIdentifier: "LaunchSegue", sender: self)
        }
        
    }
    
  


}
