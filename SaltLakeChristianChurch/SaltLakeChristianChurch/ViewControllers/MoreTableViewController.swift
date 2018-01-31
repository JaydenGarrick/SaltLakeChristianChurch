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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hides Keyboard and sets NavigationBar
        self.hideKeyboardWhenTappedAroundAndSetNavBar()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.estimatedRowHeight = 350
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//
//
//        if indexPath.section == 1 {
//            return 44
//        }
//        if indexPath.section == 2 {
//            return UITableViewAutomaticDimension
//        } else {
//            return 44
//        }
//    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1 {
            return 44
        } else {
            return UITableViewAutomaticDimension
        }
    }

   

}
