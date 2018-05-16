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
    var memberCode: Int?
    
    // PhoneNumberKit
    let phoneNumberKit = PhoneNumberKit()
    
    // MARK: - ViewDidLoad / ViewWillAppear
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initial Setup
        fetchMemberCode()
        animateViewOnLoad()
        setDelegates()
        setUI()
        
        // Hide keyboard when tapped around
        self.hideKeyboardWhenTappedAroundAndSetNavBar()
    }
    
    // MARK: - IBActions
    
    @IBAction func loginOrRegisterToggled(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            isLogin = true
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.UISetupForLoggingIn()
            })
        } else {
            isLogin = false
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.UISetupForCreatingUser()
            })
        }
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        // Handle Creating User
        if isLogin == false {
            createUser()
        // Handle logging in user
        } else {
            loginUser()
        }
    }
    
    @IBAction func continueAsGuestButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
}

// MARK: - Textfield Delegate methods
extension LoginOrRegisterViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if isLogin == true {
            passwordTextField.returnKeyType = .done
            if textField == emailTextField {
                passwordTextField.becomeFirstResponder()
            } else {
                loginUser()
            }
        } else {
            if textField == emailTextField {
                passwordTextField.becomeFirstResponder()
            }
            if textField == passwordTextField {
                confirmPasswordTextField.becomeFirstResponder()
            }
            if textField == confirmPasswordTextField {
                fullnameTextField.becomeFirstResponder()
            }
            if textField == fullnameTextField {
                phoneNumberTextField.becomeFirstResponder()
            }
            if textField == phoneNumberTextField {
                churchCodeTextField.becomeFirstResponder()
            }
            if textField == churchCodeTextField {
                createUser()
            }
        }
        return true
    }
    
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

// MARK: - Setup Functions
extension LoginOrRegisterViewController {
    
    func fetchMemberCode() {
        Database.database().reference().child("memberKey").observeSingleEvent(of: .value) { [weak self](snapshot) in
            guard let memberKey  = snapshot.value as? Int else { return }
            self?.memberCode = memberKey
        }
    }
    
    fileprivate func setDelegates() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        fullnameTextField.delegate = self
        phoneNumberTextField.delegate = self
        churchCodeTextField.delegate = self
    }
    
    fileprivate func animateViewOnLoad() {
        // Animate view in
        let transform = CATransform3DTranslate(CATransform3DIdentity, 0, 200, 0)
        loginView.layer.transform = transform
        loginView.alpha = 0
        UIView.animate(withDuration: 0.6) { [weak self] in
            self?.loginView.alpha = 1.0
            self?.loginView.layer.transform = CATransform3DIdentity
        }
    }
    
    // Creating / Logging in user functions
    fileprivate func createUser() {
        // Validate input
        guard let email = emailTextField.text, email != "", let password = passwordTextField.text, password != "", let fullname = fullnameTextField.text, fullname != "", let phoneNumber = phoneNumberTextField.text, phoneNumber != "", let loggedMemberCode = churchCodeTextField.text, loggedMemberCode != "" else {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            presentAlertControllerWithOkayAction(title: "Registration Error", message: "Please make sure you provide your name, email address and password to complete the registration.")
            return
        }
        
        // Fetch Member Code
        guard let memberCode = memberCode else { presentAlertControllerWithOkayAction(title: "Service Error", message: "Unable to create account.") ; UIApplication.shared.isNetworkActivityIndicatorVisible = false ; return }
        if loggedMemberCode == "\(memberCode)" {
            
            // Handle Creating a new user
            Auth.auth().createUser(withEmail: email, password: password) { [weak self](user, error) in
                if let error = error {
                    self?.presentAlertControllerWithOkayAction(title: "Registration Error", message: error.localizedDescription)
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    return
                }
                guard let user = user else { UIApplication.shared.isNetworkActivityIndicatorVisible = false ; return }
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
                memberRef.updateChildValues(values, withCompletionBlock: { [weak self](error, reference) in
                    if let error = error {
                        self?.presentAlertControllerWithOkayAction(title: "Registration Error", message: error.localizedDescription)
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        return
                    }
                    
                    // Create the uid
                    guard let uuid = Auth.auth().currentUser?.uid else { self?.presentAlertControllerWithOkayAction(title: "Registration Error", message: "Couldn't create user. Please try again.") ; UIApplication.shared.isNetworkActivityIndicatorVisible = false ;return }
                    MemberController.shared.fetchUserWith(uuid: uuid, completion: { [weak self](success) in
                        if success {
                            // Present the main view
                            print("✅Successfully created a user!")
                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
                            self?.dismiss(animated: true, completion: nil)
                        } else {
                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
                            return
                        }
                    })
                })
            }
        } else {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            presentAlertControllerWithOkayAction(title: "Registration Error", message: "Invalid member code.")
            return
        }
    }
    
    fileprivate func loginUser() {
        guard let email = emailTextField.text, email != "", let password = passwordTextField.text, password != "" else {
            presentAlertControllerWithOkayAction(title: "Login Error", message: "Please provide a valid Email and Password.") ; UIApplication.shared.isNetworkActivityIndicatorVisible = false ; return }
        Auth.auth().signIn(withEmail: email, password: password, completion: { [weak self](user, error) in
            if let error = error {
                self?.presentAlertControllerWithOkayAction(title: "Logging in error", message: error.localizedDescription)
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                return
            }
            guard let uid = Auth.auth().currentUser?.uid else { self?.presentAlertControllerWithOkayAction(title: "Logging in error", message: "Couldn't log in. Please try again.") ; return }
            MemberController.shared.fetchUserWith(uuid: uid, completion: { [weak self](success) in
                if success {
                    print("✅Successfully logged in!")
                    
                    // Present Main View
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    MemberController.shared.isLoggedIn = true
                    self?.dismiss(animated: true, completion: nil)
                } else {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    return
                }
            })
        })
    }
    
}

// MARK: - Setup Functions
extension LoginOrRegisterViewController {
    fileprivate func UISetupForLoggingIn() {
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
    }
    
    fileprivate func UISetupForCreatingUser() {
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
    }
    
    fileprivate func setUI() {
        confirmPasswordTextField.isHidden = true
        fullnameTextField.isHidden = true
        phoneNumberTextField.isHidden = true
        churchCodeTextField.isHidden = true
        blurView.layoutIfNeeded()
    }
}
