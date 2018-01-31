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
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginView: UIViewX!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    
    // Checks for which index
    var isLogin = true
    
    // PhoneNumberKit
    let phoneNumberKit = PhoneNumberKit()
    
    // MARK: - ViewDidLoad / ViewWillAppear
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        bottomConstraint.constant = 280.0
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
                self.fullnameTextField.isHidden = true
                self.phoneNumberTextField.isHidden = true
                self.churchCodeTextField.isHidden = true
                self.loginButton.setTitle("Login", for: .normal)
                self.bottomConstraint.constant = 280.0
                self.blurView.layoutIfNeeded()
            })
            
        } else {
            isLogin = false
            UIView.animate(withDuration: 0.3, animations: {
                self.confirmPasswordTextField.isHidden = false
                self.fullnameTextField.isHidden = false
                self.phoneNumberTextField.isHidden = false
                self.churchCodeTextField.isHidden = false
                self.loginButton.setTitle("Register", for: .normal)
                self.bottomConstraint.constant = 90.0
                self.blurView.layoutIfNeeded()
            })
            
        }
    }
    
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        
        
        // Handle Creating User
        if isLogin == false {
            // Validate input
            guard let email = emailTextField.text, email != "", let password = passwordTextField.text, password != "", let fullname = fullnameTextField.text, fullname != "", let phoneNumber = phoneNumberTextField.text, phoneNumber != "" else {
                self.presentAlertControllerWithOkayAction(title: "Registration Error", message: "Please make sure you provide your name, email address and password to complete the registration.")
                return
            }
            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                
                if let error = error {
                    self.presentAlertControllerWithOkayAction(title: "Registration Error", message: error.localizedDescription)
                    return
                }
                
                guard let user = user else { return }
                let uuid = user.uid
                let memberRef = Database.database().reference().child("members").child(uuid)
                let values = ["email" : email, "fullName" : fullname, "phoneNumber" : phoneNumber, "isAdmin" : false, "isMember" : true] as [String : Any]
                memberRef.updateChildValues(values, withCompletionBlock: { (error, reference) in
                    if let error = error {
                        self.presentAlertControllerWithOkayAction(title: "Registration Error", message: error.localizedDescription)
                        return
                    }
                    
                    print("Successfully created a user!")
                    // Dismiss Keyboard
                    self.view.endEditing(true)
                    
                    // Present the main view
                    if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MainView") {
                        UIApplication.shared.keyWindow?.rootViewController = viewController
                        self.dismiss(animated: true, completion: nil)
                    }
                    
                })
                
            }
        } else {
            guard let email = emailTextField.text, email != "", let password = passwordTextField.text, password != "" else { self.presentAlertControllerWithOkayAction(title: "Login Error", message: "Please provide a valid Email and Password.") ; return }
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                if let error = error {
                    self.presentAlertControllerWithOkayAction(title: "Logging in error", message: error.localizedDescription)
                }
                print("Successfully logged in!")
                
                // Present Main View
                if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MainView") {
                    UIApplication.shared.keyWindow?.rootViewController = viewController
                    self.dismiss(animated: true, completion: nil)
                }
            })
        }
    }
    
    
    @IBAction func continueAsGuestButtonTapped(_ sender: Any) {
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - Textfield Delegate
extension LoginOrRegisterViewController: UITextFieldDelegate {

    
    // MARK: - Password check
        func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        guard let password = passwordTextField.text, let confirmedPassword = confirmPasswordTextField.text else { return }
            if textField == confirmPasswordTextField {
                if password != confirmedPassword {
                    passwordTextField.backgroundColor = UIColor(named: "Denied")
                    confirmPasswordTextField.backgroundColor = UIColor(named: "Denied")
                } else {
                    passwordTextField.backgroundColor = UIColor(named: "Confirmed")
                    confirmPasswordTextField.backgroundColor = UIColor(named: "Confirmed")
                }
            }
    }

    
}










