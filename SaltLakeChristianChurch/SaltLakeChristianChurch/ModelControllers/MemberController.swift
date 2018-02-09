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
    
    // Singleton
    static let shared = MemberController() ; private init(){} 
    
    // Constants
    var members: [Member] = []
    var isLoggedIn = false
    var loggedInMember: Member?
    
    // MARK: - Firebase Database References
    let baseReference = Database.database().reference()
    let memberDatabase = Database.database().reference().child("members")
    
    // MARK: - Firebase Storage References
    let photoStorageReference = Storage.storage().reference().child("userProfile")
    
    // MARK: - Firebase Upload and Download Methods
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
            self.members = fetchedMembers
            completion(true)
        }
    }
    
    func fetchUserWith(uuid: String, completion: @escaping ((Bool)->Void)) {
        let reference = Database.database().reference().child("members").child(uuid)
        reference.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let memberDictionary = snapshot.value as? [String : Any] else {
                print("Error retrieving Snapshot")
                completion(false)
                return
            }
            MemberController.shared.loggedInMember = Member(memberID: snapshot.key, memberDictionary: memberDictionary)
            MemberController.shared.isLoggedIn = true
            print("Successfully Fetched logged in user!")
            completion(true)
        })
    }
    
    func updateMemberWith(image: UIImage, address: String?, email: String?, fullName: String?, phoneNumber: String?, completion: @escaping ((Bool)->Void)) {
        guard let loggedInMember = loggedInMember,
            let imageData = UIImageJPEGRepresentation(image, 0.5) else { completion(false) ; return }
        let address = address ?? loggedInMember.address
        let email = email ?? loggedInMember.email
        let fullName = fullName ?? loggedInMember.fullName
        let phoneNumber = phoneNumber ?? loggedInMember.fullName
        Storage.storage().reference().child(loggedInMember.fullName).putData(imageData, metadata: nil) { (metaData, error) in
            if let error = error {
                print("Error uploading image to Firebase storage: \(error.localizedDescription)")
                completion(false)
            }
            guard let downloadedImageURL = metaData?.downloadURL()?.absoluteString else { completion(false) ; return }
            loggedInMember.imageAsURL = downloadedImageURL
            guard let memberUID = Auth.auth().currentUser?.uid else { completion(false) ; return }
            let memberReference = Database.database().reference().child(Member.MemberKey.members).child(memberUID)
            
            let values = [Member.MemberKey.address : address!, Member.MemberKey.email : email, Member.MemberKey.fullName : fullName, Member.MemberKey.imageAsURL : downloadedImageURL, Member.MemberKey.phoneNumber : phoneNumber] as [String : Any]
            memberReference.updateChildValues(values)
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
    
   
    
    
}
