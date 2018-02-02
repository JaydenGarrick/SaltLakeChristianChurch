//
//  SettingsTableViewController.swift
//  SaltLakeChristianChurch
//
//  Created by Jayden Garrick on 1/31/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {


    @IBOutlet weak var loginSignUpLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAroundAndSetNavBar()
        if MemberController.shared.isLoggedIn == true {
            loginSignUpLabel.text = MemberController.shared.loggedInMember?.fullName
        }

    }

    // MARK: - IB Actions
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    // MARK: - Table view data source

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    }
    
    // MARK: - TableView Delegate and DataSource
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if MemberController.shared.isLoggedIn == false {
                performSegue(withIdentifier: "ToLoginScreen", sender: self)
            } else {
                
            }
        }
    }
    
}


