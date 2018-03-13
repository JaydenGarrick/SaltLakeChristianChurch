//
//  MoreTableViewController.swift
//  SaltLakeChristianChurch
//
//  Created by Jayden Garrick on 1/31/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit

class MoreTableViewController: UITableViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var readScriptureLabel: UILabel!
    @IBOutlet weak var directoryCell: UITableViewCell!
    
    // MARK: - viewDidLoad / viewWillAppear
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hides Keyboard and sets NavigationBar
        self.hideKeyboardWhenTappedAroundAndSetNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.estimatedRowHeight = 350
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1 {
            return 44
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                if MemberController.shared.isLoggedIn == true {
                    performSegue(withIdentifier: "ToDirectory", sender: self)
                } else {
                    presentActionSheet()
                }
            }
        }
    }

}

// MARK: - Create alert for member
extension MoreTableViewController {
    
    func presentActionSheet() {
        let actionSheet = UIAlertController(title: "For privacy reasons, you must be a member of Salt Lake Christian Church to access the directory", message: nil, preferredStyle: .actionSheet)
        actionSheet.view.tintColor = #colorLiteral(red: 0.2784313725, green: 0.7803921569, blue: 0.9254901961, alpha: 1)
        let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        let contactUsAction = UIAlertAction(title: "Interested in becoming a member? Contact us", style: .default) { [weak self](_) in
            self?.performSegue(withIdentifier: "ToContactUs", sender: self)
        }
        let loginAction = UIAlertAction(title: "Already a member? Login", style: .default) { [weak self](_) in
            self?.performSegue(withIdentifier: "ToLogin", sender: self)
        }
        actionSheet.addAction(contactUsAction)
        actionSheet.addAction(loginAction)
        actionSheet.addAction(okayAction)
        present(actionSheet, animated: true)
    }
    
}
