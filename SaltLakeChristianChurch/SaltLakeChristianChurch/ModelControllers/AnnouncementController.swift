//
//  AnnouncementController.swift
//  SaltLakeChristianChurch
//
//  Created by Jayden Garrick on 2/5/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import Foundation
import Firebase

class AnnouncementController {
    
    // MARK: - Variables and constants
    static let shared = AnnouncementController() ; private init(){} // Singleton
    var announcements: [Announcement] = [] // Datasource
    
    // MARK: - Firebase Database References
    let baseReference = Database.database().reference()
    let announcementDatabase = Database.database().reference().child(Announcement.AnnouncementKey.announcements)
    let photoStorageReference = Storage.storage().reference().child("announcementImage")
    
    
    // MARK: - Firebase Upload and Download Methods
    func createAnnouncement(announcementImage: UIImage, announcementName: String, description: String, completion: @escaping ((Bool)-> Void)) {
        
        guard let imageData = UIImageJPEGRepresentation(announcementImage, 0.5) else { completion(false) ; return }
        
        var imageAsStringURL = ""
        photoStorageReference.child(announcementName).putData(imageData, metadata: nil) { (metaData, error) in
            if let error = error {
                print("Error creating announcement - Can't store image: \(error.localizedDescription)")
                completion(false)
                return
            }
            guard let downloadedImageURL = metaData?.downloadURL()?.absoluteString else { completion(false) ; return }
            imageAsStringURL = downloadedImageURL
            
        }
        let announcementID = UUID().uuidString
        let values: [String : Any] = [Announcement.AnnouncementKey.announcementID : announcementID,
                                      Announcement.AnnouncementKey.announcementName : announcementName,
                                      Announcement.AnnouncementKey.description : description,
                                      Announcement.AnnouncementKey.announcementImageAsStringURL : imageAsStringURL,
                                      Announcement.AnnouncementKey.rsvpTotal : 0]
        announcementDatabase.childByAutoId().updateChildValues(values)
        completion(true)
    }
}
