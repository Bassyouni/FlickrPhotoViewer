//
//  FlickrUser.swift
//  FlickerPhotoViewer
//
//  Created by Bassyouni on 7/17/17.
//  Copyright © 2017 Bassyouni. All rights reserved.
//

import Foundation
import UIKit

class FlickrUser
{
    private var _userID: String!
    private var _secret: String!
    private var _server: String!
    private var _farm  : String!
    private var _imageID :String!
    private var _imageTitle :String!
    private var _image: UIImage?
    
    init(dic :Dictionary<String , AnyObject>) {
        self._imageID = dic["id"] as? String
        self._userID = dic["owner"] as? String
        self._secret = dic["secret"] as? String
        self._server = dic["server"] as? String
        self._farm = "\(dic["farm"] as? Int ?? -1)"
        self._imageTitle = dic["title"] as? String
        
    }
    
    //MARK: - getters
    var imageID: String
    {
        get { return self._imageID }
    }
    
    var userID: String
    {
        get{ return self._userID }
    }
    
    var secret: String
    {
        get{ return self._secret }
    }
    
    var server: String
    {
        get{ return self._server }
    }
    
    var farm: String
    {
        get { return self._farm }
    }
    
    var imageTitle: String
    {
        get { return _imageTitle }
    }
    
    var image: UIImage?
    {
        get {
            if _image == nil {
                return nil
            }
            else
            {
                return _image!
            }
        }
        set
        {
            _image = newValue
        }
    }
    
    
    
}


//MARK: - Euatable overlaod

//For array opertaion like Contain and index of
extension FlickrUser: Equatable { }
func ==(lhs: FlickrUser, rhs: FlickrUser) -> Bool {
    return lhs.imageID == rhs.imageID 
}
