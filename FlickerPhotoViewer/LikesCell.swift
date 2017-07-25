//
//  LikesCell.swift
//  FlickerPhotoViewer
//
//  Created by Bassyouni on 7/25/17.
//  Copyright © 2017 Bassyouni. All rights reserved.
//

import UIKit

class LikesCell: UITableViewCell {

    @IBOutlet weak var flickrImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var favBtn: UIButton!
    
    var imageId: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        favBtn.setBackgroundImage(UIImage(named: "IconFavouriteFill"),for: UIControlState.normal)
    }
    
    /// updates UI based on the FlickerUser sent to it
    ///
    /// - Parameter flickrUser
    func configureCell(likedPhoto: Likes) {
        
        //for grabing data when favourite btn is pressed
        imageId = likedPhoto.imageId
        
        //Configuring cell
        if likedPhoto.title == ""
        {
            self.titleLabel.text = "No Title"
        }
        else
        {
            self.titleLabel.text = likedPhoto.title
        }
        
        
        self.flickrImage.image = likedPhoto.image as? UIImage
        
        favBtn.setBackgroundImage(UIImage(named: "IconFavouriteFill"), for: UIControlState.normal)

        
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
        
        //we locate the the image and delete it then save the database
        if favBtn.currentBackgroundImage == UIImage(named: "IconFavouriteFill")
        {
            
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
