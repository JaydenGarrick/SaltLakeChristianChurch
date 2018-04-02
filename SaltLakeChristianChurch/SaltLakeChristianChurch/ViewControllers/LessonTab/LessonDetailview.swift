//
//  LessonDetailview.swift
//  SaltLakeChristianChurch
//
//  Created by Jayden Garrick on 3/21/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit
import AVKit
import MediaPlayer

class LessonDetailView: UIView {
    
    // MARK: - Variables and Constants
    var lesson: Lesson! {
        didSet {
            
            // Normals
            titleLabel.text = lesson.title
            summaryTextView.text = lesson.summary
            setupNowPlayingInfo()
            setupAudioSession()
            playEpisode()
            
            // Minis
            miniTitleLabel.text = lesson.title
            LessonController.shared.downloadImageFrom(urlString: lesson.imageURL) { [weak self](image) in
                guard let image = image else { return }
                self?.miniEpisodeImageView.image = image
                self?.episodeImageView.image = image
                var nowPlayingInfo = MPNowPlayingInfoCenter.default().nowPlayingInfo
                let artworkItem = MPMediaItemArtwork(boundsSize: image.size, requestHandler: { (_) -> UIImage in
                    return image
                })
                nowPlayingInfo?[MPMediaItemPropertyArtwork] = artworkItem
                MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
            }
            
        }
    }
    
    let player: AVPlayer = {
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = true
        return avPlayer
    }()
    var panGesture: UIPanGestureRecognizer!

    // MARK: - IBOutlets
        //Mini View Controller
    @IBOutlet weak var miniPlayerView: UIView!
    @IBOutlet weak var hiddenPlayPauseButton: UIButton!
    @IBOutlet weak var miniEpisodeImageView: UIImageView!
    @IBOutlet weak var miniTitleLabel: UILabel!
    @IBOutlet weak var miniPlayPauseButton: UIButton! {
        didSet {
            miniPlayPauseButton.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
        }
    }
    
        //Normal View Controller
    @IBOutlet weak var normalPlayerView: UIView!
    @IBOutlet weak var episodeImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.numberOfLines = 2
        }
    }
    @IBOutlet weak var summaryTextView: UITextView!
    @IBOutlet weak var currentTimeSlider: UISliderX!
    @IBOutlet weak var playPauseButtonImageView: UIImageView! {
        didSet {
            playPauseButtonImageView.image = #imageLiteral(resourceName: "pause-button")
        }
    }
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var loadingView: UIVisualEffectViewX!
    
    // MARK: - Setup Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        setupInterruptionObserver()
        setupRemoteControl()
        setupGestures()
        observePlayerCurrentTime()
        observeBoundaryTime()
        
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(checkForLag), userInfo: nil, repeats: true)
    }
    
    @objc fileprivate func checkForLag() {
        if player.reasonForWaitingToPlay == AVPlayer.WaitingReason.evaluatingBufferingRate || player.reasonForWaitingToPlay == AVPlayer.WaitingReason.toMinimizeStalls {
            loadingView.isHidden = false
            hiddenPlayPauseButton.isEnabled = false
        } else {
            loadingView.isHidden = true
            hiddenPlayPauseButton.isEnabled = true
        }
    }
    
    static func initFromNib() -> LessonDetailView {
        return Bundle.main.loadNibNamed("AudioLessonView", owner: self, options: nil)?.first as! LessonDetailView
    }
    
    func setupInterruptionObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleInterruption), name: .AVAudioSessionInterruption, object: nil)
    }
    
    // MARK: - IBActions
    @IBAction func playPauseButtonTapped(_ sender: Any) {
        handlePlayPause()
    }
    @IBAction func doneButtonTapped(_ sender: Any) {
        UIApplication.mainTabBarController()?.minimizePlayerDetails()
    }
    @IBAction func handleCurrentTimeSlider(_ sender: Any) {
        let percentage = currentTimeSlider.value
        guard let duration = player.currentItem?.duration else { return }
        let durationInSeconds = CMTimeGetSeconds(duration)
        let seekTimeInSeconds = Float64(percentage) * durationInSeconds
        let seekTime = CMTimeMakeWithSeconds(seekTimeInSeconds, 1)
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = seekTimeInSeconds
        player.seek(to: seekTime)
    }
    
}

// MARK: - MediaPlayer methods - Lock Screen Audio View
extension LessonDetailView {
    
