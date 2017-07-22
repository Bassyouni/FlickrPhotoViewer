//
//  SideMenuTableViewCell.swift
//  Marriage
//
//  Created by ZooZoo on 6/17/16.
//  Copyright © 2016 ZooZoo. All rights reserved.
//

import UIKit

class SideMenuTableViewCell: UITableViewCell {

    @IBOutlet var lblMenu : UILabel!
//    @IBOutlet var imgMenu : UIImageView!
    @IBOutlet var viewMenu : UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
