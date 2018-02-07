//
//  EventController.swift
//  SaltLakeChristianChurch
//
//  Created by Jayden Garrick on 2/6/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import Foundation

class EventController {
    
    static let shared = EventController()
    var baseURL = URL(string: "https://www.googleapis.com/calendar/v3/calendars/jep04cit3p2odlnuh6462ppjig%40group.calendar.google.com")
    var events: [Event] = []
    
    func fetchEvents(completion: @escaping ((Bool)->Void)) {
        
        // url
        baseURL?.appendPathComponent("events")
        guard let url = baseURL else { completion(false) ; return }
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        //let limitQueryItem = URLQueryItem(name: "maxResults", value: "25")
        let keyQueryItem = URLQueryItem(name: "key", value: "AIzaSyCEzvWdpJPzf6a2dcRjHBScX0Rk6aYgkYk")
        components?.queryItems = [keyQueryItem]
        guard let newURL = components?.url else { completion(false) ; return }
        print(newURL.absoluteString)
        
        // request
        var request = URLRequest(url: newURL)
        request.httpBody = nil
        request.httpMethod = "GET"
        
        // dataTask + Resume
        let dataTask = URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("Error fetching events: \(error.localizedDescription)")
                completion(false)
            }
            guard let data = data else { completion(false) ; return }
            let decoder = JSONDecoder()
            
            do {
                let topLevelData = try decoder.decode(EventTopLevelItems.self, from: data)
                let items = topLevelData.items
                var tempEventArray: [Event] = []
                for item in items {
                    let newEvent = item
                    tempEventArray.append(newEvent)
                }
                if tempEventArray.count == 0 {
                    completion(false)
                } else {
                    self.events = tempEventArray.reversed()
                    completion(true)
                }
            } catch let error {
                print("Decoder Error: \(error.localizedDescription)")
                completion(false)
            }
        }
        dataTask.resume()
    }
}
