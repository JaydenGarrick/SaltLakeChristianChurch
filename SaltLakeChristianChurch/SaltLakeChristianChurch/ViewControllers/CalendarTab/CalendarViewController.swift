//
//  CalendarViewController.swift
//  SaltLakeChristianChurch
//
//  Created by Jayden Garrick on 1/30/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set Delegate / DataSource
        tableView.delegate = self
        tableView.dataSource = self
        
        
        // HandleNavBar and Keyboard
        self.hideKeyboardWhenTappedAroundAndSetNavBar()
        EventController.shared.fetchEvents { (success) in
            if success {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    print("Successfully fetched calendar events!")
                }
            }
        }
        
    }

  

}

extension CalendarViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EventController.shared.events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarCell", for: indexPath)
        let event = EventController.shared.events[indexPath.row]  
        
        cell.textLabel?.text = event.summary ?? ""
        cell.detailTextLabel?.text = event.location ?? ""
        
        return cell
    }
    
}
