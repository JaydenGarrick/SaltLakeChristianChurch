//
//  CalendarViewController.swift
//  SaltLakeChristianChurch
//
//  Created by Jayden Garrick on 1/30/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit
import EventKit

class CalendarViewController: UIViewController {
    
    // MARK: - Constants and Variables
    var eventsByMonth: [(String, [Event])] = [] // Datasource
    let eventStore = EKEventStore()
    
    // IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestAccessToCalendar()
        
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
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .insert {
//            let eventArray = EventController.shared.eventsByMonth[indexPath.section].1
//            let event = eventArray[indexPath.row]
//
//            print(event.summary ?? "No location")
//        }
//    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // Add Action
        let addToCalendar = UIContextualAction(style: .normal, title: "Add to Calendar") { (action, view, nil) in
            print("addToCalendar")
        }
        addToCalendar.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)

        // Create Configuraiton to return
        let configuration = UISwipeActionsConfiguration(actions: [addToCalendar])
        configuration.performsFirstActionWithFullSwipe = false // Makes it so you need to tap, rather than just swipe.
        return configuration
    }

}

extension CalendarViewController {

    //    func checkCalendarAuthorizationStatus() {
//        let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
//
//        switch (status) {
//        case EKAuthorizationStatus.notDetermined:
//            // This happens on first-run
//        case EKAuthorizationStatus.authorized:
//            // Things are in line with being able to show the calendars in the table view
//        case EKAuthorizationStatus.restricted, EKAuthorizationStatus.denied:
//            // We need to help them give us permission
//        }
//    }
    
    func requestAccessToCalendar() {
        eventStore.requestAccess(to: .event) { (accessGranted, error) in
            if let error = error {
                print("⚠️Error granting access to users calendar: \(error.localizedDescription)")
            }
            if accessGranted {
                print("✅Successfully gained access to calendar")
            } else {
                print("❌Permission to access calendar denied")
            }
        }
    }
}










