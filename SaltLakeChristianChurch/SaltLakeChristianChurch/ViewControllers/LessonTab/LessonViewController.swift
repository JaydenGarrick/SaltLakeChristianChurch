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
    let imageCache = NSCache<NSString, UIImage>()
    var refreshControl: UIRefreshControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - ViewDidLoad / ViewWillAppear
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // DataSource and Delegate
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // HandleNavBar and Keyboard
        self.hideKeyboardWhenTappedAroundAndSetNavBar()
        
        // Fetch Lessons from RSS Feed
        refresh()
        
        // Set up Refresh Control for refresh on pulldown
        collectionView.alwaysBounceVertical = true
        collectionView.bounces = true
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = #colorLiteral(red: 0.27700001, green: 0.7789999843, blue: 0.9250000119, alpha: 1)
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        collectionView.addSubview(refreshControl)
    }
    
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LessonAudio" {
            guard let indexPaths = collectionView.indexPathsForSelectedItems else { return }
            guard let indexPath = indexPaths.first else { return }
            let destinationVC = segue.destination as! AudioLessonViewController
            let lesson = lessons[indexPath.row]
            destinationVC.lesson = lesson
        }
    }
    
    
}

// MARK: - CollectionView Datasource and Delegate
extension LessonViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lessons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LessonCell", for: indexPath) as! CollectionViewCell
        
        // Configure the cell
        let lesson = lessons[indexPath.row]
        
        if lesson.imageURL ==  "http://static1.squarespace.com/static/58b1f2c003596e617b2a55ad/t/5a09269a9140b7f3b7b8b654/1510549154825/1500w/SLCC+Logo+iTunes.png" {
            cell.lessonImageView.image = #imageLiteral(resourceName: "CollectionViewHolder")
        } else {
            if let cachedImage = imageCache.object(forKey: lesson.imageURL as NSString) {
                cell.lessonImageView.image = cachedImage
            } else {
                LessonController.shared.downloadImageFrom(urlString: lesson.imageURL) { (image) in
                    guard let image = image else { return }
                    self.imageCache.setObject(image, forKey: lesson.imageURL as NSString)
                    DispatchQueue.main.async {
                        cell.lessonImageView.image = image
                    }
                }
            }
        }
        cell.lessonTitle.text = lesson.title
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160.0, height: 180.0)
    }
    
    @objc func refresh() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        LessonController.shared.parseFeedWith(urlString: "https://www.saltlakechristianchurch.com/lessons-on-audio/?format=rss") { (parsedLessons) in
            self.lessons = parsedLessons
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.refreshControl.endRefreshing()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false

            }
        }
    }
    
}


