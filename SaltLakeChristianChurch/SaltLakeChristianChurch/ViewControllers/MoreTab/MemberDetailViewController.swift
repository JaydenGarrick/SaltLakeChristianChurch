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
    let imageCache = NSCache<NSString, UIImage>()
    
    
    // MARK: - ViewDidLoad / Appear
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup for navigation bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        // Create round Profile Picture
        self.imageView.layer.cornerRadius = self.imageView.frame.size.width / 2
        self.imageView.clipsToBounds = true
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
            
            // Check  to see if they have profile picture
            if member.imageAsURL != "" {
                guard let imageAsURL = member.imageAsURL else { return }
                if let cachedImage = imageCache.object(forKey: imageAsURL as NSString) {
                    self.imageView.image = cachedImage
                } else {
                    MemberController.shared.loadImageFrom(imageURL: imageAsURL, completion: { (image) in
                        guard let image = image else { return }
                        self.imageCache.setObject(image, forKey: imageAsURL as NSString)
                        DispatchQueue.main.async {
                            self.imageView.image = image
                        }
                    })
                }
            }
        }
    }
 

}
