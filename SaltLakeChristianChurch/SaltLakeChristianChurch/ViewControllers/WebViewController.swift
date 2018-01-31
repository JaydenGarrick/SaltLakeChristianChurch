//
//  WebViewController.swift
//  SaltLakeChristianChurch
//
//  Created by Jayden Garrick on 1/30/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAroundAndSetNavBar()
        guard let url = URL(string: "https://tithe.ly/give_new/www/#/tithely/give-one-time/69694") else { return }
        let request = URLRequest(url: url)
        webView.load(request)
        

    }


}
