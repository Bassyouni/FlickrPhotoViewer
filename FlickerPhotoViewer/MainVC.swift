//
//  MainVC.swift
//  FlickerPhotoViewer
//
//  Created by Bassyouni on 7/17/17.
//  Copyright © 2017 Bassyouni. All rights reserved.
//

import UIKit
import Alamofire

class MainVC: UIViewController , UITableViewDelegate , UITableViewDataSource , UISearchBarDelegate {
    
    //MARK: - iboutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var inSearchMode: Bool!
    var flickrUserArray = [FlickrUser]()
    var flickrUserFilterdArray = [FlickrUser]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        self.grabDataFromApi {
            self.tableView.reloadData()
        }
        print(urlForGetRecent)
        inSearchMode = false
       
    }
    
    //MARK: - Api Call
    func grabDataFromApi(complete :@escaping downloadCompleted)
    {
        Alamofire.request(urlForGetRecent).responseJSON
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
                                    self.flickrUserArray.append(tempUser)
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
        if inSearchMode
        {
            return flickrUserFilterdArray.count
        }
        return flickrUserArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FlickrCell", for: indexPath) as? FlickrCell
        {
            var flickrUser: FlickrUser!
            if inSearchMode
            {
                flickrUser = flickrUserFilterdArray[indexPath.row]
            }
            else
            {
                flickrUser = flickrUserArray[indexPath.row]
            }
            
            cell.configureCell(flickrUser: flickrUser)
            return cell
        }
        else
        {
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var flickrUser: FlickrUser!
        
        if inSearchMode
        {
            flickrUser = flickrUserFilterdArray[indexPath.row]
        }
        else
        {
            flickrUser = flickrUserArray[indexPath.row]
        }
        
        performSegue(withIdentifier: "UserPhotosVC" , sender: flickrUser)
    }
    
    //MARK: - search bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == ""
        {
            inSearchMode = false
            tableView.reloadData()
        }
        else
        {
            inSearchMode = true
            flickrUserFilterdArray = flickrUserArray.filter({$0.imageTitle.range(of:searchBar.text!) != nil})
            tableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }

    //MARK: - segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? UserPhotosVC
        {
            if let user = sender as? FlickrUser
            {
                destination.currentUser = user
            }
        }
    }


}

