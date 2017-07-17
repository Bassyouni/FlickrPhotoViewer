//
//  Constants.swift
//  FlickerPhotoViewer
//
//  Created by Bassyouni on 7/17/17.
//  Copyright © 2017 Bassyouni. All rights reserved.
//

import Foundation

typealias downloadCompleted = () -> ()

let baseURL: String = "https://api.flickr.com/services/rest/?"
let apiKey: String = "1fb31ddec8bfb0fafe88402968013f7b"
let perPage: String = "10"

let urlForGetRecent: String = "\(baseURL)method=flickr.interestingness.getList&api_key=\(apiKey)&per_page=\(perPage)&format=json&nojsoncallback=1"

let urlForPohotoID: String = "\(baseURL)"

var urlForGetUserPhotos: String = "\(baseURL)method=flickr.people.getPublicPhotos&api_key=\(apiKey)&format=json&nojsoncallback=1&user_id="
