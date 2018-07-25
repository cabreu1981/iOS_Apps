//
//  FeedTableViewCell.swift
//  Instagram
//
//  Created by Carlos Abreu on Jan/06/2018.
//  Copyright © 2018 Carlos Abreu. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {

    @IBOutlet weak var postedImage: UIImageView!
    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var userInfo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
