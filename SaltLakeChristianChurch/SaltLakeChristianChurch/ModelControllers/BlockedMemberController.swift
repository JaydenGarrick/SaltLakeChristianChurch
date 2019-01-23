//
//  BlockedMemberController.swift
//  SaltLakeChristianChurch
//
//  Created by Jayden Garrick on 2/11/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import Foundation
import CoreData

class BlockedMemberController {
    
    // Singleton
    static let shared = BlockedMemberController() ; private init(){}
    var blockedMembers: [BlockedMember] = [] // Datasource for blocked members
    
    // CRUD Functions
    
    
    /// Blocks the user from the directory due to apple's guidelines are user generated content
    ///
    /// - Parameter blockedID: The uid of the user who is being blocked
    func add(blockedID: String) {
        let _ = BlockedMember(memberID: blockedID)
        save()
    }
    
    
    /// Deletes the blocked member from CoreData blocked member list
    ///
    /// - Parameter blockedMember: The member that you no longer want to be blocked
    func delete(blockedMember: BlockedMember) {
        CoreDataStack.context.delete(blockedMember)
    }
    
    fileprivate func save() {
        do {
            try CoreDataStack.context.save()
        } catch {
            print("❌\(error.localizedDescription)")
        }
    }
}
