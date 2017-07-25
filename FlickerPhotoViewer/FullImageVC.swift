//
//  FullImageVC.swift
//  FlickerPhotoViewer
//
//  Created by Bassyouni on 7/20/17.
//  Copyright © 2017 Bassyouni. All rights reserved.
//

import UIKit

class FullImageVC: UIViewController {

    @IBOutlet weak var image: UIImageView!
    
    var currentImage: ImageOfFlickrUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // it justs displays the picture
        let photoUrl = urlOfPhoto(imageOfUser: currentImage)
        self.image.sd_setImage(with: photoUrl, placeholderImage: UIImage(named: "placeholder.png"))
        self.title = currentImage.imageTitle
    }

}
