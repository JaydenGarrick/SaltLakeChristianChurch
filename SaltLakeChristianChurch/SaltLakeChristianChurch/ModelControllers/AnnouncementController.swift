//
//  AnnouncementController.swift
//  SaltLakeChristianChurch
//
//  Created by Jayden Garrick on 2/5/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit
import Firebase
import CoreData

class AnnouncementController {

    // MARK: - Properties
    static let shared = AnnouncementController() ; private init(){} // Singleton
    var announcements: [Announcement] = [] // Datasource
    var alreadyGoing: Bool = false
    
    // Firebase Database References
    let baseReference = Database.database().reference()
    let announcementDatabase = Database.database().reference().child(Announcement.AnnouncementKey.announcements)
    let photoStorageReference = Storage.storage().reference().child("announcementImage")
    
    
    // MARK: - Firebase Upload and Download Methods
    
    
    /// Allows users that are admins to create an announcement to the firebase database
    ///
    /// - Parameters:
    ///   - announcementImage: The Image tied to the announcement
    ///   - announcementName: The name of the announcement being created
    ///   - description: The description of the announcement - the main text of the announcement
    ///   - completion: Completion that gives a bool as a parameter indicating whether or not the networking call was successful
    func createAnnouncement(announcementImage: UIImage, announcementName: String, description: String, completion: @escaping ((Bool)-> Void)) {
        guard let imageData = announcementImage.jpegData(compressionQuality: 0.9) else { completion(false) ; return }
        photoStorageReference.child(announcementName).putData(imageData, metadata: nil) { [weak self](metaData, error) in
            if let error = error {
                print("❌Error creating announcement - Can't store image: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            metaData?.storageReference?.downloadURL(completion: { (downloadImageURL, error) in
                if let error = error {
                    print("❌ Error downloading URL from storage while creating announcement: \(error.localizedDescription)")
                    completion(false) ; return
                }
                guard let downloadImageURL = downloadImageURL else { return }
                let announcementID = UUID().uuidString
                let dateAsDouble = Date().timeIntervalSince1970 as Double
                let values: [String : Any] = [
                    Announcement.AnnouncementKey.announcementID : announcementID,
                    Announcement.AnnouncementKey.name : announcementName,
                    Announcement.AnnouncementKey.description : description,
                    Announcement.AnnouncementKey.imageAsStringURL : downloadImageURL,
                    Announcement.AnnouncementKey.rsvpTotal : 0,
                    Announcement.AnnouncementKey.creationDate : dateAsDouble
                ]
                self?.announcementDatabase.child(announcementID).updateChildValues(values)
                completion(true)
            })
        }
    }
    
    
    /// Fetches all the announcements in the database
    ///
    /// - Parameter completion: A completion giving a bool as a parameter indicating whether or not the network call was a success
    func fetchAnnouncements(completion: @escaping ((Bool)->Void)) {
        let annoucementQuery = announcementDatabase.queryOrdered(byChild: Announcement.AnnouncementKey.creationDate)
        annoucementQuery.observeSingleEvent(of: .value) { [weak self](snapshot) in
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
            
            // Filter for blocked announcements
            for announcement in fetchedAnnouncements {
                for blockedAnnouncement in BlockedAnnouncementController.shared.blockedAnnouncements {
                    guard let blockedAnnouncementID = blockedAnnouncement.announcementID else { continue }
                    if blockedAnnouncementID == announcement.announcementID {
                        guard let index = fetchedAnnouncements.index(of: announcement) else { continue }
                        fetchedAnnouncements.remove(at: index)
                    }
                }
            }
            self?.announcements = fetchedAnnouncements.reversed()
            completion(true)
        }
    }
    
    
    /// Loads an image from a given URL
    ///
    /// - Parameters:
    ///   - imageURL: The URL of the image that is being fetched
    ///   - completion: A completion that returns an optional image when 
    func loadImageFrom(imageURL: String, completion: @escaping ((UIImage?)->Void)) {
        let downloadedData = Storage.storage().reference(forURL: imageURL)
        downloadedData.getData(maxSize: 5 * 1024 * 1024) { (data, error) in
            if let error = error {
                print("❌Error loading image from Storage: \(error.localizedDescription)")
                completion(nil)
            }
            guard let imageData = data,
                let image = UIImage(data: imageData) else { completion(nil) ; return }
            completion(image)
        }
    }
    
    
    /// Function that gives the option to hide an announcement in order to comply with apple's policy on user generated content
    ///
    /// - Parameters:
    ///   - announcement: The announcemnent that will need to be hidden
    ///   - completion: A completion giving a bool indicating whether or not the network call was a success
    func hide(announcement: Announcement, completion: @escaping ((Bool)->Void)) {
        guard let indexPath = announcements.index(of: announcement) else {  return }
        announcements.remove(at: indexPath)
        completion(true)
    }
    
}



