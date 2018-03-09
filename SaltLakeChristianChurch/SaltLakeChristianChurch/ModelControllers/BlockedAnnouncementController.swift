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
    func add(blockedID: String) {
        let _ = BlockedAnnouncement(announcementID: blockedID)
        save()
    }
    
    func delete(blockedAnnouncement: BlockedAnnouncement) {
        CoreDataStack.context.delete(blockedAnnouncement)
        save()
    }
    
    func save() {
        do {
            try CoreDataStack.context.save()
        } catch {
            print("❌\(error.localizedDescription)")
        }
    }
}
