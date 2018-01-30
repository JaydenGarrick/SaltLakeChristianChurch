//
//  ViewController.swift
//  SaltLakeChristianChurch
//
//  Created by Jayden Garrick on 1/29/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor(named: "Primary")
        navigationController?.navigationBar.tintColor = UIColor(named: "Tint")
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]

        // Do any additional setup after loading the view.
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
