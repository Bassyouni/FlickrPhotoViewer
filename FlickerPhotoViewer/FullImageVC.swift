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
    
    var currentUser: FlickrUser!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlString = "https://farm\(currentUser.farm).staticflickr.com/\(currentUser.server)/\(currentUser.imageID)_\(currentUser.secret).jpg"
        let url = URL(string: urlString)
        self.image.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder.png"))
        self.title = currentUser.imageTitle

        // Do any additional setup after loading the view.
    }

 

}
