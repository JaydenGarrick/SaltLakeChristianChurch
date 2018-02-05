//
//  Announcement.swift
//  SaltLakeChristianChurch
//
//  Created by Jayden Garrick on 2/5/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import Foundation

class Announcement {
    
    // MARK: - Properties
    var announcementID: String
    var announcementName: String
    var announcementImageAsStringURL: String
    var rsvpTotal: Int
    var description: String
    
    // MARK: - Firebase Keys
    enum AnnouncementKey {
        
        // Top Level Item
        static let announcements = "announcements"
        
        // Properties
        static let announcementID = "announcementID"
        static let announcementName = "announcementName"
        static let announcementImageAsStringURL = "announcementImageAsStringURL"
        static let rsvpTotal = "rsvpTotal"
        static let description = "description"
    }
    
    // MARK: - Initialization
    init(announcementID: String, announcementName: String, announcementImageAsStringURL: String, rsvpTotal: Int, description: String) {
        self.announcementID = announcementID
        self.announcementName = announcementName
        self.announcementImageAsStringURL = announcementImageAsStringURL
        self.rsvpTotal = rsvpTotal
        self.description = description
    }
    
    convenience init?(announcementID: String, announcementDictionary: [String:Any]) {
        guard let announcementName = announcementDictionary[AnnouncementKey.announcementName] as? String,
            let announcementImageAsStringURL = announcementDictionary[AnnouncementKey.announcementImageAsStringURL] as? String,
            let rsvpTotal = announcementDictionary[AnnouncementKey.rsvpTotal] as? Int,
            let description = announcementDictionary[AnnouncementKey.description] as? String else { return nil }
        
        self.init(announcementID: announcementID, announcementName: announcementName, announcementImageAsStringURL: announcementImageAsStringURL, rsvpTotal: rsvpTotal, description: description)
        
    }
    
    
    
}