    @objc fileprivate func handleInterruption(notification: Notification) {
        guard let userInfo = notification.userInfo else  { return }
        guard let type = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt else { return }
        if type == AVAudioSessionInterruptionType.began.rawValue {
            playPauseButtonImageView.image = #imageLiteral(resourceName: "play-button")
            miniPlayPauseButton.setImage(#imageLiteral(resourceName: "play-button"), for: .normal)
        } else {
            guard let options = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt else { return }
            if options == AVAudioSessionInterruptionOptions.shouldResume.rawValue {
                player.play()
                playPauseButtonImageView.image = #imageLiteral(resourceName: "play-button")
                miniPlayPauseButton.setImage(#imageLiteral(resourceName: "pause-button"), for: .normal)
            }
        }
    }
    
    fileprivate func setupLockScreenDuration() {
        guard let duration = player.currentItem?.duration else { return }
        let durationSeconds = CMTimeGetSeconds(duration)
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPMediaItemPropertyPlaybackDuration] = durationSeconds
    }

    fileprivate func setupRemoteControl() {
        UIApplication.shared.beginReceivingRemoteControlEvents()
        
        // Handle Play
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget { [weak self](_) -> MPRemoteCommandHandlerStatus in
            self?.setupElapsedTime(playbackRate: 1)
            self?.player.play()
            self?.playPauseButtonImageView.image = #imageLiteral(resourceName: "pause-button")
            self?.miniPlayPauseButton.setImage(#imageLiteral(resourceName: "pause-button"), for: .normal)
            return .success
        }
        
        // Handle Pause
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget { [weak self](_) -> MPRemoteCommandHandlerStatus in
            self?.setupElapsedTime(playbackRate: 0)
            self?.player.pause()
            self?.playPauseButtonImageView.image = #imageLiteral(resourceName: "play-button")
            self?.miniPlayPauseButton.setImage(#imageLiteral(resourceName: "play-button"), for: .normal)
            return .success
        }
        
        // Handle media button (Like on airpods)
        commandCenter.togglePlayPauseCommand.isEnabled = true
        commandCenter.togglePlayPauseCommand.addTarget { [weak self](_) -> MPRemoteCommandHandlerStatus in
            self?.handlePlayPause()
            return .success
        }
    }
    
    fileprivate func setupNowPlayingInfo() {
        var nowPlayingInfo = [String: Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = lesson.title
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    fileprivate func setupElapsedTime(playbackRate: Float) {
        let elapsedTime = CMTimeGetSeconds(player.currentTime())
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyPlaybackRate] = playbackRate
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = elapsedTime
    }

}

// MARK: - AVPlayer Functions
extension LessonDetailView {
    
    func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Error activating session: \(error.localizedDescription)")
        }
    }
    
    fileprivate func playEpisode() {
        guard let url = URL(string: lesson.audioURLAsString) else { return }
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }
    
    @objc func handlePlayPause() {
        if player.timeControlStatus == .paused {
            player.play()
            playPauseButtonImageView.image = #imageLiteral(resourceName: "pause-button")
            miniPlayPauseButton.setImage(#imageLiteral(resourceName: "pause-button"), for: .normal)
            setupElapsedTime(playbackRate: 1)
        } else {
            player.pause()
            playPauseButtonImageView.image = #imageLiteral(resourceName: "play-button")
            miniPlayPauseButton.setImage(#imageLiteral(resourceName: "play-button"), for: .normal)
            setupElapsedTime(playbackRate: 0)
        }
    }
    
    fileprivate func observePlayerCurrentTime() {
        let interval = CMTimeMake(1, 2)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self](time) in
            if self?.player.currentItem?.status == .readyToPlay {
                self?.currentTimeLabel.text = time.toDisplayString()
                guard let durationTime = self?.player.currentItem?.duration else { return }
                self?.durationLabel.text = (durationTime - time).toDisplayString()
                self?.updateCurrentTimeSlider()
            }
        }
    }
    
    fileprivate func updateCurrentTimeSlider() {
        let currentTimeSeconds = CMTimeGetSeconds(player.currentTime())
        let durationSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(1, 1))
        let percentage = currentTimeSeconds / durationSeconds
        currentTimeSlider.value = Float(percentage)
    }
    
    fileprivate func observeBoundaryTime() {
        let time = CMTimeMake(1, 3)
        let times = [NSValue(time: time)]
        
        // player has a reference to self through closure
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) { [weak self] in
            self?.setupLockScreenDuration()
        }
    }

}





