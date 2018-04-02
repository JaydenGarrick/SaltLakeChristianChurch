//
//  EventController.swift
//  SaltLakeChristianChurch
//
//  Created by Jayden Garrick on 2/6/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import Foundation
import EventKit
import CoreData

class EventController {
    
    // MARK: - Constants and Variales
    static let shared = EventController() ; private init(){} // Singleton
    var baseURL = URL(string: "https://www.googleapis.com/calendar/v3/calendars/jep04cit3p2odlnuh6462ppjig%40group.calendar.google.com")
    var events: [Event] = []
    
    typealias eventByMonth = (String, [Event]) // Type Alias for Month header and array of events
    var eventsByMonth: [eventByMonth] {
        var january: eventByMonth = ("January", [])
        var february: eventByMonth = ("February", [])
        var march: eventByMonth = ("March", [])
        var april: eventByMonth = ("April", [])
        var may: eventByMonth = ("May", [])
        var june: eventByMonth = ("June", [])
        var july: eventByMonth = ("July", [])
        var august: eventByMonth = ("August", [])
        var september: eventByMonth = ("September", [])
        var october: eventByMonth = ("October", [])
        var november: eventByMonth = ("November", [])
        var december: eventByMonth = ("December", [])
        
        // Sort through events
        for event in events {
            if let start = event.start, let dateAsString = start.dateTime {
                guard let startDate = DateHelper.inputFormatter.date(from: dateAsString ) else { return [] }
                let startDateString = DateHelper.outputFormatter.string(from: startDate)
                guard let month = startDateString.components(separatedBy: " ").first else { return [] }
                
                // Months
                switch month {
                case "Jan":
                    january.1.append(event)
                case "Feb":
                    february.1.append(event)
                case "Mar":
                    march.1.append(event)
                case "Apr":
                    april.1.append(event)
                case "May":
                    may.1.append(event)
                case "Jun":
                    june.1.append(event)
                case "Jul":
                    july.1.append(event)
                case "Aug":
                    august.1.append(event)
                case "Sep":
                    september.1.append(event)
                case "Oct":
                    october.1.append(event)
                case "Nov":
                    november.1.append(event)
                case "Dec":
                    december.1.append(event)
                default:
                break
                }
            }
        }
        // Look up calendar and date components API
        
        // Returns month array
        let monthArray = [january, february, march, april, may, june, july, august, september, october, november, december]
        return monthArray.filter { $0.1.count > 0 }
    }
    
    func fetchEvents(completion: @escaping ((Bool)->Void)) {
        
        // url
        baseURL?.appendPathComponent("events")
        guard let url = baseURL else { completion(false) ; return }
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        let orderByQueryItem = URLQueryItem(name: "orderBy", value: "startTime")
        let singleEventsQuery = URLQueryItem(name: "singleEvents", value: "true")
        let keyQueryItem = URLQueryItem(name: "key", value: "AIzaSyCEzvWdpJPzf6a2dcRjHBScX0Rk6aYgkYk")
        components?.queryItems = [orderByQueryItem, singleEventsQuery ,keyQueryItem]
        guard let newURL = components?.url else { completion(false) ; return }
        print(newURL.absoluteString)
        
        // request
        var request = URLRequest(url: newURL)
        request.httpBody = nil
        request.httpMethod = "GET"
        
        // dataTask + Resume
        let dataTask = URLSession.shared.dataTask(with: request) { [weak self](data, _, error) in
            if let error = error {
                print("❌Error fetching events: \(error.localizedDescription)")
                completion(false)
            }
            guard let data = data else { completion(false) ; return }
            let decoder = JSONDecoder()
            
            // decode JSON
            do {
                let topLevelData = try decoder.decode(EventTopLevelItems.self, from: data)
                let items = topLevelData.items
                var tempEventArray: [Event] = []
                for event in items {
                    guard let dateFromEvent = DateHelper.inputFormatter.date(from: event.start?.dateTime ?? "") else { continue }
                    if dateFromEvent >= Date() {
                        let newEvent = event
                        tempEventArray.append(newEvent)
                    }
                }
                if tempEventArray.count == 0 {
                    completion(false)
                } else {
                    self?.events = tempEventArray
                    completion(true)
                }
            } catch let error {
                print("❌Decoder Error: \(error.localizedDescription)")
                completion(false)
            }
        }
        dataTask.resume()
    }
    
    func addEventToCalendar(title: String, description: String?, startDate: Date, endDate: Date, completion: ((_ success: Bool, _ error: NSError?) -> Void)? = nil) {
        let eventStore = EKEventStore()
        
        eventStore.requestAccess(to: .event, completion: { (granted, error) in
            if granted && error == nil {
                let event = EKEvent(eventStore: eventStore)
                event.title = title
                event.startDate = startDate
                event.endDate = endDate
                event.notes = description
                event.calendar = eventStore.defaultCalendarForNewEvents
                do {
                    try eventStore.save(event, span: .thisEvent)
                } catch let error as NSError {
                    completion?(false, error)
                    print(error.localizedDescription as Any)
                    return
                }
                completion?(true, nil)
            } else {
                completion?(false, error as NSError?)
                print(error?.localizedDescription as Any)
            }
        })
    }
    
}

// MARK: - Calendar ID controller, so you don't add multiples of calendar events
class AddedCalendarIDController {
    
    // Constants / Variables
    static let shared = AddedCalendarIDController() ; private init(){}
    var addedCalendarEventIDs = [AddedCalendarIDs]() {
        didSet {
            print("📆\(addedCalendarEventIDs.count) is the total amount of calendar IDS")
        }
    } // Datasource
    
    // CRUD Functions
    func add(calendarID: String) {
        let _ = AddedCalendarIDs(calendarID: calendarID)
        save()
    }
    
    func save() {
        do {
            try CoreDataStack.context.save()
        } catch {
            print("❌\(error.localizedDescription)")
        }
    }
    
}

