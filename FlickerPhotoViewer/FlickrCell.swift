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
    
    func configureCell(flickrUser :FlickrUser)
    {
        if flickrUser.imageTitle == ""
        {
            self.titleLabel.text = "No Title"
        }
        else
        {
            self.titleLabel.text = flickrUser.imageTitle
        }
        
        
        let url = URL(string: "https://farm\(flickrUser.farm).staticflickr.com/\(flickrUser.server)/\(flickrUser.imageID)_\(flickrUser.secret).jpg")
        
        print("https://farm\(flickrUser.farm).staticflickr.com/\(flickrUser.server)/\(flickrUser.imageID)_\(flickrUser.secret).jpg")
        
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            DispatchQueue.main.async {
                self.flickrImage.image = UIImage(data: data!)
            }
        }
    }



}
