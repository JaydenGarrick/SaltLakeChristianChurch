//
//  AnnouncementsViewController.swift
//  SaltLakeChristianChurch
//
//  Created by Jayden Garrick on 1/30/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit
import Firebase
import CoreData
import MessageUI

class AnnouncementsViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    // MARK: - IBOutlets and constants / variables
    @IBOutlet weak var addEventBarButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
   
    var refreshControl: UIRefreshControl! // Refresh Control for reloading
    let imageCache = NSCache<NSString, UIImage>()
    
    // MARK: - ViewDidLoad / ViewWillAppear
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // HandleNavBar and Keyboard and Set network indicator
        hideKeyboardWhenTappedAroundAndSetNavBar()
        
        // Delegate And Setup
        initialFetchForAnnouncements()
        setupRefreshController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableViewSetup()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent // Set the nav bar to default configuration when the view dissapears, so it doesn't stay dark.
        UIApplication.shared.isStatusBarHidden = false
    }

    // MARK: - Refresh Function
    @objc func didPullForRefresh() {
        AnnouncementController.shared.fetchAnnouncements { [weak self](success) in
            if success {
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self?.refreshControl.endRefreshing()
                }
            }
        }
    }
    
}

// MARK: - Setup Functions
extension AnnouncementsViewController {
    fileprivate func setupRefreshController() {
        // Set up Refresh Control for refresh on pulldown
        tableView.alwaysBounceVertical = true
        tableView.bounces = true
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor(red: 71.0/255.0, green: 199.0/255.0, blue: 236/255.0, alpha: 1.0)
        refreshControl.addTarget(self, action: #selector(didPullForRefresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    fileprivate func initialFetchForAnnouncements() {
        // Initial Fetch for events
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        AnnouncementController.shared.fetchAnnouncements { [weak self](success) in
            if success {
                print("\(BlockedAnnouncementController.shared.blockedAnnouncements.count) is the total amount of blocked announcements")
                self?.tableView.reloadData()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
    }
    
    fileprivate func tableViewSetup() {
        // Set estimated height for self sizing tableview
        tableView.estimatedRowHeight = 450.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        
        if MemberController.shared.loggedInMember?.isAdmin == false || MemberController.shared.isLoggedIn == false {
            navigationItem.rightBarButtonItem = nil
        }

        // Handle bug where button is left on selected
        if MemberController.shared.loggedInMember?.isAdmin == true && MemberController.shared.loggedInMember != nil {
            addEventBarButton.isEnabled = false
            addEventBarButton.isEnabled = true
        }
    }
}


// MARK: - TableView Delegate and Datasourcec functions
extension AnnouncementsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AnnouncementController.shared.announcements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "annoucementCell", for: indexPath) as! AnnouncementTableViewCell
        let announcement = AnnouncementController.shared.announcements[indexPath.row]
        cell.delegate = self  // Set delegate of cell
        cell.announcement = announcement
        cell.imageActivityIndicator.startAnimating()
        
        // Set up image from storage
        cell.announcementImageView.image = nil
        if let cachedImage = imageCache.object(forKey: announcement.imageAsStringURL as NSString) {
            cell.announcementImageView.image = cachedImage
        } else {
            AnnouncementController.shared.loadImageFrom(imageURL: announcement.imageAsStringURL) { [weak self](image) in
                guard let image = image else { return }
                self?.imageCache.setObject(image, forKey: announcement.imageAsStringURL as NSString)
                DispatchQueue.main.async { [weak cell] in
                    cell?.announcementImageView.image = image
                    cell?.imageActivityIndicator.isHidden = true
                }
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
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
       // Set initial animation of cell
        cell.alpha = 0
        let transform = CATransform3DTranslate(CATransform3DIdentity, -5, 10, 0)
        cell.layer.transform = transform
        UIView.animate(withDuration: 0.10) { [weak cell] in
            cell?.alpha = 1.0
            cell?.layer.transform = CATransform3DIdentity
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let activiityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
        activiityIndicatorView.color = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        activiityIndicatorView.startAnimating()
        return activiityIndicatorView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return AnnouncementController.shared.announcements.isEmpty ? 250 : 0
    }
    
    // Function that hides the navigation bar when scroll down.
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity.y > 0 {
            //Code will work without the animation block.I am using animation block incase if you want to set any delay to it.
            UIView.animate(withDuration: 0.25, delay: 0.25, options: UIView.AnimationOptions(), animations: { [weak self] in
                self?.navigationController?.setNavigationBarHidden(true, animated: true)
                UIApplication.shared.isStatusBarHidden = true
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.25, delay: 0.25, options: UIView.AnimationOptions(), animations: { [weak self] in
                self?.navigationController?.setNavigationBarHidden(false, animated: true)
                UIApplication.shared.isStatusBarHidden = false
                UIApplication.shared.statusBarStyle = .lightContent
            }, completion: nil)
        }
    }
    
}

// MARK: - Add Action Sheet for reporting / hiding
extension AnnouncementsViewController: MFMailComposeViewControllerDelegate, AnnouncementtableViewCellDelegate {
    
    func announcementButtonTapped(sender: AnnouncementTableViewCell) {
        
        // Create Action Sheet
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.view.tintColor = UIColor(named: "Tint")
        
        // Create Action for hiding
        let hideAction = UIAlertAction(title: "Hide", style: .default) { [weak self](_) in
            
            // Hides the content
            self?.hideContent(cell: sender)
        }
        let reportAction = UIAlertAction(title: "Report as Offenseive", style: .destructive) { [weak self](_) in
            
            // Presents mail controller and hides content
            self?.presentMailViewController()
            self?.hideContent(cell: sender)
        }
        
        // Cancel Action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(hideAction)
        actionSheet.addAction(reportAction)
        actionSheet.addAction(cancelAction)
        present(actionSheet, animated: true)
    }
    
    func presentMailViewController() {
        let mailComposeViewController = MFMailComposeViewController()
        mailComposeViewController.mailComposeDelegate = self
        if MFMailComposeViewController.canSendMail() {
            mailComposeViewController.setToRecipients(["jaydengarrick@gmail.com"])
            mailComposeViewController.setSubject("Offensive material")
            mailComposeViewController.setMessageBody("", isHTML: false)
            present(mailComposeViewController, animated: true)
        }
    }
    
    func hideContent(cell: UITableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let announcement = AnnouncementController.shared.announcements[indexPath.row]
            AnnouncementController.shared.hide(announcement: announcement, completion: { [weak self](success) in
                if success  {
                    let blockedAnnouncement = BlockedAnnouncement(announcementID: announcement.announcementID)
                    BlockedAnnouncementController.shared.blockedAnnouncements.append(blockedAnnouncement)
                    BlockedAnnouncementController.shared.add(blockedID: blockedAnnouncement.announcementID!)
                    self?.tableView.reloadData()
                }
            })
        }
    }
    
}








