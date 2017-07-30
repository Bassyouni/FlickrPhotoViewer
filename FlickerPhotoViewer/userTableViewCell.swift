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
    @IBOutlet weak var downloadBtn: UIButton!
    
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
         var isLiked: Bool = false
         for obj in photoArry!
         {
            if (obj as AnyObject).imageId == ImageOfUser.imageID
            {
                favBtn.setBackgroundImage(UIImage(named: "IconFavouriteFill"), for: UIControlState.normal)
                isLiked = true
                break
            }
        }
        if !isLiked
        {
            favBtn.setBackgroundImage(UIImage(named: "IconFavourite"), for: UIControlState.normal)
        }
        
        //to check if this image is downloaded or not
        let array =  CurrentUser.toDownload?.allObjects
        for obj in array!
        {
            if (obj as! Download).id == ImageOfUser.imageID
            {
                downloadBtn.alpha = 0.3
                return
            }
        }
        
        downloadBtn.alpha = 1.0
    }
    
    func enableDownload()
    {
        
    }
    /// Toggles between Saving Favourte's and Removing it using core data
    ///
    /// - Parameter sender: UIButton
    @IBAction func favBtnPressed(_ sender: UIButton)
    {
        //make it inresponsive untile the photo is cashed
        if flickrImage.image == UIImage(named: "placeholder.png")
        {
            return
        }
        
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

    /// Downloades image to the database
    ///
    /// - Parameter sender: UIButton
    @IBAction func downloadBtnPressed(_ sender: UIButton) {
        
        //make it inresponsive untile the photo is cashed
        if flickrImage.image == UIImage(named: "placeholder.png")
        {
            return
        }
        
        self.downloadBtn.alpha = 0.3
        let downloadedImage = Download(context: context)
        downloadedImage.id = self.imageId
        downloadedImage.image = self.flickrImage.image
        downloadedImage.title = self.titleLabel.text
        
        //if already downloaded just retrun
        let array =  CurrentUser.toDownload?.allObjects
        for obj in array!
        {
            if (obj as! Download).id == downloadedImage.id
            {
                return
            }
        }
        
        //else saveit to database and notify user
        CurrentUser.addToToDownload(downloadedImage)
        ad.saveContext()
        print("Downloaded")
        let alert = UIAlertController(title: NSLocalizedString("Success", comment: ""), message: NSLocalizedString("image downloaded", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Done", comment: ""), style: UIAlertActionStyle.default, handler: nil))
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
        
    }

}
