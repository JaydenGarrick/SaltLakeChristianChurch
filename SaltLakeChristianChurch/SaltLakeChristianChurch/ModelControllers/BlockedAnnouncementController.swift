//
//  BlockedAnnouncementController.swift
//  SaltLakeChristianChurch
//
//  Created by Jayden Garrick on 2/11/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import Foundation
import CoreData

class BlockedAnnouncementController {
    // MARK: - Constants and Variables
    static let shared = BlockedAnnouncementController() ; private init(){} // Singleton
    var blockedAnnouncements: [BlockedAnnouncement] = [] // Datasource
    
    // CRUD Functions
    
    
    /// Adds a blocked ID for the current device using CoreData
    ///
    /// - Parameter blockedID: The uid of the announcement that's getting blocked
    func add(blockedID: String) {
        let _ = BlockedAnnouncement(announcementID: blockedID)
        save()
    }
    
    /// Deletes a blocked announcement from CoreData
    ///
    /// - Parameter blockedAnnouncement: the announcement that you no longer want to be blocked
    func delete(blockedAnnouncement: BlockedAnnouncement) {
        CoreDataStack.context.delete(blockedAnnouncement)
        save()
    }
    
    fileprivate func save() {
        do {
            try CoreDataStack.context.save()
        } catch {
            print("❌\(error.localizedDescription)")
        }
    }
}
