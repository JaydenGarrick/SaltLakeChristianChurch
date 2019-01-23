//
//  Announcement.swift
//  SaltLakeChristianChurch
//
//  Created by Jayden Garrick on 2/5/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit

final class Announcement: Equatable {

    // MARK: - Properties
    var announcementID: String
    var name: String
    var imageAsStringURL: String
    var rsvpTotal: Int
    var description: String
    var creationDate: Date
    
    var dictionaryRepresentation: [String: Any] {
        return [
            AnnouncementKey.announcementID: announcementID,
            AnnouncementKey.name: name,
            AnnouncementKey.imageAsStringURL: imageAsStringURL,
            AnnouncementKey.rsvpTotal: rsvpTotal,
            AnnouncementKey.description: description,
            AnnouncementKey.creationDate: creationDate
        ]
    }
    
    // MARK: - Firebase Keys
    enum AnnouncementKey {
        
        // Top Level Item
        static let announcements = "announcements"
        
        // Properties
        static let announcementID = "announcementID"
        static let name = "name"
        static let imageAsStringURL = "imageAsStringURL"
        static let rsvpTotal = "rsvpTotal"
        static let description = "description"
        static let creationDate = "creationDate"
    }
    
    // MARK: - Initialization
    init(announcementID: String, name: String, imageAsStringURL: String, rsvpTotal: Int, description: String, creationDate: Date) {
        self.announcementID = announcementID
        self.name = name
        self.imageAsStringURL = imageAsStringURL
        self.rsvpTotal = rsvpTotal
        self.description = description
        self.creationDate = creationDate
    }
    
    convenience init?(announcementDictionary: [String:Any]) {
        guard let announcementID = announcementDictionary[AnnouncementKey.announcementID] as? String,
            let announcementName = announcementDictionary[AnnouncementKey.name] as? String,
            let announcementImageAsStringURL = announcementDictionary[AnnouncementKey.imageAsStringURL] as? String,
            let rsvpTotal = announcementDictionary[AnnouncementKey.rsvpTotal] as? Int,
            let description = announcementDictionary[AnnouncementKey.description] as? String,
            let dateAsDobule = announcementDictionary[AnnouncementKey.creationDate] as? Double else { return nil }
        
        let creationDate = Date(timeIntervalSince1970: dateAsDobule)
        
        self.init(announcementID: announcementID, name: announcementName, imageAsStringURL: announcementImageAsStringURL, rsvpTotal: rsvpTotal, description: description, creationDate: creationDate)
    }
    
    // Equatable Protocol Function
    static func ==(lhs: Announcement, rhs: Announcement) -> Bool {
        return lhs.announcementID == rhs.announcementID
    }

}
