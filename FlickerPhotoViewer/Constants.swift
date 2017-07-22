//
//  Constants.swift
//  FlickerPhotoViewer
//
//  Created by Bassyouni on 7/17/17.
//  Copyright © 2017 Bassyouni. All rights reserved.
//

import Foundation

typealias downloadCompleted = () -> ()
//MARK: - URLS
let baseURL: String = "https://api.flickr.com/services/rest/?"
let apiKey: String = "1fb31ddec8bfb0fafe88402968013f7b"
let perPage: String = "10"

let urlForGetRecent: String = "\(baseURL)method=flickr.interestingness.getList&api_key=\(apiKey)&per_page=\(perPage)&format=json&nojsoncallback=1"

let urlForPohotoID: String = "\(baseURL)"

var urlForGetUserPhotos: String = "\(baseURL)method=flickr.people.getPublicPhotos&api_key=\(apiKey)&format=json&per_page=20&nojsoncallback=1&user_id="

//MARK: - user Constatns
let userFName = "Omar"
let userLName = "Bassiony"
let userImage = ""


//MARK: - colors
var pinkColor = UIColor(red: 253.0/255/0, green: 114.0/255.0, blue: 174.0/255.0, alpha: 0.7)
