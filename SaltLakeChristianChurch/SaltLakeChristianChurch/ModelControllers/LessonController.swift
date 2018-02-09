//
//  LessonController.swift
//  SaltLakeChristianChurch
//
//  Created by Jayden Garrick on 2/8/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import Foundation

class LessonController: NSObject, XMLParserDelegate {

    // MARK: - Properties
    static let shared = LessonController() // Singleton

    var lessons:[Lesson] = []
    var imageURLAsString = ""
    var audioURLAsString = ""
    private var currentElement = ""

    private var currentTitle = "" {
        didSet {
            currentTitle = currentTitle.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }

    private var currentSummary = "" {
        didSet {
            currentSummary = currentSummary.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }

    private var currentPubDate = "" {
        didSet {
            currentPubDate = currentPubDate.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }

    private var parserCompletionHandler:(([Lesson])->Void)? // Completion Handler for getting to the end of XML Document

    // MARK: - Tag Keys
    enum tagKey: String {
        case item = "item"
        case title = "title"
        case summary = "itunes:summary"
        case pubDate = "pubdate"
        case imageTag = "itunes:image"
        case audioTag = "enclosure"
        case imageURL = "href"
        case audioURL = "url"
    }
    
    // MARK: - XML Formatter Delegate functions
    func parseFeedWith(urlString: String, completionHandler: (([Lesson])-> Void)?) -> Void {

        self.parserCompletionHandler = completionHandler

        let request = URLRequest(url: URL(string: urlString)!)
        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: request) { (data, response, error) in

            guard let data = data else {
                if let error = error {
                    print(error)
                }
                return
            }

            // Parse XML data
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
        }
        task.resume()
    }

    func parserDidStartDocument(_ parser: XMLParser) {
        lessons = []
    }

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        // Check to see if element is Attributed Value
        if elementName == tagKey.audioTag.rawValue {
            audioURLAsString = attributeDict[tagKey.audioURL.rawValue] ?? ""
        }
        
        // Check to see if element is Attributed Value
        if elementName == tagKey.imageTag.rawValue {
            imageURLAsString = attributeDict[tagKey.imageURL.rawValue] ?? ""
        }
        
        // Set the current element to be constant
        currentElement = elementName
        if currentElement == tagKey.item.rawValue {
            currentTitle = ""
            currentPubDate = ""
            currentSummary = ""
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        //print(currentElement)
        switch currentElement {
        case tagKey.title.rawValue:
            currentTitle += string
        case tagKey.summary.rawValue:
            currentSummary += string
        case tagKey.pubDate.rawValue:
            currentPubDate += string
        default: break
        }
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == tagKey.item.rawValue {
            let lesson = Lesson(title: currentTitle, summary: currentTitle, pubDate: currentPubDate, imageURL: imageURLAsString, audioURLAsString: audioURLAsString)
            imageURLAsString = ""
            audioURLAsString = ""
            lessons.append(lesson)
        }
    }

    func parserDidEndDocument(_ parser: XMLParser) {
        parserCompletionHandler?(lessons)
    }

}
