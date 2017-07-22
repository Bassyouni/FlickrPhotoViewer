//
//  UserPhotosVC.swift
//  FlickerPhotoViewer
//
//  Created by Bassyouni on 7/17/17.
//  Copyright © 2017 Bassyouni. All rights reserved.
//

import UIKit
import Alamofire

class UserPhotosVC: ParentViewController , UITableViewDelegate , UITableViewDataSource {
    
    //MARK: - iboutlet
    @IBOutlet weak var tableView: UITableView!

    
    //MARK: - variables
    var usersPhotoArray = [FlickrUser]()
    var currentUser: FlickrUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(urlForGetUserPhotos)
        tableView.delegate = self
        tableView.dataSource = self
        showLoading()
        grabDataFromApi {
            self.tableView.reloadData()
            self.hideLoading()
        }
    }
    
    //MARK: - Api Call
    func grabDataFromApi(complete :@escaping downloadCompleted)
    {
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
                                        let tempUser = FlickrUser(dic: obj)
                                        self.usersPhotoArray.append(tempUser)
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
        return usersPhotoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FlickrCell", for: indexPath) as? userTableViewCell
        {
            cell.configureCell(flickrUser: usersPhotoArray[indexPath.row])
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
        performSegue(withIdentifier: "FullImageVC", sender: usersPhotoArray[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? FullImageVC
        {
            if let user = sender as? FlickrUser
            {
               destination.currentUser = user
            }
        }
    }
    

    


}
