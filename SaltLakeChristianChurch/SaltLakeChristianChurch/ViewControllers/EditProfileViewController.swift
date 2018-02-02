//
//  EditProfileViewController.swift
//  SaltLakeChristianChurch
//
//  Created by Jayden Garrick on 2/2/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {

    @IBOutlet weak var profilePictureImageView: UIImageViewX!
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var phoneNumberTextField: UITextFieldX!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func changeProfilePictureButtonTapped(_ sender: Any) {
    }
    
}
