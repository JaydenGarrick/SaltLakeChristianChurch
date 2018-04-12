//
//  SermonViewController.swift
//  SaltLakeChristianChurch
//
//  Created by Jayden Garrick on 1/30/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit

class LessonViewController: UIViewController {

    // MARK: - IBOutlets and constants / variables
    var lessons:[Lesson] = []
    var refreshControl: UIRefreshControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - View Lifecycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // DataSource and Delegate
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // HandleNavBar and Keyboard
        hideKeyboardWhenTappedAroundAndSetNavBar()
        
        // Fetch Lessons from RSS Feed
        refresh()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent // Set the nav bar to default configuration when the view dissapears, so it doesn't stay dark.
        UIApplication.shared.isStatusBarHidden = false
    }

}

// MARK: - CollectionView Datasource and Delegate
extension LessonViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lessons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LessonCell", for: indexPath) as! LessonCollectionViewCell
        
        // Configure the cell
        let lesson = lessons[indexPath.row]
        cell.lesson = lesson
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.alpha = 0
        let transform = CATransform3DTranslate(CATransform3DIdentity, -10, 20, 0)
        cell.layer.transform = transform
        UIView.animate(withDuration: 0.20) {
            cell.alpha = 1.0
            cell.layer.transform = CATransform3DIdentity
        }
    }
    
    // Function that hides the navigation bar when scroll down.
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity.y > 0 {
            //Code will work without the animation block.I am using animation block incase if you want to set any delay to it.
            UIView.animate(withDuration: 0.25, delay: 0, options: UIViewAnimationOptions(), animations: { [weak self] in
                self?.navigationController?.setNavigationBarHidden(true, animated: true)
                UIApplication.shared.isStatusBarHidden = true
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.25, delay: 0, options: UIViewAnimationOptions(), animations:  { [weak self] in
                self?.navigationController?.setNavigationBarHidden(false, animated: true)
                UIApplication.shared.isStatusBarHidden = false
                UIApplication.shared.statusBarStyle = .lightContent
            }, completion: nil)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160.0, height: 180.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let lesson = lessons[indexPath.row]
        UIApplication.mainTabBarController()?.maximizePlayerDetails(lesson: lesson)
    }
    
}

// MARK: - Setup For Refresh on pulldown
extension LessonViewController {
    
    @objc func refresh() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        LessonController.shared.parseFeedWith(urlString: "https://www.saltlakechristianchurch.com/lessons-on-audio/?format=rss") { [weak self](parsedLessons) in
            self?.lessons = parsedLessons
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
    }
    
}



