//
//  LaunchScreenCopyViewController.swift
//  SaltLakeChristianChurch
//
//  Created by Jayden Garrick on 2/1/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit
import Firebase
import CoreData

class LaunchScreenCopyViewController: UIViewController, NSFetchedResultsControllerDelegate {

    // MARK: - FetchRequestController for CoreData
    let announcementsFetchRequestController: NSFetchedResultsController<BlockedAnnouncement> = {
        let fetchRequest: NSFetchRequest<BlockedAnnouncement> = BlockedAnnouncement.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "announcementID", ascending: true)]
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
    }()
    
    let memberFetchRequestController: NSFetchedResultsController<BlockedMember> = {
        let fetchRequest: NSFetchRequest<BlockedMember> = BlockedMember.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "memberID", ascending: true)]
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
    }()
    
    let calendarIDFetchRequestController: NSFetchedResultsController<AddedCalendarIDs> = {
        let fetchRequest: NSFetchRequest<AddedCalendarIDs> = AddedCalendarIDs.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "calendarID", ascending: true)]
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        announcementsFetchRequestController.delegate = self
        
        // Fetch Blocked Announcements and Members
        do {
            try announcementsFetchRequestController.performFetch()
            try memberFetchRequestController.performFetch()
            try calendarIDFetchRequestController.performFetch()
            BlockedAnnouncementController.shared.blockedAnnouncements = announcementsFetchRequestController.fetchedObjects ?? []
            BlockedMemberController.shared.blockedMembers = memberFetchRequestController.fetchedObjects ?? []
            AddedCalendarIDController.shared.addedCalendarEventIDs = calendarIDFetchRequestController.fetchedObjects ?? []
        } catch {
            print("❌Error performing fetch from FetchRequestController: \(error.localizedDescription)")
        }
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
                    print("❌Error retrieving Snapshot")
                    self.performSegue(withIdentifier: "LaunchSegue", sender: self)
                    return
                }
                MemberController.shared.loggedInMember = Member(memberID: snapshot.key, memberDictionary: memberDictionary)
                MemberController.shared.isLoggedIn = true
                print("✅Successfully Fetched logged in user!")
                self.performSegue(withIdentifier: "LaunchSegue", sender: self)
            })
        } else {
            print("⚠️User isn't logged in")
            self.performSegue(withIdentifier: "LaunchSegue", sender: self)
        }
    }
    
}
