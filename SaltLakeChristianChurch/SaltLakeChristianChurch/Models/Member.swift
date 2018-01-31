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
    let memberID: String
    let fullName: String
    let email: String
    let phoneNumber: String
    let imageAsURL: String?
    let isAdmin: Bool = false
    
    // MARK: - Firebase Keys
    enum MemberKey {
        static let fullName = "fullName"
        static let email = "email"
        static let phoneNumber = "phoneNumber"
        static let imageAsURL = "imageAsURL"
    }
    
    // MARK: - Initialization
    init(memberID: String, fullName: String, email: String, phoneNumber: String, imageAsURL: String?) {
        self.memberID = memberID
        self.fullName = fullName
        self.email = email
        self.phoneNumber = phoneNumber
        self.imageAsURL = imageAsURL
    }
    
    convenience init?(memberID: String, memberDictionary: [String : Any]) {
        guard let fullName = memberDictionary[MemberKey.fullName] as? String,
            let email = memberDictionary[MemberKey.email] as? String,
            let phoneNumber = memberDictionary[MemberKey.phoneNumber] as? String,
            let imageAsURL = memberDictionary[MemberKey.imageAsURL] as? String else { return nil }
        self.init(memberID: memberID, fullName: fullName, email: email, phoneNumber: phoneNumber, imageAsURL: imageAsURL)
    }
}

