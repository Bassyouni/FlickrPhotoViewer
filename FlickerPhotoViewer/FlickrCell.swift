//
//  FlickrCell.swift
//  FlickerPhotoViewer
//
//  Created by Bassyouni on 7/17/17.
//  Copyright © 2017 Bassyouni. All rights reserved.
//

import UIKit

class FlickrCell: UITableViewCell {

    @IBOutlet weak var flickrImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(flickrUser :FlickrUser) {
        if flickrUser.imageTitle == ""
        {
            self.titleLabel.text = "No Title"
        }
        else
        {
            self.titleLabel.text = flickrUser.imageTitle
        }
        
        let urlString = "https://farm\(flickrUser.farm).staticflickr.com/\(flickrUser.server)/\(flickrUser.imageID)_\(flickrUser.secret).jpg"
        let url = URL(string: urlString)
        self.flickrImage.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder.png"))
    }


}
