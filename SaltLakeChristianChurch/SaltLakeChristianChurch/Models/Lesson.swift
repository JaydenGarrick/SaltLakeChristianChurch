//
//  Lesson.swift
//  SaltLakeChristianChurch
//
//  Created by Jayden Garrick on 2/8/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import Foundation

class Lesson {
    // MARK: - Properties
    var title: String
    var summary: String
    var pubDate: String
    var imageURL: String
    var audioURLAsString: String
    var mp3Url: URL?
    var playbackPostion: Double?
    
    init(title: String, summary: String, pubDate: String, imageURL: String, audioURLAsString: String) {
        self.title = title
        self.summary = summary
        self.pubDate = pubDate
        self.imageURL = imageURL
        self.audioURLAsString = audioURLAsString
    }
}








