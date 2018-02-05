//
//  ContactUsViewController.swift
//  SaltLakeChristianChurch
//
//  Created by Jayden Garrick on 2/2/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit
import WebKit

class ContactUsViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var webView: WKWebView!
   
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAroundAndSetNavBar()
        guard let url = URL(string: "https://www.saltlakechristianchurch.com/contact-1/#contact") else { return }
        let request = URLRequest(url: url)
        webView.load(request)

    }

 

}
