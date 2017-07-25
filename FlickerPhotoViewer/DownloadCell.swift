//
//  DownloadCell.swift
//  FlickerPhotoViewer
//
//  Created by Bassyouni on 7/25/17.
//  Copyright © 2017 Bassyouni. All rights reserved.
//

import UIKit

class DownloadCell: UITableViewCell {

    @IBOutlet weak var downloadedImage: UIImageView!
    
    var imageId: String!

    func configureCell(downloadedImage: Download) {
        
        //for grabing data when favourite btn is pressed
        imageId = downloadedImage.id
        
        //Configuring cell
        self.downloadedImage.image = downloadedImage.image as? UIImage
        
    }

}
