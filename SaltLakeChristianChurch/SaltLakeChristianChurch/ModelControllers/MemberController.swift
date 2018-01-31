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
    private init(){}
    
    // MARK: - Firebase Database References
    let baseReference = Database.database().reference()
    let memberDatabase = Database.database().reference().child("members")
    
    // MARK: - Firebase Storage References
    let photoStorageReference = Storage.storage().reference().child("userProfile")
    
    // MARK: - Firebase Upload and Download Methods
    func createMemeberWith() {
       
    }
    
    
    
}
