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
    func add(blockedID: String) {
        let _ = BlockedMember(memberID: blockedID)
        save()
    }
    
    func delete(blockedMember: BlockedMember) {
        CoreDataStack.context.delete(blockedMember)
    }
    
    func save() {
        do {
            try CoreDataStack.context.save()
        } catch {
            print("❌\(error.localizedDescription)")
        }
    }
}
