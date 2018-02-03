//
//  MemberDetailViewController.swift
//  SaltLakeChristianChurch
//
//  Created by Jayden Garrick on 1/31/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit

class MemberDetailViewController: UIViewController {
    
    
    // Member for current directory
    var member: Member?

    // MARK: - IBOutlets and constants / variables
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var imageView: UIImageViewX!
    
    // MARK: - ViewDidLoad / Appear
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup for navigation bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateViews()
    }

    // MARK: - UpdateViews Based on selected member
    func updateViews() {
        if let member = member {
            fullnameLabel.text = member.fullName
            addressLabel.text = member.address
            emailLabel.text = member.email
            phoneNumberLabel.text = member.phoneNumber
            
            
            if member.imageAsURL != "" {
                guard let imageAsURL = member.imageAsURL else { return }
                MemberController.shared.loadImageFrom(imageURL: imageAsURL, completion: { (image) in
                    self.imageView.image = image
                })
            }
        
        }
        
    }
 

}
