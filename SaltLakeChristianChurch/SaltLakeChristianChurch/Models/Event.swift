//
//  Event.swift
//  SaltLakeChristianChurch
//
//  Created by Jayden Garrick on 2/6/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import Foundation
import CoreData

struct EventTopLevelItems: Codable {
    let items: [Event]
}

struct Event: Codable {
    let summary: String?
    let location: String?
    let start: Start?
    let end: End?
    let id: String?
}

struct Start: Codable {
    let dateTime: String?
}

struct End: Codable {
    let dateTime: String?
}

extension AddedCalendarIDs {
    convenience init(calendarID: String, context:NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.calendarID = calendarID
    }
}
