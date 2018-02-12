//
//  AudioLessonViewController.swift
//  SaltLakeChristianChurch
//
//  Created by Jayden Garrick on 2/9/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit
import AVFoundation

class AudioLessonViewController: UIViewController {

    // MARK: - IBOutlets and Variables
    var lesson: Lesson?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var summaryTextView: UITextView!
    @IBOutlet weak var slider: UISliderX!
    @IBOutlet weak var playPauseButtonImageView: UIImageView!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var timeSoFarLabel: UILabel!
    @IBOutlet weak var timeRemainingLabel: UILabel!
    @IBOutlet weak var blurView: UIVisualEffectViewX!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var player: AVAudioPlayer = AVAudioPlayer()
    var mp3URL: URL?
    
    // MARK: - viewDidLoad / viewDidAppear
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Update views based on selected lesson
        updateViews()
        
        // Disable UIElements while audio is loading
        playPauseButton.isEnabled = false
        slider.isEnabled = false
        activityIndicator.tintColor = UIColor(red: 71.0/255.0, green: 199.0/255.0, blue: 236/255.0, alpha: 1.0)
        activityIndicator.startAnimating()
        
        // Setup while waiting for audio
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        if let lesson = lesson {
            downloadFileFrom(urlString: lesson.audioURLAsString, completion: { (fetchedURL) in
                DispatchQueue.main.async {
                    self.slider.maximumValue = Float(self.player.duration)
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.playPauseButton.isEnabled = true
                    self.slider.isEnabled = true
                    self.playPauseButtonImageView.image = #imageLiteral(resourceName: "pause-button")
                    Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updateSlider), userInfo: nil, repeats: true)
                    Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateTimeLabel), userInfo: nil, repeats: true)
                    UIView.animate(withDuration: 0.25, animations: {
                        self.blurView.layer.opacity = 0
                    })
                }
            })
        }
    }
    
    // MARK: - IBActions
    @IBAction func sliderDidChange(_ sender: Any) {
        player.stop()
        player.currentTime = TimeInterval(slider.value)
        player.prepareToPlay()
        player.play()
        playPauseButtonImageView.image = #imageLiteral(resourceName: "pause-button")
        updateTimeLabel()
    }
    
    @IBAction func playOrPauseButtonTapped(_ sender: Any) {
        if player.isPlaying == true {
            UIView.animate(withDuration: 0.5, animations: {
                self.playPauseButtonImageView.image = #imageLiteral(resourceName: "play-button")
            })
            player.pause()
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.playPauseButtonImageView.image = #imageLiteral(resourceName: "pause-button")
            })
            player.play()
        }
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func play(url: URL) {
        do {
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            } catch {
                print("Error with AVAudioSession: \(error.localizedDescription)")
            }
            
            self.player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
            player.volume = 1.0
            player.play()
        } catch {
            self.presentAlertControllerWithOkayAction(title: "Error Playing Audio", message: "\(error.localizedDescription)")
        }
    }
    
    func updateViews() {
        if let lesson = lesson {
            LessonController.shared.downloadImageFrom(urlString: lesson.imageURL, completion: { (image) in
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            })
            titleLabel.text = lesson.title
            summaryTextView.text = lesson.summary
        }
    }
    
    func downloadFileFrom(urlString: String, completion: @escaping ((URL?)->Void)) {
        guard let url = URL(string: urlString) else { completion(nil) ; return }
        var downloadTask: URLSessionDownloadTask
        downloadTask = URLSession.shared.downloadTask(with: url, completionHandler: { (downloadedURL, _, error) in
            if let error = error {
                print("Error with downloadTask: \(error.localizedDescription)")
            }
            guard let downloadedURL = downloadedURL else { print("Unable to get url") ; completion(nil) ; return }
            self.play(url: downloadedURL)
            completion(downloadedURL)
        })
        downloadTask.resume()
    }
    
    
    // MARK: - Functions for audio
    /// Updates slider based on audio being played
    @objc func updateSlider() {
        slider.value = Float(player.currentTime)
    }
    
    /// Updates timelabel based on audio being played
    @objc func updateTimeLabel() {
        let timeRemaining = Int(player.duration - player.currentTime)
        let timeSoFar = Int(player.currentTime)

        timeRemainingLabel.text = secondsToHoursMinutesSeconds(intSeconds: timeRemaining)
        timeSoFarLabel.text = secondsToHoursMinutesSeconds(intSeconds: timeSoFar)
    }
    
    
    /// Converts seconds into a 00:00:00 format
    func secondsToHoursMinutesSeconds (intSeconds : Int) -> String {
        let minutes:Int = intSeconds/60
        let hours:Int = minutes/60
        let seconds:Int = intSeconds%60
        
        let timeString:String = ((hours<10) ? "" : "") + String(hours) + ":" + ((minutes<10) ? "0" : "") + String(minutes) + ":" + ((seconds<10) ? "0" : "") + String(seconds)
        return timeString
    }
    
}






