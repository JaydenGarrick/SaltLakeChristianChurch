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
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        MemberController.shared.fetchMembersForDirectory(memberID: nil) { (success) in
            if success {
                DispatchQueue.main.async {
                    self.members = MemberController.shared.members
                    self.tableView.reloadData()
                }
            } else {
                self.presentAlertControllerWithOkayAction(title: "Service Error", message: "Coudln't retrieve the members from the database")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.hideKeyboardWhenTappedAroundAndSetNavBar()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.view.backgroundColor = UIColor(named: "Primary")
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
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let member = members[indexPath.row]
            presentHideAlert(member: member)
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Hide and Block"
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

// MARK: - Handle Hiding Member in the Directory
extension DirectoryTableViewController {
    
    func hideMember(member: Member) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let memberID = member.memberID
        let blockedMember = BlockedMember(memberID: memberID)
        BlockedMemberController.shared.blockedMembers.append(blockedMember)
        BlockedMemberController.shared.add(blockedID: memberID)
        
        MemberController.shared.fetchMembersForDirectory(memberID: nil) { (success) in
            if success {
                DispatchQueue.main.async {
                    self.members = MemberController.shared.members
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.tableView.reloadData()
                }
            } else {
                self.presentAlertControllerWithOkayAction(title: "Service Error", message: "Coudln't retrieve the members from the database")
            }
        }
    }
    
    func presentHideAlert(member: Member) {
        let alertController = UIAlertController(title: "Are you sure you want to block this member?", message: "Once you have completed this action, you can't undo it", preferredStyle: .alert)
        let blockAction = UIAlertAction(title: "Block", style: .destructive) { (_) in
            self.hideMember(member: member)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(blockAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
}

