//
//  CreateAnnouncementViewController.swift
//  SaltLakeChristianChurch
//
//  Created by Jayden Garrick on 2/5/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit

class CreateAnnouncementViewController: UIViewController {

    // MARK: -  IBOutlets and Variables / Constants
    @IBOutlet weak var announcementImageButton: UIButton!
    @IBOutlet weak var announcementNameTextField: UITextField!
    @IBOutlet weak var announcementDescriptionTextView: UITextView!
    
    let pickerController = UIImagePickerController() // Image picker for announcement picture
    var imageToSaveToStorage: UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hides keyboard and sets navigationbar
        self.hideKeyboardWhenTappedAroundAndSetNavBar()
        
        

    }
    
    // MARK: - IBActions
    @IBAction func addImageButtonTapped(_ sender: Any) {
    }
    
    @IBAction func createAnnouncementButtonTapped(_ sender: Any) {
    }
}

// MARK: -- UIImagePickerController Delegate method(s)
extension CreateAnnouncementViewController: UIImagePickerControllerDelegate {
    
}
