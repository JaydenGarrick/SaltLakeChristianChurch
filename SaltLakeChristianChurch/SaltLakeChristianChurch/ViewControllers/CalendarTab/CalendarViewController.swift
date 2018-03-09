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
    
    // IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
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
    
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent // Set the nav bar to default configuration when the view dissapears, so it doesn't stay dark.
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
    

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // Event for indexPath
        let eventArray = EventController.shared.eventsByMonth[indexPath.section].1
        let event = eventArray[indexPath.row]
        
        // Gives small vibration when user slides out event
        let generator = UIImpactFeedbackGenerator(style: UIImpactFeedbackStyle.light)
        generator.impactOccurred()

        // Add Action
        let addToCalendar = UIContextualAction(style: .normal, title: "Add to Calendar") { [weak self](action, view, nil) in

            self?.addCalendarEventToLocalCalendarAlert(event)
        }
        addToCalendar.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)

        // Create Configuraiton to return
        let configuration = UISwipeActionsConfiguration(actions: [addToCalendar])
        configuration.performsFirstActionWithFullSwipe = false // Makes it so you need to tap, rather than just swipe.
        return configuration
    }
    
    // Function that hides the navigation bar when scroll down.
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity.y > 0 {
            //Code will work without the animation block.I am using animation block incase if you want to set any delay to it.
            UIView.animate(withDuration: 2.5, delay: 0.75, options: UIViewAnimationOptions(), animations: {
                self.navigationController?.setNavigationBarHidden(true, animated: true)
                UIApplication.shared.statusBarStyle = .default
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 2.5, delay: 0.75, options: UIViewAnimationOptions(), animations: {
                self.navigationController?.setNavigationBarHidden(false, animated: true)
                UIApplication.shared.statusBarStyle = .lightContent
            }, completion: nil)
        }
    }

}

// MARK: - Alert functions for adding eents
extension CalendarViewController {
    
    /// Function that alerts user the event they are trying to add to the calendar already exists
    func addCalendarEventToLocalCalendarAlert(_ event: Event) {
        let alertController = UIAlertController(title: "Add \(event.summary!) to your calendar? 📆", message: nil, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "OK", style: .default) { (_) in
            let formatter = DateHelper.inputFormatter
            guard let startDateStringAsString = event.start?.dateTime else { return }
            guard let startDate = formatter.date(from: startDateStringAsString) else { return }
            guard let calendarID = event.id else { return }
            let calendarIDObj = AddedCalendarIDs(calendarID: calendarID)
            
            // Check to see if calendar event has been saved, if not, add it to the event.
            for alreadySavedCalendarID in AddedCalendarIDController.shared.addedCalendarEventIDs {
                if alreadySavedCalendarID.calendarID == calendarID {
                    self.presentAlertControllerWithOkayAction(title: "\(event.summary!) is already saved to your calendar!", message: "")
                    return
                    // DO WORK - Add alert saying calendar already exists
                }
            }
            
            // Adds to Coredata and locally so you don't have to refetch from coredata
            AddedCalendarIDController.shared.addedCalendarEventIDs.append(calendarIDObj)
            AddedCalendarIDController.shared.add(calendarID: calendarID)
            
            // Function that adds event to apple calendar
            EventController.shared.addEventToCalendar(title: event.summary ?? "", description: event.location ?? "", startDate: startDate, endDate: startDate)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(okayAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
}

