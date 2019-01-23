//
//  MemberController.swift
//  SaltLakeChristianChurch
//
//  Created by Jayden Garrick on 1/30/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import Foundation
import Firebase

class MemberController {
    
    // MARK: - Properties
    // Singleton 
    static let shared = MemberController()
    
    // Constants
    var members: [Member] = []
    var isLoggedIn = false
    var loggedInMember: Member?
    
    // Firebase Database References
    let baseReference = Database.database().reference()
    let memberDatabase = Database.database().reference().child("members")
    
    // Firebase Storage References
    let photoStorageReference = Storage.storage().reference().child("userProfile")
    
    // MARK: - Firebase Upload and Download Methods
    /// Fetches members based on the members ID for the directory
    ///
    /// - Parameters:
    ///   - memberID: The unique identifier tied to each user on the backend
    ///   - completion: Bool indicating whether or not the network call was successful
    func fetchMembersForDirectory(memberID: String?, completion: @escaping((Bool)->Void)) {
        let memberQuery = memberDatabase.queryOrdered(byChild: "fullName")
        memberQuery.observeSingleEvent(of: .value) { (snapshot) in
            var fetchedMembers: [Member] = []
            for member in snapshot.children.allObjects as! [DataSnapshot] {
                let memberDictionary = member.value as? [String : Any] ?? [:]
                if let member = Member(memberID: member.key, memberDictionary: memberDictionary) {
                    fetchedMembers.append(member)
                } else {
                    completion(false)
                    return
                }
            }
            
            for member in fetchedMembers {
                for blockedMember in BlockedMemberController.shared.blockedMembers {
                    guard let blockID = blockedMember.memberID else { continue }
                    if blockID == member.memberID {
                        guard let index =  fetchedMembers.index(of: member) else { continue }
                        fetchedMembers.remove(at: index)
                    }
                }
            }
            self.members = fetchedMembers
            completion(true)
        }
    }
    
    /// Fetches members based on the members ID for logging in
    ///
    /// - Parameters:
    ///   - uuid: The unique identifier tied to each user on the backend
    ///   - completion: Bool indicating whether or not the network call was successful
    func fetchUserWith(uuid: String, completion: @escaping ((Bool)->Void)) {
        let reference = memberDatabase.child(uuid)
        reference.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let memberDictionary = snapshot.value as? [String : Any] else {
                print("❌Error retrieving Snapshot")
                completion(false)
                return
            }
            MemberController.shared.loggedInMember = Member(memberID: snapshot.key, memberDictionary: memberDictionary)
            MemberController.shared.isLoggedIn = true
            print("✅Successfully Fetched logged in user!")
            completion(true)
        })
    }
    
    /// Updates a member with the given parameters
    ///
    /// - Parameters:
    ///   - image: The new image of the member
    ///   - address: The new address of the member
    ///   - email: The new email of the member
    ///   - fullName: The new fullName of the member
    ///   - phoneNumber: The new phone number of the memeber
    ///   - completion: A completion handler that gives the bool as a parameter indicating whether or not the network call was a success
    func updateMemberWith(image: UIImage, address: String?, email: String?, fullName: String?, phoneNumber: String?, completion: @escaping ((Bool)->Void)) {
        guard let loggedInMember = loggedInMember,
        let imageData = image.jpegData(compressionQuality: 0.5) else { completion(false) ; return }
        let address = address ?? loggedInMember.address
        let email = email ?? loggedInMember.email
        let fullName = fullName ?? loggedInMember.fullName
        let phoneNumber = phoneNumber ?? loggedInMember.fullName
        Storage.storage().reference().child(loggedInMember.fullName).putData(imageData, metadata: nil) { (metaData, error) in
            if let error = error {
                print("❌Error uploading image to Firebase storage: \(error.localizedDescription)")
                completion(false)
            }
            
            metaData?.storageReference?.downloadURL(completion: { (downloadedImageURL, error) in
                if let error = error {
                    print("❌Error downloading reference when updating reference: \(error.localizedDescription)")
                    completion(false)
                    return
                }
                loggedInMember.imageAsURL = downloadedImageURL?.absoluteString
                guard let memberUID = Auth.auth().currentUser?.uid else { completion(false) ; return }
                let memberReference = Database.database().reference().child(Member.MemberKey.members).child(memberUID)
                
                let values = [Member.MemberKey.address : address!, Member.MemberKey.email : email, Member.MemberKey.fullName : fullName, Member.MemberKey.imageAsURL : downloadedImageURL!, Member.MemberKey.phoneNumber : phoneNumber] as [String : Any]
                memberReference.updateChildValues(values)
                completion(true)
            })
        }
    }
    
    
    /// Loads an image from a URL
    ///
    /// - Parameters:
    ///   - imageURL: The url of the image
    ///   - completion: A completion that when the network call is completed returns an optional image
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
    
}
