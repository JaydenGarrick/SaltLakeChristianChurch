//
//  AnnouncementsViewController.swift
//  SaltLakeChristianChurch
//
//  Created by Jayden Garrick on 1/30/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit
import Firebase

class AnnouncementsViewController: UIViewController {

    
    // MARK: - IBOutlets and constants / variables
    @IBOutlet weak var addEventBarButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl: UIRefreshControl! // Refresh Control for reloading
    let imageCache = NSCache<NSString, UIImage>()
    
    
    // MARK: - ViewDidLoad / ViewWillAppear
    override func viewDidLoad() {
        super.viewDidLoad()

        // HandleNavBar and Keyboard and Set network indicator
        self.hideKeyboardWhenTappedAroundAndSetNavBar()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        // Check to see if logged in member is admin
        if MemberController.shared.loggedInMember?.isAdmin == false || MemberController.shared.isLoggedIn == false {
            self.navigationItem.rightBarButtonItem = nil
        }
        
        // Delegate
        tableView.delegate = self
        tableView.dataSource = self
        
        
        // Initial Fetch for events
        AnnouncementController.shared.fetchAnnouncements { (success) in
            if success {
                self.tableView.reloadData()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
        
        // Set up Refresh Control for refresh on pulldown
        tableView.alwaysBounceVertical = true
        tableView.bounces = true
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor(named: "Tint")
        refreshControl.addTarget(self, action: #selector(didPullForRefresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set estimated height for self sizing tableview
        tableView.estimatedRowHeight = 450.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        
        // Handle bug where button is left on selected
        if MemberController.shared.loggedInMember?.isAdmin == true && MemberController.shared.loggedInMember != nil {
            addEventBarButton.isEnabled = false
            addEventBarButton.isEnabled = true
        }
    }
    
    // MARK: - Refresh Function
    @objc func didPullForRefresh() {
        AnnouncementController.shared.fetchAnnouncements { (success) in
            if success {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                }
            }
        }
    }
    
}

// MARK: - TableView Delegate and Datasourcec functions
extension AnnouncementsViewController: UITableViewDelegate, UITableViewDataSource, AnnouncementtableViewCellDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AnnouncementController.shared.announcements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "annoucementCell", for: indexPath) as! AnnouncementTableViewCell
        let announcement = AnnouncementController.shared.announcements[indexPath.row]
       
        cell.delegate = self  // Set delegate of cell
        cell.imageActivityIndicator.startAnimating()
        
        // Set up image from storage
        cell.announcementImageView.image = nil
        if let cachedImage = imageCache.object(forKey: announcement.imageAsStringURL as NSString) {
            cell.announcementImageView.image = cachedImage
        } else {
            AnnouncementController.shared.loadImageFrom(imageURL: announcement.imageAsStringURL) { (image) in
                guard let image = image else { return }
                self.imageCache.setObject(image, forKey: announcement.imageAsStringURL as NSString)
                cell.announcementImageView.image = image
                cell.imageActivityIndicator.isHidden = true
            }
        }
        
        // Set properties
        cell.announcementNameLabel.text = announcement.name
        cell.announcementDetailTextView.text = announcement.description
        
        
        // Set up date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        let dateAsString = dateFormatter.string(from: announcement.creationDate)
        cell.dateCreatedLabel.text = dateAsString
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
       // Set initial animation of cell
        cell.alpha = 0
        let transform = CATransform3DTranslate(CATransform3DIdentity, -5, 10, 0)
        cell.layer.transform = transform
        UIView.animate(withDuration: 0.10) {
            cell.alpha = 1.0
            cell.layer.transform = CATransform3DIdentity
        }
    }
    
    
}








