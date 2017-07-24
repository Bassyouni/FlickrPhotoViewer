//
//  UserPhotosVC.swift
//  FlickerPhotoViewer
//
//  Created by Bassyouni on 7/17/17.
//  Copyright © 2017 Bassyouni. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

class UserPhotosVC: ParentViewController , UITableViewDelegate , UITableViewDataSource {
    
    //MARK: - iboutlet
    @IBOutlet weak var tableView: UITableView!

    //MARK: - variables
    var usersPhotos = [ImageOfFlickrUser]()
    var currentUser: FlickrUser!
    
    //MARK: - view DidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        //remove navbar back btn
        if let topItem = self.navigationController?.navigationBar.topItem
        {
            topItem.backBarButtonItem = UIBarButtonItem(title: "" , style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        tableView.delegate = self
        tableView.dataSource = self
        showLoading()
        //This function starts when the closure ends
        grabDataFromApi {
            self.tableView.reloadData()
            self.hideLoading()
        }
    }
    
    //MARK: - Api Call
    /// This fucntion uses Alamofire to make json calls and return Flickr user public photos
    /// - Parameter complete:
    func grabDataFromApi(complete :@escaping downloadCompleted)
    {
        print("\(urlForGetUserPhotos)\(currentUser.userID)")
        Alamofire.request("\(urlForGetUserPhotos)\(currentUser.userID)").responseJSON
            {
                response in
                
                if let dic = response.result.value as? Dictionary<String , AnyObject>
                {
                    if let status = dic["stat"] as? String
                    {
                        if status == "ok"
                        {
                            if let photosDic = dic["photos"] as? Dictionary<String , AnyObject>
                            {
                                if let photoArray = photosDic["photo"] as? [Dictionary<String , AnyObject>]
                                {
                                    for obj in photoArray
                                    {
                                        let tempImage = ImageOfFlickrUser(dic: obj)
                                        self.usersPhotos.append(tempImage)
                                    }
                                }
                            }
                        }
                        else
                        {
                            print("problem with request -> \(status)")
                        }
                    }
                    complete()
                }
                
        }
    }

    //MARK: - table
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersPhotos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FlickrCell", for: indexPath) as? userTableViewCell
        {
            let tempImage = usersPhotos[indexPath.row]
            cell.configureCell(ImageOfUser: tempImage)
            return cell
        }
        else
        {
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {        return 150

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "FullImageVC", sender: usersPhotos[indexPath.row])
    }
    
    //MARK: - segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? FullImageVC
        {
            if let user = sender as? ImageOfFlickrUser
            {
               destination.currentImage = user
            }
        }
    }
    
    
    

    


}
