![Alt text](https://static1.squarespace.com/static/58b1f2c003596e617b2a55ad/t/59922de52994ca5618af3272/1502752297619/lake+blanche.jpg)

# Salt Lake Christian Church
Find Salt Lake Christian Church on [github](https://github.com/JaydenGarrick/SaltLakeChristianChurch)

## Description
Salt Lake Christian Church is an app created for a non-profit church. The goal of the app is to bring members of the church together and helps to stay organized, but also offer an array of features non-members can access as well, such as the calendar, lesson RSS feed, and announcement tab.


### Technologies used
Firebase, RESTful APIs, CoreData, Autolayout, XMLParser, AVFoundation

#####  Firebase
Firebase was used to create a directory for members that are able to sign in / sign up. Firebase is also used for the creation of announcements, such as important upcoming events.

#####  RESTFul APIS
Implemented Google Calendar API to keep members up to date with all events happening within the church. Automatically updates with the calendar, and can refresh within the app.

#####  CoreData
Used coredata to handle the blocking and hiding of user generated content. Because creating an account is only a member feature, had to implement another method besides Firebase to handle apple's guidelines on user generated content.  

#####  Autolayout
Implemented Autolayout to handle all UI design. Managed to create complex designs with efficient, adaptive constraints.

#####  XMLParser and AVFoundation
XML parsing was used primarily for the RSS feed. The church hosts a podcast that has recordings of all sermons and guest speakers talks / lectures. Created a audio player using AVFoundation, and used a download task with the .mp3 URL from the XML to play the audio.

#####  Highlights
Managed to work with a client and exceed all expectations in a timely manner.

![Alt text](https://static1.squarespace.com/static/58b1f2c003596e617b2a55ad/t/59922de52994ca5618af3272/1502752297619/lake+blanche.jpg)

# Root - Local Art Finder
Find Root on [github](https://github.com/JaydenGarrick/root)

### Technologies used
MapKit, CloudKit, CoreLocation

#####  CloudKit
CloudKit was used to handle user authentication, and managed all persistence with the application. We also used CKPredicates to handle how the feed works - i.e. it only pulls events happening within 50 miles of the user.

##### CoreLocation and MapKit
Implemented CoreLocation and MapKit to handle how the feed works. The user gets all events within 50 miles of their current location, which CoreLocation prompts you to allow access. Then those events are put on a MapView using MapKit using MKAnnotations. 
