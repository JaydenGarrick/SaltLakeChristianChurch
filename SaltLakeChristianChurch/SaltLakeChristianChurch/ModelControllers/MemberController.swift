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
    static let shared = MemberController()
    
    // Constants
    var members: [Member] = []
    var isLoggedIn = false
    var loggedInMember: Member?
    
    private init(){}
    
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
    
    func fetchUserWithID(uuid: String, completion: @escaping ((Bool)->Void)) {
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
    
    
}
