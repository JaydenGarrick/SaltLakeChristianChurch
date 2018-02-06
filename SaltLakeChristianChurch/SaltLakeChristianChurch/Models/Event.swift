//
//  Event.swift
//  SaltLakeChristianChurch
//
//  Created by Jayden Garrick on 2/6/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import Foundation

struct EventTopLevelItems {
    let items: [Item]
}

struct Item {
    let event: Event
}

struct Event {
    let summary: String
    let location: String
    let start: Start
    let end: End
}

struct Start {
    let dateTime: Date
}

struct End {
    let dateTime: Date
}
