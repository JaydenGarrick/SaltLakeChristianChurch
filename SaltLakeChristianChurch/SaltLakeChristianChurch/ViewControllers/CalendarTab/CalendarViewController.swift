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
    var eventsByMonth: [(String, [Event])] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set Delegate / DataSource
        tableView.delegate = self
        tableView.dataSource = self
        
        
        // HandleNavBar and Keyboard
        self.hideKeyboardWhenTappedAroundAndSetNavBar()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        // Initial Fetch of Events
        EventController.shared.fetchEvents { (success) in
            if success {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    print("Successfully fetched Calendar events!")
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.estimatedRowHeight = 55
        tableView.rowHeight = UITableViewAutomaticDimension
    }
}

extension CalendarViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return EventController.shared.eventsByMonth.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EventController.shared.eventsByMonth[section].1.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarCell", for: indexPath) as! CalendarTableViewCell
        
        let eventArray = EventController.shared.eventsByMonth[indexPath.section].1
        let event = eventArray[indexPath.row]
        var timeText = "All Day"
        if let dateString = event.start?.dateTime {
            if let date = DateHelper.inputFormatter.date(from: dateString) {
                let time = DateHelper.outputFormatter.string(from: date)
                print(time)
                timeText = time
            }
        }
        
        cell.timeLabel.text = timeText
        cell.summaryLabel.text = event.summary ?? ""
        cell.locationTextView.text = event.location ?? ""
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return EventController.shared.eventsByMonth[section].0
    }

    
}







