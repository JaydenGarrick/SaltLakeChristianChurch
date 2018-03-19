//
//  SaltLakeChristianChurchTests.swift
//  SaltLakeChristianChurchTests
//
//  Created by Jayden Garrick on 3/19/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import XCTest
@testable import SaltLakeChristianChurch

class SaltLakeChristianChurchTests: XCTestCase {
    
    var session: URLSession?
    
    override func setUp() {
        super.setUp()
        session = URLSession(configuration: .default)
    }
    
//    func testFirebaseAnnouncementFetch() {
//        AnnouncementController.shared.fetchAnnouncements { (success) in
//            if success {
//                XCTAssertTrue(AnnouncementController.shared.announcements.count != 0)
//            }
//        }
//    }
//
//    func testXmlLessonFetch() {
//        LessonController.shared.parseFeedWith(urlString: "https://www.saltlakechristianchurch.com/lessons-on-audio/?format=rss") { (lessons) in
//            XCTAssertTrue(lessons.count != 0)
//        }
//    }
    
    func testEventFetch() {
        guard let session = session else { return }
        EventController.shared.fetchEvents(session: session) { (events) in
            XCTAssertNotNil(events, "Events is")
        }
    }
    
//    func testFetchUserWithUID() {
//        XCTAssertNil(MemberController.shared.loggedInMember)
//        MemberController.shared.fetchUserWith(uuid: "xxQxap6jBhbMrvcufIbrJxAP0xi1") { (success) in
//            XCTAssertNotNil(MemberController.shared.loggedInMember, "Couldn't fetch user")
//        }
//    }
    
    override func tearDown() {
        super.tearDown()
    }
    
}
