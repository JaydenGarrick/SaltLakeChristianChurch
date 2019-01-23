//
//  CreateAnnouncementViewController.swift
//  SaltLakeChristianChurch
//
//  Created by Jayden Garrick on 2/5/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit

class CreateAnnouncementViewController: UIViewController, UINavigationControllerDelegate {

    // MARK: -  IBOutlets and Variables / Constants
    @IBOutlet weak var announcementNameTextField: UITextField!
    @IBOutlet weak var announcementDescriptionTextView: UITextView!
    @IBOutlet weak var announcementImageView: UIImageView!
    @IBOutlet weak var addImageButton: UIButton!
    
    let pickerController = UIImagePickerController() // Image picker for announcement picture
    var imageToSaveToStorage: UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hides keyboard and sets navigationbar
        hideKeyboardWhenTappedAroundAndSetNavBar()
        
        // Set Delegate
        pickerController.delegate = self
    }
    
    // MARK: - IBActions
    @IBAction func addImageButtonTapped(_ sender: Any) {
        pickerController.allowsEditing = true
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true)
    }
    
    @IBAction func createAnnouncementButtonTapped(_ sender: Any) {
        if announcementImageView.image == nil {
            presentAlertControllerWithOkayAction(title: "Image Missing", message: "Image required to create an announcement")
        } else {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            guard let announcementImage = announcementImageView.image,
                let announcementName = announcementNameTextField.text,
                let description = announcementDescriptionTextView.text else { print("Couldn't create announcement, line 47") ; return }
            
            AnnouncementController.shared.createAnnouncement(announcementImage: announcementImage, announcementName: announcementName, description: description) { [weak self](success) in
                if success {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self?.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}

// MARK: -- UIImagePickerController Delegate method(s)
extension CreateAnnouncementViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        guard let selectedPicture = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage else { return }
        let announcementPicture = selectedPicture.scale(newWidth: 375.0)
        announcementImageView.image = announcementPicture
        announcementImageView.contentMode = .scaleToFill
        imageToSaveToStorage = announcementPicture
        addImageButton.setTitle("", for: .normal)
        
        // Jump on main thread to dismiss view
        DispatchQueue.main.async { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
