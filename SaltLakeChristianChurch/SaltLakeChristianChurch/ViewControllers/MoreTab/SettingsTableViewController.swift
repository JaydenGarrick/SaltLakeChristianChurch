//
//  SettingsTableViewController.swift
//  SaltLakeChristianChurch
//
//  Created by Jayden Garrick on 1/31/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit
import Firebase

class SettingsTableViewController: UITableViewController {


    @IBOutlet weak var loginSignUpLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAroundAndSetNavBar()
        if MemberController.shared.isLoggedIn == true {
            loginSignUpLabel.text = MemberController.shared.loggedInMember?.fullName
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if MemberController.shared.isLoggedIn == true {
            loginSignUpLabel.text = MemberController.shared.loggedInMember?.fullName
        }
    }
    
    // MARK: - IBActions
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - TableView Delegate and DataSource
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 { // Login / Logout Controller
            if MemberController.shared.isLoggedIn == false {
                performSegue(withIdentifier: "ToLoginScreen", sender: self)
            } else {
                presentLogOutActionSheet()
            }
        }
        
        if indexPath.row == 1 {
            if MemberController.shared.isLoggedIn == false {
                presentAlertControllerWithOkayAction(title: "Can't edit profile", message: "You must be logged in to edit your profile.")
            } else {
                performSegue(withIdentifier: "ToEditAccount", sender: self)
            }
        }
    }
    
}

extension SettingsTableViewController {
    func presentLogOutActionSheet() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let logoutAction = UIAlertAction(title: "Logout", style: .destructive) { [weak self](_) in
            do {
                try Auth.auth().signOut()
                MemberController.shared.isLoggedIn = false
                MemberController.shared.loggedInMember = nil
            } catch let error {
                print("Error logging user out: \(error.localizedDescription)")
            }
            MemberController.shared.loggedInMember = nil
            self?.loginSignUpLabel.text = "Login / Register"
            self?.dismiss(animated: true)
            self?.tableView.reloadData()
        }
        alertController.addAction(cancelAction)
        alertController.addAction(logoutAction)
        present(alertController, animated: true)
    }
}

