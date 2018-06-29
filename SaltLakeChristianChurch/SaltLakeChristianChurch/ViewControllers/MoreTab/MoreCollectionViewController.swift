//
//  MoreCollectionViewController.swift
//  SaltLakeChristianChurch
//
//  Created by Jayden Garrick on 4/2/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//
import UIKit

class MoreCollectionViewController: UICollectionViewController {

    // MARK - Constants / Variables
    typealias moreDataSource = (image: UIImage, title: String)
    private let cellInformation: [moreDataSource] = [(image: #imageLiteral(resourceName: "Directory"), title: "Directory"), (image: #imageLiteral(resourceName: "ContactUs"), title: "Contact Us"), (image: #imageLiteral(resourceName: "ReadScripture"), title: "Read Scripture"), (image: #imageLiteral(resourceName: "AboutUs"), title: "About Us")]
    private let stretchyCollectionHeader = "StretchyCollectionHeader"
    private let cellID = "cellID"
    private let urlString = "https://itunes.apple.com/us/app/read-scripture/id1067865974?mt=8"
    
    // MARK: - View Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.register(MoreCollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        collectionView?.scrollToItem(at: IndexPath(item: 0, section: 0), at: .bottom, animated: true)
        hideKeyboardWhenTappedAroundAndSetNavBar()
    }
    
}

// MARK: - CollectionView DataSource + Delegate Methods
extension MoreCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    // Normal
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellInformation.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! MoreCollectionViewCell
        let cellInfo = cellInformation[indexPath.row]
        cell.nameLabel.text = cellInfo.title
        cell.imageView.image = cellInfo.image
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        if indexPath.row == 0 {
            if MemberController.shared.isLoggedIn == true {
                performSegue(withIdentifier: "ToDirectory", sender: self)
            } else {
                presentActionSheet()
            }
        } else if indexPath.row == 1 {
            performSegue(withIdentifier: "ToContactUs", sender: self)
        } else if indexPath.row == 2 {
            guard let url = URL(string: urlString) else { return }
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            UIApplication.shared.open(url, options: [:]) { (success) in
                if success {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            }

        } else if indexPath.row == 3 {
            performSegue(withIdentifier: "ToAboutUs", sender: self)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 3 * 16) / 2
        return CGSize(width: width, height: width + 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    // Header
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerID", for: indexPath)
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 300)
    }
    
}

// MARK: - Create alert for member
extension MoreCollectionViewController {
    
    func presentActionSheet() {
        let actionSheet = UIAlertController(title: "For privacy reasons, you must be a member of Salt Lake Christian Church to access the directory", message: nil, preferredStyle: .actionSheet)
        actionSheet.view.tintColor = #colorLiteral(red: 0.2784313725, green: 0.7803921569, blue: 0.9254901961, alpha: 1)
        let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        let contactUsAction = UIAlertAction(title: "Interested in becoming a member? Contact us", style: .default) { [weak self](_) in
            self?.performSegue(withIdentifier: "ToContactUs", sender: self)
        }
        let loginAction = UIAlertAction(title: "Already a member? Login", style: .default) { [weak self](_) in
            self?.performSegue(withIdentifier: "ToLogin", sender: self)
        }
        actionSheet.addAction(contactUsAction)
        actionSheet.addAction(loginAction)
        actionSheet.addAction(okayAction)
        present(actionSheet, animated: true)
    }
    
}

