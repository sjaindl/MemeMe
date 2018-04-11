//
//  SentMemeTableViewCell.swift
//  MemeMe
//
//  Created by Stefan Jaindl on 09.04.18.
//  Copyright © 2018 Stefan Jaindl. All rights reserved.
//

import UIKit

class SentMemeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var topTextLabel: UILabel!
    @IBOutlet weak var bottomTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
