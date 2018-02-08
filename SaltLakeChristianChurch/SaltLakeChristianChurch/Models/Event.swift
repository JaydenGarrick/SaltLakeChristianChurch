//
//  Event.swift
//  SaltLakeChristianChurch
//
//  Created by Jayden Garrick on 2/6/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import Foundation

struct EventTopLevelItems: Codable {
    let items: [Event]
}

struct Event: Codable {
    let summary: String?
    let location: String?
    let start: Start?
    let end: End?
}

struct Start: Codable {
    let dateTime: String?
}

struct End: Codable {
    let dateTime: String?
}
