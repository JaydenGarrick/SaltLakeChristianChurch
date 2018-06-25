//
//  BlockedMember.swift
//  SaltLakeChristianChurch
//
//  Created by Jayden Garrick on 2/11/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import Foundation
import CoreData

extension BlockedMember {
    convenience init(memberID: String, context:NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.memberID = memberID
    }
}
