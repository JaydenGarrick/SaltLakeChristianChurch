//
//  MoreCollectionViewController.swift
//  SaltLakeChristianChurch
//
//  Created by Jayden Garrick on 4/2/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit

private let cellID = "cellID"

class MoreCollectionViewController: UICollectionViewController {

    // MARK - Constants / Variables
    typealias moreDataSource = (image: UIImage, title: String)
    let cellInformation: [moreDataSource] = [(image: #imageLiteral(resourceName: "Directory"), title: "Directory"), (image: #imageLiteral(resourceName: "ContactUs"), title: "Contact Us"), (image: #imageLiteral(resourceName: "ReadScripture"), title: "Read Scripture"), (image: #imageLiteral(resourceName: "AboutUs"), title: "About Us")]
    
    // MARK: - View Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.register(MoreCollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        hideKeyboardWhenTappedAroundAndSetNavBar()
    }
}


// MARK: - CollectionView DataSource + Delegate Methods
extension MoreCollectionViewController: UICollectionViewDelegateFlowLayout {
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
            print("ReadScripture")
        } else if indexPath.row == 3 {
            print("About Us")
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 3 * 16) / 2
        return CGSize(width: width, height: width + 46)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
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

