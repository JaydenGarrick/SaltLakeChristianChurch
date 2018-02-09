//
//  AnnouncementController.swift
//  SaltLakeChristianChurch
//
//  Created by Jayden Garrick on 2/5/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit
import Firebase

class AnnouncementController {
    
    // MARK: - Variables and constants
    static let shared = AnnouncementController() ; private init(){} // Singleton
    var announcements: [Announcement] = [] // Datasource
    var alreadyGoing: Bool = false
    
    // MARK: - Firebase Database References
    let baseReference = Database.database().reference()
    let announcementDatabase = Database.database().reference().child(Announcement.AnnouncementKey.announcements)
    let photoStorageReference = Storage.storage().reference().child("announcementImage")
    
    
    // MARK: - Firebase Upload and Download Methods
    func createAnnouncement(announcementImage: UIImage, announcementName: String, description: String, completion: @escaping ((Bool)-> Void)) {
        guard let imageData = UIImageJPEGRepresentation(announcementImage, 0.9) else { completion(false) ; return }
        photoStorageReference.child(announcementName).putData(imageData, metadata: nil) { (metaData, error) in
            if let error = error {
                print("Error creating announcement - Can't store image: \(error.localizedDescription)")
                completion(false)
                return
            }
            guard let downloadedImageURL = metaData?.downloadURL()?.absoluteString else { completion(false) ; return }
            
            let announcementID = UUID().uuidString
            let dateAsDouble = Date().timeIntervalSince1970 as Double
            let values: [String : Any] = [Announcement.AnnouncementKey.announcementID : announcementID,
                                          Announcement.AnnouncementKey.name : announcementName,
                                          Announcement.AnnouncementKey.description : description,
                                          Announcement.AnnouncementKey.imageAsStringURL : downloadedImageURL,
                                          Announcement.AnnouncementKey.rsvpTotal : 0,
                                          Announcement.AnnouncementKey.creationDate : dateAsDouble]
            self.announcementDatabase.child(announcementID).updateChildValues(values)
            completion(true)
        }
    }
    
    func fetchAnnouncements(completion: @escaping ((Bool)->Void)) {
        let annoucementQuery = announcementDatabase.queryOrdered(byChild: Announcement.AnnouncementKey.creationDate)
        annoucementQuery.observeSingleEvent(of: .value) { (snapshot) in
            var fetchedAnnouncements: [Announcement] = []
            for announcement in snapshot.children.allObjects as! [DataSnapshot] {
                let announcementDictionary = announcement.value as? [String: Any] ?? [:]
                if let announcement = Announcement(announcementDictionary: announcementDictionary) {
                    fetchedAnnouncements.append(announcement)
                } else {
                    completion(false)
                    return
                }
            }
            self.announcements = fetchedAnnouncements.reversed()
            completion(true)
        }
    }
    
    func loadImageFrom(imageURL: String, completion: @escaping ((UIImage?)->Void)) {
        let downloadedData = Storage.storage().reference(forURL: imageURL)
        downloadedData.getData(maxSize: 5 * 1024 * 1024) { (data, error) in
            if let error = error {
                print("Error loading image from Storage: \(error.localizedDescription)")
                completion(nil)
            }
            guard let imageData = data,
                let image = UIImage(data: imageData) else { completion(nil) ; return }
            completion(image)
        }
    }
    
    func rsvpTapped(announcement: Announcement, completion: @escaping ((Bool)->Void)) {
        if alreadyGoing == false {
            let announcementID = announcement.announcementID
            let rsvpCount = announcement.rsvpTotal + 1
            let values = ["announcementID" : announcementID,
                          "description" : announcement.description,
                          "imageAsStringURL" : announcement.imageAsStringURL,
                          "name" : announcement.name,
                          "rsvpTotal" : rsvpCount
                ] as [String : Any]
            announcementDatabase.child(announcementID).updateChildValues(values)
        }
    }
}



