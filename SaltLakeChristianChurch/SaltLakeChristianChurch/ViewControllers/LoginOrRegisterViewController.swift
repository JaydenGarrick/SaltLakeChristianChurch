//
//  LoginOrRegisterViewController.swift
//  SaltLakeChristianChurch
//
//  Created by Jayden Garrick on 1/30/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit
import Firebase

class LoginOrRegisterViewController: UIViewController {

    // MARK: - IBOutlets and Constants / Variables
    @IBOutlet weak var emailTextField: UITextFieldX!
    @IBOutlet weak var passwordTextField: UITextFieldX!
    @IBOutlet weak var confirmPasswordTextField: UITextFieldX!
    @IBOutlet weak var fullnameTextField: UITextFieldX!
    @IBOutlet weak var phoneNumberTextField: UITextFieldX!
    @IBOutlet weak var churchCodeTextField: UITextFieldX!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginView: UIViewX!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    
    var isLogin = true
    
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
        confirmPasswordTextField.delegate = self
        
        // Set initial view look
        confirmPasswordTextField.isHidden = true
        fullnameTextField.isHidden = true
        phoneNumberTextField.isHidden = true
        churchCodeTextField.isHidden = true
        bottomConstraint.constant = 280.0
        blurView.layoutIfNeeded()
        
        // Hide keyboard when tapped around
        self.hideKeyboardWhenTappedAround()
        

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
                self.bottomConstraint.constant = 100.0
                self.blurView.layoutIfNeeded()
            })
            
        }
    }
    
    
    @IBAction func loginButtonTapped(_ sender: Any) {
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
        if password != confirmedPassword {
            passwordTextField.backgroundColor = UIColor(named: "Denied")
            confirmPasswordTextField.backgroundColor = UIColor(named: "Denied")

        } else {
            passwordTextField.backgroundColor = UIColor(named: "Confirmed")
            confirmPasswordTextField.backgroundColor = UIColor(named: "Confirmed")
        }
    }

    
}








