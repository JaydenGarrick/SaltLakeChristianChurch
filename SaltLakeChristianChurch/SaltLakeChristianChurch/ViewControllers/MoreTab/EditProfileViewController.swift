//
//  EditProfileViewController.swift
//  SaltLakeChristianChurch
//
//  Created by Jayden Garrick on 2/2/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit
import PhoneNumberKit

class EditProfileViewController: UIViewController, UINavigationControllerDelegate {

    // MARK: - IBOutlets and constants / variables
    @IBOutlet weak var profilePictureImageView: UIImageViewX!
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var phoneNumberTextField: PhoneNumberTextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    
    // PhoneNumberKit
    let phoneNumberKit = PhoneNumberKit()
    
    // Image Controllers
    let pickerController = UIImagePickerController() // Image picker for profile picture
    var imageToSaveToStorage: UIImage?
    
    // MARK: - viewDidLoad / Appear
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        
        // Set delegate
        pickerController.delegate = self
        
        // Handle keyboard and setup navigation bar
        hideKeyboardWhenTappedAroundAndSetNavBar()
        
        // Make imageView a circle
        let cornerRadius = profilePictureImageView.bounds.height / 2
        profilePictureImageView.layer.cornerRadius = cornerRadius
    }

    // MARK: - IBActions
    @IBAction func changeProfilePictureButtonTapped(_ sender: Any) {
        pickerController.allowsEditing = true
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true)
    }
    
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        // Set activity indicator
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        // Set properties to be saved
        guard let image = profilePictureImageView.image,
            let phoneNumber = phoneNumberTextField.text,
            let email = emailTextField.text,
            let address = addressTextField.text else { return }
        
        MemberController.shared.updateMemberWith(image: image, address: address, email: email, fullName: nil, phoneNumber: phoneNumber) { [weak self](success) in
            if success {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                print("Successfully updated Member!")
                self?.dismiss(animated: true)
            } else {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self?.presentAlertControllerWithOkayAction(title: "Saving error", message: "Error updating profile - Please check your connection and try again")

            }
        }
        
        
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    // MARK: - Functions
    func updateViews() {
        guard let loggedInMember = MemberController.shared.loggedInMember else { return }
        fullnameLabel.text = loggedInMember.fullName
        if loggedInMember.phoneNumber != "" {
            phoneNumberTextField.text = loggedInMember.phoneNumber
        }
        if loggedInMember.email != "" {
            emailTextField.text = loggedInMember.email
        }
        if loggedInMember.address != "" {
            addressTextField.text = loggedInMember.address
        }
        if loggedInMember.imageAsURL != "" {
            guard let imageURL = loggedInMember.imageAsURL else { return }
            MemberController.shared.loadImageFrom(imageURL: imageURL, completion: { [weak self](profileImage) in
                self?.profilePictureImageView.image = profileImage
            })
        }
    }
    
}

// MARK: - UIImagePickerController Delegate method(s)
extension EditProfileViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        guard let profilePicture = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage else { return }
        profilePictureImageView.image = profilePicture
        profilePictureImageView.contentMode = .scaleAspectFit
        imageToSaveToStorage = profilePicture
        
        // Update UI
        DispatchQueue.main.async { [weak self] in
            self?.dismiss(animated: true, completion: nil)
            self?.profilePictureImageView.alpha = 1
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
