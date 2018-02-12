//
//  LoginOrRegisterViewController.swift
//  SaltLakeChristianChurch
//
//  Created by Jayden Garrick on 1/30/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit
import Firebase
import PhoneNumberKit

class LoginOrRegisterViewController: UIViewController {

    // MARK: - IBOutlets and Constants / Variables
    @IBOutlet weak var emailTextField: UITextFieldX!
    @IBOutlet weak var passwordTextField: UITextFieldX!
    @IBOutlet weak var confirmPasswordTextField: UITextFieldX!
    @IBOutlet weak var fullnameTextField: UITextFieldX!
    @IBOutlet weak var phoneNumberTextField: PhoneNumberTextField!
    @IBOutlet weak var churchCodeTextField: UITextFieldX!
    @IBOutlet weak var loginView: UIViewX!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    
    // Checks for which index the segmented controller is on
    var isLogin = true
    
    // MemberCode
    var memberCode: Int? {
        didSet {
            print("The membercode is \(String(describing: memberCode))")
        }
    }
    
    // PhoneNumberKit
    let phoneNumberKit = PhoneNumberKit()
    
    // MARK: - ViewDidLoad / ViewWillAppear
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMemberCode()
        
        // Animate view in
        let transform = CATransform3DTranslate(CATransform3DIdentity, 0, 200, 0)
        loginView.layer.transform = transform
        loginView.alpha = 0
        UIView.animate(withDuration: 0.6) {
            self.loginView.alpha = 1.0
            self.loginView.layer.transform = CATransform3DIdentity
        }
        
        
        // Set delegates
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self

        
        // Set initial view look
        confirmPasswordTextField.isHidden = true
        fullnameTextField.isHidden = true
        phoneNumberTextField.isHidden = true
        churchCodeTextField.isHidden = true
        blurView.layoutIfNeeded()
        
        // Hide keyboard when tapped around
        self.hideKeyboardWhenTappedAroundAndSetNavBar()

    }

    // MARK: - IBActions
    
    @IBAction func loginOrRegisterToggled(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            isLogin = true
            UIView.animate(withDuration: 0.3, animations: {
                self.confirmPasswordTextField.isHidden = true
                self.confirmPasswordTextField.backgroundColor = .white
                self.passwordTextField.backgroundColor = .white
                self.confirmPasswordTextField.text = ""
                self.passwordTextField.text = ""
                self.fullnameTextField.isHidden = true
                self.phoneNumberTextField.isHidden = true
                self.churchCodeTextField.isHidden = true
                self.loginButton.setTitle("Login", for: .normal)
                self.blurView.layoutIfNeeded()
            })
            
        } else {
            isLogin = false
            UIView.animate(withDuration: 0.3, animations: {
                self.confirmPasswordTextField.isHidden = false
                self.confirmPasswordTextField.backgroundColor = .white
                self.passwordTextField.backgroundColor = .white
                self.confirmPasswordTextField.text = ""
                self.passwordTextField.text = ""
                self.fullnameTextField.isHidden = false
                self.phoneNumberTextField.isHidden = false
                self.churchCodeTextField.isHidden = false
                self.loginButton.setTitle("Register", for: .normal)
                self.blurView.layoutIfNeeded()
            })
        }
    }
    
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        
        // Handle Creating User
        if isLogin == false {
            // Validate input
            guard let email = emailTextField.text, email != "", let password = passwordTextField.text, password != "", let fullname = fullnameTextField.text, fullname != "", let phoneNumber = phoneNumberTextField.text, phoneNumber != "", let loggedMemberCode = churchCodeTextField.text, loggedMemberCode != "" else {
                self.presentAlertControllerWithOkayAction(title: "Registration Error", message: "Please make sure you provide your name, email address and password to complete the registration.")
                return
            }
            
        // Fetch Member Code
            guard let memberCode = memberCode else { self.presentAlertControllerWithOkayAction(title: "Service Error", message: "Unable to create account.") ; return }
            if loggedMemberCode == "\(memberCode)" {
                
                // Handle Creating a new user
                Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                    if let error = error {
                        self.presentAlertControllerWithOkayAction(title: "Registration Error", message: error.localizedDescription)
                        return
                    }
                    guard let user = user else { return }
                    let uuid = user.uid
                    let memberID = UUID().uuidString
                    let memberRef = Database.database().reference().child("members").child(uuid)
                    let values = ["email" : email,
                                  "fullName" : fullname,
                                  "phoneNumber" : phoneNumber,
                                  "isAdmin" : false,
                                  "isMember" : true,
                                  "address" : "",
                                  "memberID" : memberID,
                                  "imageAsURL" : ""] as [String : Any]
                    memberRef.updateChildValues(values, withCompletionBlock: { (error, reference) in
                        if let error = error {
                            self.presentAlertControllerWithOkayAction(title: "Registration Error", message: error.localizedDescription)
                            return
                        }
                        
                        // Create the uid
                        guard let uuid = Auth.auth().currentUser?.uid else { self.presentAlertControllerWithOkayAction(title: "Registration Error", message: "Couldn't create user. Please try again.") ; return }
                        MemberController.shared.fetchUserWith(uuid: uuid, completion: { (success) in
                            if success {
                                // Present the main view
                                print("Successfully created a user!")
                                self.dismiss(animated: true, completion: nil)
                            } else {
                                return
                            }
                        })
                    })
                }
            } else {
                self.presentAlertControllerWithOkayAction(title: "Registration Error", message: "Invalid member code.")
                return
            }
        
        // Handle logging in user
        } else {
            guard let email = emailTextField.text, email != "", let password = passwordTextField.text, password != "" else { self.presentAlertControllerWithOkayAction(title: "Login Error", message: "Please provide a valid Email and Password.") ; return }
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                if let error = error {
                    self.presentAlertControllerWithOkayAction(title: "Logging in error", message: error.localizedDescription)
                    return
                }
                guard let uid = Auth.auth().currentUser?.uid else { self.presentAlertControllerWithOkayAction(title: "Logging in error", message: "Couldn't log in. Please try again.") ; return }
                MemberController.shared.fetchUserWith(uuid: uid, completion: { (success) in
                    if success {
                        print("Successfully logged in!")
                        
                        // Present Main View
                        MemberController.shared.isLoggedIn = true
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        return 
                    }
                })
            })
        }
    }
    
    
    @IBAction func continueAsGuestButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }


}

