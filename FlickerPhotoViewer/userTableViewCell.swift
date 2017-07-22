//
//  userTableViewCell.swift
//  FlickerPhotoViewer
//
//  Created by Bassyouni on 7/20/17.
//  Copyright © 2017 Bassyouni. All rights reserved.
//

import UIKit

class userTableViewCell: UITableViewCell {
    
    @IBOutlet weak var flickrImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var favBtn: UIButton!
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
    //MARK: - ibactions
    @IBAction func favBtnPressed(_ sender: Any) {
        
        if favBtn.currentBackgroundImage == UIImage(named: "IconFavorate")
        {
            favBtn.setBackgroundImage(UIImage(named: "IconFavourateFill"), for: UIControlState.normal)
        }
        else
        {
            favBtn.setBackgroundImage(UIImage(named: "IconFavorate"), for: UIControlState.normal)
        }

}
}
