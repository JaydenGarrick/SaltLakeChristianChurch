//
//  DirectoryTableViewController.swift
//  SaltLakeChristianChurch
//
//  Created by Jayden Garrick on 1/31/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit

class DirectoryTableViewController: UITableViewController {
    
    // DataSource
    var members: [Member] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MemberController.shared.fetchMembersForDirectory(memberID: nil) { (success) in
            if success {
                DispatchQueue.main.async {
                    self.members = MemberController.shared.members
                    self.tableView.reloadData()
                }
            } else {
                self.presentAlertControllerWithOkayAction(title: "dangman couldn't get members", message: ":(")
            }
        }
    }
    
    // MARK: - TableView Delegate and DataSource Functions
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemberCell", for: indexPath)
        let member = members[indexPath.row]
        cell.textLabel?.text = member.fullName
        return cell
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MemberDetailID" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let destinationVC = segue.destination as! MemberDetailViewController
            let member = members[indexPath.row]
            destinationVC.member = member
            
        }
    }
    
    
    
    

   

}