// MARK: - Textfield Delegate
extension LoginOrRegisterViewController: UITextFieldDelegate {

    // MARK: - Password check
        func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        guard let password = passwordTextField.text, let confirmedPassword = confirmPasswordTextField.text else { return }
            if textField == confirmPasswordTextField {
                if password != confirmedPassword {
                    passwordTextField.backgroundColor = UIColor(red: 254.0/255.0, green: 177.0/255.0, blue: 178.0/255.0, alpha: 1)
                    confirmPasswordTextField.backgroundColor = UIColor(red: 254.0/255.0, green: 177.0/255.0, blue: 178.0/255.0, alpha: 1)
                } else {
                    passwordTextField.backgroundColor = UIColor(red: 153.0/255.0, green: 204.0/255.0, blue: 153.0/255.0, alpha: 1)
                    confirmPasswordTextField.backgroundColor = UIColor(red: 153.0/255.0, green: 204.0/255.0, blue: 153.0/255.0, alpha: 1)
                }
            }
            if textField == passwordTextField && confirmPasswordTextField.text != "" {
                if password != confirmedPassword {
                    passwordTextField.backgroundColor = UIColor(red: 254.0/255.0, green: 177.0/255.0, blue: 178.0/255.0, alpha: 1)
                    confirmPasswordTextField.backgroundColor = UIColor(red: 254.0/255.0, green: 177.0/255.0, blue: 178.0/255.0, alpha: 1)
                } else {
                    passwordTextField.backgroundColor = UIColor(red: 153.0/255.0, green: 204.0/255.0, blue: 153.0/255.0, alpha: 1)
                    confirmPasswordTextField.backgroundColor = UIColor(red: 153.0/255.0, green: 204.0/255.0, blue: 153.0/255.0, alpha: 1)
                }
            }
    }

}

// MARK: - Fetch Member Code
extension LoginOrRegisterViewController {
    func fetchMemberCode() {
        Database.database().reference().child("memberKey").observeSingleEvent(of: .value) { (snapshot) in
            guard let memberKey  = snapshot.value as? Int else { return }
            self.memberCode = memberKey
            
        }
    }
}










