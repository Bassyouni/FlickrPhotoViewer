//
//  userTableViewCell.swift
//  FlickerPhotoViewer
//
//  Created by Bassyouni on 7/20/17.
//  Copyright © 2017 Bassyouni. All rights reserved.
//

import UIKit
import CoreData

class userTableViewCell: UITableViewCell {
    
    @IBOutlet weak var flickrImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var favBtn: UIButton!
    
    var imageId: String!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        favBtn.setBackgroundImage(UIImage(named: "IconFavourite"),for: UIControlState.normal)
    }
    
    /// updates UI based on the FlickerUser sent to it
    ///
    /// - Parameter flickrUser
    func configureCell(ImageOfUser :ImageOfFlickrUser) {
        
        //for grabing data when favourite btn is pressed
        imageId = ImageOfUser.imageID
        
        //Configuring cell
        if ImageOfUser.imageTitle == ""
        {
            self.titleLabel.text = "No Title"
        }
        else
        {
            self.titleLabel.text = ImageOfUser.imageTitle
        }
        

        let photoURL = urlOfPhoto(imageOfUser: ImageOfUser)
        self.flickrImage.sd_setImage(with: photoURL, placeholderImage: UIImage(named: "placeholder.png"))
        
        //for determining which is liked and which is not , I need to optmize it if i can
         let photoArry = CurrentUser.toLikes?.allObjects
         for obj in photoArry!
         {
            if (obj as AnyObject).imageId == ImageOfUser.imageID
            {
                favBtn.setBackgroundImage(UIImage(named: "IconFavouriteFill"), for: UIControlState.normal)
                return
            }
        }
        favBtn.setBackgroundImage(UIImage(named: "IconFavourite"), for: UIControlState.normal)

    }
    
    
    /// Toggles between Saving Favourte's and Removing it using core data
    ///
    /// - Parameter sender: UIButton
    @IBAction func favBtnPressed(_ sender: UIButton)
    {
        var like = Likes(context:context)
        like.image = self.flickrImage.image
        like.imageId = self.imageId
        like.title = self.titleLabel.text
        if favBtn.currentBackgroundImage == UIImage(named: "IconFavourite")
        {
            favBtn.setBackgroundImage(UIImage(named: "IconFavouriteFill"), for: UIControlState.normal)
            CurrentUser.addToToLikes(like)
        }
        else
        {
            favBtn.setBackgroundImage(UIImage(named: "IconFavourite"), for: UIControlState.normal)
            
            let array =  CurrentUser.toLikes?.allObjects
            for obj in array!
            {
                if (obj as AnyObject).imageId == like.imageId
                {
                    like = obj as! Likes
                    CurrentUser.removeFromToLikes(like)
                }
            }
        }
        ad.saveContext()
    }


}
