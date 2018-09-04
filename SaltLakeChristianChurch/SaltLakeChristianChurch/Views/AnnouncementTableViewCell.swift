//
//  AnnouncementTableViewCell.swift
//  SaltLakeChristianChurch
//
//  Created by Jayden Garrick on 2/5/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit
import Firebase

class AnnouncementTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets / Constants and Variables
    @IBOutlet weak var announcementImageView: UIImageView!
    @IBOutlet weak var announcementDetailTextView: UITextView!
    @IBOutlet weak var announcementNameLabel: UILabel!
    @IBOutlet weak var backgroundShadowView: UIView!
    @IBOutlet weak var dateCreatedLabel: UILabel!
    @IBOutlet weak var imageActivityIndicator: UIActivityIndicatorView!
    var announcement: Announcement?
    
    weak var delegate: AnnouncementtableViewCellDelegate? // Delegate for cell
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundShadowView.layer.cornerRadius = 3.0
        backgroundShadowView.layer.masksToBounds = false
        backgroundShadowView.layer.shadowColor = UIColor.black.withAlphaComponent(0.5).cgColor
        backgroundShadowView.layer.shadowOffset = CGSize(width: 0, height: 0)
        backgroundShadowView.layer.shadowOpacity = 0.8
        imageActivityIndicator.startAnimating()
    }
    
    @IBAction func hideAnnouncementButtonTapped(_ sender: Any) {
        delegate?.announcementButtonTapped(sender: self)
    }

}

protocol AnnouncementtableViewCellDelegate : class {
    func announcementButtonTapped(sender: AnnouncementTableViewCell)
}



