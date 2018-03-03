//
//  CalendarTableViewCell.swift
//  SaltLakeChristianChurch
//
//  Created by Jayden Garrick on 2/7/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit

class CalendarTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var locationTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
