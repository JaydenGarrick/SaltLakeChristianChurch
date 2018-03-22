//
//  GiveViewController.swift
//  SaltLakeChristianChurch
//
//  Created by Jayden Garrick on 1/30/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit

class GiveViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // HandleNavBar and Keyboard
        hideKeyboardWhenTappedAroundAndSetNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.tintColor = .red
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.tintColor = UIColor(named: "Tint")
    }
    
    @IBAction func giveButtonTapped(_ sender: Any) {
        guard let url = URL(string: "https://tithe.ly/give_new/www/#/tithely/give-one-time/69694") else { return }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        UIApplication.shared.open(url, options: [:]) { (success) in
            if success {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
    }
}
