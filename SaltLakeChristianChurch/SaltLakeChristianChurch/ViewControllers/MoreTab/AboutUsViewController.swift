//
//  AboutUsViewController.swift
//  SaltLakeChristianChurch
//
//  Created by Jayden Garrick on 4/2/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit
import WebKit

class AboutUsViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAroundAndSetNavBar()
        guard let url = URL(string: "https://www.saltlakechristianchurch.com/about/") else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    
}



