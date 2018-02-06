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
        
        let limitQueryItem = URLQueryItem(name: "maxResults", value: "25")
        let keyQueryItem = URLQueryItem(name: "key", value: "AIzaSyCEzvWdpJPzf6a2dcRjHBScX0Rk6aYgkYk")
        components?.queryItems = [limitQueryItem, keyQueryItem]
        guard let newURL = components?.url else { completion(false) ; return }
        print(newURL.absoluteString)
        // request
        
        // dataTask + Resume
    }
}
