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
        
        //remove navbar back btn
        if let topItem = self.navigationController?.navigationBar.topItem
        {
            topItem.backBarButtonItem = UIBarButtonItem(title: "" , style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        
        // it justs displays the picture and checks if it comes form userPhotosVC or Download VC
        if currentImage.image == nil
        {
            let photoUrl = urlOfPhoto(imageOfUser: currentImage)
            self.image.sd_setImage(with: photoUrl, placeholderImage: UIImage(named: "placeholder.png"))
        }
        else
        {
            self.image.image = currentImage.image
        }
        
        self.title = currentImage.imageTitle
    }

}
