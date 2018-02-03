//
//  Member.swift
//  SaltLakeChristianChurch
//
//  Created by Jayden Garrick on 1/30/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import Foundation

class Member {

    // MARK: - Properties
    var memberID: String
    var fullName: String
    var email: String
    var phoneNumber: String
    var imageAsURL: String?
    var address: String?
    var isAdmin: Bool = false
    var isMember: Bool = true
    
    // MARK: - Firebase Keys
    enum MemberKey {
        
        // Members
        static let members = "members"
        
        // Properties
        static let fullName = "fullName"
        static let email = "email"
        static let phoneNumber = "phoneNumber"
        static let imageAsURL = "imageAsURL"
        static let address = "address"
    }
    
    // MARK: - Initialization
    init(memberID: String, fullName: String, email: String, phoneNumber: String, imageAsURL: String?, address: String?) {
        self.memberID = memberID
        self.fullName = fullName
        self.email = email
        self.phoneNumber = phoneNumber
        self.imageAsURL = imageAsURL
        self.address = address
    }
    
    convenience init?(memberID: String, memberDictionary: [String : Any]) {
        guard let fullName = memberDictionary[MemberKey.fullName] as? String,
            let email = memberDictionary[MemberKey.email] as? String,
            let phoneNumber = memberDictionary[MemberKey.phoneNumber] as? String,
            let imageAsURL = memberDictionary[MemberKey.imageAsURL] as? String,
            let address = memberDictionary[MemberKey.address] as? String else { return nil }
        self.init(memberID: memberID, fullName: fullName, email: email, phoneNumber: phoneNumber, imageAsURL: imageAsURL, address: address)
    }
}

