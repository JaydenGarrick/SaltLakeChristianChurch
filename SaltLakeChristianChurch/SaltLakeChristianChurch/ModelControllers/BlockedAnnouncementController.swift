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
    
    // Singleton
    static let shared = BlockedAnnouncementController()
    
    var blockedAnnouncements: [BlockedAnnouncement] = []
    
    // CRUD Functions
    func add(blockedID: String) {
        let _ = BlockedAnnouncement(announcementID: blockedID)
        save()
    }
    
    func delete(blockedAnnouncement: BlockedAnnouncement) {
        CoreDataStack.context.delete(blockedAnnouncement)
    }
    
    func save() {
        do {
            try CoreDataStack.context.save()
        } catch {
            print("\(error.localizedDescription)")
        }
    }
}
