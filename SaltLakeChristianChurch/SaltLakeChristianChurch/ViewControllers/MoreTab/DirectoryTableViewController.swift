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
    var membersDictionary: [String:[Member]] = [:]
    var membersSectionTitles: [String] = []
    let memberIndexTitles = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    
    // MARK: - viewDidLoad / viewWillAppear
    override func viewDidLoad() {
        super.viewDidLoad()
        MemberController.shared.fetchMembersForDirectory(memberID: nil) { (success) in
            if success {
                DispatchQueue.main.async {
                    self.members = MemberController.shared.members
                    self.createMemberDictionary()
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
        self.navigationController?.view.backgroundColor = UIColor(red: 71.0/255.0, green: 199.0/255.0, blue: 236/255.0, alpha: 1.0)
    }
    
    // MARK: - Function to sort members in dictionary for index
    func createMemberDictionary() {
        
        // Cycle through members array
        for member in members {
            
            // Get the first letter of the member and build the dictionary
            let memberName = member.fullName
            let firstLetterIndex = memberName.index(memberName.startIndex, offsetBy: 1)
            let memberKey = String(memberName[..<firstLetterIndex])
            if var memberValues = membersDictionary[memberKey] {
                memberValues.append(member)
                membersDictionary[memberKey] = memberValues
            } else {
                membersDictionary[memberKey] = [member]
            }
        }
        
        // Get the section titles from the dictionary's keys and sort them in ascending order
        membersSectionTitles = [String](membersDictionary.keys)
        membersSectionTitles = membersSectionTitles.sorted(by: {$0 < $1})
    }
    
    // MARK: - TableView Delegate and DataSource Functions
    override func numberOfSections(in tableView: UITableView) -> Int {
        return membersSectionTitles.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return membersSectionTitles[section]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let memberKey = membersSectionTitles[section]
        guard let memberValues = membersDictionary[memberKey] else { return 0 }
        return memberValues.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemberCell", for: indexPath)
        
        // Configure the cell...
        let memberKey = membersSectionTitles[indexPath.section]
        if let memberValues = membersDictionary[memberKey] {
            cell.textLabel?.text = memberValues[indexPath.row].fullName
        }
        return cell
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return memberIndexTitles
    }
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
       
        guard let index = membersSectionTitles.index(of: title) else {
            return -1
        }
        print(membersDictionary)
        return index
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
            let memberKey = membersSectionTitles[indexPath.section]
            if let memberValues = membersDictionary[memberKey] {
                let member = memberValues[indexPath.row]
                destinationVC.member = member
            }
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
        
        // Fetch the members for the directory
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
        let alertController = UIAlertController(title: "Are you sure you want to block this member?", message: "Once you have completed this action, it can't be undone", preferredStyle: .alert)
        let blockAction = UIAlertAction(title: "Block", style: .destructive) { (_) in
            self.hideMember(member: member)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(blockAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
}

